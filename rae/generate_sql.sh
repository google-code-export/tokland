#!/bin/bash
set -e
TABLENAME="drae"
NAME="drae2.2"

generate_sql() {
  TABLE=$1
  DIRECTORY=$2  
  echo "DROP TABLE $TABLE;"
  echo "CREATE TABLE $TABLE(word varchar(255), definition text);"
  find $DIRECTORY -type f -name '*.html' | while read FILE; do
    WORD=$(basename "$FILE" ".html")
    DEFINITION=$(cat "$FILE" | sed "s/'/''/g")
    echo "INSERT INTO $TABLE (word, definition) VALUES ('$WORD', '$DEFINITION');"
  done
}

generate_sql "$TABLE" "$NAME" | gzip > "$NAME.sql.gz"
