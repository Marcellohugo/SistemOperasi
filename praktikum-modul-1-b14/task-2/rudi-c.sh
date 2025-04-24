#!/bin/bash

# File log yang diberikan
LOG_FILE="/home/marcomanalu/Documents/praktikum-modul-1-b14/access.log"

# Menghitung jumlah status code 500 per IP
awk '$9 == 500 {count[$1]++} END {for (ip in count) print ip, count[ip]}' "$LOG_FILE" | sort -k2 -nr | head -n1
