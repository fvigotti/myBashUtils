#!/usr/bin/env bash
set -xe
print_help() {
  echo ' execute bash script located at given url '
  echo $0' $url $args'
}
URL=$1
shift;

curl -s $URL | bash -s $@ --