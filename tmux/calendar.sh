#!/usr/bin/env bash

GCALC=$(which gcalcli)
if [ -z "${GCALC}" ]; then
  true
else
  NEXT_ITEM=$(${GCALC} --nocolor agenda --nostarted --nodeclined --no-military | grep "[0-9]:[0-9][0-9]" | head -1 | sed -e 's/^[ \t]*//' | sed "s/[[:space:]]\{2,\}/ - /g")
  echo "| #[fg=colour147,bg=colour238,bold]${NEXT_ITEM}#[fg=colour240,default]"
fi

