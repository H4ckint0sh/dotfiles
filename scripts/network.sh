#!/usr/bin/env bash

output=$(/System/Library/PrivateFrameworks/Apple80211.framework/Versions/A/Resources/airport -I)
airport=$(echo "$output" | grep 'AirPort' | awk -F': ' '{print $2}')

if [ "$airport" = "Off" ]; then
  echo "Offline"
else
  echo "$(echo "$output" | grep ' SSID' | xargs | awk -F': ' 'echo $2' | sed 's/SSID: //')"
fi
