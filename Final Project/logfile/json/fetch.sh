#!/bin/bash

# Fetch Airbox json file to format like 2018-12-09-0334.json

while [ 1 ]
do
  now="$(date +'%Y-%m-%d-%H%M')"
  wget -O $now.json https://pm25.lass-net.org/data/last-all-airbox.json
  echo "Fetch time:" "$now"
  sleep 300
done

