#!/bin/bash

#choice=$(find $HOME/Pictures/Backgrounds -name '*.jpg' -type f | shuf -n1)
#gsettings set org.gnome.desktop.background picture-uri "file://$choice"

trap die SIGINT

die() {
	echo "Ending background shuffle."
	exit 0
}

while true; do
	feh --bg-scale --randomize --no-fehbg $(find $HOME/Pictures/Backgrounds -type f)
	sleep 30m
done

