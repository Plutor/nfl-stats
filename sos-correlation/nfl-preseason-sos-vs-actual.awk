# awk -f nfl-preseason-sos-vs-actual.awk ../nfl-game-results-1970-2014.csv

BEGIN {
  FS=","
  print "Season,Team,Actual SOS,Predicted SOS"
}
/^Season/ { next }

function calc_sos(this_st, last_st) {
  # Calculate the teams win percent
  for (team in this_st) {
    this_st[team]["wperc"] = \
        (this_st[team]["W"] + 0.5*this_st[team]["T"]) / \
        (this_st[team]["W"] + this_st[team]["L"] + this_st[team]["T"])
  }

  # Calculate the teams SOS
  for (team in this_st) {
    total_opp_wperc = 0
    for (opp in this_st[team]["opp"]) {
      total_opp_wperc += (this_st[team]["opp"][opp] * \
                          this_st[opp]["wperc"])
    }
    this_st[team]["sos"] = total_opp_wperc / \
        (this_st[team]["W"] + this_st[team]["L"] + this_st[team]["T"])

    # Calculated the predicted SOS based on previous season's win percentages.
    if (isarray(last_st)) {
      total_opp_wperc = 0
      for (opp in this_st[team]["opp"]) {
        total_opp_wperc += (this_st[team]["opp"][opp] * \
                            last_st[opp]["wperc"])
      }
      this_st[team]["presos"] = total_opp_wperc / \
          (this_st[team]["W"] + this_st[team]["L"] + this_st[team]["T"])
    }

    printf("%d,%s,%.03f,%.03f\n", season, team,
           this_st[team]["sos"], this_st[team]["presos"])
  }
}

{
  if (season != $1) {
    if (season) {
      # New season!
      calc_sos(standings[season], standings[season-1])
    }

    season = $1
  }

  vt = $3
  vts = $4
  ht = $5
  hts = $6
  # Set winner and loser
  if (vts > hts) {
    standings[season][vt]["W"]++;
    standings[season][ht]["L"]++;
  } else if (vts < hts) {
    standings[season][vt]["L"]++;
    standings[season][ht]["W"]++;
  } else {
    standings[season][vt]["T"]++;
    standings[season][ht]["T"]++;
  }
  # Append to opponents list
  standings[season][vt]["opp"][ht]++;
  standings[season][ht]["opp"][vt]++
}

END {
  calc_sos(standings[season], standings[season-1])
}

