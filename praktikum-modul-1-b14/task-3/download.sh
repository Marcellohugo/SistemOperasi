#!/bin/bash
BASE_DIR="/home/marcomanalu/Documents/praktikum-modul-1-b14/cloud_storage"
flag_file="$BASE_DIR/.download_flag"
download_dir="$BASE_DIR/downloads"

[[ ! -f "$flag_file" ]] && { echo "Error: .download_flag not found!" >&2; exit 1; }

username=$(cat "$flag_file")
user_dir="$download_dir/$username"
mkdir -p "$user_dir" || { echo "Failed to create user directory!" >&2; exit 1; }

timestamp=$(date +"%H-%M_%d-%m-%Y")
temp_dir=$(mktemp -d)

# Gunakan Picsum sebagai alternatif
wget -qO "$temp_dir/image.jpg" "https://picsum.photos/1200/800.jpg?random=1&nature" || {
    echo "Download failed! Check internet connection or URL." >&2
    rm -rf "$temp_dir"
    exit 1
}

# Validasi file gambar
if [ ! -f "$temp_dir/image.jpg" ]; then
    echo "Error: No image downloaded!" >&2
    rm -rf "$temp_dir"
    exit 1
fi

# Zip file
zip -qj "$user_dir/$timestamp.zip" "$temp_dir"/*.jpg || { 
    echo "Zipping failed! Ensure 'zip' is installed." >&2
    rm -rf "$temp_dir"
    exit 1
}
rm -rf "$temp_dir"

echo "Download successful! File: $user_dir/$timestamp.zip"
