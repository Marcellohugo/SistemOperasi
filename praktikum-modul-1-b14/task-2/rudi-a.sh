#!/bin/bash

# Lokasi file log
LOG_FILE="/home/marcomanalu/Documents/praktikum-modul-1-b14/access.log"

# Cek apakah file log tersedia
if [[ ! -f "$LOG_FILE" ]]; then
    echo "File $LOG_FILE tidak ditemukan!"
    exit 1
fi

# Menampilkan total request per IP
echo "Total Request per IP:"
awk '{print $1}' "$LOG_FILE" | sort | uniq -c | sort -nr

echo ""

# Menampilkan jumlah dari setiap status code
echo "Jumlah Status Code:"
awk '{print $NF}' "$LOG_FILE" | sort | uniq -c | sort -nr
