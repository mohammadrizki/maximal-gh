# 🚀 Maximal-GH Prompt (Oh-My-Bash + Ghostty + t)

Konfigurasi lingkungan terminal Linux super produktif, estetik (*eye candy*), dan efisien untuk **Arch Linux**. Repositori ini berisi tema kustom bash orisinal **`maximal-gh`** yang dirancang khusus dari nol untuk mengintegrasikan emulator terminal **Ghostty** dengan pelacak tugas CLI minimalis **`t`**.

---

## ✨ Fitur Utama

- 🕒 **Indikator Waktu Real-Time** – Jam redup presisi di baris paling depan (`HH:MM:SSpm`).
-    **Identitas Dinamis** – Otomatis membaca user dan `$HOSTNAME` sistem Anda tanpa *hardcode*.
- 🌐 **Deteksi IP Otomatis** – Mengekstrak IP lokal aktif (LAN/Wi-Fi) menggunakan metode modern `ip route` tepat di samping hostname.
-  **Jalur Kerja Visual** – Penunjuk direktori penuh (`full path`) yang kontras berwarna kuning emas dilengkapi ikon folder.
-  **Integrasi Git Mandiri** – Deteksi otomatis pencabangan (*branch*) dan status repositori (`✓` bersih / `*` ada perubahan) dalam satu baris yang sama.
-  **Live Todo Counter** – Penghitung sisa tugas dari aplikasi `t` yang menyala hanya jika ada pekerjaan tersisa.
- 🎨 **Minimalist Inline Prompt** – Tata letak satu baris ramping berbasis teks berwarna (*foreground coloring*) yang rapi, ringan, dan bebas dari masalah *rendering glitch*.

---

## 🛠️ Syarat Pemasangan (Prerequisites)

Sebelum memasang tema, pastikan paket-paket berikut sudah tersedia di sistem Arch Linux Anda:

```bash
# 1. Pastikan Oh-My-Bash sudah terinstal
# Jika belum: sh -c "$(curl -fsSL https://githubusercontent.com)"

# 2. Instal Font dengan ekosistem Ikon Lengkap via AUR (Wajib untuk Ghostty)
yay -S ttf-jetbrains-mono-nerd

# 3. Instal paket font pelengkap emoji/simbol sistem
sudo pacman -S noto-fonts-emoji ttf-font-awesome
```

---

## 📦 Langkah Pemasangan

### 1. Pemasangan Task Manager `t`
Unduh skrip `sjl/t` asli dan buat menjadi biner sistem global:

```bash
# Klon repositori t ke folder lokal
git clone https://github.com/sjl/t.git ~/.t-todo

# Buat direktori tempat menyimpan berkas teks daftar tugas
mkdir ~/tasks

# Buat script wrapper global di sistem
sudo bash -c 'cat << "EOF" > /usr/local/bin/t
#!/bin/bash
python3 $HOME/.t-todo/t.py --task-dir $HOME/tasks --list tasks "$@"
EOF'

# Berikan izin eksekusi
sudo chmod +x /usr/local/bin/t
```

### 2. Pemasangan Tema Kustom `maximal-gh`
Buat berkas tema baru di dalam folder kustom Oh-My-Bash:

```bash
git clone https://github.com/mohammadrizki/maximal-gh.git ~/.oh-my-bash/custom/themes/maximal-gh
```

### 3. Aktivasi di `.bashrc`
Buka file konfigurasi Bash Anda (`nano ~/.bashrc`) dan sesuaikan baris tema menjadi:

```bash
OSH_THEME="maximal-gh"
```
Terapkan perubahan dengan perintah: `source ~/.bashrc`

### 4. Konfigurasi Terminal Ghostty
Pastikan file konfigurasi Ghostty Anda (`~/.config/ghostty/config`) mengunci penggunaan Nerd Font agar ikon tidak berubah menjadi kotak kosong:

```text
# Font Configuration
font-family = "JetBrainsMono Nerd Font"
font-size = 9
```
*Muat ulang konfigurasi Ghostty dengan menekan kombinasi tombol `Ctrl + Shift + ,`.*

---

## ⌨️ Alur Kerja Harian (Cara Penggunaan `t`)

Gunakan perintah-perintah ringkas berikut untuk mengelola produktivitas Anda langsung dari baris perintah:

- **Menambahkan tugas:**
  ```bash
  t Tulis dokumentasi modul baru
  ```
- **Melihat semua daftar tugas aktif:**
  ```bash
  t
  ```
- **Menyelesaikan tugas (Gunakan ID angka di sebelah kiri):**
  ```bash
  t -f 21
  ```

---

## 📜 Lisensi

Proyek ini dilisensikan di bawah **MIT License**. Jangan ragu untuk melakukan *fork*, modifikasi, dan membagikannya kembali!

