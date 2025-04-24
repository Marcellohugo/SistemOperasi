#!/bin/bash

FILE="/home/farqil/Downloads/newjeans_analysis/DataStreamer.csv"

if [[ ! -f "$FILE" ]]; then
    echo "File $FILE tidak ditemukan!"
    exit 1
fi

echo "Nama yang memenuhi syarat (ASCII kecil ke terbesar):"
awk -F, '$2 ~ /2/ && $2 !~ /_/ {print $2}' "$FILE" | sort
count=$(awk -F, '$2 ~ /2/ && $2 !~ /_/ {count++} END {print count}' "$FILE")
echo "Nama yang sesuai syarat ada $count kali"
