#!/bin/bash

# Meminta input dari user
echo "Masukkan Tanggal (MM/DD/YYYY):"
read tanggal
echo "Masukkan IP Address (192.168.1.X):"
read ip

# File sumber
data_peminjaman="/home/marcomanalu/Documents/praktikum-modul-1-b14/peminjaman_computer.csv"
data_log="/home/marcomanalu/Documents/praktikum-modul-1-b14/access.log"
backup_dir="/home/marcomanalu/Documents/praktikum-modul-1-b14/backup"

# Pastikan direktori backup ada
mkdir -p "$backup_dir"

# Konversi tanggal ke format pencarian yang sesuai dengan CSV (DD/MM/YYYY)
tanggal_csv=$(echo "$tanggal" | awk -F'/' '{printf "%02d/%02d/%04d", $2, $1, $3}')

# Ambil nomor komputer dari IP Address
nomor_komputer=$(echo "$ip" | awk -F'.' '{print $4}')

# Cari pengguna berdasarkan nomor komputer dan tanggal di CSV
pengguna=$(awk -F, -v tanggal="$tanggal_csv" -v nomor="$nomor_komputer" '$1 == tanggal && $2 == nomor {print $3}' "$data_peminjaman")

# Jika pengguna tidak ditemukan
if [[ -z "$pengguna" ]]; then
    echo "Data yang kamu cari tidak ada"
    exit 1
fi

echo "Pengguna saat itu adalah $pengguna"

# File backup log
timestamp=$(date +"%H%M%S")
backup_file="$backup_dir/${pengguna}_$(echo "$tanggal" | sed 's@/@@g')_${timestamp}.log"

# Format tanggal untuk pencarian log (ubah MM/DD/YYYY ke DD/Mon/YYYY)
log_tanggal=$(date -d "$tanggal" +"%d/%b/%Y")

# Ekstrak log aktivitas pengguna berdasarkan IP dan tanggal
grep "$ip" "$data_log" | grep "$log_tanggal" | awk '{print $4, $6, $7, $9}' > "$backup_file"

echo "Log Aktivitas $pengguna disimpan di $backup_file"
