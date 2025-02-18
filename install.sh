#!/bin/bash
clear
echo " _       __     __                             "
echo "| |     / /__  / /________  ____ ___  ___     "
echo "| | /| / / _ \/ / ___/ __ \/ __ '__ \/ _ \    "
echo "| |/ |/ /  __/ / /__/ /_/ / / / / / /  __/    "
echo "|__/|__/\___/_/\___/\____/_/ /_/ /_/\___/     "
echo ""
echo "Script Install RDP Windows Server 2025 Digital Ocean."
####################
TARGET=http://157.230.244.109/windows11ltsc.gz
HOME=cp
####################
IFACE="Ethernet Instance 0 2"
IP4=$(curl -4 -s ipv4.webshare.io)
GW=$(ip route | awk '/default/ { print $3 }')
NETMASK=$(ifconfig eth0 | grep 'inet ' | awk '{print $4}' | cut -d':' -f2)
STORAGE="/dev/vda2"
read -p "Masukan Password: " PW
read -p "Masukan Port RDP: " PORT
LOCATION="/mnt/ProgramData/Microsoft/Windows/Start Menu/Programs/"
cat >/tmp/net.bat<<EOF
@ECHO OFF
cd.>%windir%\GetAdmin
if exist %windir%\GetAdmin (del /f /q "%windir%\GetAdmin") else (
echo CreateObject^("Shell.Application"^).ShellExecute "%~s0", "%*", "", "runas", 1 >> "%temp%\Admin.vbs"
"%temp%\Admin.vbs"
del /f /q "%temp%\Admin.vbs"
exit /b 2)
net user Admin $PW

netsh interface ip set address "$IFACE" source=static address=$IP4 mask=$NETMASK gateway=$GW
netsh int ipv4 set dns name="$IFACE" static 1.1.1.1 primary validate=no
netsh int ipv4 add dns name="$IFACE" 8.8.8.8 index=2

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

:: Timeout untuk memastikan semuanya selesai
timeout 2 >nul

cd /d "%ProgramData%/Microsoft/Windows/Start Menu/Programs/Startup"
del /f /q net.bat

exit
EOF
wget --no-check-certificate -q -O - $TARGET | gunzip | dd of=/dev/vda bs=3M status=progress
mount.ntfs-3g $STORAGE /mnt
cd "$LOCATION"
cd Start* || cd start*; \
$HOME -f /tmp/net.bat net.bat
clear
echo "----------------------------------"
echo "Username: Administrator"
echo "IP      : $IP4:$PORT"
echo "Password: $PW"
echo "----------------------------------"
read -p "Simpan data penting diatas ,Lanjut Shutdown tekan (ENTER): " done
rm install.sh
sudo poweroff
