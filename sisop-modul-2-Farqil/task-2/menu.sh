#!/bin/bash

# Fungsi untuk menampilkan menu
show_menu() {
    clear
    echo "================================="
    echo " Menu Utama - Anthony's Program "
    echo "================================="
    echo "1. Download File"
    echo "2. Mengelompokkan Film"
    echo "3. Membuat Report"
    echo "4. Keluar"
    echo "================================="
    echo -n "Masukkan pilihan Anda [1-4]: "
}

# Fungsi untuk menjalankan script dan menangani error
run_script() {
    local script=$1
    echo "Menjalankan $script..."
    
    if [ -f "$script" ]; then
        if [ -x "$script" ]; then
            ./"$script"
            local status=$?
            if [ $status -ne 0 ]; then
                echo "Error: $script gagal dijalankan dengan status $status"
                read -p "Tekan Enter untuk melanjutkan..."
            fi
        else
            echo "Error: $script tidak memiliki izin eksekusi"
            read -p "Tekan Enter untuk melanjutkan..."
        fi
    else
        echo "Error: File $script tidak ditemukan"
        read -p "Tekan Enter untuk melanjutkan..."
    fi
}

# Main program
while true; do
    show_menu
    read choice
    
    case $choice in
        1)
            run_script "download_extract.sh"
            ;;
        2)
            run_script "sort_movies.sh"
            ;;
        3)
            # Kompilasi Anthony.c jika diperlukan
            if [ -f "Anthony.c" ]; then
                echo "Mengkompilasi Anthony.c..."
                gcc Anthony.c -o Anthony
                if [ $? -eq 0 ]; then
                    run_script "Anthony"
                else
                    echo "Error: Gagal mengkompilasi Anthony.c"
                    read -p "Tekan Enter untuk melanjutkan..."
                fi
            else
                echo "Error: File Anthony.c tidak ditemukan"
                read -p "Tekan Enter untuk melanjutkan..."
            fi
            ;;
        4)
            echo "Terima kasih, sampai jumpa!"
            exit 0
            ;;
        *)
            echo "Pilihan tidak valid. Silakan pilih 1-4."
            read -p "Tekan Enter untuk melanjutkan..."
            ;;
    esac
done