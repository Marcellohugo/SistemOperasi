#!/bin/bash
BASE_DIR="/home/marcomanalu/Documents/praktikum-modul-1-b14/cloud_storage"
download_dir="$BASE_DIR/downloads"
archive_dir="$BASE_DIR/archives"

for user_dir in "$download_dir"/*/; do
    username=$(basename "$user_dir")
    user_archive="$archive_dir/$username"
    mkdir -p "$user_archive"
    
    files=("$user_dir"*.zip)
    if [ ${#files[@]} -gt 0 ]; then
        archive_name="archive_$(date +'%H-%d-%m-%Y').zip"
        zip -qj "$user_archive/$archive_name" "${files[@]}"
        rm -f "${files[@]}"
    fi
done