#!/bin/bash
set -e

MONTHS=(enero febrero marzo abril mayo junio julio agosto septiembre agosto
        septiembre octubre noviembre diciembre)

PDF=$1
STRDATE=$(pdftohtml -xml -stdout "$PDF" | grep '<text top="1"' | tail -n1 | \
          grep -o ">.*<" | tr -d '<>' | cut -d"," -f2- | xargs | tr '[A-Z]' '[a-z]')
read DAY MONTH YEAR <<< "$STRDATE"  
NMONTH=$(echo ${MONTHS[*]} | xargs -n1 | cat -n | awk "\$2 == \"$MONTH\"" | \
         awk '{print $1}' | xargs)

printf "%d-%02d-%02d %s\n" $YEAR $NMONTH $DAY "$STRDATE"
