#!/bin/bash
RED='\033[1;31m' 
RESET='\033[0m'
# CREATE BY KANGQULL
# Script ini menampilkan daftar password Windows, meminta konfirmasi, dan mengunduh Windows langsung ke /dev/vda.

clear

# Header
echo -e "${RED}  ____ ___  ____   ____ __   ___  ____ ___  __   ____ ____    ${RESET}"
echo -e "${RED}  | . \|  \ | . \  |___\| \|\| _\ |_ _\|  \ | |  | __\| . \   ${RESET}"
echo -e "${RED}  |  <_| . \| __/  | /  |  \|[__ \  || | . \| |__|  ]_|  <_   ${RESET}"
echo -e "${RED}  |/\_/|___/|/     |/   |/\_/|___/  |/ |/\_/|___/|___/|/\_/   ${RESET}"
echo -e "${RED}___  ____ ____ ____ ____ ___  __     ____ ____ ____ ___  __   ${RESET}"
echo -e "${RED}|  \ |___\|  _\|___\|_ _\|  \ | |    |   || __\| __\|  \ | \|\ ${RESET}"
echo -e "${RED}| . \| /  | [ \| /    || | . \| |__  | . || \__|  ]_| . \|  \| ${RESET}"
echo -e "${RED}|___/|/   |___/|/     |/ |/\_/|___/  |___/|___/|___/|/\_/|/\_/ ${RESET}"
echo ""
echo -e "${RED}|—————————————————————————————————————————————————————————————|${RESET}"
# Tabel Password Windows
cat << EOF
|---------------------------------------------------------|
| Windows Version          | Windows Version              |
|---------------------------------------------------------|
| 1) Windows Server 2022   | 6) Windows 10 XLite          |
| 2) Windows Server 2019   | 7) Windows 10 NeonLite       |
| 3) Windows Server 2016   | 8) Windows 11 xLite Micro    |
| 4) Windows Server 2012   | 9) Windows 11 Ghost Spectre  |
| 5) Windows 10 Pro        | 10) Windows 11 24H2 xLite    |
|---------------------------------------------------------|

EOF

# Peringatan
echo "‼️ *Catatan: Windows hanya dapat diinstall pada VPS Ubuntu/Debian."
echo ""

# Lokasi file dan ekstensi
location="https://cloudshydro.tech/s/gABn6KJM9bzbKWf/download?path"
files=".gz"

# Pilihan pengguna
read -p "Pilih Windows sesuai nomor (1-10): " GETOS

# Tentukan password dan file berdasarkan input
case "$GETOS" in
    1) USER="Administrator"; PASSWORD="windowsNetwork"; GETOS="$location=win2022$files" ;;
    2) PASSWORD="comingsoon"; GETOS="soon" ;;
    3) PASSWORD="comingsoon"; GETOS="soon" ;;
    4) PASSWORD="comingsoon"; GETOS="soon" ;;
    5) USER="Admin"; PASSWORD="windows.me"; GETOS="$location=windows10lite$files" ;;
    6) USER="Admin"; PASSWORD="windows.me"; GETOS="$location=win10XLite$files" ;;
    7) USER="Admin"; PASSWORD="windows.me"; GETOS="$location=win10neonLite$files" ;;
    8) USER="Admin"; PASSWORD="windows.me"; GETOS="$location=win11xLiteMicro$files" ;;
    9) USER="Admin"; PASSWORD="windows.me"; GETOS="$location=win11Ghostspectre$files" ;;
    10) USER="Admin"; PASSWORD="windows.me"; GETOS="$location=win1124H2xLite$files" ;;
    *) 
        echo "❌ Pilihan tidak valid! Silakan coba lagi."
        exit 1
        ;;
esac
clear
# Tampilkan password sebelum mengunduh
echo ""
echo "----------------------------------------------------"
echo "🔑 Password untuk Windows yang dipilih:"
echo "Username : $USER"
echo "Password : $PASSWORD"
echo "----------------------------------------------------"

# Konfirmasi unduhan
read -p "Apakah Anda ingin melanjutkan dengan unduhan dan instalasi? (y/n): " CONFIRM
if [[ "$CONFIRM" != "y" ]]; then
    echo "❌ Proses dibatalkan."
    exit 0
fi

# Proses unduhan dan instalasi
if [[ "$GETOS" == "soon" ]]; then
    echo "❌ Windows versi ini belum tersedia. Harap tunggu pembaruan."
else
    echo "🔄 Mengunduh dan menginstal langsung ke /dev/vda..."
    wget -qO- --no-check-certificate "$GETOS" | gunzip -c | dd of=/dev/vda bs=4M status=progress
    sync
    echo "✅ Instalasi selesai! Sistem Windows telah diinstal di /dev/vda."
fi

# Footer
echo ""
echo "Terima kasih telah menggunakan script ini! 🙏"
echo "Support dan donasi: https://github.com/KangQull"
echo ""
echo "👉 Setelah selesai, matikan VPS dan kembali ke mode Hard Drive."
