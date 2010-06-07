#!/bin/bash
set -e

debug() { echo "$@" >&2; }

download() {
  local OUTDIR=$1; local START=$2; local END=$3
  mkdir -p "$OUTDIR"
  seq $START $END | while read ID; do
    debug -n "id $ID... "
    URL="http://buscon.rae.es/draeI/SrvltObtenerHtml?origen=RAE&IDLEMA=$ID"
    FILE="$OUTDIR/$ID.html"
    curl -s "$URL" >  "$FILE" || 
      { debug "error"; continue; }
    debug "done"
    echo "$FILE"
  done
}

download "html" 1 100000
