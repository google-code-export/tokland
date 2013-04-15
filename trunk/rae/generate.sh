#!/bin/bash
set -e

remove_html_tags() { sed "s/<[^>]*>//g"; }

escape_sql() { sed "s/'/''/g; s/^[[:space:]]*//; s/[[:space:]]*$//"; }

remove_blank_lines() { 
  sed "s/^[[:space:]]\+$//" | 
    sed '/./,$!d' | 
    sed ':a;/^\n*$/{$d;N;ba;}'
}

generate_sql() {
  local TABLE=$1  

  # For Mysql append: CHARACTER SET utf8 COLLATE utf8_bin;"  
  echo "CREATE TABLE $TABLE(word varchar(255), html text, text text);"
   
  while read FILE; do
    WORD=$(basename "$FILE" ".html")
    HTML=$(< "$FILE" escape_sql)
    TEXT=$(cat "$FILE" | grep -v "<title" | remove_html_tags | remove_blank_lines | escape_sql)
    echo "INSERT INTO $TABLE (word, html, text) VALUES ('$WORD', '$HTML', '$TEXT');"
  done
  
  echo "CREATE INDEX word_index ON words (word);"
}

generate_jargon_input() {
  while read HTMLFILE; do
    WORD=$(basename "$HTMLFILE" ".html")
    DEFINITION=$(cat "$HTMLFILE" | grep -v "<title" | remove_html_tags | remove_blank_lines)
    # Jargon (-f) format 
    echo ":$WORD:$DEFINITION"
  done
}

generate_dict() {
  local NAME=$1  
  
  generate_jargon_input |
    tee $NAME.jargon | 
    dictfmt -j --utf8 --without-headword -s "$NAME" "$NAME"
  dictzip $NAME.dict
  echo "$NAME.index $NAME.dict.dz"
}

generate_dictionaries() {
  local DIRECTORY=$1 NAME=$2  
  
  find "$DIRECTORY" -type f -name '*.html' |
    tee >(generate_sql words | gzip > $NAME.sql.gz) | 
    generate_dict $NAME
}

generate_dictionaries "html-defs" "drae"
