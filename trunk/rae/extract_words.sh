#!/bin/bash
set -e

debug() { echo "$@" >&2; }
remove_empty_lines() { grep -v "^[[:space:]]*$"; }
strip_lines() { sed "s/^[[:space:]]*//; s/[[:space:]]*$//"; }

extract_words_from_binary() {
  grep -a -o "[a-zA-Záéíóúñ \.,]\+" |
    sed "s/\.$//; s/,.*$//" |
    sed "s/ o /\n/" | 
    strip_lines | 
    remove_empty_lines
}            
           
# data/ixLm/_3son.fdt
cat _3son.fdt | extract_words_from_binary | sort -u > words.txt
