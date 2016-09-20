#!/usr/bin/env bash

function raw_data {
  pmset -g batt
}

if [ `uname` = "Darwin" ]; then
  PERC=$(raw_data | grep "InternalBattery" | awk '{print $2}' | sed -e 's/[^0-9]//g')
  CHARGING=$(raw_data | grep "charging")
  DISCHARGING=$(raw_data | grep "discharging")
  if [ -z "$PERC" ]; then
    echo ""
  else
    if [ $PERC -gt 50 ]; then
      COLOR="#[fg=colour22]"
    elif [ $PERC -gt 20 ]; then
      COLOR="#[fg=colour136]"
    else
      COLOR="#[fg=colour1]"
    fi
    if [ ! -z "${DISCHARGING}" ]; then
      DIR="-"
    else
      if [ ! -z "${CHARGING}" ]; then
        DIR="+"
      else
        DIR=""
      fi
    fi
    echo "#[bg=colour237,bold] ${COLOR}${PERC}%${DIR}#[fg=colour240] #[bg=colour235]"
  fi
else
  echo ""
fi

