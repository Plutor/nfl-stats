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
    DATA=( $(cat ${TEAM}_${YEAR}_injuries.html | grep -A1 '<h2>Totals</h2>' | tail -1 |
             sed -e 's/<[^>]*>/\n/g' | grep -v '^$') )

    for ((i=0; i<${#DATA[*]}; i++)); do
      if [[ ${DATA[i]} == "Probable" ]]; then
        PR=${DATA[i+1]}
        PP=${DATA[i+2]}
      elif [[ ${DATA[i]} == "Questionable" ]]; then
        QR=${DATA[i+1]}
        QP=${DATA[i+2]}
      elif [[ ${DATA[i]} == "Doubtful" ]]; then
        DR=${DATA[i+1]}
        DP=${DATA[i+2]}
      fi
    done

    printf "%s,%d,%d,%d,%d,%d,%d,%d\n" "$TEAM" "$YEAR" "$PR" "$PP" "$QR" "$QP" "$DR" "$DP"

    unset IFS
  done
done
