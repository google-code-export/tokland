#!/bin/bash
set -e

debug() { echo "$@" >&2; }

download() {
  local OUTDIR=$1; local START=$2; local END=$3
  mkdir -p "$OUTDIR"
  RETVAL=0
  for ID in $(seq $START $END); do
    debug -n "id $ID... "
    URL="http://buscon.rae.es/draeI/SrvltObtenerHtml?origen=RAE&IDLEMA=$ID"
    FILE="$OUTDIR/$ID.html"
    test -s "$FILE" && { debug "exists"; continue; }
    curl -s -o "$FILE" "$URL" || 
      { RETVAL=1; debug "error"; continue; }
    debug "done"
    echo "$FILE"
  done
  return $RETVAL
}

download "html" ${1:-1} ${2:-100000} || exit $?
