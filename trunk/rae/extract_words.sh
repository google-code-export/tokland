#!/bin/bash
set -e

debug() { echo "$@" >&2; }

extract_words_from_binary() {
  grep -a -o "[a-zA-Záéíóúñ \.,]\+" |
    grep "[a-zA-Záéíóúñ]" |
    grep -v "^[[:space:]]" |
    sed "s/\.$//; s/,.*$//" |
    grep -v "^[[:space:]]*$" |
    sed "s/ o /\n/" |    
    sort -u
}            
           
# source: cdrom-rae2.2/data/ixLm/_3son.fdt
cat _3son.fdt | extract_words_from_binary > words.txt
