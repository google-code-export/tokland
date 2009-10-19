#!/bin/bash
set -e

debug() { echo "$@" >&2; }

extract_words_from_binary() {
  grep -a -o "[a-zA-Záéíóúñ \.,]\+" "$FILE" | \
    grep "[a-zA-Záéíóúñ]" | \
    grep -v "^[[:space:]]" | \
    sed "s/\.$//; s/,.*$//"
}            
           
# cdrom-rae2.2/data/ixLm/_3son.fdt
cat _3son.fdt | extract_words_from_binary > words.txt
