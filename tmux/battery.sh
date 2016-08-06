#!/usr/bin/env bash

function raw_data {
  pmset -g batt
}

if [ `uname` = "Darwin" ]; then
  PERC=$(raw_data | grep "InternalBattery" | awk '{print $2}' | sed -e 's/[^0-9]//g')
  if [ $PERC -gt 50 ]; then
    COLOR="#[fg=colour22]"
  elif [ $PERC -gt 20 ]; then
    COLOR="#[fg=colour58]"
  else
    COLOR="#[fg=colour1]"
  fi
  echo "#[bg=colour237,bold]$COLOR $PERC#[fg=colour240]% #[bg=colour235]"
else
  echo ""
fi

