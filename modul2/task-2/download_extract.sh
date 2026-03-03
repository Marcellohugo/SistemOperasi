#!/bin/bash

# === Konfigurasi ===
FILE_ID="12GWsZbSH858h2HExP3x4DfWZB1jLdV-J"
FILE_NAME="netflixData.zip"
DEST_FOLDER="netflixData"

# === Step 1: Download ZIP dari Google Drive ===
echo "[INFO] Mengunduh file ZIP dari Google Drive..."

wget --no-check-certificate "https://drive.google.com/uc?export=download&id=${FILE_ID}" -O "$FILE_NAME"

if [[ $? -ne 0 ]]; then
  echo "[ERROR] Gagal mengunduh file."
  exit 1
fi

echo "[INFO] Unduhan selesai: $FILE_NAME"

# === Step 2: Ekstrak ke folder tujuan ===
echo "[INFO] Mengekstrak file ZIP..."

mkdir -p "$DEST_FOLDER"
unzip -q "$FILE_NAME" -d "$DEST_FOLDER"

if [[ $? -ne 0 ]]; then
  echo "[ERROR] Gagal mengekstrak file ZIP."
  exit 1
fi

echo "[INFO] Ekstraksi selesai ke folder '$DEST_FOLDER'"

# === Step 3: Hapus file ZIP ===
rm "$FILE_NAME"
echo "[INFO] File ZIP dihapus."

# === Selesai ===
echo "[DONE] Semua proses selesai."
