#!/bin/bash

FILE="/home/farqil/Downloads/newjeans_analysis/DataStreamer.csv"

if [[ ! -f "$FILE" ]]; then
    echo "File $FILE tidak ditemukan!"
    exit 1
fi

echo "Jumlah user beserta devicenya (Descending) :"
awk -F, 'NR > 1 {print $7}' "$FILE" | sort | uniq -c | sort -nr

echo ""

echo "Jumlah waktu streaming beserta devicenya (Descending) :"
awk -F,  'NR > 1 {device[$7]+=$4} END{for(d in device){print "   "device[d]" "d}}' "$FILE" | sort -nr

echo ""

awk -F, 'NR > 1 {print $7}' "$FILE" | sort | uniq -c | sort -nr | head -n 1 | awk '{print "Device dengan user terbanyak :", $1, "|", $2, $3}'
awk -F, 'NR > 1 {device[$7]+=$4} END{for(d in device){print "Device dengan waktu streaming terbanyak : " device[d] " | " d}}' "$FILE" | sort -nr | head -n 1

awk -F, '
NR > 1 {
        device[$7] += $4
        user[$7,$2]++
}
END {
    for(d in device){
        user_count = 0
        for (u in user) if (index(u, d) == 1) user_count++
        loyalty = device[d] / user_count
        print "Device terloyal (rasio waktu streaming / jumlah user terbanyak) :", loyalty, "|", d
    }
}
' "$FILE" | sort -nr | head -n 1
