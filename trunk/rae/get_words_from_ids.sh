#!/bin/bash
set -e

extract() {
  local DIR=$1
  grep -o '<span class="eLema"><B>[^<]*</B>' $DIR/*.html | 
    cut -d">" -f3 | cut -d"<" -f1 | 
    sed "s/\xe2\x80\x92\xcc\x81/-/g; s/^-//g; s/-$//g" 
}

extract "html" | sort -u > words.txt
