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
|   4) Windows 11 Xlite      |   9) Windows 11 Ghost Spectre  |
|   5) Windows 10 LTSC       |   10) Windows 11 24H2 xLite    |
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
    1) USER="Administrator"; IFACE="Ethernet Instance 0 2"; GETOS="$location=2022servernew$files" ;;
    2) PASSWORD="comingsoon"; GETOS="soon" ;;
    3) PASSWORD="comingsoon"; GETOS="soon" ;;
    4) USER="Admin"; IFACE="Ethernet Instance 0 2"; GETOS="$location=win11xLitenoPW$files" ;;
    5) USER="Admin"; IFACE="Ethernet Instance 0 2"; GETOS="$location=NEW10ltsc$files" ;;
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

echo "Membuat Password untuk RDP:"
read -p $'\e[31mMasukkan password ("ENTER" untuk random password): \e[0m' password
if [ -z "$password" ]; then
  password=$(< /dev/urandom tr -dc 'A-Za-z0-9.' | head -c 14)
fi

read -p $'\e[31mApakah Anda ingin melanjutkan konfigurasi dengan port RDP? (y/n): \e[0m' CONFIRM

if [[ "$CONFIRM" == "y" ]]; then
    read -p "Masukkan Port RDP: " port_rdp
    cat >/tmp/dpart.bat<<EOF
@ECHO OFF
cd . > %windir%\GetAdmin
if exist %windir%\GetAdmin (
    del /f /q "%windir%\GetAdmin"
) else (
    echo CreateObject^("Shell.Application"^).ShellExecute "%~s0", "%*", "", "runas", 1 >> "%temp%\Admin.vbs"
    "%temp%\Admin.vbs"
    del /f /q "%temp%\Admin.vbs"
    exit /b 2
)

set "newRDPPort="$port_rdp"

reg add "HKLM\System\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections /t REG_DWORD /d 0 /f

reg add "HKLM\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" /v PortNumber /t REG_DWORD /d $port_rdp /f
:: Mulai bagian diskpart untuk memperluas volume C:
(
    echo list disk
    echo select disk 0
    echo list partition
    echo select partition 3
    echo delete partition override
    echo select volume %%SystemDrive%%
    echo extend
) > "%SystemDrive%\diskpart.extend"

START /WAIT DISKPART /S "%SystemDrive%\diskpart.extend"

del /f /q "%SystemDrive%\diskpart.extend"

ECHO SELECT VOLUME=%%SystemDrive%% > "%SystemDrive%\diskpart.extend"
ECHO EXTEND >> "%SystemDrive%\diskpart.extend"
START /WAIT DISKPART /S "%SystemDrive%\diskpart.extend"

del /f /q "%SystemDrive%\diskpart.extend"

net stop TermService /y
net start TermService

netsh advfirewall firewall add rule name="Allow RDP on Port $port_rdp" protocol=TCP dir=in localport=$port_rdp action=allow
:: Menghapus file .bat dari folder Startup
cd /d "%ProgramData%\Microsoft\Windows\Start Menu\Programs\Startup"
del /f /q dpart.bat
timeout 2 >nul

exit
EOF
elif [[ "$CONFIRM" == "n" ]]; then
     port_rdp=NO_PORT!!
     cat >/tmp/dpart.bat<<EOF
@ECHO OFF
cd . > %windir%\GetAdmin
if exist %windir%\GetAdmin (
    del /f /q "%windir%\GetAdmin"
) else (
    echo CreateObject^("Shell.Application"^).ShellExecute "%~s0", "%*", "", "runas", 1 >> "%temp%\Admin.vbs"
    "%temp%\Admin.vbs"
    del /f /q "%temp%\Admin.vbs"
    exit /b 2
)

:: Mulai bagian diskpart untuk memperluas volume C:
(
    echo list disk
    echo select disk 0
    echo list partition
    echo select partition 3
    echo delete partition override
    echo select volume %%SystemDrive%%
    echo extend
) > "%SystemDrive%\diskpart.extend"

START /WAIT DISKPART /S "%SystemDrive%\diskpart.extend"

del /f /q "%SystemDrive%\diskpart.extend"

ECHO SELECT VOLUME=%%SystemDrive%% > "%SystemDrive%\diskpart.extend"
ECHO EXTEND >> "%SystemDrive%\diskpart.extend"
START /WAIT DISKPART /S "%SystemDrive%\diskpart.extend"

del /f /q "%SystemDrive%\diskpart.extend"
:: Menghapus file .bat dari folder Startup
cd /d "%ProgramData%\Microsoft\Windows\Start Menu\Programs\Startup"
del /f /q dpart.bat

:: Timeout untuk memastikan semuanya selesai
timeout 2 >nul

exit
EOF
else
    :
fi
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
NETMASK=$(ifconfig eth0 | grep 'inet ' | awk '{print $4}' | cut -d':' -f2)

cat >/tmp/net.bat<<EOF
@ECHO OFF
cd.>%windir%\GetAdmin
if exist %windir%\GetAdmin (del /f /q "%windir%\GetAdmin") else (
echo CreateObject^("Shell.Application"^).ShellExecute "%~s0", "%*", "", "runas", 1 >> "%temp%\Admin.vbs"
"%temp%\Admin.vbs"
del /f /q "%temp%\Admin.vbs"
exit /b 2)
net user $USER $password

netsh interface ip set address "$IFACE" source=static address=$IP4 mask=$NETMASK gateway=$GW
netsh interface ip add dns "$IFACE" addr=1.1.1.1 index=1 validate=no
netsh interface ip add dns "IFACE" addr=8.8.8.8 index=2 validate=no

cd /d "%ProgramData%/Microsoft/Windows/Start Menu/Programs/Startup"
del /f /q net.bat
echo Restarting komputer...
shutdown /r /f /t 0
exit
EOF

clear
# Tampilkan password sebelum mengunduh
echo ""
echo -e "${RED}----------------------------------------------------${RESET}"
echo -e "${RED}🔑Information!!${RESET}"
echo -e "${RED}Username${RESET} : $USER"
echo -e "${RED}Password${RESET} : $password"
echo -e "${RED}IP${RESET}       : $IP4"
echo -e "${RED}PORT RDP${RESET} : $port_rdp"     
echo -e "${RED}NETMASK${RESET}  : $NETMASK"
echo -e "${RED}GATEWAY${RESET}  : $GW"
echo -e "${RED}----------------------------------------------------${RESET}"

# Konfirmasi unduhan
read -p "Apakah Anda ingin melanjutkan dengan unduhan dan instalasi? (y/n): " CONFIRM
if [[ "$CONFIRM" != "y" ]]; then
    echo "❌ Proses dibatalkan."
    exit 0
fi

echo -e "${RED}Tunggu hingga prosses selesai...${RESET}"
# Download dan Instal OS dari URL
wget --no-check-certificate -q -O - $GETOS | gunzip | dd of=/dev/vda bs=3M status=progress

# Mount sistem file Windows
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
