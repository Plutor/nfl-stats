#!/bin/bash

TEAMS="nwe buf mia nyj pit cin rav cle clt htx jax oti den sdg kan rai
       dal phi nyg was gnb det min chi car nor atl tam sea crd sfo ram"

>tenure.csv

# Get the list of URLs for 2014 and get the number of those URLs that also
# appear in previous years.
for TEAM in $TEAMS; do
  LASTCOMM=$(cut -d, -f3 ${TEAM}_2014_roster.csv | grep pro-football-reference.com/players | sort)
  printf "%s,2014,%d\n" $TEAM $(echo $LASTCOMM | wc -w)  >> tenure.csv
  for YEAR in `seq 2013 -1 1998`; do
    COMM=$(comm <(echo $LASTCOMM | tr ' ' '\n') \
                <(cut -d, -f3 ${TEAM}_${YEAR}_roster.csv | grep pro-football-reference.com/players | sort) \
                -1 -2)
    N=$(echo $COMM | wc -w)

    #if [[ $N < 2 && $(echo $LASTCOMM | wc -w) > 1 ]]; then
    #  # Longest tenured teammates
    #  echo $LASTCOMM | sed -e "s/\"\([^\"]*\)\"/[](\1)/g; s/ /, /g; s/^/* $((YEAR+1)): $TEAM /"
    #fi
    #if [[ $N == 0 && -n $LASTCOMM ]]; then
    #  # Longest tenured players
    #  echo $LASTCOMM | sed -e "s/\"\([^\"]*\)\"/[](\1)/g; s/ /, /g; s/^/* $((YEAR+1)): $TEAM /"
    #fi

    LASTCOMM=$COMM
    printf "%s,%d,%d\n" $TEAM $YEAR $N  >> tenure.csv
done; done
wc -l tenure.csv
