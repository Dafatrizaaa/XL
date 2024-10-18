#!/bin/bash
#
#CREATE BY KANGQULL
#
echo "##################################################"
echo "#<<<<<<<<< List Pasword Windows>>>>>>>>>>>>>>    #"
echo "#-Windows 10&11 login dengan username: Admin     #"
echo "#-Windows Server login dengan: Administrator     #"
echo "#------------------⇩⇩⇩⇩⇩--------------------------#"
echo "#|*Windows 2022 : pw: comingsoon          |      #"
echo "#|*Windows 2019 : pw: comingsoon          |      #"
echo "#|*Windows 2016 : pw: comingsoon          |      #"
echo "#|*Windows 2012 : pw: comingsoon          |      #"
echo "#|*Windows 10   : pw: windowsme           |      #"
echo "#|*Windows 11 xLite M : pw: windowsme     |      #"
echo "#------------------------------------------------#"
echo "#!!WINDOWS CUMA BISA DI VPS UBUNTU DAN DEBIAN!!  #"
echo "#----------------------------------------------  #"
echo "#Install Windows yang tersedia dibawah ini:      #"
echo "##################################################"
echo "#|1) Windows 2022 (belum tersedia)       |       #"
echo "#|2) Windows 2019 (belum tersedia)       |       #"
echo "#|3) Windows 2016 (belum tersedia)       |       #"
echo "#|4) Windows 2012 (belum tersedia)       |       #"
echo "#|5) Windows 10 Pro (tersedia)           |       #"
echo "#|6) Windows 11 x Lite Micro (tersedia)  |       #"
echo "##################################################"

ALAMAT=https://bit.ly

read -p "Pilih Windows sesuai nomor: " GETOS

case "$GETOS" in
	1|"") GETOS="soon"
        ;;
	2|"") GETOS="soon"
        ;;
	3) GETOS="soon"
        ;;
	4) GETOS="soon"
        ;;
	5) GETOS="$ALAMAT/3Y9W8zI"
        ;;
	6) GETOS="$ALAMAT/4eKLtCs"
        ;;
	*) echo "pilihan salah"; exit;;
esac

wget --no-check-certificate -O- $GETOS | gunzip | dd of=/dev/vda bs=3M status=progress

echo 'Trimakasih telah menggunakan script by KangQull -'
echo ''
echo 'Support di https://github.com/KangQull -'
echo ''
echo ''
echo 'Server kamu akan off dalam waktu 15 detik....'
sleep 15
poweroff
