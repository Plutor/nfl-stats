#!/bin/bash

TEAMS="nwe buf mia nyj pit cin rav cle clt htx jax oti den sdg kan rai
       dal phi nyg was gnb det min chi car nor atl tam sea crd sfo ram"

# Get roster html
for TEAM in $TEAMS; do for YEAR in `seq 1998 2014`; do
  if [ \! -s ${TEAM}_${YEAR}_roster.html ]; then
    wget "http://widgets.sports-reference.com/wg.fcgi?css=1&site=pfr&url=%2Fteams%2F${TEAM}%2F${YEAR}_roster.htm&div=div_games_played_team" \
        -O ${TEAM}_${YEAR}_roster.html
    sleep 1
  fi
done; done

# Convert to csv
for TEAM in $TEAMS; do for YEAR in `seq 1998 2014`; do
  cat ${TEAM}_${YEAR}_roster.html | grep '^<table' | \
  sed -e 's/<\/\(a\|td\|tr\)>//g; s/<tr[^>]*>/"\n"/g; s/<td[^>]*>/","/g; s/<a href="//g; s/">/","/g; ' | \
  grep -v '^<table\|"<th' \
    > ${TEAM}_${YEAR}_roster.csv
done; done
