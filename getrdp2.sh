#!/bin/bash

# CREATE BY KANGQULL
# Script ini menampilkan daftar password Windows, meminta konfirmasi, dan mengunduh Windows langsung ke /dev/vda.

clear

# Header
echo "##################################################"
echo "#                                                #"
echo "#          🎉 Daftar Password Windows 🎉         #"
echo "#                                                #"
echo "##################################################"

# Tabel Password Windows
cat << EOF
----------------------------------------------------
| Windows Version       | Username         | Password |
----------------------------------------------------
| 1) Windows Server 2022   | Administrator    | windowsNetwork |
| 2) Windows Server 2019   | Administrator    | comingsoon     |
| 3) Windows Server 2016   | Administrator    | comingsoon     |
| 4) Windows Server 2012   | Administrator    | comingsoon     |
| 5) Windows 10 Pro         | Admin            | windowsme      |
| 6) Windows 10 XLite       | Admin            | windowsme      |
| 7) Windows 10 NeonLite    | Admin            | windowsme      |
| 8) Windows 11 xLite Micro | Admin            | windowsme      |
| 9) Windows 11 Ghost Spectre | Admin         | windowsme      |
| 10) Windows 11 24H2 xLite | Admin           | windowsme      |
----------------------------------------------------

EOF

# Peringatan
echo "‼️ *Catatan: Windows hanya dapat diinstall pada VPS Ubuntu/Debian."
echo ""

# Menu Install Windows
echo "##################################################"
echo "# Pilih Windows untuk diunduh dan diinstal       #"
echo "##################################################"

# Lokasi file dan ekstensi
location="https://cloudshydro.tech/s/gABn6KJM9bzbKWf/download?path"
files=".gz"

# Pilihan pengguna
read -p "Pilih Windows sesuai nomor (1-10): " GETOS

# Tentukan password dan file berdasarkan input
case "$GETOS" in
    1) PASSWORD="windowsNetwork"; GETOS="$location=win2022$files" ;;
    2) PASSWORD="comingsoon"; GETOS="soon" ;;
    3) PASSWORD="comingsoon"; GETOS="soon" ;;
    4) PASSWORD="comingsoon"; GETOS="soon" ;;
    5) PASSWORD="windowsme"; GETOS="$location=windows10lite$files" ;;
    6) PASSWORD="windowsme"; GETOS="$location=win10XLite$files" ;;
    7) PASSWORD="windowsme"; GETOS="$location=win10neonLite$files" ;;
    8) PASSWORD="windowsme"; GETOS="$location=win11xLiteMicro$files" ;;
    9) PASSWORD="windowsme"; GETOS="$location=win11Ghostspectre$files" ;;
    10) PASSWORD="windowsme"; GETOS="$location=win1124H2xLite$files" ;;
    *) 
        echo "❌ Pilihan tidak valid! Silakan coba lagi."
        exit 1
        ;;
esac

# Tampilkan password sebelum mengunduh
echo ""
echo "----------------------------------------------------"
echo "🔑 Password untuk Windows yang dipilih:"
echo "Username : Admin/Administrator"
echo "Password : $PASSWORD"
echo "----------------------------------------------------"

# Konfirmasi unduhan
read -p "Apakah Anda ingin melanjutkan dengan unduhan dan instalasi? (y/n): " CONFIRM
if [[ "$CONFIRM" != "y" ]]; then
    echo "❌ Proses dibatalkan."
    exit 0
fi

# Proses unduhan dan instalasi
if [[ "$GETOS" == "soon" ]]; then
    echo "❌ Windows versi ini belum tersedia. Harap tunggu pembaruan."
else
    echo "🔄 Mengunduh dan menginstal langsung ke /dev/vda..."
    wget -qO- --no-check-certificate "$GETOS" | gunzip -c | dd of=/dev/vda bs=4M status=progress
    sync
    echo "✅ Instalasi selesai! Sistem Windows telah diinstal di /dev/vda."
fi

# Footer
echo ""
echo "Terima kasih telah menggunakan script ini! 🙏"
echo "Support dan donasi: https://github.com/KangQull"
echo ""
echo "👉 Setelah selesai, matikan VPS dan kembali ke mode Hard Drive."
