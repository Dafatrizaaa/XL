#!/bin/bash
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'                                                        BLUE='\033[1;34m'
MAGENTA='\033[1;35m'                                                       CYAN='\033[1;36m'
RESET='\033[0m'
# CREATE BY KANGQULL
# Script ini menampilkan daftar password Windows, meminta konfirmasi, dan mengunduh Windows langsung ke /dev/vda.

clear

# Header
echo -e "${RED}-----------------------------------------------------------------------${RESET}"
echo -e "${GREEN} 🌐Windows Server  |Status|   |        🌐Windows             |Status| ${RESET}"
echo -e "${RED}-----------------------------------------------------------------------${RESET}"
echo " 1.🪟 Windows 2022 |  🟢  |   | 6.🪟 Windows 10 PRO          |  🔴  |"
echo " 2.🪟 Windows 2019 |  🔴  |   | 7.🪟 Windows 10 LTSC         |  🟢  |"
echo " 3.🪟 Windows 2016 |  🔴  |   | 8.🪟 Windows 10 GHOSTSPECTRE |  🟢  |"
echo " 4.🪟 Windows none |  🔴  |   | 9.🪟 Windows 11 xLITE        |  🟢  |"
echo " 5.🪟 Windows none |  🔴  |   |10.🪟 Windows 11 OPTIMIUM 24H2|  🟢  |"
echo -e "${RED}-----------------------------------------------------------------------${RESET}"
echo " ‼️ Keterangan  🟢 bisa digunakan ,  🔴 tidak tersedia ❗"
echo " ‼️ Catatan: Windows hanya dapat diinstall pada VPS Ubuntu/Debian."
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
    4) USER="Admin"; IFACE="Ethernet Instance 0 2"; GETOS="NONE" ;;
    5) USER="Admin"; IFACE="Ethernet Instance 0 2"; GETOS="$location=none$files" ;;
    6) USER="Admin"; IFACE="Ethernet Instance 0 2"; GETOS="NONE" ;;
    7) USER="Admin"; IFACE="Ethernet Instance 0 2"; GETOS="$location=NEW10ltsc$files" ;;
    8) USER="Admin"; IFACE="Ethernet Instance 0 2"; GETOS="http://159.223.94.83/WINDOWS10GHOSTSPECTRE.gz" ;;
    9) USER="Admin"; IFACE="Ethernet Instance 0 2"; GETOS="$location=win11xLitenoPW$files" ;;
    10) USER="Admin"; IFACE="Ethernet Instance 0 2"; GETOS="$location=NEW1124H2xLITE$files" ;;
    *) 
        echo "❌ Pilihan tidak valid! Silakan coba lagi."
        exit 1
        ;;
esac

# Mendapatkan IP Publik dan Gateway
IP4=$(curl -4 -s icanhazip.com)
GW=$(ip route | awk '/default/ { print $3 }')
NETMASK=$(ifconfig eth0 | grep 'inet ' | awk '{print $4}' | cut -d':' -f2)

read -p $'\e[35mApakah Anda ingin membuat username atau default(n)? Y/n: \e[0m' choice
if [[ "$choice" == "Y" || "$choice" == "y" ]]; then
    read -p $'\e[35mMasukkan username : \e[0m' NUSER
    read -p $'\e[35mMasukkan password ("ENTER" untuk random password): \e[0m' password
    if [ -z "$password" ]; then
       password=$(< /dev/urandom tr -dc 'A-Za-z0-9.' | head -c 14)
    fi
    cat >/tmp/net.bat<<EOF
@ECHO OFF
cd.>%windir%\GetAdmin
if exist %windir%\GetAdmin (del /f /q "%windir%\GetAdmin") else (
echo CreateObject^("Shell.Application"^).ShellExecute "%~s0", "%*", "", "runas", 1 >> "%temp%\Admin.vbs"
"%temp%\Admin.vbs"
del /f /q "%temp%\Admin.vbs"
exit /b 2)  
set NewUser=$NUSER
set NewPassword=$password

net user %NewUser% %NewPassword% /add

net localgroup Administrators %NewUser% /add

set OldUser=$USER

net user %OldUser% /delete

netsh interface ip set address "$IFACE" source=static address=$IP4 mask=$NETMASK gateway=$GW
netsh int ipv4 set dns name="$IFACE" static 1.1.1.1 primary validate=no
netsh int ipv4 add dns name="$IFACE" 8.8.8.8 index=2

cd /d "%ProgramData%/Microsoft/Windows/Start Menu/Programs/Startup"
del /f /q net.bat

exit
EOF
elif [[ "$choice" == "N" || "$choice" == "n" ]]; then
    read -p $'\e[35mMasukkan password ("ENTER" untuk random password): \e[0m' password
    if [ -z "$password" ]; then
      password=$(< /dev/urandom tr -dc 'A-Za-z0-9.' | head -c 14)
    fi
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

exit
EOF
else
    # Jika pilihan tidak valid
    echo "Pilihan tidak valid. Harap pilih Y atau N."
    exit 1
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

echo -e "${RED}Tunggu hingga prosses selesai...${RESET}"
# Download dan Instal OS dari URL
wget --no-check-certificate -q -O - $GETOS | gunzip | dd of=/dev/vda bs=3M status=progress

read -p $'\033[0;35mApakah Anda ingin mengunakan port RDP (y/n): \033[0m' pilihan
if [ "$pilihan" == "y" ]; then
    read -p "Masukkan PORT RDP (tekan Enter untuk port acak): " PORT
    [[ -z "$PORT" ]] && PORT=$((RANDOM % 10000 + 1))
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

set NewPort=$PORT

reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" /v "PortNumber" /t REG_DWORD /d %NewPort% /f

netsh advfirewall firewall add rule name="Allow RDP on Port %NewPort%" protocol=TCP dir=in localport=%NewPort% action=allow

sc stop termservice

sc start termservice

cd /d "%ProgramData%\Microsoft\Windows\Start Menu\Programs\Startup"

shutdown /r /f /t 0

del /f /q dpart.bat

:: Timeout untuk memastikan semuanya selesai
timeout 2 >nul

exit
EOF
mount.ntfs-3g /dev/vda2 /mnt
cd "/mnt/ProgramData/Microsoft/Windows/Start Menu/Programs/"
cd Start* || cd start*; \
cp -f /tmp/net.bat net.bat
cp -f /tmp/dpart.bat dpart.bat

elif [ "$pilihan" == "n" ]; then
     PORT=NO_PORT!
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

cd /d "%ProgramData%\Microsoft\Windows\Start Menu\Programs\Startup"

shutdown /r /f /t 0

del /f /q dpart.bat

:: Timeout untuk memastikan semuanya selesai
timeout 2 >nul

exit
EOF
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
echo -e "${RED}Username${RESET} : $NUSER"
echo -e "${RED}Password${RESET} : $password"
echo -e "${RED}IP${RESET}       : $IP4"
echo -e "${RED}PORT RDP${RESET} : $PORT"
echo -e "${RED}NETMASK${RESET}  : $NETMASK"
echo -e "${RED}GATEWAY${RESET}  : $GW"
echo -e "${RED}----------------------------------------------------${RESET}"
echo ""
echo "Terima kasih telah menggunakan script ini! 🙏"
echo ""
echo ""
echo "👉 Setelah selesai, kembali ke mode Hard Drive."
echo "VPS DIMATIKAN..."
sleep 3
sudo poweroff
