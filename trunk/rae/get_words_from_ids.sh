#!/bin/bash
set -e

extract() {
  local DIR=$1
  grep -o '<span class="eLema"><B>[^<]*</B>' $DIR/*.html | 
    cut -d">" -f3 | cut -d"<" -f1
}

extract "html" > words.txt
