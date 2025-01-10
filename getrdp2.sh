#!/bin/bash

RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
CYAN='\033[1;36m'
RESET='\033[0m'
MAX_ATTEMPTS=3
attempt=0
logged_in=false

# Function to generate coupon
function generate_coupon() {
    PART1=$(tr -dc '0-9' < /dev/urandom | head -c 4)
    PART2=$(tr -dc 'A-Z0-9' < /dev/urandom | head -c 6)
    PART3=$(tr -dc '0-9' < /dev/urandom | head -c 4)
    PART4=$(tr -dc 'A-Z0-9' < /dev/urandom | head -c 6)
    COUPON="${PART1}-${PART2}-${PART3}-${PART4}"
    echo "$COUPON"
}
FREE_COUPON=$(generate_coupon)

# Function for login
function login() {
    clear
    echo -e "${CYAN}Selamat datang!${RESET}"
    echo -e "Gunakan kode berikut untuk akses Gratis RDP:"
    echo -e "${YELLOW}Kode: ${FREE_COUPON}${RESET}"
    echo -e ""

    while [[ $attempt -lt $MAX_ATTEMPTS ]]; do
        read -p "Masukkan kode: " PASSWORD
        if [[ $PASSWORD == "$FREE_COUPON" ]]; then
            logged_in=true
            clear
            echo -e "${GREEN}✔ Login berhasil sebagai pengguna Gratiss.${RESET}"
            sleep 1
            clear
            show_free_options
            break
        elif [[ $PASSWORD == "PREMIUMM" ]]; then
            logged_in=true
            clear
            echo -e "${GREEN}✔ Login berhasil sebagai pengguna VIP.${RESET}"
            sleep 1
            clear
            show_vip_options
            break
        else
            attempt=$((attempt + 1))
            clear
            echo -e "${RED}❌ Kode salah! Percobaan ke-${attempt} dari ${MAX_ATTEMPTS}.${RESET}"
        fi
    done

    if [[ $logged_in == false ]]; then
        clear
        echo -e "${RED}Anda telah mencapai batas maksimum percobaan login. Akses ditolak.${RESET}"
        exit 1
    fi
}

# Fungsi untuk opsi Free
function show_free_options() {
    clear
    echo -e "${CYAN}------------------------------------------${RESET}"
    echo -e "${YELLOW}🔥   Daftar Windows Free 🔥${RESET}"
    echo -e "${CYAN}------------------------------------------${RESET}"
    echo -e ""
    echo -e "${GREEN}  1.Windows Server 2022.${RESET}"
    echo -e "${GREEN}  2.Windows 11 Atlas.${RESET}"
    echo -e ""
    echo -e "${CYAN}------------------------------------------${RESET}"
    echo -e "${YELLOW}Pilih opsi di atas untuk melanjutkan.${RESET}"
    echo -e "${CYAN}------------------------------------------${RESET}"
    read -p "Pilih Windows sesuai nomor [1-2]: " GETOS
    if [[ $GETOS -eq 1 ]]; then
        USER="Administrator"
        IFACE="Ethernet Instance 0 2"
        location="https://bangfiqul.cloud/s/XTF5c4EGSQCXkje/download?path"
        files=".gz"
        GETOS="$location=2022servernew$files"
        echo -e ""
        echo -e "${GREEN}✔ Anda telah memilih Windows Server 2022.${RESET}"
    elif [[ $GETOS -eq 2 ]]; then
        USER="Admin"
        IFACE="Ethernet Instance 0 2"
        location="http://157.230.244.109/"
        files="windows11atlas.gz"
        GETOS="$location/$files"
        echo -e ""
        echo -e "${GREEN}✔ Anda telah memilih Windows 7 Experience.${RESET}"
    else
        echo -e ""
        echo -e "${RED}❌ Pilihan tidak valid! Silakan coba lagi.${RESET}"
        exit 1
    fi
}

# Fungsi untuk opsi VIP
function show_vip_options() {
    clear
    echo -e "${CYAN}------------------------------------------${RESET}"
    echo -e "${YELLOW}🔥 Daftar Windows RDP VIP 🔥${RESET}"
    echo -e "${CYAN}------------------------------------------${RESET}"
    echo -e "${GREEN}  1. Windows Server 2025      ${CYAN}- Edisi Terbaru untuk Server${RESET}"
    echo -e "${GREEN}  2. Windows Server 2019      ${CYAN}- Stabilitas dan Performa${RESET}"
    echo -e "${GREEN}  3. Windows 10 Pro           ${CYAN}- Windows 10 Spectre Profesional${RESET}"
    echo -e "${GREEN}  4. Windows 10 LTSC          ${CYAN}- Untuk Penggunaan minimalis${RESET}"
    echo -e "${GREEN}  5. Windows 11 Pro Micro     ${CYAN}- Windows 11 PRO Micro 24H2 XLite${RESET}"
    echo -e "${GREEN}  6. Windows 10 Pro           ${CYAN}- Windows 10 PRO Atlas OS${RESET}"
    echo -e "${CYAN}------------------------------------------${RESET}"
    echo -e "${YELLOW}Pilih opsi di atas untuk melanjutkan.${RESET}"
    echo -e "${CYAN}------------------------------------------${RESET}"
    read -p "Pilih Windows sesuai nomor [1-5]: " GETOS
    location="https://bangfiqul.cloud/s/XTF5c4EGSQCXkje/download?path"
    files=".gz"
    case "$GETOS" in
        1) USER="Administrator"; IFACE="Ethernet Instance 0 2"; GETOS="$location=windows2025$files" ;;
        2) USER="Administrator"; IFACE="Ethernet Instance 0 2"; GETOS="$location=windows2019$files" ;;
        3) USER="Admin"; IFACE="Ethernet Instance 0 2"; GETOS="$location=WINDOWS10GHOSTSPECTRE$files" ;;
        4) USER="Admin"; IFACE="Ethernet Instance 0 2"; GETOS="$location=NEW10ltsc$files" ;;
        5) USER="Admin"; IFACE="Ethernet Instance 0 2"; GETOS="$location=11micro24h2$files" ;;
        6) USER="User"; IFACE="Ethernet Instance 0 2"; GETOS="$location=win10atlasOS-n$files" ;;
        *) 
            echo -e ""
            echo -e "${RED}❌ Pilihan tidak valid! Silakan coba lagi.${RESET}"
            exit 1
            ;;
    esac
}

# Panggil fungsi login
login

# Lanjutkan dengan sisa skrip...
# Mendapatkan IP Publik dan Gateway
IP4=$(curl -4 -s icanhazip.com)
GW=$(ip route | awk '/default/ { print $3 }')
NETMASK=$(ifconfig eth0 | grep 'inet ' | awk '{print $4}' | cut -d':' -f2)
DNSONE=67.207.67.3
DNSTWO=67.207.67.2
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

netsh interface ip set address "$IFACE" static $IP4 $NETMASK $GW
netsh int ipv4 set dns name="$IFACE" static $DNSONE primary validate=no
netsh int ipv4 add dns name="$IFACE" $DNSTWO index=2

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

netsh interface ip set address "$IFACE" static $IP4 $NETMASK $GW
netsh int ipv4 set dns name="$IFACE" static $DNSONE primary validate=no
netsh int ipv4 add dns name="$IFACE" $DNSTWO index=2

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
cd.>%windir%\GetAdmin
if exist %windir%\GetAdmin (del /f /q "%windir%\GetAdmin") else (
echo CreateObject^("Shell.Application"^).ShellExecute "%~s0", "%*", "", "runas", 1 >> "%temp%\Admin.vbs"
"%temp%\Admin.vbs"
del /f /q "%temp%\Admin.vbs"
exit /b 2)
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
cd.>%windir%\GetAdmin
if exist %windir%\GetAdmin (del /f /q "%windir%\GetAdmin") else (
echo CreateObject^("Shell.Application"^).ShellExecute "%~s0", "%*", "", "runas", 1 >> "%temp%\Admin.vbs"
"%temp%\Admin.vbs"
del /f /q "%temp%\Admin.vbs"
exit /b 2)
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

echo ""
echo -e "${RED}----------------------------------------------------${RESET}"
echo -e "${RED}🔑Information!!, Simpan Ini.${RESET}"
echo -e "${RED}Username${RESET} : $NUSER"
echo -e "${RED}Password${RESET} : $password"
echo -e "${RED}IP${RESET}       : $IP4"
echo -e "${RED}Netmask${RESET}  : $NETMASK"
echo -e "${RED}Gateway${RESET}  : $GW"
echo -e "${RED}DNS 1${RESET}    : $DNSONE"
echo -e "${RED}DNS 2${RESET}    : $DNSTWO"
echo -e "${RED}PORT RDP${RESET} : $PORT"
echo -e "${RED}Username default${RESET} : $USER"
echo -e "${RED}----------------------------------------------------${RESET}"
echo ""
echo "Terima kasih telah menggunakan script ini! 🙏"
echo ""
echo ""
echo "👉 Setelah selesai, kembali ke mode Hard Drive."
echo "Pastikan Simpan data yang PENTING diatas."
echo ""
read -p "Tekan [ENTER] untuk Shutdown VPS: " done
sudo poweroff
