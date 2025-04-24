#!/bin/bash

FILE="/home/farqil/Downloads/newjeans_analysis/DataStreamer.csv"

if [[ ! -f "$FILE" ]]; then
    echo "File $FILE tidak ditemukan!"
    exit 1
fi

hasil=$(awk -F, '$2 ~ /[0-9]/ {print $3}' "$FILE" | sort | uniq -c | sort -nr | head -n 1)
user=$(echo "$hasil" | awk '{print $1}')
lagu=$(echo "$hasil" | awk '{print $2}')
echo "Lagu yang paling banyak distreaming oleh username berangka:"
echo "$user $lagu"
if [[ "$user" -ge 24 ]]; then
        echo "Keren, Minji! Kamu hebat <3!"
else
        echo "Maaf, Minji, total streamingnya tidak sesuai harapan :("
fi
