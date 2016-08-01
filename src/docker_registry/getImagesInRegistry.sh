#!/usr/bin/env bash

# URL must be provided, ie:
# export URL=https://user:pass@reg:port

# return 1 tag per line
get_tags_for_image(){
    IMAGE_ID=$1
    curl -s -k "${URL}/v2/${IMAGE_ID}/tags/list" | jq -r '.tags[]'
}

get_tag_creation_date(){
    IMAGE_ID=$1
    TAG_ID=$2
    curl -s -k "${URL}/v2/${IMAGE_ID}/manifests/${TAG_ID}" |  jq -r '.history[].v1Compatibility' |jq -r '.created' | sort  | tail -n1
}

get_images_catalog(){
curl -s -k "${URL}/v2/_catalog"  | jq  -r '.repositories[]'
}


convert_iso_to_epoch(){ # return epoch , ie: 1469441418
isodate=$1 #ie : 2016-07-25T10:10:18.936104767Z
date -d"${isodate}" +%s
}

for image in $(get_images_catalog); do
    for tag in $(get_tags_for_image $image); do
    CREATION_DATE=$(get_tag_creation_date $image $tag)
    echo "$image ($CREATION_DATE / $(convert_iso_to_epoch $CREATION_DATE)) -> $tag  "
    done
done
