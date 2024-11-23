#!/bin/bash
RED='\033[1;31m' 
RESET='\033[0m'
# CREATE BY KANGQULL
# Script ini menampilkan daftar password Windows, meminta konfirmasi, dan mengunduh Windows langsung ke /dev/vda.

clear

# Header
echo -e "${RED}         █▀▄░█▀▄░█▀█░░░▀█▀░█▀█░█▀▀░▀█▀░█▀█░█░░░█▀▀░█▀▄  ${RESET}"
echo -e "${RED}         █▀▄░█░█░█▀▀░░░░█░░█░█░▀▀█░░█░░█▀█░█░░░█▀▀░█▀▄  ${RESET}"
echo -e "${RED}         ▀░▀░▀▀░░▀░░░░░▀▀▀░▀░▀░▀▀▀░░▀░░▀░▀░▀▀▀░▀▀▀░▀░▀  ${RESET}"
echo -e "${RED}       █▀▄░▀█▀░█▀▀░▀█▀░▀█▀░█▀█░█░░░░░█▀█░█▀▀░█▀▀░█▀█░█▀█ ${RESET}"
echo -e "${RED}       █░█░░█░░█░█░░█░░░█░░█▀█░█░░░░░█░█░█░░░█▀▀░█▀█░█░█ ${RESET}"
echo -e "${RED}       ▀▀░░▀▀▀░▀▀▀░▀▀▀░░▀░░▀░▀░▀▀▀░░░▀▀▀░▀▀▀░▀▀▀░▀░▀░▀░▀ ${RESET}"
# Tabel Password Windows
cat << EOF
                      Menu RDP Instaler
                     |—————————————————|
|-------------------------------------------------------------|
|       Windows Version      |       Windows Version          |
|-------------------------------------------------------------|
|   1) Windows Server 2022   |   6) Windows 10 XLite          |
|   2) Windows Server 2019   |   7) Windows 10 NeonLite       |
|   3) Windows Server 2016   |   8) Windows 11 xLite Micro    |
|   4) Windows 11 Xlite no pw|   9) Windows 11 Ghost Spectre  |
|   5) Windows 10 Pro        |   10) Windows 11 24H2 xLite    |
|-------------------------------------------------------------|

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
    4) USER="Admin"; GETOS="$location=win11xLitenoPW$files" ;;
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

echo "Membuat Username dan Password:"
read -p "Masukkan password: " password

# Cek Koneksi Internet
echo "Memeriksa koneksi internet..."
ping -c 4 8.8.8.8 &> /dev/null
if [ $? -ne 0 ]; then
  echo "Koneksi internet tidak tersedia. Pastikan perangkat terhubung ke jaringan."
  exit 1
else
  echo "Koneksi internet tersedia."
fi

# Mendapatkan IP Publik dan Gateway
IP4=$(curl -4 -s icanhazip.com)
GW=$(ip route | awk '/default/ { print $3 }')

cat >/tmp/net.bat<<EOF
@ECHO OFF
cd.>%windir%\GetAdmin
if exist %windir%\GetAdmin (del /f /q "%windir%\GetAdmin") else (
echo CreateObject^("Shell.Application"^).ShellExecute "%~s0", "%*", "", "runas", 1 >> "%temp%\Admin.vbs"
"%temp%\Admin.vbs"
del /f /q "%temp%\Admin.vbs"
exit /b 2)
net user Admin $password

netsh interface ip set address "Ethernet Instance 0 2" source=static address=$IP4 mask=255.255.240.0 gateway=$GW
netsh interface ip add dns "Ethernet Instance 0 2" addr=1.1.1.1 index=1 validate=no
netsh interface ip add dns "Ethernet Instance 0 2" addr=8.8.8.8 index=2 validate=no


cd /d "%ProgramData%/Microsoft/Windows/Start Menu/Programs/Startup"
del /f /q net.bat
exit
EOF

cat >/tmp/dpart.bat<<EOF
@ECHO OFF
cd.>%windir%\GetAdmin
if exist %windir%\GetAdmin (del /f /q "%windir%\GetAdmin") else (
echo CreateObject^("Shell.Application"^).ShellExecute "%~s0", "%*", "", "runas", 1 >> "%temp%\Admin.vbs"
"%temp%\Admin.vbs"
del /f /q "%temp%\Admin.vbs"
exit /b 2)

ECHO SELECT VOLUME=%%SystemDrive%% > "%SystemDrive%\diskpart.extend"
ECHO EXTEND >> "%SystemDrive%\diskpart.extend"
START /WAIT DISKPART /S "%SystemDrive%\diskpart.extend"

del /f /q "%SystemDrive%\diskpart.extend"
cd /d "%ProgramData%/Microsoft/Windows/Start Menu/Programs/Startup"
del /f /q dpart.bat
timeout 50 >nul

:: Restart komputer
echo Restarting komputer...
shutdown /r /f /t 0
exit
EOF

clear
# Tampilkan password sebelum mengunduh
echo ""
echo -e "${RED}----------------------------------------------------${RESET}"
echo -e "${RED}🔑 Password untuk Windows yang dipilih:${RESET}"
echo -e "${RED}Username${RESET} : $USER"
echo -e "${RED}Password${RESET} : $password"
echo -e "${RED}----------------------------------------------------${RESET}"

# Konfirmasi unduhan
read -p "Apakah Anda ingin melanjutkan dengan unduhan dan instalasi? (y/n): " CONFIRM
if [[ "$CONFIRM" != "y" ]]; then
    echo "❌ Proses dibatalkan."
    exit 0
fi

# Download dan Instal OS dari URL
wget --no-check-certificate -O- $PILIHOS | gunzip | dd of=/dev/vda bs=3M status=progress

# Mount sistem file Windows
mkdir /mnt
mount.ntfs-3g /dev/vda2 /mnt
cd "/mnt/ProgramData/Microsoft/Windows/Start Menu/Programs/"
cd Start* || cd start*; \
cp -f /tmp/net.bat net.bat
cp -f /tmp/dpart.bat dpart.bat

# Footer
echo ""
echo "Terima kasih telah menggunakan script ini! 🙏"
echo "Support dan donasi: https://github.com/KangQull"
echo ""
echo "👉 Setelah selesai, matikan VPS dan kembali ke mode Hard Drive."
