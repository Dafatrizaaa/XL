#!/bin/bash
#
#CREATE BY KANGQULL
#
sudo apt install aria2 -y
echo "##################################################"
echo "#            List Pasword Windows                #"
echo "#-Windows 10&11 login dengan username: Admin     #"
echo "#-Windows 10 ReviOS username : Virtual           #"
echo "#-Windows Server login dengan: Administrator     #"
echo "#-------------------⇩⇩⇩⇩⇩------------------------#"
echo "#|*Windows 2022 pw: windowsNetwork       |       #"
echo "#|*Windows 2019 pW: comingsoon           |       #"
echo "#|*Windows 2016 pW: comingsoon           |       #"
echo "#|*Windows 2012 pW: comingsoon           |       #"
echo "#|*Windows 10   pW: windowsme            |       #"
echo "#|*Windows 10 reviOS pW: windows.me      |       #"
echo "#|*Windows 11 xLite M pW: windowsme      |       #"
echo "#|*Windows 11 Ghost spectr pW: windowsme |       #"
echo "#------------------------------------------------#"
echo "#!!WINDOWS CUMA BISA DI VPS UBUNTU DAN DEBIAN!!  #"
echo "#----------------------------------------------  #"
echo "#Install Windows yang tersedia dibawah ini:      #"
echo "##################################################"
echo "#|1) Windows 2022 (tersedia)             |       #"
echo "#|2) Windows 2019 (belum tersedia)       |       #"
echo "#|3) Windows 2016 (belum tersedia)       |       #"
echo "#|4) Windows 2012 (belum tersedia)       |       #"
echo "#|5) Windows 10 Pro (tersedia)           |       #"
echo "#|6) Windows 10 XLite (tersedia)         |       #"
echo "#|7) Windows 10 NeonLite (tersedia)      |       #"
echo "#|8) Windows 11 x Lite Micro (tersedia)  |       #"
echo "#|9) Windows 11 Ghost Spectre (tersedia) |       #"
echo "#|10) Windows 11                         |       #"
echo "##################################################"

location=https://cloudshydro.tech/s/7f7JCBDBQzGffyq/download?path
files=.gz

read -p "Pilih Windows sesuai nomor: " GETOS

case "$GETOS" in
	1|"") GETOS="$location=win2022$files"
        ;;
	2) GETOS="soon"
        ;;
	3) GETOS="soon"
        ;;
	4) GETOS="soon"
        ;;
	5) GETOS="$location=windows10lite$files"
        ;;
	6) GETOS="$location=win10XLite$files"
        ;;
	7) GETOS="$location=win10neonLite$files"
        ;;
	8) GETOS="$location=win11xLiteMicro$files"
        ;;
	9) GETOS="$location=win11Ghostspectre$files"
        ;;
	10) GETOS="$location=soon$files"
        ;;
	*) echo "pilihan salah"; exit;;
esac

aria2c --no-check-certificate -o - "$GETOS" | gunzip -c | dd of=/dev/vda

echo 'Trimakasih telah menggunakan script by KangQull'
echo ''
echo ''
echo 'Support di https://github.com/KangQull -'
echo ''
echo ''
echo 'Matikan VPS kembali ke mode Hardrive'
