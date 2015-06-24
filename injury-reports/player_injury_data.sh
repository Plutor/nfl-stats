TEAMS="nwe buf mia nyj pit cin rav cle clt htx jax oti den sdg kan rai
       dal phi nyg was gnb det min chi car nor atl tam sea crd sfo ram"

for TEAM in $TEAMS; do
  for YEAR in `seq 2014 -1 2009`; do
    if [[ ! -f ${TEAM}_${YEAR}_injuries.html ]]; then
      wget "http://www.pro-football-reference.com/teams/${TEAM}/${YEAR}_injuries.htm" \
          -O ${TEAM}_${YEAR}_injuries.html
      sleep 1
    fi

    IFS=$'\n'
    DATA=( $(cat ${TEAM}_${YEAR}_injuries.html | grep '<h2>Team Injuries</h2>' |
    		 sed -e 's/<td><\/td>/<td>-<\/td>/g; s/<\/\?\(t\|span\)[^>]*>/\n/g' |
    		 grep -v '^$' ) )

	  PLAYER=""
    declare -A PLDATA
    for ((i=0; i<${#DATA[*]}; i++)); do
      if [[ ${DATA[i]} =~ \/boxscores\/ ]]; then
        true  # skip headers
      elif [[ ${DATA[i]} =~ \.htm ]]; then
        PLAYER=${DATA[i]}
      elif [[ $PLAYER != "" && ${DATA[i]} =~ ^[PQD] ]]; then
        printf "%s\n" $PLAYER
      fi
    done
    unset IFS
  done
done | sed -e 's/<a href="\/players\/[^"]*">\([^<]*\)<\/a>/\1/g' | sort | uniq -c | sort -rn | \
  sed -e 's/^ *//; s/\([0-9]\) \(.\)/\1,\2/g'
