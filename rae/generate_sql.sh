#!/bin/bash
set -e

debug() { echo "$@" >&2; }
escape_sql() { sed "s/'/''/g; s/^[[:space:]]*//; s/[[:space:]]*$//"; }

generate_sql() {
  local TABLE=$1
  local DIRECTORY=$2  
  
  echo "CREATE TABLE $TABLE(word varchar(255), html text, text text);"
  find $DIRECTORY -type f -name '*.html' | while read FILE; do
    WORD=$(basename "$FILE" ".html")
    HTML=$(< "$FILE" escape_sql)
    TEXT=$(lynx -nolist -dump "$FILE" | recode iso8859-1..utf8 | tail -n+7 | head -n-1 | escape_sql)
    echo "INSERT INTO $TABLE (word, html, text) VALUES ('$WORD', '$HTML', '$TEXT');"
  done
  echo "CREATE INDEX word_index ON words (word);"
}

generate_sql "words" "html2" #| gzip > "drae-2009.sql.gz"
# tee | sqlite3 drae-2009.sqlite3 |
