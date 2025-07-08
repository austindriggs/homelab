#!/bin/bash

# Network prefix
SUBNET="172.16.58"

# Start and end of host range (193-254)
START=193
END=254

echo "Scanning network $SUBNET.XXX from $START to $END..."

for i in $(seq $START $END); do
    IP="$SUBNET.$i"
    ping -c 1 -W 1 $IP &> /dev/null && echo "Host $IP is up"
done

echo "Scan complete."

