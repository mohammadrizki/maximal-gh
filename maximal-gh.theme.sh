#!/bin/bash

function _omb_theme_PROMPT_COMMAND() {
    local last_status="$?"

    # =========================================================================
    # 1. Deteksi Distro Otomatis (Ikon & Warna Spesifik Distro)
    # =========================================================================
    local distro_id=""
    if [ -f /etc/os-release ]; then
        distro_id=$(string_lower=$(cat /etc/os-release | grep -E '^ID=' | cut -d= -f2 | tr -d '"'); echo "$string_lower")
    fi

    # Inisialisasi default jika distro tidak terdaftar
    local i_arch=$'\uF31A'   # Ikon Linux Tux Default
    local c_arch="\[\e[1;37m\]"       # Putih Tebal default

    # Mapping Ikon & Warna Berdasarkan Nama Distro (Nerd Fonts v3.x)
    case "$distro_id" in
        arch)
            i_arch=$'\uF303' # Ikon Arch Linux
            c_arch="\[\e[1;36m\]" # Cyan khas Arch
            ;;
        ubuntu)
            i_arch=$'\uF31B' # Ikon Ubuntu
            c_arch="\[\e[38;5;202m\]" # Jingga gelap Ubuntu
            ;;
        debian)
            i_arch=$'\uF306' # Ikon Debian
            c_arch="\[\e[1;31m\]" # Merah Debian
            ;;
        fedora)
            i_arch=$'\uF30a' # Ikon Fedora
            c_arch="\[\e[1;34m\]" # Biru Fedora
            ;;
        kali)
            i_arch=$'\uF327' # Ikon Kali Linux
            c_arch="\[\e[1;34m\]" # Biru gelap Kali
            ;;
        raspbian)
            i_arch=$'\uF315' # Ikon Raspberry Pi
            c_arch="\[\e[1;35m\]" # Merah Muda/Magenta Raspberry
            ;;
        alpine)
            i_arch=$'\uF300' # Ikon Alpine
            c_arch="\[\e[1;36m\]" # Biru Muda Alpine
            ;;
        centos)
            i_arch=$'\uF304' # Ikon CentOS
            c_arch="\[\e[1;33m\]" # Kuning Mustard CentOS
            ;;
        amzn)
            i_arch=$'\uF31C' # Ikon AWS Amazon Linux
            c_arch="\[\e[38;5;214m\]" # Kuning Jingga AWS
            ;;
    esac

    # =========================================================================
    # 2. Konstanta Warna ANSI Cerah & Eye Candy
    # =========================================================================
    local c_reset="\[\e[0m\]"
    local c_time="\[\e[38;5;242m\]"     # Abu-abu redup untuk waktu
    local c_user="\[\e[1;32m\]"       # Hijau terang untuk user
    local c_machine="\[\e[1;32m\]"      # Hijau terang untuk hostname
    local c_ip="\[\e[38;5;245m\]"       # Abu-abu sedang untuk alamat IP
    local c_path="\[\e[1;33m\]"       # Kuning emas untuk full path folder
    local c_git="\[\e[1;35m\]"        # Ungu/Magenta untuk status Git
    local c_t_icon="\[\e[38;5;208m\]"   # Jingga/Orange cerah untuk ikon tugas
    local c_t_num="\[\e[1;95m\]"      # Pink menyala untuk angka tugas

    # Warna dinamis untuk simbol prompt (❯) berdasarkan sukses/gagal perintah
    local c_status
    if [ "$last_status" -eq 0 ]; then
        c_status="\[\e[1;32m\]"       # Hijau jika sukses
    else
        c_status="\[\e[1;31m\]"       # Merah jika perintah error
    fi

    # =========================================================================
    # 3. Ambil IP Lokal Aktif Menggunakan Perintah 'ip' Modern
    # =========================================================================
    local local_ip
    local_ip=$(ip route get 1.1.1.1 2>/dev/null | awk '{print $7}')
    if [ -z "$local_ip" ]; then
        local_ip=$(ip addr show | grep -v '127.0.0.1' | grep -w 'inet' | head -n 1 | awk '{print $2}' | cut -d/ -f1)
    fi
    if [ -z "$local_ip" ]; then
        local_ip="127.0.0.1"
    fi

    # =========================================================================
    # 4. Deteksi Git Branch Menggunakan Pembacaan Berkas .git
    # =========================================================================
    local git_info=""
    if git rev-parse --git-dir &>/dev/null; then
        local branch
        branch=$(git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)
        local status_sign=" ✓ "
        if [ -n "$(git status --porcelain 2>/dev/null)" ]; then
            status_sign=" * "
        fi
        git_info="${branch}${status_sign}"
    fi

    # =========================================================================
    # 5. Ambil jumlah tugas live dari aplikasi 't'
    # =========================================================================
    local t_todo=""
    if type t &>/dev/null; then
        t_todo=$(t | wc -l | sed -e "s/ *//")
    fi

    # =========================================================================
    # 6. Ekstraksi Karakter Simbol Unicode Eksternal Lainnya
    # =========================================================================
    local i_folder=$'\uF07C' # Ikon Folder
    local i_git=$'\uF408'    # Ikon Cabang Git
    local i_todo=$'\uF0CA'   # Ikon Todo List

    # =========================================================================
    # 7. Susun Struktur Tampilan Prompt (Sempurna & Tanpa Bug Pemisah)
    # =========================================================================

    # Blok Waktu, Distro Icon, User@Host, IP, dan Folder Path (Selalu Tampil)
    PS1="[${c_time}\$(date +%I:%M:%S%P)${c_reset}]"
    PS1+="-[${c_arch}${i_arch}${c_reset}]-[${c_user}\u${c_reset}@${c_machine}\h${c_reset}]-[${c_ip}${local_ip}${c_reset}]"
    PS1+="-[${c_path}${i_folder} \w${c_reset}]"

    # Blok Git (Hanya muncul jika di dalam repositori git)
    if [ -n "$git_info" ]; then
        PS1+="-[${c_git}${i_git} ${git_info}${c_reset}]"
    fi

    # Blok Todo List (Hanya muncul jika ada tugas > 0)
    if [ -n "$t_todo" ] && [ "$t_todo" -gt 0 ] 2>/dev/null; then
        PS1+="-[${c_t_icon}${i_todo} ${c_t_num}${t_todo}${c_reset}]"
    fi

    # Karakter isi perintah di baris baru
    PS1+="\n${c_status}❯${c_reset} "
}

_omb_util_add_prompt_command _omb_theme_PROMPT_COMMAND
