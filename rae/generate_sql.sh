#!/bin/bash
set -e

debug() { echo "$@" >&2; }
escape_sql() { sed "s/'/''/g"; }

generate_sql() {
  local TABLE=$1
  local DIRECTORY=$2  
  
  echo "CREATE TABLE $TABLE(word varchar(255) PRIMARY KEY, definition text);"
  find $DIRECTORY -type f -name '*.html' | while read FILE; do
    WORD=$(basename "$FILE" ".html")
    DEFINITION=$(cat "$FILE" | escape_sql)
    echo "INSERT INTO $TABLE (word, definition) VALUES ('$WORD', '$DEFINITION');"
  done
}

generate_sql "words" "drae2.2" | gzip > "drae2.2.sql.gz"

# Create a sqlite3 database:
# generate_sql "words" "drae2.2"| sqlite3 database.sqlite3
