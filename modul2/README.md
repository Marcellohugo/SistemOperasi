[![Review Assignment Due Date](https://classroom.github.com/assets/deadline-readme-button-22041afd0340ce965d47ae6ef1cefeee28c7c493a6346c4f15d667ab976d596c.svg)](https://classroom.github.com/a/9LcL5VTQ)

|    NRP     |      Name      |
| :--------: | :------------: |
| 5025221102 | Marco Marcello Hugo |
| 5025241015 | Farrel Aqilla Novianto |

# Praktikum Modul 2 _(Module 2 Lab Work)_

</div>

### Daftar Soal _(Task List)_

- [Task 1 - Trabowo & Peddy Movie Night](/task-1/)

- [Task 2 - Organize and Analyze Anthony's Favorite Films](/task-2/)

- [Task 3 - Cella’s Manhwa](/task-3/)

- [Task 4 - Pipip's Load Balancer](/task-4/)

### Laporan Resmi Praktikum Modul 2 _(Module 2 Lab Work Report)_

## Task 1 (Farrel)
Trabowo dan sahabatnya, Peddy, sedang menikmati malam minggu di rumah sambil mencari film seru untuk ditonton. Mereka menemukan sebuah file ZIP yang berisi gambar-gambar poster film yang sangat menarik. File tersebut dapat diunduh dari **[Google Drive](https://drive.google.com/file/d/1nP5kjCi9ReDk5ILgnM7UCnrQwFH67Z9B/view?usp=sharing)**. Karena penasaran dengan film-film tersebut, mereka memutuskan untuk membuat sistem otomatis guna mengelola semua file tersebut secara terstruktur dan efisien. Berikut adalah tugas yang harus dikerjakan untuk mewujudkan sistem tersebut:

### **a. Ekstraksi File ZIP**
Trabowo langsung mendownload file ZIP tersebut dan menyimpannya di penyimpanan lokal komputernya. Namun, karena file tersebut dalam bentuk ZIP, Trabowo perlu melakukan **unzip** agar dapat melihat daftar film-film seru yang ada di dalamnya.
<hr>

1. Untuk mulai mengerjakan, saya mengakses direktori workspace modul 2 Sistem operasi:
```
cd sisop-modul-2-Farqil/task-1/
```
Lalu saya membuka direktori di Visual Studio Code (VSC):
```
code .
```

2. Saya mengerjakan skrip didalam file `trabowo-a.c`, dengan hasil akhir sebagai berikut:
```c
#include <stdio.h> // Untuk fungsi input/output standar (printf, scanf, dll)
#include <stdlib.h> // Untuk fungsi standar (exit, malloc, free, dll)
#include <sys/types.h> // Untuk tipe data pid_t
#include <sys/wait.h> // Untuk fungsi wait() menunggu proses anak
#include <unistd.h> // Untuk fungsi fork(), execvp(), dan fungsi sistem Unix/Linux

int main(){
    const char *zip_file = "film.zip"; // Nama file zip hasil download
    const char *tujuan_dir = "film"; // Nama folder tujuan untuk ekstraksi
    const char *drive_url = "https://drive.google.com/uc?export=download&id=1nP5kjCi9ReDk5ILgnM7UCnrQwFH67Z9B"; // URL file yang akan di-download

    pid_t pid = fork();  // Membuat proses baru (anak); pid = 0 di anak, pid > 0 di induk
    if(pid == 0){ // Jika ini proses anak (download file)
        char *argv[] = {"wget", "-O", (char *)zip_file, (char *)drive_url, NULL}; // Argumen untuk wget: download file dan simpan sebagai zip_file
        execvp(argv[0], argv); // Menjalankan wget menggunakan execvp (ganti proses anak dengan wget)
    } 
    else wait(NULL); // Proses induk menunggu proses anak selesai (download selesai)

    pid = fork(); // Membuat proses baru lagi untuk unzip
    if(pid == 0){ // Jika ini proses anak baru (ekstrak file)
        char *argv[] = {"unzip", "-j", (char *)zip_file, "-d", (char *)tujuan_dir, NULL}; // Argumen untuk unzip: -j (ekstrak file tanpa folder dalam zip), -d untuk tentukan folder tujuan
        execvp(argv[0], argv); // Menjalankan unzip menggunakan execvp (ganti proses anak dengan unzip)
    } 
    else wait(NULL); // Proses induk menunggu proses anak selesai (unzip selesai)
    return 0;
}
```
3. Untuk menjalankan skrip maka kita akan compile dan run dengan syntax berikut:
```
gcc -o trabowo-a trabowo-a.c
./trabowo-a
```
4. Kita cek di direktori apakah sudah terdownload dan ter-ekstrak (unzip) menggunakan `ls`, jika sudah maka skrip berhasil dijalankan
<img src="https://github.com/user-attachments/assets/0a0cce6c-c2e3-4ce0-ae2b-e72531b90035">

Terlihat sudah ada `film.zip` dan hasil unzip dari `film.zip` yaitu folder `film`.

### **b. Pemilihan Film Secara Acak**

Setelah berhasil melakukan unzip, Trabowo iseng melakukan pemilihan secara acak/random pada gambar-gambar film tersebut untuk menentukan film pertama yang akan dia tonton malam ini.

**Format Output:**

```
Film for Trabowo & Peddy: ‘<no_namafilm_genre.jpg>’
```
<hr>

1. Saya mengerjakan skrip didalam file `trabowo-b.c`, dengan hasil akhir sebagai berikut:
```c
#include <stdio.h> // Untuk printf
#include <stdlib.h> // Untuk malloc, free, srand, rand
#include <dirent.h> // Untuk buka-baca folder (opendir, readdir, closedir)
#include <unistd.h> // Untuk getpid (ID proses)
#include <string.h> // Untuk strdup (duplikasi string)

int main() {              
    DIR *d = opendir("film"); // Buka folder "film"
    struct dirent *e; // Pointer untuk membaca isi folder
    char *f = NULL; // Menyimpan nama file yang terpilih
    unsigned n = 0; // Counter jumlah file
    srand(getpid()); // Seed random pakai ID proses

    while(e = readdir(d)) // Loop membaca setiap file dalam folder
        if (e->d_name[0] != '.' && rand() % ++n == 0) // Abaikan file tersembunyi, pilih angka random menggunakan rand()
            f = strdup(e->d_name); // Simpan nama file yang dipilih

    closedir(d); // Tutup folder
    if(f) printf("Film for Trabowo & Peddy: '%s'\n", f); // Cetak nama file yang dipilih
    return 0;
}

```
3. Untuk menjalankan skrip maka kita akan compile dan run dengan syntax berikut:
```
gcc -o trabowo-b trabowo-b.c
./trabowo-b
```
4. Kita cek output di terminal tempat kita menjalankan skrip:
<img src="https://github.com/user-attachments/assets/9dda6a3e-a285-422d-8b7b-2a33335faea8">

Hasil akan selalu random, karena kita memilih angka random setiap skrip dijalankan yang dihandle oleh `rand()`

### **c. Memilah Film Berdasarkan Genre**

Karena Trabowo sangat perfeksionis dan ingin semuanya tertata rapi, dia memutuskan untuk mengorganisir film-film tersebut berdasarkan genre. Dia membuat 3 direktori utama di dalam folder `~/film`, yaitu:

- **FilmHorror**
- **FilmAnimasi**
- **FilmDrama**

Setelah itu, dia mulai memindahkan gambar-gambar film ke dalam folder yang sesuai dengan genrenya. Tetapi Trabowo terlalu tua untuk melakukannya sendiri, sehingga ia meminta bantuan Peddy untuk memindahkannya. Mereka membagi tugas secara efisien dengan mengerjakannya secara bersamaan (overlapping) dan membaginya sama banyak. Trabowo akan mengerjakan dari awal, sementara Peddy dari akhir. Misalnya, jika ada 10 gambar, Trabowo akan memulai dari gambar pertama, gambar kedua, dst dan Peddy akan memulai dari gambar kesepuluh, gambar kesembilan, dst. Lalu buatlah file “recap.txt” yang menyimpan log setiap kali mereka selesai melakukan task

Contoh format log :

```
[15-04-2025 13:44:59] Peddy: 50_toystory_animasi.jpg telah dipindahkan ke FilmAnimasi
```

Setelah memindahkan semua film, Trabowo dan Peddy juga perlu menghitung jumlah film dalam setiap kategori dan menuliskannya dalam file **`total.txt`**. Format dari file tersebut adalah:

```
Jumlah film horror: <jumlahfilm>
Jumlah film animasi: <jumlahfilm>
Jumlah film drama: <jumlahfilm>
Genre dengan jumlah film terbanyak: <namagenre>
```
<hr>

1. Saya mengerjakan skrip didalam file `trabowo-c.c`, dengan hasil akhir sebagai berikut:
```c
#include <stdio.h> // Untuk input-output standar
#include <stdlib.h> // Untuk fungsi umum
#include <dirent.h> // Untuk buka folder
#include <string.h> // Untuk manipulasi string
#include <unistd.h> // Untuk fork() dan execvp()
#include <pthread.h> // Untuk multithreading
#include <sys/wait.h> // Untuk menunggu proses anak
#include <time.h> // Untuk ambil waktu sekarang

const char *cekgenre(const char *f){ // Fungsi cari genre file dari nama file
    if(strstr(f, "horror")) return "FilmHorror"; // Kalau ketemu "horror", genre = FilmHorror
    if(strstr(f, "animasi")) return "FilmAnimasi"; // Kalau ketemu "animasi", genre = FilmAnimasi
    if(strstr(f, "drama")) return "FilmDrama"; // Kalau ketemu "drama", genre = FilmDrama
    return NULL; // Selain itu, NULL

int cekid(const char *f){ // Fungsi ambil ID dari nama file
    char id[10]; int i = 0; // Deklarasi array id dan counter
    while(f[i] != '_' && f[i] != '\0') id[i++] = f[i]; // Ambil ID sebelum '_'
    id[i] = '\0'; // Terminasi string
    return atoi(id); // Mengembalikan ID sebagai integer
}

void *pindah(void *arg){ // Fungsi untuk memindahkan file
    char **a = (char **)arg; // Menerima argumen berupa array
    int s = atoi(a[0]), e = atoi(a[1]), step = atoi(a[2]); // Start, end, dan step
    char **files = (char **)a[3]; // Array file
    char *film_dir = a[4], *nama = a[5], *log_dir = a[6]; // Direktori film, nama, dan log
    const char *parent_dir = "."; // Direktori utama
}

    for(int i = s; i != e; i += step){ // Loop untuk memindahkan file
        char *f = files[i]; // Ambil nama file
        const char *g = cekgenre(f); // Cek genre file
        if(g && ((strcmp(nama, "Trabowo") == 0 && cekid(f) <= 25) || (strcmp(nama, "Peddy") == 0 && cekid(f) >= 26))){ // Cek apakah file sesuai dengan aturan (Trabowo handle ID 1 - 25, sedangkan Peddy handle ID 26 - 50)
            char src[300], dst[300]; // Variabel untuk path sumber dan tujuan
            snprintf(src, sizeof(src), "%s/%s", film_dir, f); // Path sumber
            snprintf(dst, sizeof(dst), "%s/%s/%s", parent_dir, g, f); // Path tujuan
            rename(src, dst); // Pindahkan file
            FILE *file = fopen(log_dir, "a"); // Buka file log untuk menulis
            if(file){ // Jika file log berhasil dibuka
                char t[30]; time_t now = time(NULL); // Ambil waktu sekarang
                strftime(t, sizeof(t), "%d-%m-%Y %H:%M:%S", localtime(&now)); // Format waktu
                fprintf(file, "[%s] %s: %s telah dipindahkan ke %s\n", t, nama, f, g); // Tulis log
                fclose(file); // Tutup file log
            }
        }    
    }
    return NULL;  // Mengembalikan NULL sebagai tanda selesai
}

void folder(const char *nama){ // Fungsi untuk membuat folder
    if(fork() == 0){ // Fork proses baru
        char *args[] ={"mkdir", "-p", (char *)nama, NULL}; // Perintah untuk membuat folder
        execvp("mkdir", args); // Eksekusi perintah mkdir
        exit(1); // Keluar dari proses anak jika execvp gagal
    }
    else wait(NULL); // Tunggu proses anak selesai
}

void deletefolder(const char *path){  // Fungsi untuk menghapus folder
    if(fork() == 0){ // Fork proses baru
        char *args[] ={"rm", "-rf", (char *)path, NULL}; // Perintah untuk menghapus folder
        execvp("rm", args); // Eksekusi perintah rm
        exit(1); // Keluar dari proses anak jika execvp gagal
    }
    else wait(NULL); // Tunggu proses anak selesai
}

int compare(const void *a, const void *b){ // Fungsi untuk perbandingan ID
    return cekid(*(const char **)a) - cekid(*(const char **)b); // Bandingkan ID
}

int main(){
    const char *film_dir = "film"; // Direktori film
    const char *log_dir = "recap.txt"; // File log
    const char *stat_dir = "total.txt"; // File statistik
    const char *genre_arr[] ={"FilmHorror", "FilmAnimasi", "FilmDrama"}; // Array genre
    int count = 0, jml[3] ={0}; // Hitung jumlah file dan inisialisasi genre count
    char *files[500]; // Array untuk menyimpan nama file

    DIR *dir = opendir(film_dir); struct dirent *entry; // Buka direktori film
    while(entry = readdir(dir)) if(entry->d_name[0] != '.') files[count++] = strdup(entry->d_name); // Baca nama file dan simpan
    closedir(dir); // Tutup direktori

    for(int i = 0; i < count; i++){ // Loop untuk menghitung jumlah file berdasarkan genre
        const char *g = cekgenre(files[i]); // Cek genre file
        if(g){ // Jika genre ditemukan
            if(strcmp(g, genre_arr[0]) == 0) jml[0]++; // Genre horror
            else if(strcmp(g, genre_arr[1]) == 0) jml[1]++; // Genre animasi
            else if(strcmp(g, genre_arr[2]) == 0) jml[2]++; // Genre drama
        }
    }
    for(int i = 0; i < 3; i++) folder(genre_arr[i]); // Membuat folder untuk setiap genre
    qsort(files, count, sizeof(char *), compare); // Urutkan file berdasarkan ID

    char *a1[] ={"0", "25", "1", (char *)files, (char *)film_dir, "Trabowo", (char *)log_dir}; // Argumen untuk thread Trabowo
    char *a2[] ={"49", "24", "-1", (char *)files, (char *)film_dir, "Peddy", (char *)log_dir}; // Argumen untuk thread Peddy
    pthread_t t1, t2; // Thread untuk Trabowo dan Peddy
    pthread_create(&t1, NULL, pindah, a1); // Membuat thread Trabowo
    pthread_create(&t2, NULL, pindah, a2); // Membuat thread Peddy
    pthread_join(t1, NULL); pthread_join(t2, NULL); // Menunggu kedua thread selesai

    int max = 0; // Menentukan genre dengan jumlah film terbanyak
    for(int i = 1; i < 3; i++) if(jml[i] > jml[max]) max = i; // Bandingkan jumlah film per genre dan mencari genre dengan film terbanyak
    FILE *stat = fopen(stat_dir, "w"); // Buka file untuk menulis statistik
    if(stat){ // Jika file berhasil dibuka
        fprintf(stat, "Jumlah film horror: %d\nJumlah film animasi: %d\nJumlah film drama: %d\nGenre dengan jumlah film terbanyak: %s\n", jml[0], jml[1], jml[2], genre_arr[max] + 4); // Tulis statistik
        fclose(stat); // Tutup file
    }

    for(int i = 0; i < count; i++) free(files[i]); // Bebaskan memory
    deletefolder(film_dir); // Hapus folder film setelah proses selesai
    return 0;
}
```
2. Sebelum kita compile dan jalankan, mari kita lihat isi direktori kita yang berbentuk:
```
task-1/
└── film/
    ├── film1.jpg
    ├── film2.jpg
    └── film3.jpg
```
3. Untuk menjalankan skrip maka kita akan compile dan run dengan syntax berikut:
```
gcc -o trabowo-c trabowo-c.c
./trabowo-c
```
4. Lihat kembali isi direktori kita menggunakan `ls` yang sekarang seharusnya berbentuk:
```
task-1/
├── FilmHorror/
|   └── filmhorror.jpg
├── FilmAnimasi/
|   └── filmanimasi.jpg
├── FilmDrama/
|   └── filmdrama.jpg
├── recap.txt
└── total.txt
```
<img src="https://github.com/user-attachments/assets/f83e2638-1dd8-423b-a39a-7f911a55f09e">

isi dari `film` akan dipindahkan sesuai kategori film masing-masing, setelah selesai maka folder `film` akan dihapus serta membuat file `recap.txt` dan `total.txt` untuk melihat log pemindahan dan statistik per kategori serta kategori dengan film terbanyak.

5. Kita lihat isi file `recap.txt` dan `total.txt` untuk melihat log pemindahan gambar dan total gambar per kategori dengan menjalankan syntax berikut:
```
cat recap.txt
cat total.txt
```
<img src="https://github.com/user-attachments/assets/72ec1332-36fe-4cc7-8f1a-eb17d1ea7a73">

Terlihat di file `recap.txt`, Trabowo handle pemindahan film dengan ID 1 - 25 dengan cara ascending (meningkat), sedangkan Peddy handle pemindahan film dengan ID 26 - 50 dengan cara descending (menurun). Di dalam file `total.txt` terlihat juga statistik dari masing-masing kategori jumlah filmnya, dan ternyata kategori dengan film terbanyak dipegang oleh Drama dengan total film 21.

### **d. Pengarsipan Film**

Setelah semua film tertata dengan rapi dan dikelompokkan dalam direktori masing-masing berdasarkan genre, Trabowo ingin mengarsipkan ketiga direktori tersebut ke dalam format **ZIP** agar tidak memakan terlalu banyak ruang di komputernya.
<hr>

1. Saya mengerjakan skrip didalam file `trabowo-d.c`, dengan hasil akhir sebagai berikut:
```c
#include <stdio.h> // Untuk input-output standar
#include <stdlib.h> // Untuk fungsi exit() dan malloc()
#include <unistd.h> // Untuk fork(), execvp(), dll
#include <sys/types.h> // Untuk tipe data pid_t
#include <sys/wait.h> // Untuk fungsi wait()

int main(){
    pid_t pid = fork(); // Membuat proses anak
    if(pid == 0){ // Proses anak
        char *argv[] = {
            "sh", // Nama program yang dijalankan (shell)
            "-c", // Opsi untuk shell, menjalankan perintah berikutnya
            "cd /home/farqil/Documents/sisop-modul-2-Farqil/task-1 && zip -r hasil.zip FilmHorror FilmAnimasi FilmDrama",
            // 1. Pindah ke direktori target: cd /home/farqil/Documents/sisop-modul-2-Farqil/task-1
            // 2. Lalu menjalankan perintah zip untuk mengkompresi folder FilmHorror, FilmAnimasi, dan FilmDrama menjadi hasil.zip
            NULL // Menandakan akhir dari array argv
        };
        execvp(argv[0], argv); // Menjalankan perintah yang diberikan dalam argv
    } 
    else wait(NULL); // Proses induk menunggu sampai proses anak selesai

    pid_t hapuspid = fork(); // Membuat proses anak kedua untuk menghapus folder
    if(hapuspid == 0){ // Proses anak kedua
        char *rm_argv[] = {
            "rm", // Nama program yang dijalankan (perintah remove)
            "-rf", // Opsi untuk rm (hapus folder secara rekursif dan paksa)
            "/home/farqil/Documents/sisop-modul-2-Farqil/task-1/FilmHorror", // Folder pertama yang akan dihapus
            "/home/farqil/Documents/sisop-modul-2-Farqil/task-1/FilmAnimasi", // Folder kedua yang akan dihapus
            "/home/farqil/Documents/sisop-modul-2-Farqil/task-1/FilmDrama", // Folder ketiga yang akan dihapus
            NULL // Menandakan akhir dari array rm_argv
        };
        execvp(rm_argv[0], rm_argv); // Menjalankan perintah yang diberikan dalam rm_argv
    }
    else wait(NULL); // Proses induk menunggu sampai proses anak kedua selesai
    return 0;
}
```
2. Untuk menjalankan skrip maka kita akan compile dan run dengan syntax berikut:
```
gcc -o trabowo-d trabowo-d.c
./trabowo-d
```
3. Setelah skrip dijalankan, isi direktori menjadi seperti berikut:
```
task-1/
├── hasil.zip
├── recap.txt
└── total.txt
```
<img src ="https://github.com/user-attachments/assets/191a3307-3a27-4013-94e6-b6967208b756">

hasil.zip akan berisi `FilmHorror`, `FilmAnimasi`, dan `FilmHorror` yang sudah di-zip menggunakan `zip` lalu remove folder tersebut menggunakan `rm`

---

## Task 2 (Marco)
### **a. One Click and Done!**
Pernahkah kamu merasa malas untuk mengelola file ZIP yang penuh dengan data film? Anthony merasa hal yang sama, jadi dia ingin semuanya serba instan dengan hanya satu perintah. Dengan satu perintah saja, Anthony bisa:

- Mendownload file ZIP yang berisi data film-film Netflix favoritnya.
- Mengekstrak file ZIP tersebut ke dalam folder yang sudah terorganisir.
- Menghapus file ZIP yang sudah tidak diperlukan lagi, supaya tidak memenuhi penyimpanan.

Buatlah skrip yang akan mengotomatiskan proses ini sehingga Anthony hanya perlu menjalankan satu perintah untuk mengunduh, mengekstrak, dan menghapus file ZIP.

1. Saya membuka terminal dan membuat file automasi download_extract.sh

```
touch download_extract.sh
```

dan mengisi program pada file yang sudah saya buat

```
nano download_extract.sh
```

Source Code
``` bash
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

```

2. Saya menambahkan izin untuk eksekusi file pada terminal dengan 

```
chmod +x download_extract.sh
```

3. Saya menjalankan program dengan perintah pada terminal

```
./download_extract.sh
```

4. Dan program berhasil dijalankan

<img src="https://github.com/Marcellohugo/SistemOperasi/blob/main/sisop-modul-2-Farqil/Dokumentasi/1.png?raw=true">

dan direktori berisi file yang ingin diunduh

<img src="https://github.com/Marcellohugo/SistemOperasi/blob/main/sisop-modul-2-Farqil/Dokumentasi/2.png?raw=true">

### **b. Sorting Like a Pro**
Koleksi film Anthony semakin banyak dan dia mulai bingung mencari cara yang cepat untuk mengelompokkannya. Nah, Anthony ingin mengelompokkan film-filmnya dengan dua cara yang sangat mudah:

1. Berdasarkan huruf pertama dari judul film.
2. Berdasarkan tahun rilis (release year).

Namun, karena Anthony sudah mempelajari **multiprocessing**, dia ingin mengelompokkan kedua kategori ini secara paralel untuk menghemat waktu.

**Struktur Output:**

- **Berdasarkan Huruf Pertama Judul Film:**

  - Folder: `judul/`
  - Setiap file dinamai dengan huruf abjad atau angka, seperti `A.txt`, `B.txt`, atau `1.txt`.
  - Jika judul film tidak dimulai dengan huruf atau angka, film tersebut disimpan di file `#.txt`.

- **Berdasarkan Tahun Rilis:**
  - Folder: `tahun/`
  - Setiap file dinamai sesuai tahun rilis film, seperti `1999.txt`, `2021.txt`, dst.

Format penulisan dalam setiap file :

```
Judul Film - Tahun Rilis - Sutradara
```

Setiap proses yang berjalan akan mencatat aktivitasnya ke dalam satu file bernama **`log.txt`** dengan format:

```
[jam:menit:detik] Proses mengelompokkan berdasarkan [Abjad/Tahun]: sedang mengelompokkan untuk film [judul_film]
```

**Contoh Log:**

```
[14:23:45] Proses mengelompokkan berdasarkan Abjad: sedang mengelompokkan untuk film Avengers: Infinity War
[14:23:46] Proses mengelompokkan berdasarkan Tahun: sedang mengelompokkan untuk film Kung Fu Panda
```
1. Saya membuka terminal dan membuat file automasi sort_movies.sh

```
touch sort_movies.sh
```

dan mengisi program pada file yang sudah saya buat

```
nano sort_movies.sh
```

Source Code
``` bash
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

```

2. Saya menambahkan izin untuk eksekusi file pada terminal dengan 

```
chmod +x sort_movies.sh
```

3. Saya menjalankan program dengan perintah pada terminal

```
./sort_movies.sh
```
4. Dan program berhasil dijalankan

<img src="https://github.com/Marcellohugo/SistemOperasi/blob/main/sisop-modul-2-Farqil/Dokumentasi/3.png?raw=true">

lihat isi file judul untuk memastikan kecocokan dari perintah yang diminta

<img src="https://github.com/Marcellohugo/SistemOperasi/blob/main/sisop-modul-2-Farqil/Dokumentasi/4.png?raw=true">

lihat isi file tahun untuk memastikan kecocokan dari perintah yang diminta

<img src="https://github.com/Marcellohugo/SistemOperasi/blob/main/sisop-modul-2-Farqil/Dokumentasi/5.png?raw=true">

dan lihat file log

<img src="https://github.com/Marcellohugo/SistemOperasi/blob/main/sisop-modul-2-Farqil/Dokumentasi/6.png?raw=true">

### **c. The Ultimate Movie Report**

Sebagai penggemar film yang juga suka menganalisis, Anthony ingin mengetahui statistik lebih mendalam tentang film-film yang dia koleksi. Misalnya, dia ingin tahu berapa banyak film yang dirilis **sebelum tahun 2000** dan **setelah tahun 2000**.

Agar laporan tersebut mudah dibaca, Anthony ingin hasilnya disimpan dalam file **`report_ddmmyyyy.txt`**.

**Format Output dalam Laporan:**

```
i. Negara: <nama_negara>
Film sebelum 2000: <jumlah>
Film setelah 2000: <jumlah>

...
i+n. Negara: <nama_negara>
Film sebelum 2000: <jumlah>
Film setelah 2000: <jumlah>
```

Agar penggunaannya semakin mudah, Anthony ingin bisa menjalankan semua proses di atas melalui sebuah antarmuka terminal interaktif dengan pilihan menu seperti berikut:
1. Download File
2. Mengelompokkan Film
3. Membuat Report

Catatan:
- Dilarang menggunakan `system`
- Harap menggunakan thread dalam pengerjaan soal C

1. Saya membuka terminal dan membuat file automasi Anthony.c

```
touch Anthony.c
```

dan mengisi program pada file yang sudah saya buat

```
nano Anthony.c
```

Source Code

```c
// File: Anthony.c

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <pthread.h>

#define MAX_LINE      1024
#define MAX_COUNTRY   200

typedef struct {
    char country[128];
    int before_2000;
    int after_2000;
} CountryStats;

typedef struct {
    CountryStats stats[MAX_COUNTRY];
    int count;
    pthread_mutex_t lock;
} ReportData;

// Hilangkan newline/carriage return di ujung string
void trim_newline(char *s) {
    char *p = s + strlen(s) - 1;
    while (p >= s && (*p == '\n' || *p == '\r')) {
        *p-- = '\0';
    }
}

void *thread_process_csv(void *arg) {
    ReportData *rd = (ReportData *)arg;
    FILE *f = fopen("netflixData/netflixData.csv", "r");
    if (!f) {
        perror("Gagal membuka netflixData/netflixData.csv");
        pthread_exit(NULL);
    }

    char line[MAX_LINE];
    int lineno = 0;
    while (fgets(line, sizeof(line), f)) {
        lineno++;
        if (lineno == 1) continue;  // skip header

        trim_newline(line);
        // Tokenize: title,director,country,release year
        char *title    = strtok(line, ",");
        char *director = strtok(NULL, ",");
        char *country  = strtok(NULL, ",");
        char *year_s   = strtok(NULL, ",");

        if (!country || !year_s) continue;
        int year = atoi(year_s);
        if (year <= 0) continue;

        // update stats
        pthread_mutex_lock(&rd->lock);
        int found = 0;
        for (int i = 0; i < rd->count; i++) {
            if (strcmp(rd->stats[i].country, country) == 0) {
                if (year < 2000) rd->stats[i].before_2000++;
                else             rd->stats[i].after_2000++;
                found = 1;
                break;
            }
        }
        if (!found && rd->count < MAX_COUNTRY) {
            // tambah negara baru
            CountryStats *cs = &rd->stats[rd->count];
            strncpy(cs->country, country, sizeof(cs->country)-1);
            cs->country[sizeof(cs->country)-1] = '\0';
            cs->before_2000 = (year < 2000);
            cs->after_2000  = (year >= 2000);
            rd->count++;
        }
        pthread_mutex_unlock(&rd->lock);
    }

    fclose(f);
    pthread_exit(NULL);
}

int main(void) {
    ReportData rd;
    rd.count = 0;
    pthread_mutex_init(&rd.lock, NULL);

    // jalankan single thread untuk memproses CSV
    pthread_t tid;
    if (pthread_create(&tid, NULL, thread_process_csv, &rd)) {
        fprintf(stderr, "Error membuat thread\n");
        return 1;
    }
    pthread_join(tid, NULL);

    // buat nama file report_DDMMYYYY.txt
    time_t now = time(NULL);
    struct tm *t = localtime(&now);
    char fname[64];
    strftime(fname, sizeof(fname), "report_%d%m%Y.txt", t);

    FILE *out = fopen(fname, "w");
    if (!out) {
        perror("Gagal membuat file laporan");
        return 1;
    }

    for (int i = 0; i < rd.count; i++) {
        fprintf(out,
            "%d. Negara: %s\n"
            "   Film sebelum 2000: %d\n"
            "   Film setelah 2000: %d\n\n",
            i+1,
            rd.stats[i].country,
            rd.stats[i].before_2000,
            rd.stats[i].after_2000
        );
    }
    fclose(out);
    pthread_mutex_destroy(&rd.lock);

    printf("✅ Report generated: %s\n", fname);
    return 0;
}

```
2. Saya kompile program C tersebut dengan

```
gcc Anthony.c -o Anthony
```

<img src="https://github.com/Marcellohugo/SistemOperasi/blob/main/sisop-modul-2-Farqil/Dokumentasi/7.png?raw=true">

3. Saya menjalankan program dengan perintah pada terminal

```
./Anthony
```
4. Dan program berhasil dijalankan

<img src="https://github.com/Marcellohugo/SistemOperasi/blob/main/sisop-modul-2-Farqil/Dokumentasi/8.png?raw=true">

melihat isi file untuk memeriksa keberhasilan program

<img src="https://github.com/Marcellohugo/SistemOperasi/blob/main/sisop-modul-2-Farqil/Dokumentasi/9.png?raw=true">

5. Untuk mempermudah menjalankan keseluruhan, saya membuat interface terminal interaktif.

Saya membuka terminal dan membuat file menu.sh

```
touch menu.sh
```

dan mengisi program pada file yang sudah saya buat

```
nano menu.sh
```

Source Code

```bash
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
```

lalu saya jalankan dengan perintah pada terminal

```
./menu.sh
```

<img src="https://github.com/Marcellohugo/SistemOperasi/blob/main/sisop-modul-2-Farqil/Dokumentasi/10.png?raw=true">

---

## Task 3 (Farrel)
Cella, si ratu scroll Facebook, tiba-tiba terinspirasi untuk mengumpulkan informasi dan foto dari berbagai **manhwa favoritnya**. Namun, kemampuan ngoding Cella masih cetek, jadi dia butuh bantuanmu untuk membuatkan skrip otomatis agar semua berjalan mulus. Tugasmu adalah membantu Cella mengolah data manhwa dan heroine-nya.

Berikut adalah daftar manhwa bergenre shoujo/josei yang paling disukai Cella:

|    No     |      Manhwa      |
| :--------: | :------------: |
| 1 | Mistaken as the Monster Duke's Wife |
| 2 | The Villainess Lives Again |
| 3 | No, I Only Charmed the Princess! |
| 4 | Darling, Why Can't We Divorce? |

Saya akan sertakan skrip akhir ```solver.c``` terlebih dahulu yang nanti akan dibagi per-bagiannya:
```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <unistd.h>
#include <sys/wait.h>
#include <dirent.h>
#include <pthread.h>

void caridata(char *tujuan, size_t size, const char *url, const char *jq_filter){
    char cmd[512], buf[256];
    snprintf(cmd, sizeof(cmd), "curl -s '%s' | jq -r '%s'", url, jq_filter);
    FILE *file = popen(cmd, "r");
    if(file){
        if(fgets(buf, sizeof(buf), file)){
            buf[strcspn(buf, "\n")] = 0;
            strncpy(tujuan, buf, size);
        }
        pclose(file);
    }
}

void api(int id){
    char url[128], judulmanhwa[256] = "", status[64] = "", release[64] = "", genres[256] = "", themes[256] = "", authors[256] = "";
    snprintf(url, sizeof(url), "https://api.jikan.moe/v4/manga/%d", id);
    caridata(judulmanhwa, sizeof(judulmanhwa), url, ".data.title_english // .data.judulmanhwa");
    caridata(status, sizeof(status), url, ".data.status");
    caridata(release, sizeof(release), url, ".data.published.from | if. == null then \"Unknown\" else .[:10] end");
    caridata(genres, sizeof(genres), url, "[.data.genres[].name] | join(\", \")");
    caridata(themes, sizeof(themes), url, "[.data.themes[].name] | join(\", \")");
    caridata(authors, sizeof(authors), url, "[.data.authors[].name] | join(\", \")");
    char filename[300];
    snprintf(filename, sizeof(filename), "Manhwa/%s.txt", judulmanhwa);
   for(char *p = filename; *p; p++) if(!isalnum(*p) && *p != '_' && *p != '/' && *p != '.') *p = '_';
    FILE *file = fopen(filename, "w");
    if(!file) return;
    fprintf(file, "Title: %s\nStatus: %s\nRelease: %s\nGenre: %s\nTheme: %s\nAuthor: %s", judulmanhwa, status, release, genres, themes, authors);
    fclose(file);
}

void zipkapital(){
    DIR *dir = opendir("Manhwa");
    if(!dir) return;
    pid_t pid = fork();
    if(pid == 0){
        char *argv[] ={"mkdir", "-p", "Archive", NULL};
        execvp(argv[0], argv);
        exit(1);
    } 
    else waitpid(pid, NULL, 0);
    struct dirent *entry;
    while((entry = readdir(dir)) != NULL){
        if(strstr(entry->d_name, ".txt")){
            char namazip[256] = "Archive/";
           for(int i = 0; entry->d_name[i] != '\0'; i++) if(entry->d_name[i] >= 'A' && entry->d_name[i] <= 'Z') strncat(namazip, &entry->d_name[i], 1);
            strcat(namazip, ".zip");
            char srcfile[256] = "Manhwa/";
            strcat(srcfile, entry->d_name);
            pid = fork();
            if(pid == 0){
                char *argv[] ={"zip", "-j", namazip, srcfile, NULL};
                execvp(argv[0], argv);
                exit(1);
            } 
            else waitpid(pid, NULL, 0);
        }
    }
    closedir(dir);
}

void *download_image(void *arg){
    char **args = (char **)arg;
    pid_t pid = fork();
    if(pid == 0){
        char *argv[] ={"wget", "-q", "-O", args[0], args[1], NULL};
        execvp(argv[0], argv);
        exit(1);
    } else waitpid(pid, NULL, 0);
    pthread_exit(NULL);
}

void gambarheroine(const char *heroine, const char *manhwa, const char *url){
    DIR *dir = opendir("Manhwa");
    if(!dir) return;
    struct dirent *entry;
    while((entry = readdir(dir)) != NULL){
        if(strstr(entry->d_name, ".txt")){
            char path[512], line[256], judulmanhwa[256];
            snprintf(path, sizeof(path), "Manhwa/%s", entry->d_name);
            FILE *file = fopen(path, "r");
            if(!file) continue;
            int yes = 0, jumlahfoto = 0;
            while(fgets(line, sizeof(line), file)){
                if(strstr(line, "Title:")){
                    sscanf(line, "Title: %[^\n]", judulmanhwa);
                    if(strcmp(judulmanhwa, manhwa) == 0) yes = 1; else break;
                }
                if(yes && strstr(line, "Release:")){
                    sscanf(line, "Release: %*d-%d-%*d", &jumlahfoto);
                    break;
                }
            }
            fclose(file);
            if(yes && jumlahfoto > 0){
                pid_t pid = fork();
                if(pid == 0){
                    char folder[128];
                    snprintf(folder, sizeof(folder), "Heroines/%s", heroine);
                    char *argv[] ={"mkdir", "-p", folder, NULL};
                    execvp(argv[0], argv);
                    exit(1);
                } 
                else waitpid(pid, NULL, 0);
                pthread_t threads[jumlahfoto];
                for(int i = 1; i <= jumlahfoto; i++){
                    char **args = malloc(2 * sizeof(char *));
                    char file[256], url[512];
                    snprintf(file, sizeof(file), "Heroines/%s/%s_%d.jpg", heroine, heroine, i);
                    snprintf(url, sizeof(url), url, heroine, i);
                    args[0] = strdup(file);
                    args[1] = strdup(url);
                    pthread_create(&threads[i - 1], NULL, download_image, args);
                }
                for(int i = 0; i < jumlahfoto; i++) pthread_join(threads[i], NULL);
                break;
            }
        }
    }
    closedir(dir);
}

void zipheroine(const char *manhwa, const char *heroine){
    char zip[512];
    char direktori[] = "Archive/Images";
    char hurufkapital[256];
    int j = 0;
    for(int i = 0; manhwa[i] != '\0'; i++) if(manhwa[i] >= 'A' && manhwa[i] <= 'Z') hurufkapital[j++] = manhwa[i];
    hurufkapital[j] = '\0';

    pid_t pid = fork();
    if(pid == 0){
        char *argv[] ={"mkdir", "-p", direktori, NULL};
        execvp(argv[0], argv);
        exit(1);
    } 
    else waitpid(pid, NULL, 0);
    snprintf(zip, sizeof(zip), "../../%s/%s_%s.zip", direktori, hurufkapital, heroine);
    pid = fork();
    if(pid == 0){
        char folder[128];
        snprintf(folder, sizeof(folder), "/home/farqil/Documents/sisop-modul-2-Farqil/task-3/Heroines/%s", heroine);
        char command[1024];
        snprintf(command, sizeof(command), "cd %s && zip -r %s *", folder, zip); 
        char *argv[] ={"sh", "-c", command, NULL};
        execvp(argv[0], argv);
        exit(1);
    } 
    else waitpid(pid, NULL, 0);
    char path[512];
    snprintf(path, sizeof(path), "/home/farqil/Documents/sisop-modul-2-Farqil/task-3/Heroines/%s", heroine);
    pid = fork();
    if(pid == 0){
        char *argv[] ={"rm", "-rf", path, NULL};
        execvp(argv[0], argv);
        exit(1);
    }
}

int main(){
    pid_t pid = fork();
    if(pid == 0){
        char *argv[] ={"mkdir", "-p", "Manhwa", NULL};
        execvp(argv[0], argv);
        exit(1);
    }
    else waitpid(pid, NULL, 0);
    int id[] ={168827, 147205, 169731, 175521};
    for(int i = 0; i < 4; i++) api(id[i]);
    zipkapital();
    const char *heroine[] ={"Adelia", "Lia", "Ophelia", "Tia"};
    const char *manhwa[] ={"No, I Only Charmed the Princess!", "Mistaken as the Monster Duke's Wife", "Darling, Why Can't We Divorce?", "The Villainess Lives Again"};
    const char *url[] ={"https://i.pinimg.com/736x/09/81/6c/09816c1e9e3306c67ecbc2db318a6b93.jpg", "https://i.pinimg.com/736x/cc/88/fc/cc88fc7520e11783dccbf081dcf5293d.jpg", "https://i.pinimg.com/736x/17/3a/ae/173aaec355eed29a86c423009eba7710.jpg", "https://i.pinimg.com/736x/ab/e4/f0/abe4f0004953bccb57b2e8ed17bd6263.jpg"};
    for(int i = 0; i < 4; i++) gambarheroine(heroine[i], manhwa[i], url[i]);
    for(int i = 0; i < 4; i++) zipheroine(manhwa[i], heroine[i]);
    return 0;
}
```

### **a. Summoning the Manhwa Stats**

Cella ingin mengambil data detail dari **manhwa** menggunakan [API Jikan](https://docs.api.jikan.moe/). Informasi yang diambil:

- Judul
- Status
- Tanggal rilis
- Genre
- Tema
- Author

Setelah data berhasil diambil, hasilnya harus disimpan ke dalam file teks, dengan nama file disesuaikan dengan **judul versi bahasa Inggris** (tanpa karakter khusus dan spasi diganti dengan underscore). Semua file teks disimpan dalam folder `Manhwa`.

**Contoh format isi file:**

```
Title: The Villain's Daughter-in-Law
Status: Publishing
Release: 2024-10-16
Genre: Fantasy, Romance
Theme: Time Travel
Author: Na, Reuyan, Kim, Dael
```

**&#128161; Hint**

Contoh Penggunaan Simple API:
1. Kunjungi situs **MyAnimeList**.

2. Cari **manhwa** yang diinginkan.

3. Sebagai contoh:

    `https://myanimelist.net/manga/154063/The_Perks_of_Being_a_Villainess`

3. Gunakan **154063** sebagai **ID** untuk melakukan pengambilan data (scraping).

4. Sehingga **endpoint API** akan menjadi seperti berikut:

    `https://api.jikan.moe/v4/manga/154063`
<hr>

1. Untuk mulai mengerjakan, saya mengakses direktori workspace modul 2 Sistem operasi:
```
cd Documents/sisop-modul-2-Farqil/task-3/
```
Lalu saya membuka direktori di Visual Studio Code (VSC):
```
code .
```
2. Saya mengerjakan skrip didalam file `solver.c`, dengan hasil akhir yang sudah dibagi sebagai berikut:
```c
void caridata(char *tujuan, size_t size, const char *url, const char *jq_filter){ // Fungsi untuk mengambil data dari API
    char cmd[512], buf[256]; // Buffer untuk menyimpan perintah dan hasil
    snprintf(cmd, sizeof(cmd), "curl -s '%s' | jq -r '%s'", url, jq_filter);
    // curl -s digunakan untuk mengunduh data dari URL secara diam-diam tanpa menampilkan progress
    // jq -r digunakan untuk memproses dan mengeluarkan hasil yang di-filter sesuai dengan filter jq
    FILE *file = popen(cmd, "r"); // Menjalankan perintah curl dan membuka pipe untuk membaca hasilnya
    if(file){ // Memeriksa apakah file terbuka dengan benar
        if(fgets(buf, sizeof(buf), file)){ // Membaca hasil dari pipe
            buf[strcspn(buf, "\n")] = 0; // Menghapus karakter newline pada akhir string
            strncpy(tujuan, buf, size); // Menyalin hasil ke buffer tujuan
        }
        pclose(file); // Menutup file/pipe
    }
}

void api(int id){ // Fungsi untuk mengambil data spesifik manhwa berdasarkan ID
    char url[128], judulmanhwa[256] = "", status[64] = "", release[64] = "", genres[256] = "", themes[256] = "", authors[256] = ""; // Deklarasi variabel untuk menyimpan hasil
    snprintf(url, sizeof(url), "https://api.jikan.moe/v4/manga/%d", id); // Membuat URL API berdasarkan ID manhwa
    caridata(judulmanhwa, sizeof(judulmanhwa), url, ".data.title_english // .data.judulmanhwa"); // Mengambil judul manhwa
    caridata(status, sizeof(status), url, ".data.status"); // Mengambil status manhwa
    caridata(release, sizeof(release), url, ".data.published.from | if. == null then \"Unknown\" else .[:10] end"); // Mengambil tanggal rilis
    caridata(genres, sizeof(genres), url, "[.data.genres[].name] | join(\", \")"); // Mengambil genre manhwa
    caridata(themes, sizeof(themes), url, "[.data.themes[].name] | join(\", \")"); // Mengambil tema manhwa
    caridata(authors, sizeof(authors), url, "[.data.authors[].name] | join(\", \")"); // Mengambil penulis manhwa
    char filename[300]; // Buffer untuk nama file
    snprintf(filename, sizeof(filename), "Manhwa/%s.txt", judulmanhwa);  // Membuat nama file berdasarkan judul manhwa
    for(char *p = filename; *p; p++) if(!isalnum(*p) && *p != '_' && *p != '/' && *p != '.') *p = '_'; // Mengganti karakter non-alfanumerik dalam nama file dengan '_'
    FILE *file = fopen(filename, "w"); // Membuka file untuk menulis data
    if(!file) return; // Jika file gagal dibuka, keluar dari fungsi
    fprintf(file, "Title: %s\nStatus: %s\nRelease: %s\nGenre: %s\nTheme: %s\nAuthor: %s", judulmanhwa, status, release, genres, themes, authors); // Menulis data ke dalam file
    fclose(file); // Menutup file
}

int main(){
    pid_t pid = fork(); // Membuat proses baru
    if(pid == 0){  // Jika ini adalah proses anak
        char *argv[] ={"mkdir", "-p", "Manhwa", NULL}; // Perintah untuk membuat folder "Manhwa"
        execvp(argv[0], argv); // Menjalankan perintah di atas
        exit(1); // Keluar dari proses anak
    }
    else waitpid(pid, NULL, 0); // Proses induk menunggu proses anak selesai
    int id[] ={168827, 147205, 169731, 175521}; // Daftar ID manhwa
    for(int i = 0; i < 4; i++) api(id[i]); // Mengambil data untuk setiap ID manhwa
}
```
3. Untuk menjalankan skrip maka kita akan compile dan run dengan syntax berikut:
```
gcc -o solver-c solver-c.c
./solver-c
```
4. Isi direktori akan seperti ini setelah memasukkan data-data kedalam folder `Manhwa` menggunakan `ls` serta melihat contoh `.txt` yang dihasilkan:
<img src="https://github.com/user-attachments/assets/f1bb89f7-e0f2-4f42-b4ff-027680b54a33">

### **b. Seal the Scrolls**

Cella ingin agar setiap file `.txt` tadi di-**zip** satu per satu dan disimpan ke dalam folder baru bernama `Archive`. Yang dimana nama masing masing dari zip diambil dari **huruf kapital nama file**.
<hr>

1. Saya mengerjakan skrip didalam file `solver.c`, dengan hasil akhir yang sudah dibagi sebagai berikut:
```c
// Fungsi untuk mencari file .txt di Manhwa dan membuat zip berdasarkan huruf kapital nama file
void zipkapital(){
    // Membuka folder "Manhwa"
    DIR *dir = opendir("Manhwa");
    if(!dir) return; // Jika folder gagal dibuka, keluar dari fungsi

    // Membuat proses anak untuk membuat folder Archive
    pid_t pid = fork();
    if(pid == 0){
        // Di proses anak: buat folder Archive jika belum ada
        char *argv[] ={"mkdir", "-p", "Archive", NULL};
        execvp(argv[0], argv);
        exit(1); // Setelah execvp, keluar dari proses anak
    } 
    else waitpid(pid, NULL, 0); // Di proses induk: tunggu proses anak selesai

    struct dirent *entry;
    // Membaca semua isi folder "Manhwa"
    while((entry = readdir(dir)) != NULL){
        // Jika nama file mengandung ".txt"
        if(strstr(entry->d_name, ".txt")){
            // Menyiapkan nama zip, diawali "Archive/"
            char namazip[256] = "Archive/";

            // Loop semua karakter nama file
            // Kalau karakter huruf kapital ('A' - 'Z'), ditambahkan ke nama zip
            for(int i = 0; entry->d_name[i] != '\0'; i++)
                if(entry->d_name[i] >= 'A' && entry->d_name[i] <= 'Z')
                    strncat(namazip, &entry->d_name[i], 1);

            // Tambahkan ".zip" di akhir nama zip
            strcat(namazip, ".zip");

            // Membuat path file sumber, yaitu "Manhwa/nama_file"
            char srcfile[256] = "Manhwa/";
            strcat(srcfile, entry->d_name);

            // Membuat proses anak baru untuk melakukan zip
            pid = fork();
            if(pid == 0){
                // Di proses anak: jalankan zip -j Archive/NAMAZIP.zip Manhwa/nama_file
                char *argv[] ={"zip", "-j", namazip, srcfile, NULL};
                execvp(argv[0], argv);
                exit(1); // Setelah execvp, keluar dari proses anak
            } 
            else waitpid(pid, NULL, 0); // Di proses induk: tunggu proses zip selesai
        }
    }
    closedir(dir); // Tutup folder setelah semua file selesai diproses
}

int main(){
    zipkapital(); // Panggil fungsi untuk zip file berdasarkan huruf kapital
}
```
2. Untuk menjalankan skrip maka kita akan compile dan run dengan syntax berikut:
```
gcc -o solver-c solver-c.c
./solver-c
```
3. Isi direktori akan seperti ini setelah memasukkan zip-zip yang sudah dibuat kedalam folder `Archive` menggunakan `ls`:
<img src="https://github.com/user-attachments/assets/d6da6f53-878d-42df-91ae-bfac88a3875d">

Terihat nama file `.zip` terdiri dari huruf kapital tiap judul, misalkan manhwa berjudul `Darling, Wht Can't We Divorce?` akan memiliki zip `DWCWD.zip`

### **c. Making the Waifu Gallery**

Setiap manhwa memiliki heroine alias **Female Main Character (FMC)**. Cella ingin mengunduh gambar heroine dari internet, dengan jumlah unduhan sesuai dengan **bulan rilis manhwa**.

**Contoh:**

- Jika rilis bulan Februari → unduh **2 foto**
- Jika rilis bulan Desember → unduh **12 foto**
- Format nama file: `Heroine_1.jpg`, `Heroine_2.jpg`, dst.

Selain itu, Cella ingin melakukan pengunduhan **sesuai urutan** daftar manhwa yang tertera pada deskripsi di atas, dan proses pengunduhan harus menggunakan **thread**, karena Cella malas menunggu. Sebagai contohnya, gambar heroine dari manhwa Mistaken as the Monster Duke's Wife harus diunduh terlebih dahulu dan tidak boleh didahului oleh gambar heroine dari manhwa lainnya.

Seluruh gambar akan disimpan dalam folder Heroines. Di dalam folder Heroines, akan terdapat subfolder dengan nama depan atau nama panggilan heroine dari masing-masing manhwa.

Struktur folder yang diinginkan:

```
Heroines/
├── Alisha/
│   ├── Alisha_1.jpg
│   └── Alisha_2.jpg
└── Dorothea/
    ├── Dorothea_1.jpg
    └── Dorothea_2.jpg
```
<hr>

1. Saya mengerjakan skrip didalam file `solver.c`, dengan hasil akhir yang sudah dibagi sebagai berikut:
```c
// Fungsi untuk mendownload gambar heroine dengan thread
void *download_image(void *arg){
    // Ambil argumen sebagai array string [nama_file, url]
    char **args = (char **)arg;

    // Membuat proses anak
    pid_t pid = fork();
    if(pid == 0){
        // Di proses anak: jalankan wget untuk download gambar
        char *argv[] ={"wget", "-q", "-O", args[0], args[1], NULL};
        execvp(argv[0], argv);
        exit(1); // Keluar setelah execvp
    } else waitpid(pid, NULL, 0); // Di proses induk: tunggu proses anak selesai

    pthread_exit(NULL); // Keluar dari thread
}

// Fungsi untuk mencari manhwa, lalu download gambar heroine
void gambarheroine(const char *heroine, const char *manhwa, const char *url){
    // Membuka folder "Manhwa"
    DIR *dir = opendir("Manhwa");
    if(!dir) return; // Kalau gagal buka, keluar

    struct dirent *entry;
    // Baca semua file di folder Manhwa
    while((entry = readdir(dir)) != NULL){
        // Cari file .txt
        if(strstr(entry->d_name, ".txt")){
            char path[512], line[256], judulmanhwa[256];
            // Membuat path lengkap file
            snprintf(path, sizeof(path), "Manhwa/%s", entry->d_name);

            // Buka file
            FILE *file = fopen(path, "r");
            if(!file) continue;

            int yes = 0, jumlahfoto = 0;
            // Baca setiap baris file
            while(fgets(line, sizeof(line), file)){
                // Cari baris yang ada "Title:"
                if(strstr(line, "Title:")){
                    // Ambil judul manhwa dari file
                    sscanf(line, "Title: %[^\n]", judulmanhwa);
                    // Cocokkan dengan manhwa target
                    if(strcmp(judulmanhwa, manhwa) == 0) yes = 1;
                    else break; // Kalau beda, lanjut file lain
                }
                // Kalau sudah ketemu manhwa yang cocok, cari "Release:"
                if(yes && strstr(line, "Release:")){
                    // Ambil bulan dari tanggal rilis
                    sscanf(line, "Release: %*d-%d-%*d", &jumlahfoto);
                    break;
                }
            }
            fclose(file); // Tutup file

            // Kalau manhwa cocok dan jumlahfoto > 0
            if(yes && jumlahfoto > 0){
                // Membuat proses anak untuk buat folder heroine
                pid_t pid = fork();
                if(pid == 0){
                    char folder[128];
                    // Folder tujuan: Heroines/nama_heroine
                    snprintf(folder, sizeof(folder), "Heroines/%s", heroine);
                    // Buat folder
                    char *argv[] ={"mkdir", "-p", folder, NULL};
                    execvp(argv[0], argv);
                    exit(1);
                } 
                else waitpid(pid, NULL, 0); // Tunggu sampai folder dibuat

                pthread_t threads[jumlahfoto];
                // Membuat thread untuk setiap gambar
                for(int i = 1; i <= jumlahfoto; i++){
                    // Siapkan argumen untuk thread
                    char **args = malloc(2 * sizeof(char *));
                    char file[256], url_download[512];

                    // Nama file gambar: Heroines/heroine/heroine_i.jpg
                    snprintf(file, sizeof(file), "Heroines/%s/%s_%d.jpg", heroine, heroine, i);

                    // Format URL download (disini ada salah: harusnya url_download, bukan url)
                    snprintf(url_download, sizeof(url_download), url, heroine, i);

                    // Simpan nama file dan URL ke args
                    args[0] = strdup(file);
                    args[1] = strdup(url_download);

                    // Buat thread baru untuk download gambar
                    pthread_create(&threads[i - 1], NULL, download_image, args);
                }
                // Tunggu semua thread selesai
                for(int i = 0; i < jumlahfoto; i++) pthread_join(threads[i], NULL);
                break; // Setelah ketemu dan selesai download, keluar dari loop
            }
        }
    }
    closedir(dir); // Tutup folder Manhwa
}

int main(){
    // Data heroine, manhwa, dan url gambarnya
    const char *heroine[] ={"Adelia", "Lia", "Ophelia", "Tia"};
    const char *manhwa[] ={
        "No, I Only Charmed the Princess!",
        "Mistaken as the Monster Duke's Wife",
        "Darling, Why Can't We Divorce?",
        "The Villainess Lives Again"
    };
    const char *url[] ={
        "https://i.pinimg.com/736x/09/81/6c/09816c1e9e3306c67ecbc2db318a6b93.jpg",
        "https://i.pinimg.com/736x/cc/88/fc/cc88fc7520e11783dccbf081dcf5293d.jpg",
        "https://i.pinimg.com/736x/17/3a/ae/173aaec355eed29a86c423009eba7710.jpg",
        "https://i.pinimg.com/736x/ab/e4/f0/abe4f0004953bccb57b2e8ed17bd6263.jpg"
    };
    // Panggil fungsi untuk setiap heroine
    for(int i = 0; i < 4; i++) gambarheroine(heroine[i], manhwa[i], url[i]);
}
```
2. Untuk menjalankan skrip maka kita akan compile dan run dengan syntax berikut:
```
gcc -o solver-c solver-c.c
./solver-c
```
3. Isi direktori akan seperti ini setelah memasukkan foto-foto yang sudah dibuat kedalam folder `Heroines` dimana jumlah foto menyesuaikan bulan rilis manhwa, misalkan manhwa yang berjudul "No, I Only Charmed the Princess!" dengan heroine Adelia akan mengunduh foto sebanyak 4 kali karena manhwa tersebut rilis dibulan April:
<img src="https://github.com/user-attachments/assets/2019092c-2a29-43c5-a3ca-36a5f72a561f">
<img src="https://github.com/user-attachments/assets/09012c57-d6a9-4dc3-ad58-34253e1c8617" height="300">

### **d. Zip. Save. Goodbye**

Setelah semua gambar heroine berhasil diunduh, Cella ingin mengarsipkannya:

- Setiap folder heroine di-zip dengan format:
  ```
  [HURUFKAPITALNAMAMANHWA]_[namaheroine].zip
  ```
- Disimpan di folder `Archive/Images`
- Setelah zip selesai, gambar pada masing masing folder Heroine akan dihapus secara **urut dengan abjad**.
<hr>

1. Saya mengerjakan skrip didalam file `solver.c`, dengan hasil akhir yang sudah dibagi sebagai berikut:
```c
// Fungsi untuk nge-zip folder heroine berdasarkan manhwa dan heroine
void zipheroine(const char *manhwa, const char *heroine){
    char zip[512];
    char direktori[] = "Archive/Images";
    char hurufkapital[256];
    int j = 0;

    // Ambil semua huruf kapital dari nama manhwa
    for(int i = 0; manhwa[i] != '\0'; i++) 
        if(manhwa[i] >= 'A' && manhwa[i] <= 'Z') 
            hurufkapital[j++] = manhwa[i];
    hurufkapital[j] = '\0'; // Akhiri string

    // Buat folder "Archive/Images"
    pid_t pid = fork();
    if(pid == 0){
        char *argv[] ={"mkdir", "-p", direktori, NULL};
        execvp(argv[0], argv);
        exit(1);
    } 
    else waitpid(pid, NULL, 0); // Tunggu mkdir selesai

    // Buat path file zip nantinya
    snprintf(zip, sizeof(zip), "../../%s/%s_%s.zip", direktori, hurufkapital, heroine);

    // Fork lagi untuk nge-zip folder heroine
    pid = fork();
    if(pid == 0){
        char folder[128];
        // Path folder heroine yang mau di-zip
        snprintf(folder, sizeof(folder), "/home/farqil/Documents/sisop-modul-2-Farqil/task-3/Heroines/%s", heroine);

        char command[1024];
        // Buat command untuk zip: cd ke folder dulu baru zip semua file
        snprintf(command, sizeof(command), "cd %s && zip -r %s *", folder, zip); 

        char *argv[] ={"sh", "-c", command, NULL}; // Pake shell karena command panjang
        execvp(argv[0], argv);
        exit(1);
    } 
    else waitpid(pid, NULL, 0); // Tunggu proses zip selesai

    // Hapus folder heroine
    char path[512];
    snprintf(path, sizeof(path), "/home/farqil/Documents/sisop-modul-2-Farqil/task-3/Heroines/%s", heroine);

    pid = fork();
    if(pid == 0){
        char *argv[] ={"rm", "-rf", path, NULL}; // Hapus folder heroine
        execvp(argv[0], argv);
        exit(1);
    }
    // Di parent, tidak perlu tunggu rm selesai, biar lanjut program
}

// Fungsi utama
int main(){
    // Daftar heroine, manhwa, dan URL gambar mereka
    const char *heroine[] ={"Adelia", "Lia", "Ophelia", "Tia"};
    const char *manhwa[] ={
        "No, I Only Charmed the Princess!",
        "Mistaken as the Monster Duke's Wife",
        "Darling, Why Can't We Divorce?",
        "The Villainess Lives Again"
    };
    const char *url[] ={
        "https://i.pinimg.com/736x/09/81/6c/09816c1e9e3306c67ecbc2db318a6b93.jpg",
        "https://i.pinimg.com/736x/cc/88/fc/cc88fc7520e11783dccbf081dcf5293d.jpg",
        "https://i.pinimg.com/736x/17/3a/ae/173aaec355eed29a86c423009eba7710.jpg",
        "https://i.pinimg.com/736x/ab/e4/f0/abe4f0004953bccb57b2e8ed17bd6263.jpg"
    };
    // Setelah itu zip semua heroine
    for(int i = 0; i < 4; i++) 
        zipheroine(manhwa[i], heroine[i]);

    return 0; // Program selesai
}
```
2. Untuk menjalankan skrip maka kita akan compile dan run dengan syntax berikut:
```
gcc -o solver-c solver-c.c
./solver-c
```
3. Isi direktori akan seperti ini setelah membuat zip didalam `Archive/Image` setelah membuat zip maka kita akan menghapus foto-foto didalam folder `Heroines` secara urut abjad, karena isi folder `Heroines` saya sudah urut sesuai abjad, maka penghapusan otomatis dilakukan sesuai abjad. Kita cek direktori menggunakan `ls`:
<img src="https://github.com/user-attachments/assets/68481f81-edda-4ad8-9e23-7016f7713a7f">

Penamaan zip berupa `[HURUFKAPITALNAMAMANHWA]_[namaheroine].zip`, misalkan manhwa yang berjudul `Mistaken as the Monster Duke's Wife` dengan heroine `Lia` akan memiliki zip `MMDW_Lia.zip`

---

## Task 4 (Marco)
### **a. Client Mengirimkan Pesan ke Load Balancer**

Pipip ingin agar proses `client.c` dapat mengirimkan pesan ke `loadbalancer.c` menggunakan IPC dengan metode **shared memory**. Proses pengiriman pesan dilakukan dengan format input dari pengguna sebagai berikut:

```
Halo A;10
```

**Penjelasan:**

- `"Halo A"` adalah isi pesan yang akan dikirim.
- `10` adalah jumlah pesan yang ingin dikirim, dalam hal ini sebanyak 10 kali pesan yang sama.

Selain itu, setiap kali pesan dikirim, proses `client.c` harus menuliskan aktivitasnya ke dalam **`sistem.log`** dengan format:

```
Message from client: <isi pesan>
Message count: <jumlah pesan>
```

Semua pesan yang dikirimkan dari client akan diteruskan ke `loadbalancer.c` untuk diproses lebih lanjut.

1. Saya membuka terminal dan membuat file client.c

```
touch client.c
```

dan mengisi program pada file yang sudah saya buat

```
nano client.c
```

Source Code
```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/ipc.h>
#include <sys/shm.h>

#define SHM_KEY 1234
#define MAX_MSG_LEN 256

typedef struct {
    char message[MAX_MSG_LEN];
    int count;
} SharedData;

int main() {
    char input[300];
    printf("Masukkan pesan dan jumlah (format: Pesan;Jumlah): ");
    fgets(input, sizeof(input), stdin);
    input[strcspn(input, "\n")] = '\0';  // hapus newline

    // Parsing input
    char *token = strtok(input, ";");
    if (token == NULL) {
        fprintf(stderr, "Format salah. Harus Pesan;Jumlah\n");
        return 1;
    }

    char pesan[MAX_MSG_LEN];
    strncpy(pesan, token, MAX_MSG_LEN);

    token = strtok(NULL, ";");
    if (token == NULL) {
        fprintf(stderr, "Jumlah tidak ditemukan.\n");
        return 1;
    }
    int jumlah = atoi(token);

    // Akses atau buat shared memory
    int shmid = shmget(SHM_KEY, sizeof(SharedData), IPC_CREAT | 0666);
    if (shmid < 0) {
        perror("shmget error");
        return 1;
    }

    SharedData *data = (SharedData *) shmat(shmid, NULL, 0);
    if (data == (void *) -1) {
        perror("shmat error");
        return 1;
    }

    // Tulis ke shared memory
    strncpy(data->message, pesan, MAX_MSG_LEN);
    data->count = jumlah;

    // Tulis ke log
    FILE *log = fopen("sistem.log", "a");
    if (log != NULL) {
        fprintf(log, "Message from client: %s\n", pesan);
        fprintf(log, "Message count: %d\n", jumlah);
        fclose(log);
    } else {
        perror("Gagal membuka sistem.log");
    }

    // Detach shared memory
    shmdt(data);

    printf("Pesan dikirim ke load balancer melalui shared memory.\n");
    return 0;
}

```

2. Saya kompile program C tersebut dengan

```
gcc client.c -o client
```

<img src="https://github.com/Marcellohugo/SistemOperasi/blob/main/sisop-modul-2-Farqil/Dokumentasi/11.png?raw=true">

3. Saya menjalankan program dengan perintah pada terminal

```
./client
```
4. Dan program berhasil dijalankan

<img src="https://github.com/Marcellohugo/SistemOperasi/blob/main/sisop-modul-2-Farqil/Dokumentasi/12.png?raw=true">

lihat isi sistem.log

<img src="https://github.com/Marcellohugo/SistemOperasi/blob/main/sisop-modul-2-Farqil/Dokumentasi/13.png?raw=true">

### **b. Load Balancer Mendistribusikan Pesan ke Worker Secara Round-Robin**

Setelah menerima pesan dari client, tugas `loadbalancer.c` adalah mendistribusikan pesan-pesan tersebut ke beberapa **worker** menggunakan metode **round-robin**. Sebelum mendistribusikan pesan, `loadbalancer.c` terlebih dahulu mencatat informasi ke dalam **`sistem.log`** dengan format:

```
Received at lb: <isi pesan> (#message <indeks pesan>)
```

Contoh jika ada 10 pesan yang dikirimkan, maka output log yang dihasilkan adalah:

```
Received at lb: Halo A (#message 1)
Received at lb: Halo A (#message 2)
...
Received at lb: Halo A (#message 10)
```

Setelah itu, `loadbalancer.c` akan meneruskan pesan-pesan tersebut ke **n worker** secara bergiliran (round-robin), menggunakan **IPC message queue**. Berikut adalah contoh distribusi jika jumlah worker adalah 3:

- Pesan 1 → worker1
- Pesan 2 → worker2
- Pesan 3 → worker3
- Pesan 4 → worker1 (diulang dari awal)

Dan seterusnya.

Proses `worker.c` bertugas untuk mengeksekusi pesan yang diterima dan mencatat log ke dalam file yang sama, yakni **`sistem.log`**.

1. Saya membuka terminal dan membuat file loadbalancer.c

```
touch loadbalancer.c
```

dan mengisi program pada file yang sudah saya buat

```
nano loadbalancer.c
```

Source Code
```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/ipc.h>
#include <sys/shm.h>
#include <sys/msg.h>
#include <unistd.h>

#define SHM_KEY 1234
#define MAX_MSG_LEN 256
#define MAX_WORKERS 10

typedef struct {
    char message[MAX_MSG_LEN];
    int count;
} SharedData;

struct msg_buffer {
    long msg_type;
    char msg_text[MAX_MSG_LEN];
};

int main() {
    int num_workers;
    printf("Masukkan jumlah worker: ");
    scanf("%d", &num_workers);

    if (num_workers > MAX_WORKERS || num_workers <= 0) {
        printf("Jumlah worker tidak valid (maks %d)\n", MAX_WORKERS);
        return 1;
    }

    // Ambil shared memory
    int shmid = shmget(SHM_KEY, sizeof(SharedData), 0666);
    if (shmid < 0) {
        perror("shmget error");
        return 1;
    }

    SharedData *data = (SharedData *) shmat(shmid, NULL, 0);
    if (data == (void *) -1) {
        perror("shmat error");
        return 1;
    }

    // Setup message queue untuk tiap worker
    int msgids[MAX_WORKERS];
    for (int i = 0; i < num_workers; i++) {
        key_t key = ftok(".", 'A' + i);  // unik untuk setiap worker
        msgids[i] = msgget(key, IPC_CREAT | 0666);
        if (msgids[i] < 0) {
            perror("msgget error");
            return 1;
        }
    }

    FILE *log = fopen("sistem.log", "a");
    if (!log) {
        perror("Gagal membuka sistem.log");
        return 1;
    }

    for (int i = 0; i < data->count; i++) {
        // Tulis log
        fprintf(log, "Received at lb: %s (#message %d)\n", data->message, i + 1);

        // Kirim pesan ke worker round-robin
        int worker_id = i % num_workers;
        struct msg_buffer msg;
        msg.msg_type = 1;
        strncpy(msg.msg_text, data->message, MAX_MSG_LEN);

        if (msgsnd(msgids[worker_id], &msg, sizeof(msg.msg_text), 0) < 0) {
            perror("msgsnd error");
        }
    }

    fclose(log);
    shmdt(data); // detach shared memory

    printf("Pesan telah didistribusikan ke worker menggunakan round-robin.\n");
    return 0;
}

```

2. Saya kompile program C tersebut dengan

```
gcc loadbalancer.c -o loadbalancer
```

<img src="https://github.com/Marcellohugo/SistemOperasi/blob/main/sisop-modul-2-Farqil/Dokumentasi/14.png?raw=true">

3. Saya menjalankan program dengan perintah pada terminal

```
./loadbalancer
```
4. Dan program berhasil dijalankan

<img src="https://github.com/Marcellohugo/SistemOperasi/blob/main/sisop-modul-2-Farqil/Dokumentasi/15.png?raw=true">

### **c. Worker Mencatat Pesan yang Diterima**

Setiap worker yang menerima pesan dari `loadbalancer.c` harus mencatat pesan yang diterima ke dalam **`sistem.log`** dengan format log sebagai berikut:

```
WorkerX: message received
```
1. Saya membuka terminal dan membuat file worker.c

```
touch worker.c
```

dan mengisi program pada file yang sudah saya buat

```
nano worker.c
```

Source Code
```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/ipc.h>
#include <sys/msg.h>
#include <unistd.h>

#define MAX_MSG_LEN 256

struct msg_buffer {
    long msg_type;
    char msg_text[MAX_MSG_LEN];
};

int main(int argc, char *argv[]) {
    if (argc != 3) {
        fprintf(stderr, "Usage: %s <worker_id> <jumlah_pesan>\n", argv[0]);
        return 1;
    }

    int worker_id = atoi(argv[1]);        // misalnya: 0, 1, 2...
    int jumlah_pesan = atoi(argv[2]);     // jumlah pesan yang akan diterima

    key_t key = ftok(".", 'A' + worker_id);
    int msgid = msgget(key, 0666);
    if (msgid < 0) {
        perror("msgget error");
        return 1;
    }

    FILE *log = fopen("sistem.log", "a");
    if (!log) {
        perror("Gagal membuka sistem.log");
        return 1;
    }

    int received_count = 0;
    struct msg_buffer msg;
    while (received_count < jumlah_pesan) {
        if (msgrcv(msgid, &msg, sizeof(msg.msg_text), 0, 0) < 0) {
            perror("msgrcv error");
            continue;
        }

        fprintf(log, "Worker%d: message received\n", worker_id + 1);
        received_count++;
    }

    // Tulis total pesan setelah selesai
    fprintf(log, "Worker %d: %d messages\n", worker_id + 1, received_count);
    fclose(log);

    printf("Worker %d selesai menerima %d pesan.\n", worker_id + 1, received_count);
    return 0;
}

```

2. Saya kompile program C tersebut dengan

```
gcc worker.c -o worker
```

<img src="https://github.com/Marcellohugo/SistemOperasi/blob/main/sisop-modul-2-Farqil/Dokumentasi/16.png?raw=true">

3. Saya menjalankan program dengan perintah pada terminal

```
./worker 0 4
// worker pertama menerima 4 pesan
./worker 1 3
// worker kedua menerima 3 pesan
./worker 2 3
// worker ketiga menerima 3 pesan
```
4. Dan program berhasil dijalankan

<img src="https://github.com/Marcellohugo/SistemOperasi/blob/main/sisop-modul-2-Farqil/Dokumentasi/17.png?raw=true">
<img src="https://github.com/Marcellohugo/SistemOperasi/blob/main/sisop-modul-2-Farqil/Dokumentasi/18.png?raw=true">
<img src="https://github.com/Marcellohugo/SistemOperasi/blob/main/sisop-modul-2-Farqil/Dokumentasi/19.png?raw=true">

### **d. Catat Total Pesan yang Diterima Setiap Worker di Akhir Eksekusi**

Setelah proses selesai (semua pesan sudah diproses), setiap worker akan mencatat jumlah total pesan yang mereka terima ke bagian akhir file **`sistem.log`**.

```
Worker 1: 3 messages
Worker 2: 4 messages
Worker 3: 3 messages
```

**Penjelasan:**
3 + 4 + 3 = 10, sesuai dengan jumlah pesan yang dikirim pada soal a

<img src="https://github.com/Marcellohugo/SistemOperasi/blob/main/sisop-modul-2-Farqil/Dokumentasi/20.png?raw=true">
