#!/bin/bash
set -e

debug() { echo "$@" >&2; }
enumerate() { cat -n; }
         
download_words_html() {
  local WORDS_FILE=$1
  local DIRECTORY=$2

  URL="http://buscon.rae.es/draeI/SrvltGUIBusUsual"
  
  mkdir -p "$DIRECTORY" || return 1
  local TOTAL=$(wc -l < "$WORDS_FILE")
  
  cat "$WORDS_FILE" | enumerate | while read INDEX WORD; do
    debug -n "$INDEX/$TOTAL: $WORD... "
    OUTPUT="$DIRECTORY/$WORD.html"
    if test -e "$OUTPUT" -a -s "$OUTPUT"; then
      debug "already exists"
    else
      curl -s "$URL?LEMA=$WORD" > $OUTPUT && 
        debug "done" || debug "error"
    fi
  done
}
    
download_words_html "words.txt" "html2"
