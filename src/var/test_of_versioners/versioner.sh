#!/usr/bin/env bash
set -xe
#
#  VERSION BUILDS BASED ON `version` file content
#  versioned branch are branch with vNN.NN name syntax
#
#

export SCRIPT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
export PROJECT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )

cd $PROJECT_DIR

#export CHANGES_FILE=${PROJECT_DIR}/CHANGES
export VERSION_FILE=${PROJECT_DIR}/version
export VERSION_UPDATE_COMMIT_MESSAGE="version updated" # this commit message is configured in jenkins to not trigger build ( avoid build infinite loop )

export CURRENT_VERSION=$(cat "${VERSION_FILE}")

## there are needed because commit will be cherry picked from jenkins plugin so easier ways to retrieve those informations do not work

getShortCommitHash(){
  echo $(git rev-parse --short HEAD)
}

getCurrentBranch(){
  echo $(git for-each-ref --sort=-committerdate --format='%(refname:short) %(objectname)' | grep "$(git rev-parse HEAD)" | grep origin | head -1 | cut -d" " -f 1 | cut -d '/' -f 2)
}

# ie: 20160729.153549
buildVersionDateTag(){
  date +'%Y%m%d.%H%M%S'
}

export BUILD_NAME=$(getCurrentBranch)'.'$(buildVersionDateTag)'.'$(getShortCommitHash)
echo $BUILD_NAME > build.name




#git for-each-ref --sort=-committerdate --format='%(refname:short) %(objectname:short)'






export CURRENT_BRANCH_NAME=$(git branch | awk '/\*/ { print $2; }')




export DRY_RUN=${DRY_RUN:-0} # if == 1 , will not write changes

echo "pre-build version = $CURRENT_VERSION"

VERSION_PORTIONS=(`echo $CURRENT_VERSION | tr '.' ' '`)

export V_MAJOR=${VERSION_PORTIONS[0]:-0}
export V_MINOR=${VERSION_PORTIONS[1]:-0}
export V_BUILD=${VERSION_PORTIONS[2]:-0}

BRANCH_LAST_TAG=$(git describe --abbrev=0)
CURRENT_COMMIT_TAG=$(git describe --exact-match --abbrev=0 2>/dev/null || true)

parseVersionFromTag(){
  echo $1 | sed -E 's/^v([0-9]+\.[0-9]+.[0-9]+).*/\1/'
}

validateVersionNumberFormat(){
  if [ "$(echo $1 | egrep  '^[0-9]+\.[0-9]+\.[0-9]+s$')" != '' ]; then
    echo "1"; ## valid format
  else
    echo "0" # format not valid
  fi
}


echo 'CURRENT_COMMIT_TAG='$CURRENT_COMMIT_TAG
echo 'BRANCH_LAST_TAG='$BRANCH_LAST_TAG
echo 'CURRENT_BRANCH_NAME='$CURRENT_BRANCH_NAME


exit 0 ;


# return: 1 if tag exist , 0 otherwise
checkTagExists(){
  TAG_TO_SEARCH=$1
  t=$(git tag | egrep '^'$TAG_TO_SEARCH'$' | wc -l)
  if [ $t -eq 0 ] ; then # TAG DOES NOT EXIST
    echo "0";
  else
    echo "1"; ## TAG EXIST
  fi
}


export V_BUILD=$((V_BUILD+1))
export BUILT_VERSION="${V_MAJOR}.${V_MINOR}.${V_BUILD}"

# ensure that chosed tag is unique !
while [ "$(checkTagExists $BUILT_VERSION)" -eq "1" ]; do
  export V_BUILD=$((V_BUILD+1))
  export BUILT_VERSION="${V_MAJOR}.${V_MINOR}.${V_BUILD}"
done


echo "built version = ${BUILT_VERSION}"

export MOST_RECENTS_TAG_TRACKED_CHANGES="" ## VERSION OF MOST RECENT TRACKED CHANGES, if empty will register all changes

# return '1.2.3' or '' if changefile does not exist
get_last_tracked_version_number(){
  CHANGES_FILE=$1
  if [ -f $CHANGES_FILE ]; then
    echo $(cat "${CHANGES_FILE}"  | grep -P '^Version \d\.\d\.\d:$' | cut -d' '  -f 2 | cut -d ':' -f 1 | head -n1)
  else
    echo ""
  fi
}

# args :
# $1 = tag to search for
assertTagExist(){
  t=$(git tag | egrep '^'$1'$' | wc -l)
  [ $t -gt 0 ] || {
  echo 'error, tag ['$1'] does not exist!'
  exit 1
  }
}


## validate given tag, return latest one if the provided is invalid
validate_tag_or_get_latest(){
  TAG_TO_SEARCH=$1
  t=$(git tag | egrep '^'$TAG_TO_SEARCH'$' | wc -l)

  if [ $t -eq 0 ] ; then
    echo $( git tag | sort -Vr | head -n 1)
  else
    echo $TAG_TO_SEARCH
  fi
}

append_old_changelog(){
  APPEND_TO_FILEPATH=$1
  if [ -f "${CHANGES_FILE}" ]; then
   cat ${CHANGES_FILE} | head -n 1000 >> $APPEND_TO_FILEPATH
  fi
}

append_git_changes_to_file(){
   FROM_VERSION_TAG=$1
   APPEND_TO_FILEPATH=$2
   LATEST_TAG=$(validate_tag_or_get_latest $FROM_VERSION_TAG)

  [ -z "${FROM_VERSION_TAG}" ] || [ -z "${LATEST_TAG}" ] && { ## changelog resetted

   echo 'this is first tagged version, extracting whole commit history '
   git log --pretty=format:"%cn %h %ci - %s" | grep -v "${VERSION_UPDATE_COMMIT_MESSAGE}" >> $APPEND_TO_FILEPATH

  } || {  ## changelog increment
   echo 'updating commit history since last tagged version ('${LATEST_TAG}') '
   countCommits=$(git log --pretty=format:"%cn %h %ci - %s" "${LATEST_TAG}"...HEAD | grep -v "${VERSION_UPDATE_COMMIT_MESSAGE}"|wc -l)
   if [ "${countCommits}" -lt 1 ]; then
    echo "no commits since last append to CHANGES file"
    #echo "--no changes" >> $APPEND_TO_FILEPATH
   else
    git log --pretty=format:"%cn %h %ci - %s" "${LATEST_TAG}"...HEAD | grep -v "${VERSION_UPDATE_COMMIT_MESSAGE}"  >> $APPEND_TO_FILEPATH
   fi

   # also append previous stored changelog
   append_old_changelog $APPEND_TO_FILEPATH
  }

}


MOST_RECENTS_TAG_TRACKED_CHANGES=$(get_last_tracked_version_number $CHANGES_FILE)

tmpfile=$(mktemp)

#  CHANGELOG HEADERS
echo $"Version ${BUILT_VERSION}:" > $tmpfile



append_git_changes_to_file "$MOST_RECENTS_TAG_TRACKED_CHANGES" "$tmpfile"

if [ $DRY_RUN -eq 1 ]; then
  echo 'DRY RUN MDDE , CHANGELOG FILE = '
  cat $tmpfile
else
  mv $tmpfile $CHANGES_FILE
  echo "${BUILT_VERSION}" > $VERSION_FILE
  git add $CHANGES_FILE
  git add $VERSION_FILE
  git commit -m "${VERSION_UPDATE_COMMIT_MESSAGE} ${BUILT_VERSION}"
  git tag -a -m "Tagging version ${BUILT_VERSION}" "${BUILT_VERSION}"
  ##git push origin $CURRENT_BRANCH_NAME --tags # moved to dedicated script which require credentials
fi


