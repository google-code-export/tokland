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
      curl -m60 -s -d "LEMA=$(echo $WORD | recode ..iso8859-15)" "$URL" > "$OUTPUT" ||
        { debug "timeout"; return 1; }
      grep -i -l "no est. en el diccionario" &>/dev/null && 
        { debug "said not found"; return 2; }
      debug "done" 
    fi
  done
}
    
download_words_html "words.txt" "html2"
