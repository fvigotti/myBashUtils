#!/usr/bin/env bash
set -xe
#
#  VERSION BUILDS BASED ON `version` file content
#
#
#
PUSH_REPO_URL=$1

export SCRIPT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
export PROJECT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )

cd $PROJECT_DIR

export GIT_CMD_CURRENT_BRANCH="git rev-parse --abbrev-ref HEAD"
#export CURRENT_BRANCH_NAME=$(eval $GIT_CMD_CURRENT_BRANCH)
export CURRENT_BRANCH_NAME=$(basename $(git symbolic-ref HEAD))

echo '$GIT_URL='$GIT_URL
echo 'GIT_BRANCH='$GIT_BRANCH
echo 'GIT_PREVIOUS_COMMIT='$GIT_PREVIOUS_COMMIT
echo 'GIT_PREVIOUS_SUCCESSFUL_COMMIT='$GIT_PREVIOUS_SUCCESSFUL_COMMIT
echo 'GIT_AUTHOR_NAME='$GIT_AUTHOR_NAME
echo 'GIT_COMMITTER_NAME='$GIT_COMMITTER_NAME
echo 'GIT_AUTHOR_EMAIL='$GIT_AUTHOR_EMAIL
# git push origin $CURRENT_BRANCH_NAME --tags

git push --tags --repo $PUSH_REPO_URL $CURRENT_BRANCH_NAME
