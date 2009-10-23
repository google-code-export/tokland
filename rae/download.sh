#!/bin/bash
set -e

debug() { echo "$@" >&2; }

enumerate() { cat -n; }
         
download_html() {
  WORDS_FILE=$1
  URL=$2
  DIRECTORY=$3
  
  mkdir -p "$DIRECTORY" || return 1
  TOTAL=$(wc -l < "$WORDS_FILE")
  
  cat "$WORDS_FILE" | enumerate | while read INDEX WORD; do
    debug -n "$INDEX/$TOTAL: $WORD... "
    OUTPUT="$DIRECTORY/$WORD.html"
    if test -e "$OUTPUT" -a -s "$OUTPUT"; then
      debug "already exists"
    else
      wget -o /dev/null -O "$OUTPUT" "$URL/$WORD" &&
        debug "done" || debug "error"
    fi
  done
}
    
download_html "words.txt" "http://drae2.es" "html"
