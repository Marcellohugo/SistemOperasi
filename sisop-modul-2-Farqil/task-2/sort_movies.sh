#!/bin/bash

MOVIES_DIR="netflixData"
MOVIES_FILE=$(find "$MOVIES_DIR" -type f -name "*.csv" | head -n 1)

mkdir -p judul tahun
> log.txt

# Judul
sort_by_title() {
  tail -n +2 "$MOVIES_FILE" | while IFS=',' read -r title director country year; do
    # Validasi tahun
    if [[ ! "$year" =~ ^[0-9]{4}$ ]]; then
      continue
    fi

    # Bersihkan kutipan dan spasi
    title_clean=$(echo "$title" | sed 's/^"//;s/"$//')
    director_clean=$(echo "$director" | sed 's/^"//;s/"$//')

    first="${title_clean:0:1}"
    if [[ "$first" =~ [A-Za-z0-9] ]]; then
      out_file="judul/${first^^}.txt"
    else
      out_file="judul/#.txt"
    fi

    echo "$title_clean - $year - $director_clean" >> "$out_file"
    echo "[$(date +%T)] Proses mengelompokkan berdasarkan Abjad: sedang mengelompokkan untuk film $title_clean" >> log.txt
  done
}

# Tahun
sort_by_year() {
  tail -n +2 "$MOVIES_FILE" | while IFS=',' read -r title director country year; do
    if [[ ! "$year" =~ ^[0-9]{4}$ ]]; then
      continue
    fi

    title_clean=$(echo "$title" | sed 's/^"//;s/"$//')
    director_clean=$(echo "$director" | sed 's/^"//;s/"$//')

    out_file="tahun/${year}.txt"
    echo "$title_clean - $year - $director_clean" >> "$out_file"
    echo "[$(date +%T)] Proses mengelompokkan berdasarkan Tahun: sedang mengelompokkan untuk film $title_clean" >> log.txt
  done
}

sort_by_title &
sort_by_year &
wait

echo "[DONE] Pengelompokan berhasil dan log.txt sudah terisi."
