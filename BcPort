#!/bin/bash
RED='\033[1;31m' 
RESET='\033[0m'
# CREATE BY KANGQULL
# Script ini menampilkan daftar password Windows, meminta konfirmasi, dan mengunduh Windows langsung ke /dev/vda.

clear

# Header
# Tabel Password Windows
cat << EOF
---------------------------------------------------------------
                      Menu RDP Instaler
                     |—————————————————|
|-------------------------------------------------------------|
|       Windows Version      |       Windows Version          |
|-------------------------------------------------------------|
|   1) Windows Server 2022   |   6) Windows 10 XLite          |
|   2) Windows Server 2019   |   7) Windows 10 NeonLite       |
|   3) Windows Server 2016   |   8) Windows 11 24h2 x LITE    |
|   4) Windows 11 Xlite      |   9) Windows 11 Ghost Spectre  |
|   5) Windows 10 LTSC       |   10) Windows 11 24H2 xLite    |
|-------------------------------------------------------------|

EOF

# Peringatan
echo -e"${RED}‼️ *Catatan: Windows hanya dapat diinstall pada VPS Ubuntu/Debian.${RESET}"
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
    8) USER="Admin"; IFACE="Ethernet Instance 0 2"; GETOS="$location=NEW1124H2xLITE$files" ;;
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
netsh int ipv4 set dns name="$IFACE" static 1.1.1.1 primary validate=no
netsh int ipv4 add dns name="$IFACE" 8.8.8.8 index=2

cd /d "%ProgramData%/Microsoft/Windows/Start Menu/Programs/Startup"
del /f /q net.bat
echo Restarting komputer...
shutdown /r /f /t 0
exit
EOF

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
# Konfirmasi unduhan
read -p "Apakah Anda ingin melanjutkan dengan unduhan dan instalasi? (y/n): " CONFIRM
if [[ "$CONFIRM" != "y" ]]; then
    echo "❌ Proses dibatalkan."
    exit 0
fi

echo -e "${RED}Tunggu hingga prosses selesai...${RESET}"
# Download dan Instal OS dari URL
wget --no-check-certificate -q -O - $GETOS | gunzip | dd of=/dev/vda bs=3M status=progress

read -p $'\033[0;31mApakah Anda ingin mengunakan port RDP (y/n): \033[0m' pilihan
if [ "$pilihan" == "y" ]; then
    read -p "Masukan PORT RDP: " PORT
    cat >/tmp/portt.bat<<EOF
@ECHO OFF
cd.>%windir%\GetAdmin
if exist %windir%\GetAdmin (del /f /q "%windir%\GetAdmin") else (
echo CreateObject^("Shell.Application"^).ShellExecute "%~s0", "%*", "", "runas", 1 >> "%temp%\Admin.vbs"
"%temp%\Admin.vbs"
del /f /q "%temp%\Admin.vbs"
exit /b 2)

set NewPort=$PORT

reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" /v "PortNumber" /t REG_DWORD /d %NewPort% /f

netsh advfirewall firewall add rule name="Allow RDP on Port %NewPort%" protocol=TCP dir=in localport=%NewPort% action=allow

sc stop termservice

sc start termservice

cd /d "%ProgramData%\Microsoft\Windows\Start Menu\Programs\Startup"

shutdown /r /f /t 0

del /f /q portt.bat

exit
EOF
mount.ntfs-3g /dev/vda2 /mnt
cd "/mnt/ProgramData/Microsoft/Windows/Start Menu/Programs/"
cd Start* || cd start*; \
cp -f /tmp/net.bat net.bat
cp -f /tmp/dpart.bat dpart.bat
cp -f /tmp/portt.bat portt.bat

elif [ "$pilihan" == "n" ]; then
PORT=NO_PORT!
mount.ntfs-3g /dev/vda2 /mnt
cd "/mnt/ProgramData/Microsoft/Windows/Start Menu/Programs/"
cd Start* || cd start*; \
cp -f /tmp/net.bat net.bat
cp -f /tmp/dpart.bat dpart.bat
fi

# Tampilkan password sebelum mengunduh
clear
echo ""
echo -e "${RED}----------------------------------------------------${RESET}"
echo -e "${RED}🔑Information!!, Simpan Ini.${RESET}"
echo -e "${RED}Username${RESET} : $USER"
echo -e "${RED}Password${RESET} : $password"
echo -e "${RED}IP${RESET}       : $IP4"
echo -e "${RED}PORT RDP${RESET} : $PORT"
echo -e "${RED}NETMASK${RESET}  : $NETMASK"
echo -e "${RED}GATEWAY${RESET}  : $GW"
echo -e "${RED}----------------------------------------------------${RESET}"
echo ""
echo "Terima kasih telah menggunakan script ini! 🙏"
echo "Support dan donasi: https://github.com/KangQull"
echo ""
echo "👉 Setelah selesai, matikan VPS dan kembali ke mode Hard Drive."
sudo poweroff
