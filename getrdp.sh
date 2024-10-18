#!/bin/bash
#
#CREATE BY KANGQULL
#
echo "List Pasword Windows"
echo "-----------------------------"
echo "*Windows 10 password : windowsme"
echo "-----------------------------"
echo "!WINDOWS CUMA BISA DI VPS UBUNTU DAN DEBIAN!"
echo "Install Windows yang tersedia dibawah ini:"
echo "#########################################"
echo "|1) Windows 2019 (belum tersedia)       |"
echo "|2) Windows 2016 (belum tersedia)       |"
echo "|3) Windows 2012 (belum tersedia)       |"
echo "|4) Windows 10 Pro (tersedia)           |"
echo "|5) Windows 11 x Lite Micro             |"
echo "#########################################"

read -p "Pilih [1]: " GETOS

case "$GETOS" in
	1|"") GETOS="soon"
        ;;
	2) GETOS="soon"
        ;;
	3) GETOS="soon"
        ;;
	4) GETOS="https://onboardcloud.dl.sourceforge.net/project/vlitee/windows10lite.gz"
        ;;
	5) GETOS="soon"
        ;;
	*) echo "pilihan salah"; exit;;
esac

wget --no-check-certificate -O- $GETOS | gunzip | dd of=/dev/vda bs=3M status=progress

echo 'Trimakasih telah menggunakan script by KangQull -'
echo 'Support di https://github.com/KangQull -'
echo 'Server kamu akan off dalam waktu 15 detik....'
sleep 15
poweroff
