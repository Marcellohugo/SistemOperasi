[![Review Assignment Due Date](https://classroom.github.com/assets/deadline-readme-button-22041afd0340ce965d47ae6ef1cefeee28c7c493a6346c4f15d667ab976d596c.svg)](https://classroom.github.com/a/Ph837wyE)
|    NRP     |      Name      |
| :--------: | :------------: |
| 5025221102 | Marco Marcello Hugo |
| 5025241015 | Farrel Aqilla Novianto |

# Praktikum Modul 1 _(Module 1 Lab Work)_

</div>

### Daftar Soal _(Task List)_

- [Task 1 - New Jeans Global Teratas _(Top Global New Jeans)_](/task-1/)

- [Task 2 - Liburan Bersama Rudi _(Holiday with Rudi)_](/task-2/)

- [Task 3 - Ignatius Si Cloud Engineer _(Ignatius The Cloud Engineer)_](/task-3/)

- [Task 4 - Proxy Terbaik di New Eridu _(Best Proxy in New Eridu)_](/task-4/)

### Laporan Resmi Praktikum Modul 1 _(Module 1 Lab Work Report)_

## Task 1 (Farrel)
### a. Minji penasaran dengan nama-nama user yang mendengarkan lagunya pada platform “N”. Berhubung Minji sangat menyukai angka 2 dan ia sangat membenci orang yang membuat username menggunakan underscore (_), bantulah Minji untuk mendapatkan username yang sesuai dengan kriterianya (terdapat angka 2 dan tidak terdapat underscore) dan tampilkan jumlahnya. Pastikan username yang ditampilkan berurutan berdasarkan ASCII Table (dari kecil ke besar).

Rule: gunakan ```DataStreamer.csv```

1. Saya membuka terminal dan membuka file script di "~/home/farqil/praktikum-modul-1-b14/task-1:
    ``` bash
   nano ~/home/farqil/praktikum-modul-1-b14/task-1/new-jeans-a.sh
    ```
2. Saya memasukan program pada "~/new-jeans-a.sh" :

Source Code
``` bash

#!/bin/bash

# Lokasi file CSV
FILE="/home/farqil/Downloads/newjeans_analysis/DataStreamer.csv"
# Variabel FILE berisi path menuju file csv (DataStreamer.csv) yang akan dianalisis

# Cek apakah file CSV tersedia
if [[ ! -f "$FILE" ]]; then
    echo "File $FILE tidak ditemukan!"
    exit 1
fi
# [[ ! -f "$FILE" ]] → Mengecek apakah file tidak ada (! berarti "tidak")
# Jika file tidak ditemukan, program akan mencetak pesan dan berhenti (exit 1)

# Menampilkan seluruh nama yang memenuhi syarat
echo "Nama yang memenuhi syarat (ASCII kecil ke terbesar):"

awk -F, '$2 ~ /2/ && $2 !~ /_/ {print $2}' "$FILE" | sort
# awk -F, → Field separator file csv yang berupa koma (,)
# '$2 ~ /2/ && $2 !~ /_/ {print $2}' "$FILE" → Membaca kolom ke-2 dari $FILE dengan kriteria memiliki angka 2 dan tidak memiliki underscore, lalu cetak kolom ke-2 atau usernamenya
# sort → Menyortir data dari ASCII terkecil ke terbesar

count=$(awk -F, '$2 ~ /2/ && $2 !~ /_/ {count++} END {print count}' "$FILE")
# Perintah count sama seperti awk diatas, namun disini dia membaca baris yang sesuai lalu dijumlahkan

# # Print jumlah keseluruhan nama yang memenuhi syarat
echo "Nama yang sesuai syarat ada $count kali"
```
3. Saya mengubah izin akses eksekusi dengan menambahkan '+x' 

``` bash
chmod +x ~/new-jeans-a.sh
```
4. Saya menjalankan program dengan :

``` bash
./new-jeans-a.sh
```
Output yang dihasilkan :
<p align="center">
   <img src="https://github.com/user-attachments/assets/ddbd49bf-0a02-4f27-822e-c9a86ec68065">
</p>

### b. Ternyata, Minji tidak hanya menyukai angka 2, tetapi semua angka. Ia ingin mengetahui lagu apa yang paling banyak di-streaming oleh user yang memiliki username berangka. Beri tahu Minji nama lagu tersebut dan jumlah usernya. Jika jumlah user tersebut tidak mencapai 24, maka berikan pesan kepada Minji “Maaf, Minji, total streamingnya tidak sesuai harapan :(“. Jika jumlah user mencapai atau melebihi 24, berikan pesan kepada Minji “Keren, Minji! Kamu hebat <3!”.

1. Saya membuka terminal dan membuka file script di "~/home/farqil/praktikum-modul-1-b14/task-1:
    ``` bash
   nano ~/home/farqil/praktikum-modul-1-b14/task-1/new-jeans-b.sh
    ```
2. Saya memasukan program pada "~/new-jeans-b.sh" :

Source Code
``` bash

#!/bin/bash

# Lokasi file CSV
FILE="/home/farqil/Downloads/newjeans_analysis/DataStreamer.csv"
# Variabel FILE berisi path menuju file csv (DataStreamer.csv) yang akan dianalisis

# Cek apakah file CSV tersedia
if [[ ! -f "$FILE" ]]; then
    echo "File $FILE tidak ditemukan!"
    exit 1
fi
# [[ ! -f "$FILE" ]] → Mengecek apakah file tidak ada (! berarti "tidak")
# Jika file tidak ditemukan, program akan mencetak pesan dan berhenti (exit 1)

hasil=$(awk -F, '$2 ~ /[0-9]/ {print $3}' "$FILE" | sort | uniq -c | sort -nr | head -n 1)
# -F, → Field separator file csv yang berupa koma (,)
# '$2 ~ /[0-9]/ {print $3}' "$FILE": → Membaca kolom ke-2 dari $FILE dengan kriteria memiliki angka, lalu cetak kolom ke-3 atau judul lagu

# sort → Mengurutkan nama lagu secara alfabetis
# uniq -c → Menghitung kemunculan setiap lagu
# sort -nr→ Mengurutkan hasil berdasarkan jumlah kemunculan secara descending (dari terbesar ke terkecil)
# head -n 1 → Mengambil baris pertama (lagu dengan jumlah streaming terbanyak)

# Hasilnya disimpan dalam variabel hasil.

user=$(echo "$hasil" | awk '{print $1}')
# Mengambil kolom pertama dari variabel hasil, yaitu jumlah streamer

lagu=$(echo "$hasil" | awk '{print $2, $3, $4}')
# Mengambil kolom kedua dari variabel hasil, yaitu nama lagu. Mengambil maks 3 kata karena data judul lagu yang paling panjang memiliki 3 kata

echo "Lagu yang paling banyak distreaming oleh username berangka>>"
echo "$user $lagu"
# Cetak jumlah user dan judul lagu paling populer

if [[ "$user" -ge 24 ]]; then
# Jika jumlah user lebih besar atau sama dengan 24 dia akan bernilai TRUE dan mencetak teks dibawah ini
        echo "Keren, Minji! Kamu hebat <3!"
else
# Jika jumlah user kurang dari 24 dia akan bernilai FALSE dan mencetak teks dibawah ini
        echo "Maaf, Minji, total streamingnya tidak sesuai harapan :("
fi
```
3. Saya mengubah izin akses eksekusi dengan menambahkan '+x' 

``` bash
chmod +x ~/new-jeans-b.sh
```
4. Saya menjalankan program dengan :

``` bash
./new-jeans-b.sh
```
Output yang dihasilkan :
<p align="center">
   <img src="https://github.com/user-attachments/assets/5a8f499b-2734-4083-b766-1909e3652858">
</p>

### c. Tiba-tiba Minji lupa, di album mana lagu yang paling banyak di-streaming tersebut berada. Carikan Minji nama album dari lagu yang paling banyak di-streaming di platform tersebut, beserta tahun rilisnya!

Rule: wajib menggunakan ```AlbumDetails.csv``` dan output tidak menggunakan tanda petik (```" "```)

1. Saya membuka terminal dan membuka file script di "~/home/farqil/praktikum-modul-1-b14/task-1:
    ``` bash
   nano ~/home/farqil/praktikum-modul-1-b14/task-1/new-jeans-c.sh
    ```
2. Saya memasukan program pada "~/new-jeans-c.sh" :

Source Code
``` bash                                                                                
#!/bin/bash

# Lokasi file CSV
DATA="/home/farqil/Downloads/newjeans_analysis/DataStreamer.csv"
# Variabel FILE berisi path menuju file csv (DataStreamer.csv) yang akan dianalisis
ALBUM="/home/farqil/Downloads/newjeans_analysis/AlbumDetails.csv"
# Variabel FILE berisi path menuju file csv (AlbumDetails.csv) yang akan dianalisis

# Cek apakah file CSV tersedia
if [[ ! -f "$DATA" ]]; then
    echo "File $DATA tidak ditemukan!"
    exit 1
fi
# [[ ! -f "$DATA" ]] → Mengecek apakah file tidak ada (! berarti "tidak")
# Jika file tidak ditemukan, program akan mencetak pesan dan berhenti (exit 1)

if [[ ! -f "$ALBUM" ]]; then
    echo "File $ALBUM tidak ditemukan!"
    exit 1
fi
# [[ ! -f "$ALBUM" ]] → Mengecek apakah file tidak ada (! berarti "tidak")
# Jika file tidak ditemukan, program akan mencetak pesan dan berhenti (exit 1

lagu=$(awk -F, '$2 ~ /[0-9]/ {print $3}' "$DATA" | sort | uniq -c | sort -nr | head -n 1 | awk '{print $2}')
# -F, → Field separator file csv yang berupa koma (,)
# '$2 ~ /[0-9]/ {print $3}' "$DATA": → Membaca kolom ke-2 dari $FILE dengan kriteria memiliki angka, lalu cetak kolom ke-3 atau judul lagu

# sort → Mengurutkan nama lagu secara alfabetis
# uniq -c → Menghitung kemunculan setiap lagu
# sort -nr→ Mengurutkan hasil berdasarkan jumlah kemunculan secara descending (dari terbesar ke terkecil)
# head -n 1 → Mengambil baris pertama (lagu dengan jumlah streaming terbanyak)
# awk '{print $2}' → Print hanya judul lagu

echo "Lagu favorit: $lagu"
# Cetak judul lagu favorit

awk -F, -v song="$lagu" '$2 == song {print "Album :",  $1, "\nTahun Rilis :", $3}' "$ALBUM"
# -F, → Field separator file csv yang berupa koma (,)
# -v song="$lagu" → Membuat variabel dari lagu favorit yang sudah dicari yang nantinya untuk membandingkan 
# '$2 == song {print "Album :",  $1, "\nTahun Rilis :", $3}' "$ALBUM" → Membandingkan antara judul lagu favorit dengan judul lagu yang ada di AlbumDetails.csv. Jika ada maka cetak album dan tahun rilisnya
```
3. Saya mengubah izin akses eksekusi dengan menambahkan '+x' 

``` bash
chmod +x ~/new-jeans-c.sh
```
4. Saya menjalankan program dengan :

``` bash
./new-jeans-c.sh
```
Output yang dihasilkan :
<p align="center">
   <img src="https://github.com/user-attachments/assets/5a8342b8-c910-466c-9d86-d52211fe596f">
</p>

### d. Minji ingin mengajukan ke agensi untuk membuat campaign iklan supaya lagu-lagu NewJeans lebih dikenal, tapi Minji bingung mau optimasi iklan untuk device apa. Berikut tugas kamu untuk membantu Minji menyusun proposal iklan sebelum diberikan ke CEO ADOR:<br>

Hitung berapa banyak pengguna yang menggunakan setiap jenis device (Tablet, Smart TV, Desktop, Mobile) untuk streaming lagu NewJeans.

Hitung total durasi streaming (detik) untuk setiap device.

Tentukan:

1. Device paling populer yang punya user terbanyak.
2. Device menang durasi yang memiliki total streaming tertinggi.
3. Device ter-“loyal” berdasarkan rasio (total durasi / user) tertinggi.
<br>

1. Saya membuka terminal dan membuka file script di "~/home/farqil/praktikum-modul-1-b14/task-1:
    ``` bash
   nano ~/home/farqil/praktikum-modul-1-b14/task-1/new-jeans-d.sh
    ```
2. Saya memasukan program pada "~/new-jeans-d.sh" :

Source Code
``` bash
#!/bin/bash

# Lokasi file CSV
FILE="/home/farqil/Downloads/newjeans_analysis/DataStreamer.csv"
# Variabel FILE berisi path menuju file csv (DataStreamer.csv) yang akan dianalisis

if [[ ! -f "$FILE" ]]; then
    echo "File $FILE tidak ditemukan!"
    exit 1
fi
# [[ ! -f "$FILE" ]] → Mengecek apakah file tidak ada (! berarti "tidak")
# Jika file tidak ditemukan, program akan mencetak pesan dan berhenti (exit 1)

# Menampilkan jumlah user per device
echo "Jumlah user beserta devicenya (Descending) :"
awk -F, 'NR > 1 {print $7}' "$FILE" | sort | uniq -c | sort -nr
# -F, → Field separator file csv yang berupa koma (,)
# 'NR > 1 {print $7}' "$FILE" → Melewati baris header / baris pertama lalu membaca data kolom-7 dari DataStreamer.csv

# sort → Mengurutkan device secara alfabetis
# uniq -c → Menghitung kemunculan setiap device
# sort -nr → Mengurutkan hasil berdasarkan jumlah kemunculan secara descending (dari terbesar ke terkecil)

# Spasi satu baris
echo ""

# Menampilkan jumlah waktu streaming per device
echo "Jumlah waktu streaming beserta devicenya (Descending) :"
awk -F,  'NR > 1 {device[$7]+=$4} END{for(d in device){print "   "device[d]" "d}}' "$FILE" | sort -nr
# -F, → Field separator file csv yang berupa koma (,)
# 'NR > 1 {device[$7]+=$4} → Melewati baris header / baris pertama lalu membaca data kolom-7 dari DataStreamer.csv
# {device[$7]+=$4} → Membuat atau mengakses elemen array device dengan isi berupa nama device ($7), lalu menambahkan nilai waktu streaming ($4) ke elemen array yang sesuai

# END{} → Blok kode ini dieksekusi setelah semua baris file selesai diproses
# for(d in device){print "   "device[d]" "d}}' "$FILE" → Loop melalui semua device di array device, lalu mencetak setiap device dan total waktu streamingnya. Semua kode ini berjalan dengan membaca $FILE
# sort -nr → Mengurutkan hasil berdasarkan jumlah kemunculan secara descending (dari terbesar ke terkecil)

# Spasi satu baris
echo ""

awk -F, 'NR > 1 {print $7}' "$FILE" | sort | uniq -c | sort -nr | head -n 1 | awk '{print "Device dengan user terbanyak :", $1, "|", $2, $3}'
# -F, → Field separator file csv yang berupa koma (,)
# 'NR > 1 {print $7}' "$FILE" → Melewati baris header / baris pertama lalu membaca data kolom-7 dari DataStreamer.csv

# sort → Mengurutkan device secara alfabetis
# uniq -c → Menghitung kemunculan setiap device
# sort -nr → Mengurutkan hasil berdasarkan jumlah kemunculan secara descending (dari terbesar ke terkecil)
# head -n 1 → Mengambil baris pertama (device dengan jumlah user terbanyak)
# awk '{print "Device dengan user terbanyak : " $1, "|", $2, $3} → Cetak device yang paling banyak digunakan dan jumlah usernya

awk -F, 'NR > 1 {device[$7]+=$4} END{for(d in device){print "Device dengan waktu streaming terbanyak : " device[d] " | " d}}' "$FILE" | sort -nr | head -n 1
# -F, → Field separator file csv yang berupa koma (,)
# 'NR > 1 → Melewati baris header / baris pertama
# {device[$7]+=$4} → Membuat atau mengakses elemen array device dengan isi berupa nama device ($7), lalu menambahkan nilai waktu streaming ($4) ke elemen array yang sesuai

# END{} → Blok kode ini dieksekusi setelah semua baris file selesai diproses
# for(d in device){print "   "device[d]" "d}}' "$FILE" → Loop melalui semua device di array device, lalu mencetak setiap device dan total waktu streamingnya. Semua kode ini berjalan dengan membaca $FILE
# sort -nr → Mengurutkan hasil berdasarkan jumlah kemunculan secara descending (dari terbesar ke terkecil)
# head -n 1 → Mengambil baris pertama (device dengan jumlah waktu streaming terbanyak)

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
# -F, → Field separator file csv yang berupa koma (,)
# 'NR > 1 → Melewati baris header / baris pertama
# {device[$7]+=$4} → Membuat atau mengakses elemen array device dengan isi berupa nama device ($7), lalu menambahkan nilai waktu streaming ($4) ke elemen array yang sesuai
# user[$7,$2]++ → Membuat atau mengakses elemen array dengan isi gabungan dari nama device dan nama user, lalu menghitung jumlah user per device.

# END{} → Blok kode ini dieksekusi setelah semua baris file selesai diproses
# for (d in device): → Iterasi untuk semua device
# user_count = 0 → Deklarasi variabel untuk menghitung jumlah user per device
# for (u in user) → Iterasi untuk semua user
# if (index(u, d) == 1) user_count++ → Memeriksa apakah device memeiliki user. Jika ya, tambahkan user_count
# loyalty = device[d] / user_count → Menghitung rasio loyalitas dari total waktu streaming dibagi jumlah user
# print "Device terloyal (rasio waktu streaming / jumlah user terbanyak) :", loyalty, "|", d → Cetak hasil perhitungan dengan rasio terbanyak

# "$FILE" → Membaca data dari $FILE
# sort -nr → Mengurutkan hasil berdasarkan jumlah kemunculan secara descending (dari terbesar ke terkecil)
# head -n 1 → Mengambil baris pertama (lagu dengan jumlah streaming terbanyak)
```
3. Saya mengubah izin akses eksekusi dengan menambahkan '+x' 

``` bash
chmod +x ~/new-jeans-d.sh
```
4. Saya menjalankan program dengan :

``` bash
./new-jeans-a.sh
```
Output yang dihasilkan :
<p align="center">
   <img src="https://github.com/user-attachments/assets/01bc6168-3ec1-4b3d-b059-d2523a061397">
</p>

## Task 2 (Marco)
### a. Karena melihat ada IP dan Status Code pada file [access.log](https://drive.google.com/file/d/1yf4lWB4lUgq4uxKP8Pr8pqcAWytc3eR4/view?usp=sharing) Rudi meminta praktikan untuk menampilkan total request yang dibuat oleh setiap IP dan menampilkan jumlah dari setiap status code.

1. Saya melihat isi file dengan:
   ``` bash
   cat ~/Documents/praktikum-modul-1-b14/access.log
   ```
2. Saya membuka terminal dan membuka file script di "~/Documents/praktikum-modul-1-b14":
    ``` bash
   nano ~/Documents/praktikum-modul-1-b14/rudi-a.sh
    ```

3. Saya memasukan program pada "~/rudi-a.sh" :

Source Code
``` bash

#!/bin/bash

# Lokasi file log
LOG_FILE="/home/marcomanalu/Documents/praktikum-modul-1-b14/access.log"
# Variabel LOG_FILE berisi path menuju file log (access.log) yang akan dianalisis.


# Cek apakah file log tersedia
if [[ ! -f "$LOG_FILE" ]]; then
    echo "File $LOG_FILE tidak ditemukan!"
    exit 1
fi
#[[ ! -f "$LOG_FILE" ]] → Mengecek apakah file tidak ada (! berarti "tidak").
# Jika file tidak ditemukan, program akan mencetak pesan dan berhenti (exit 1).

# Menampilkan total request per IP
echo "Total Request per IP:"
awk '{print $1}' "$LOG_FILE" | sort | uniq -c | sort -nr
# awk '{print $1}' "$LOG_FILE" → Mengambil kolom pertama dari setiap baris (biasanya berisi alamat IP dari pengunjung).
# sort → Mengurutkan IP secara alfabetis.
# uniq -c → Menghitung jumlah kemunculan setiap IP.
# sort -nr → Mengurutkan hasil berdasarkan jumlah request (dari terbesar ke terkecil).

echo ""

# Menampilkan jumlah dari setiap status code
echo "Jumlah Status Code:"
awk '{print $NF}' "$LOG_FILE" | sort | uniq -c | sort -nr

# awk '{print $NF}' "$LOG_FILE" → Mengambil kolom terakhir ($NF, "Number of Fields"), biasanya berisi status code (misalnya 200, 404, 500).
# sort → Mengurutkan status code.
# uniq -c → Menghitung jumlah masing-masing status code.
# sort -nr → Mengurutkan dari yang paling sering muncul.
```
4. Saya menggunakan linux dan file masih memiliki karakter carriage return (CR) dari format Windows (CRLF), bukan UNIX (LF). Ini menyebabkan skrip tidak dapat dijalankan dengan benar. Maka saya menggunakan 'tr' untuk membersihkan karakter '\r'

```bash
cat rudi-a.sh | tr -d '\r' > rudi-a-fixed.sh
mv rudi-a-fixed.sh rudi-a.sh
```
lalu saya mengubah izin akses eksekusi dengan menambahkan '+x' 

``` bash
chmod +x ~/Documents/rudi-a.sh
```
<p align="center">
   <img src="https://github.com/user-attachments/assets/bc980d37-937b-4c63-b7e1-0e25f8aff867" alt="Deskripsi Gambar">
</p>

5. Saya menjalankan program dengan :
``` bash
./rudi-a.sh
```

Ouput :

<p align="center">
   <img src=https://github.com/user-attachments/assets/a74bc543-efb3-4c16-b803-aa91cb1f4519>
</p>

Output pada gambar tersebut panjang dan saya hanya menunjukan intinya saja (bisa juga menggunakan perintah "head dan/atau tail")

### b. Karena banyaknya status code error, Rudi ingin tahu siapa yang menemukan error tersebut. Setelah melihat-lihat, ternyata IP komputer selalu sama. Dengan bantuan [peminjaman_komputer.csv](https://drive.google.com/file/d/1-aN4Ca0M3IQdp6xh3PiS_rLQeLVT1IWt/view?usp=drive_link), Rudi meminta kamu untuk membuat sebuah program bash yang akan menerima inputan tanggal dan IP serta menampilkan siapa pengguna dan membuat file backup log aktivitas

1. Saya melihat isi kedua file dengan:
   ``` bash
   cat ~/Documents/praktikum-modul-1-b14/peminjaman_computer.csv
   cat ~/Documents/praktikum-modul-1-b14/access.log
    ```

2. Saya membuka terminal dan membuka file script di "~/Documents/praktikum-modul-1-b14":
``` bash
nano ~/Documents/praktikum-modul-1-b14/rudi-b.sh
```

3. Saya memasukan program pada "~/rudi-b.sh":

Source Code
``` bash
#!/bin/bash

# Meminta input dari user
echo "Masukkan Tanggal (MM/DD/YYYY):"
read tanggal
echo "Masukkan IP Address (192.168.1.X):"
read ip
# read tanggal → Membaca tanggal dari input user.
# read ip → Membaca IP Address yang dimasukkan user.

# File sumber
data_peminjaman="/home/marcomanalu/Documents/praktikum-modul-1-b14/peminjaman_computer.csv"
data_log="/home/marcomanalu/Documents/praktikum-modul-1-b14/access.log"
backup_dir="/home/marcomanalu/Documents/praktikum-modul-1-b14/backup"
# data_peminjaman → Menunjuk file CSV yang menyimpan data peminjaman komputer.
# data_log → Menunjuk file log sistem.
# backup_dir → Direktori tempat menyimpan log hasil pencarian.

# Pastikan direktori backup ada
mkdir -p "$backup_dir"
# mkdir -p "$backup_dir" → Membuat direktori backup jika belum ada.

# Konversi tanggal ke format pencarian yang sesuai dengan CSV (DD/MM/YYYY)
tanggal_csv=$(echo "$tanggal" | awk -F'/' '{printf "%02d/%02d/%04d", $2, $1, $3}')
# Konversi tanggal dari format MM/DD/YYYY (input user) menjadi DD/MM/YYYY (sesuai CSV).
# Misalnya: Input: 01/01/2025 → Output: 01/01/2025 (format sesuai CSV).

# Ambil nomor komputer dari IP Address
nomor_komputer=$(echo "$ip" | awk -F'.' '{print $4}')
# IP Address memiliki format 192.168.1.X, di mana X adalah nomor komputer.
# awk -F'.' '{print $4}' mengambil angka terakhir (X) sebagai nomor komputer.
# Misalnya: Input: 192.168.1.2 → Output: 2.

# Cari pengguna berdasarkan nomor komputer dan tanggal di CSV
pengguna=$(awk -F, -v tanggal="$tanggal_csv" -v nomor="$nomor_komputer" '$1 == tanggal && $2 == nomor {print $3}' "$data_peminjaman")
# Mencari baris dalam peminjaman_computer.csv yang memiliki:
# Tanggal yang sesuai dengan tanggal_csv.
# Nomor komputer yang sesuai dengan nomor_komputer.
# Jika ditemukan, nama pengguna akan disimpan dalam variabel pengguna.

# Jika pengguna tidak ditemukan
if [[ -z "$pengguna" ]]; then
    echo "Data yang kamu cari tidak ada"
    exit 1
fi
# Jika pengguna kosong → Cetak "Data yang kamu cari tidak ada" lalu keluar.
# Jika ditemukan → Cetak nama pengguna.

echo "Pengguna saat itu adalah $pengguna"

# File backup log
timestamp=$(date +"%H%M%S")
backup_file="$backup_dir/${pengguna}_$(echo "$tanggal" | sed 's@/@@g')_${timestamp}.log"
# timestamp=$(date +"%H%M%S") → Menghasilkan timestamp (format HHMMSS).
# backup_file="$backup_dir/${pengguna}_$(echo "$tanggal" | sed 's@/@@g')_${timestamp}.log"
# Menyimpan hasil log dengan nama "NamaPengguna_Tanggal_Timestamp.log".
# Tanggal diformat ulang agar tidak ada karakter /.

# Format tanggal untuk pencarian log (ubah MM/DD/YYYY ke DD/Mon/YYYY)
log_tanggal=$(date -d "$tanggal" +"%d/%b/%Y")
# Mengonversi format tanggal ke DD/Mon/YYYY agar cocok dengan log server.
# Misalnya: 01/01/2025 → 01/Jan/2025.

# Ekstrak log aktivitas pengguna berdasarkan IP dan tanggal
grep "$ip" "$data_log" | grep "$log_tanggal" | awk '{print $4, $6, $7, $9}' > "$backup_file"
# Mencari baris yang mengandung IP Address pengguna dan tanggal dalam access.log.
# Menyaring kolom-kolom penting dari log menggunakan awk.
# Kolom yang disimpan: waktu akses, metode HTTP, endpoint yang diakses, status kode HTTP.
# Menyimpan hasil pencarian ke dalam file backup.

echo "Log Aktivitas $pengguna disimpan di $backup_file"
```
4. Saya menggunakan linux dan file masih memiliki karakter carriage return (CR) dari format Windows (CRLF), bukan UNIX (LF). Ini menyebabkan skrip tidak dapat dijalankan dengan benar. Maka saya menggunakan 'tr' untuk membersihkan karakter '\r'

```bash
cat rudi-b.sh | tr -d '\r' > rudi-b-fixed.sh
mv rudi-b-fixed.sh rudi-b.sh
```
lalu saya mengubah izin akses eksekusi dengan menambahkan '+x' 

``` bash
chmod +x ~/Documents/praktikum-modul-1-b14/rudi-b.sh
```
<p align="center">
   <img src=https://github.com/user-attachments/assets/fdaccf7e-2c10-4506-9577-20bd5167c21e>
</p>

5. Saya menjalankan program dengan :
``` bash
./rudi-b.sh
```

Output :
<p align="center">
  <img src="https://github.com/user-attachments/assets/803ca5d5-d337-4440-920a-af4206a7c127" alt="Deskripsi Gambar">
</p>

<p align="center">
  <img src="https://github.com/user-attachments/assets/2c23de88-297a-41b5-bd6f-d9aa08612f6d" alt="Deskripsi Gambar">
</p>

- **Tanggal** (format: `MM/DD/YYYY`)
- **IP Address** (format: `192.168.1.X`, karena menggunakan jaringan lokal, di mana `X` adalah nomor komputer)
- Setelah pengecekan, program akan memberikan **message pengguna dan log aktivitas** dengan format berikut:
  ```
  Pengguna saat itu adalah [Nama Pengguna Komputer]
  Log Aktivitas [Nama Pengguna Komputer]
  ```
  atau jika data tidak ditemukan:

  ```
  Data yang kamu cari tidak ada
  ```
- File akan disimpan pada directory “/backup/[Nama file]”, dengan format nama file sebagai berikut
  ```
  [Nama Pengguna Komputer]_[Tanggal Dipilih (MMDDYYY)]_[Jam saat ini (HHMMSS)].log
  ```
- Format isi log
  ```
  [dd/mm/yyyy:hh:mm:ss]: Method - Endpoint - Status Code
  ```

### c. Rudi ingin memberikan hadiah kepada temannya yang sudah membantu. Namun karena dana yang terbatas, Rudi hanya akan memberikan hadiah kepada teman yang berhasil menemukan server error dengan Status Code 500 terbanyak. Bantu Rudi untuk menemukan siapa dari ketiga temannya yang berhak mendapat hadiah dan tampilkan jumlah Status Code 500 yang ditemukan
1. Saya membuka terminal dan buat file script di "~/Documents":
``` bash
touch ~/Documents/praktikum-modul-1-b14/rudi-c.sh
```
2. Saya memasukan program pada "~/rudi-c.sh":

Source Code
``` bash
#!/bin/bash

# File log yang diberikan
LOG_FILE="/home/marcomanalu/Documents/praktikum-modul-1-b14/access.log"
# Variabel LOG_FILE menyimpan lokasi file log (access.log) yang akan dianalisis.

# Menghitung jumlah status code 500 per IP
awk '$9 == 500 {count[$1]++} END {for (ip in count) print ip, count[ip]}' "$LOG_FILE" | sort -k2 -nr | head -n1
# Menggunakan awk untuk membaca file log.
# $9 == 500 → Memeriksa apakah kolom ke-9 (status code) memiliki nilai 500.
# count[$1]++ → Menyimpan jumlah kejadian status code 500 berdasarkan alamat IP (kolom pertama $1).
# END {for (ip in count) print ip, count[ip]} → Setelah membaca semua baris, mencetak alamat IP beserta jumlah error 500 yang ditemukan.
# sort -k2 -nr → Mengurutkan hasil berdasarkan jumlah error secara numerik dalam urutan menurun (-n untuk numerik, -r untuk reverse order).
# head -n1 → Mengambil hanya satu hasil teratas, yaitu IP dengan jumlah error 500 terbanyak.
```
3. Saya menggunakan linux dan file masih memiliki karakter carriage return (CR) dari format Windows (CRLF), bukan UNIX (LF). Ini menyebabkan skrip tidak dapat dijalankan dengan benar. Maka saya menggunakan 'tr' untuk membersihkan karakter '\r'

```bash
cat rudi-c.sh | tr -d '\r' > rudi-c-fixed.sh
mv rudi-c-fixed.sh rudi-c.sh
```
lalu saya mengubah izin akses eksekusi dengan menambahkan '+x' 

``` bash
chmod +x ~/Documents/rudi-c.sh
```
<p align="center">
  <img src="https://github.com/user-attachments/assets/d4e7be20-a37d-4287-b833-9b21f00eb21c" alt="Deskripsi Gambar">
</p>

4. Saya menjalankan program dengan :
``` bash
./rudi-a.sh
```
Output
<p align="center">
  <img src="https://github.com/user-attachments/assets/65766e6c-262a-4313-9be8-b1f681ac037b" alt="Deskripsi Gambar">
</p>

---

## Task 3 Marco
### a.

``` bash
#!/bin/bash

users_file="/home/marcomanalu/Downloads/cloud_storage/users.txt"
log_file="/home/marcomanalu/Downloads/cloud_storage/cloud_log.txt"

log_message() {
    echo "$(date +'%y/%m/%d %T') $1" >> "$log_file"
}

validate_password() {
    local username=$1
    local password=$2
    
    # Check minimum length
    [[ ${#password} -lt 8 ]] && { echo "Password too short"; return 1; }
    
    # Check uppercase letter
    [[ ! "$password" =~ [A-Z] ]] && { echo "Password must contain uppercase letter"; return 1; }
    
    # Check number
    [[ ! "$password" =~ [0-9] ]] && { echo "Password must contain number"; return 1; }
    
    # Check special character (diperbaiki regex-nya)
    [[ ! "$password" =~ [@\#\$%\^\&*+_] ]] && { echo "Password must contain special character"; return 1; }
    
    # Check password != username
    [[ "$password" == "$username" ]] && { echo "Password cannot be same as username"; return 1; }
    
    # Check forbidden words (case-insensitive)
    [[ "${password,,}" =~ cloud ]] && { echo "Password contains forbidden word"; return 1; }
    [[ "${password,,}" =~ storage ]] && { echo "Password contains forbidden word"; return 1; }
    
    return 0
}

read -p "Username: " username
read -sp "Password: " password
echo

# Check existing user
if grep -q "^$username:" "$users_file"; then
    log_message "REGISTER: ERROR User already exists"
    echo "Error: User already exists"
    exit 1
fi

# Validate password
error=$(validate_password "$username" "$password")
if [ $? -ne 0 ]; then
    log_message "REGISTER: ERROR $error"
    echo "Error: $error"
    exit 1
fi

# Store user
hashed_pw=$(echo -n "$password" | sha256sum | cut -d' ' -f1)
echo "$username:$hashed_pw" >> "$users_file"
log_message "REGISTER: INFO User registered successfully"
echo "Registration successful!"
```

register.sh

``` bash
#!/bin/bash

users_file="/home/marcomanalu/Downloads/cloud_storage/users.txt"
log_file="/home/marcomanalu/Downloads/cloud_storage/cloud_log.txt"
session_file="/home/marcomanalu/Downloads/cloud_storage/.cloud_session"

log_message() {
    echo "$(date +'%y/%m/%d %T') $1" >> "$log_file"
}

# Check existing session
if [ -f "$session_file" ]; then
    current_user=$(cat "$session_file")
    echo "Another user ($current_user) is still logged in!"
    exit 1
fi

read -p "Username: " username
read -sp "Password: " password
echo

# Verify credentials (diperbaiki bagian hashing)
hashed_pw=$(echo -n "$password" | sha256sum | cut -d' ' -f1)  # Tambahkan -n
stored_pw=$(grep "^$username:" "$users_file" | cut -d: -f2)

if [ -z "$stored_pw" ]; then
    log_message "LOGIN: ERROR Failed login attempt on user $username"
    echo "Invalid credentials"
    exit 1
fi

if [ "$hashed_pw" != "$stored_pw" ]; then
    log_message "LOGIN: ERROR Failed login attempt on user $username"
    echo "Invalid credentials"
    exit 1
fi

# Create session
echo "$username" > "$session_file"
log_message "LOGIN: INFO User $username logged in"
echo "Login successful!"

# Logout function
logout() {
    log_message "LOGOUT: INFO User $username logged out"
    rm -f "$session_file"
    echo "Logged out successfully"
    exit 0
}

trap logout SIGINT
while true; do
    echo "Press CTRL+C to logout"
    sleep 300
done
```

login.sh

### b.

### c.

## Task 4 Marco + Farrel


