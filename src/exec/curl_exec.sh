#!/usr/bin/env bash

print_help() {
  echo ' execute bash script located at given url '
  echo $0' $url $args'
}
URL=$1
shift;

curl -s $1 | bash -s $@ --