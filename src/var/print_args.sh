#!/usr/bin/env bash

args=("$@")
ELEMENTS=${#args[@]}

for (( i=0;i<$ELEMENTS;i++)); do
    echo '['$i']'${args[${i}]}'[/'$i']'
done