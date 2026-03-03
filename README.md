# 🖥️ Praktikum Sistem Operasi (Operating Systems Lab)

Repository ini berisi seluruh tugas praktikum mata kuliah **Sistem Operasi** di Institut Teknologi Sepuluh Nopember (ITS).

## 👥 Anggota Kelompok

| NRP | Nama |
| :---: | :---: |
| 5025221102 | Marco Marcello Hugo |
| 5025241015 | Farrel Aqilla Novianto |

---

## 📁 Struktur Repository

```
SistemOperasi/
├── praktikum-modul-1-b14/   # Modul 1 – Shell Scripting
├── Archive-Sisop/modul2/     # Modul 2 – Daemon & Process (Farrel)
├── sisop-modul-2-Farqil/     # Modul 2 – Daemon & Process (Marco)
├── Modul3/                   # Modul 3 – Custom OS (Budinux)
├── Modul4/                   # Modul 4 – FUSE & Kernel
├── challenge_1/              # Challenge 1 – Bash Scripting
└── challengeModul4/          # Challenge Modul 4
```

---

## 📝 Deskripsi Modul

### Modul 1 — Shell Scripting
> **Direktori:** `praktikum-modul-1-b14/`

Modul pertama berfokus pada penguasaan **Bash scripting** untuk otomasi dan pengolahan data di lingkungan Linux.

| Task | Judul | Deskripsi |
| :---: | --- | --- |
| 1 | New Jeans Global Teratas | Analisis data CSV menggunakan Bash (filter, sort, count) |
| 2 | Liburan Bersama Rudi | Pengolahan dan manipulasi file dengan shell script |
| 3 | Ignatius Si Cloud Engineer | Sistem cloud storage sederhana (register, login, upload, download) |
| 4 | Proxy Terbaik di New Eridu | Monitoring uptime dan logging otomatis dengan crontab |

**Teknologi:** Bash, awk, grep, sed, crontab

---

### Modul 2 — Daemon & Process
> **Direktori:** `Archive-Sisop/modul2/` dan `sisop-modul-2-Farqil/`

Modul kedua membahas manajemen proses di Linux menggunakan bahasa **C**, termasuk `fork()`, `exec()`, daemon process, dan inter-process communication.

| Task | Judul | Deskripsi |
| :---: | --- | --- |
| 1 | Trabowo & Peddy Movie Night | Download, ekstraksi, dan manajemen file film menggunakan proses C |
| 2 | Organize Anthony's Films | Otomasi download, ekstraksi, dan sorting data film Netflix |
| 3 | Cella's Manhwa | Solver otomatis menggunakan daemon process |
| 4 | Pipip's Load Balancer | Implementasi load balancer sederhana dengan client-worker architecture |

**Teknologi:** C, fork(), exec(), IPC, daemon process, shell scripting

---

### Modul 3 — Custom Operating System (Budinux)
> **Direktori:** `Modul3/`

Modul ketiga menantang pembuatan **sistem operasi sederhana** berbasis BusyBox dari awal, meliputi:

- Penyiapan prasyarat dan instalasi tools
- Pembuatan struktur direktori OS (bin, dev, proc, sys, tmp, sisop)
- Konfigurasi init system
- Kompilasi kernel (`bzImage`)
- Pembuatan bootable ISO (`mylinuxiso/`)

**Teknologi:** BusyBox, Linux kernel, QEMU, initramfs

---

### Modul 4 — FUSE Filesystem & Kernel Development
> **Direktori:** `Modul4/`

Modul terakhir mencakup topik lanjutan dalam sistem operasi: **FUSE (Filesystem in Userspace)** dan pengembangan kernel.

| Task | Judul | Deskripsi |
| :---: | --- | --- |
| 1 | FUSecure | FUSE filesystem dengan akses read-only dan visibilitas file berbasis permission user |
| 2 | LawakFS++ | Custom FUSE filesystem dengan konfigurasi khusus |
| 3 | Drama Troll | FUSE filesystem dengan jebakan kondisional berdasarkan identitas user |
| 4 | LilHabOS | Kernel sederhana dengan fitur piping (echo, grep, wc) menggunakan bootloader dan assembly |

**Teknologi:** C, FUSE, x86 Assembly (NASM), Bochs emulator, kernel development

---

### Challenge
> **Direktori:** `challenge_1/`

Tantangan tambahan berupa latihan shell scripting:
- `fet.sh` — Menampilkan tanggal menggunakan array numerik
- `misq.sh` — Menampilkan bulan menggunakan array karakter
- `calender.txt` — Referensi data kalender

---

## ⚙️ Cara Menjalankan

### Shell Scripts (Modul 1 & Challenge)
```bash
chmod +x script.sh
./script.sh
```

### Program C (Modul 2 & 4)
```bash
gcc -o output program.c
./output
```

### FUSE Filesystem (Modul 4)
```bash
gcc -Wall program.c -o program -D_FILE_OFFSET_BITS=64 -lfuse
sudo ./program /mnt/mountpoint -o allow_other
```

### Custom OS — Budinux (Modul 3)
Ikuti instruksi pada [Modul Sisop](https://github.com/arsitektur-jaringan-komputer/Modul-Sisop/blob/master/Modul3/README-ID.md) untuk setup dan boot OS.

### LilHabOS Kernel (Modul 4 Task 4)
```bash
cd Modul4/task-4
make
# Jalankan dengan Bochs emulator
bochs -f bochsrc.txt
```

---

## 📚 Referensi

- [Modul Praktikum Sisop ITS](https://github.com/arsitektur-jaringan-komputer/Modul-Sisop)
- Linux man pages (`man fork`, `man fuse`, `man bash`)
- BusyBox Documentation

---

## 📄 Lisensi

Repository ini dibuat untuk keperluan akademik Praktikum Sistem Operasi, Departemen Informatika, Institut Teknologi Sepuluh Nopember (ITS).
