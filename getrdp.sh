#!/bin/bash
#
#CREATE BY KANGQULL
#
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
echo "#|6) Windows 10 XLite (tersedia)        |       #"
echo "#|7) Windows 11 x Lite Micro (tersedia)  |       #"
echo "#|8) Windows 11 Ghost Spectre (tersedia) |       #"
echo "##################################################"

linked=onboardcloud.dl.sourceforge.net
your=project
projek=vlitee
windows2022=win2022.gz
windows10pro=windows10lite.gz
windows10xlite=win10XLite.gz
windows11xlite=win11xLiteMicro.gz
windows11ghostspectre=win11Ghostspectre.gz

read -p "Pilih Windows sesuai nomor: " GETOS

case "$GETOS" in
	1|"") GETOS="https://$linked/$your/$projek/$windows2022"
        ;;
	2) GETOS="soon"
        ;;
	3) GETOS="soon"
        ;;
	4) GETOS="soon"
        ;;
	5) GETOS="https://$linked/$your/$projek/$windows10pro"
        ;;
	6) GETOS="https://$linked/$your/$projek/$windows10xlite"
        ;;
	7) GETOS="https://$linked/$your/$projek/$windows11xlite"
        ;;
	8) GETOS="https://$linked/$your/$projek/$windows11ghostspectre"
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
