#!/bin/bash

DATA="/home/farqil/Downloads/newjeans_analysis/DataStreamer.csv"
ALBUM="/home/farqil/Downloads/newjeans_analysis/AlbumDetails.csv"

if [[ ! -f "$DATA" ]]; then
    echo "File $DATA tidak ditemukan!"
    exit 1
fi

if [[ ! -f "$ALBUM" ]]; then
    echo "File $ALBUM tidak ditemukan!"
    exit 1
fi

lagu=$(awk -F, '$2 ~ /[0-9]/ {print $3}' "$DATA" | sort | uniq -c | sort -nr | head -n 1 | awk '{print $2}')
echo "Lagu favorit : $lagu"
awk -F, -v song="$lagu" '$2 == song {print "Album :",  $1, "\nTahun Rilis :", $3}' "$ALBUM"
