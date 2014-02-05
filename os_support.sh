#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒Grub4Dos#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒

#pci_clonemaxx.iso pci_emaxx.iso
#e-maxx: http://www.pcinspector.de/EMaxx/info.htm?language=2
#clone-maxx: http://www.pcinspector.de/CloneMaxx/info.htm?language=2
if [ "$(echo "${option2}" | grep "pci_.*emaxx.iso")" ]; then
osname="$(basename "${option2}")"
osicone="multisystem-img"
FCT_DOS5
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_GRUB4DOS)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/menu.lst"

#iBoot
#http://www.sysprobs.com/iboot-loader-virtualbox-install-snow-leopard
#http://www.tonymacx86.com/viewforum.php?f=125
#http://www.tonymacx86.com/1010110101/iBoot-3.0.2.zip
elif [ "$(grep -i 'iBoot' /tmp/multisystem/multisystem-mountpoint-iso/i[Bb]oot*.txt 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osicone="multisystem-iboot"
osnamemodif="iBoot"
FCT_DOS5
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_GRUB4DOS)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/menu.lst"

#rBoot
elif [ "$(grep -i 'rBoot' /tmp/multisystem/multisystem-mountpoint-iso/r[Bb]oot*.txt 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osicone="multisystem-iboot"
osnamemodif="rBoot"
FCT_DOS5
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_GRUB4DOS)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/menu.lst"

#KillDisk
#http://www.killdisk.com/downloadfree.htm
#http://software.lsoft.net/boot-cd-iso.zip
elif [ "$(grep 'BOOT-DSK.ISO' /tmp/multisystem/multisystem-mountpoint-iso/!ReadMe.txt 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osicone="multisystem-windows"
osnamemodif="KillDisk"
FCT_DOS5
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_GRUB4DOS)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/menu.lst"

#ShadowProtect (WinPE)
#http://www.storagecraft.com/shadow_protect_desktop.php
elif [ -f "/tmp/multisystem/multisystem-mountpoint-iso/install_shadowprotect_desktop_edition.cmd" ]; then
osname="$(basename "${option2}")"
osicone="multisystem-pebuilder"
osnamemodif="ShadowProtect"
FCT_DOS6
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_GRUB4DOS)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/menu.lst"

#NT Password & Registry Editor
#http://pogostick.net/~pnh/ntpasswd/
#http://www.bellamyjc.org/fr/pwdnt.html
elif [ "$(grep 'Windows Change Password / Registry Editor / Boot CD' /tmp/multisystem/multisystem-mountpoint-iso/readme.txt 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osnamemodif="NT Password"
osicone="multisystem-ntpassword"
FCT_DOS2
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_GRUB4DOS)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/menu.lst"

#Hiren's BootCD 14/15
elif [ "$(grep "Hiren.*s BootCD" /tmp/multisystem/multisystem-mountpoint-iso/HBCD.txt 2>/dev/null)" ]; then
modiso="hiren"
if [ ! -d "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/HBCD" ]; then
osname="HBCD"
osicone="multisystem-hiren"
osnamemodif="UBCD4Win"
ligne1="title Hiren's BootCD\nfind --set-root /HBCD/menu.lst\nkernel /boot/grub.exe --config-file=/HBCD/menu.lst"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_GRUB4DOS)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/menu.lst"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/HBCD/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/HBCD"
sed -i "s@%pm%@/HBCD/Boot/pmagic.lst@g" "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/HBCD/Boot/pmagic.lst"
sed -i "s@%pm%@/HBCD/Boot/pmagic.lst@g" "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/HBCD/menu.lst"
else
zenity --error --text "$(eval_gettext "Erreur: LiveCD déjà présent.")"
fi

#FalconFour's Ultimate Boot CD
#http://thepiratebay.org/user/FalconFour/
#http://falconfour.wordpress.com/2011/03/12/falconfours-ultimate-boot-cdusb-4-5/
elif [ "$(grep -i '/F4UBCD/Images/ntldr.gz' /tmp/multisystem/multisystem-mountpoint-iso/menu.lst 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osicone="multisystem-ubcd"
FCT_DOS2
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_GRUB4DOS)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/menu.lst"

#Hiren's BootCD 10.0 OK!
#http://www.hirensbootcd.org/download/
elif [ "$(grep 'For information about this bootcd please visit http://www.hiren.info' /tmp/multisystem/multisystem-mountpoint-iso/BootCD.txt 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osnamemodif="Hiren's BootCD"
osicone="multisystem-hiren"
FCT_DOS2
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_GRUB4DOS)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/menu.lst"

#ubcd5 OK
elif [ "$(grep 'MENU TITLE Ultimate Boot CD' /tmp/multisystem/multisystem-mountpoint-iso/ubcd/menus/syslinux/defaults.cfg 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osicone="multisystem-ubcd"
#FCT_DOS1
FCT_DOS2
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_GRUB4DOS)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/menu.lst"

#ubcd411.iso
elif [ "$(grep 'Ultimate Boot CD' /tmp/multisystem/multisystem-mountpoint-iso/website/index.html 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osicone="multisystem-ubcd"
FCT_DOS2
#FCT_DOS1
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_GRUB4DOS)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/menu.lst"

#My Windows 7 Builder
#http://www.my7vision.fr/wordpress/
elif [ "$(grep 'title My 7 LiveCd v2' /tmp/multisystem/multisystem-mountpoint-iso/menu.lst 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osicone="multisystem-ubcd"
FCT_DOS2
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_GRUB4DOS)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/menu.lst"

#ERD.Commander.6.0.WINDOWS7.32bits.FRENCH.iso
#http://www.911cd.net/forums/lofiversion/index.php/t22965.html
elif [ "$(echo "${option2}" | grep -i "ERDCommander.*.iso")" ]; then
osname="$(basename "${option2}")"
osicone="multisystem-windows"
FCT_DOS5
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_GRUB4DOS)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/menu.lst"

#Ghost
#
elif [ "$(echo "${option2}" | grep -i "Ghost.*.iso")" ]; then
osname="$(basename "${option2}")"
osicone="multisystem-windows"
FCT_DOS5
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_GRUB4DOS)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/menu.lst"

#mimiPE-edition
#http://minipe.org/
#Mot de passe: thecavern 
#http://www.megaupload.com/?d=3F0GESKF
#http://www.megaupload.com/?d=GI36LZJ9
#http://www.megaupload.com/?d=WWZJTV7S
#http://www.megaupload.com/?d=GAC3RWZN
#http://www.megaupload.com/?d=7FJGG8DI
#http://www.megaupload.com/?d=TBQ58NHI
#ou
#http://rapidshare.com/users/5YFB7B
elif [ "$(grep 'WinBOMType=WinPE' /tmp/multisystem/multisystem-mountpoint-iso/winbom.ini 2>/dev/null)" ]; then
modiso="ubcd4win"
if [ ! -d "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/minint" ]; then
osname="minint"
osicone="multisystem-pebuilder"
osnamemodif="mimiPE-edition"
ligne1="title ${osnamemodif}"
ligne2="find --set-root --ignore-floppies --ignore-cd /ntldr"
ligne3="chainloader /ntldr"
ligne4="boot"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_GRUB4DOS)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/menu.lst"
#Démonter
sudo umount "/tmp/multisystem/multisystem-mountpoint-iso" 2>/dev/null
sleep 2
#recreer avant de remonter
echo -e "\E[37;44m\033[1m $(eval_gettext 'Veuillez saisir votre mot de passe d\047administrateur') \033[0m"
#remonter iso pour noms en majuscules
sudo umount "/tmp/multisystem/multisystem-mountpoint-iso" 2>/dev/null
sudo mount -o loop,map=off "${option2}" "/tmp/multisystem/multisystem-mountpoint-iso"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/I386/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/minint"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/PROGRAMS/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/PROGRAMS"
cp -f /tmp/multisystem/multisystem-mountpoint-iso/I386/NTDETECT.COM "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/ntdetect.com"
cp -f /tmp/multisystem/multisystem-mountpoint-iso/I386/SETUPLDR.BIN "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/ntldr"
else
zenity --error --text "$(eval_gettext "Erreur: LiveCD déjà présent.")"
fi

#G Data BootCD
#https://www.gdatasoftware.com/support/main-subjects/upgrade-service/download.html
elif [ -f "/tmp/multisystem/multisystem-mountpoint-iso/GDATA/GDATA" ]; then
modiso="gdata"
if [ ! -d "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/GDATA" ]; then
osname="GDATA"
osicone="multisystem-gdata"
osnamemodif="G Data BootCD"
ligne1="title ${osnamemodif}"
ligne2="kernel /GDATA/linux26 image_dir=GDATA image_name=GDATA usb rw noscsi nofirewire ramdisk_size=100000 init=/linuxrc apm=power-off vga=791 nomce lang=${LANG} video=vesa"
ligne3="initrd /GDATA/minirt26.gz"
ligne4="boot"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_GRUB4DOS)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/menu.lst"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/GDATA/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/GDATA"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/dbase/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/dbase"
cp -f /tmp/multisystem/multisystem-mountpoint-iso/boot/linux26 "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/GDATA/linux26"
cp -f /tmp/multisystem/multisystem-mountpoint-iso/boot/minirt26.gz "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/GDATA/minirt26.gz"
else
zenity --error --text "$(eval_gettext "Erreur: LiveCD déjà présent.")"
fi

#UBCD4Win
elif [ "$(grep 'The Ultimate Boot CD for Windows' /tmp/multisystem/multisystem-mountpoint-iso/menu.lst 2>/dev/null)" ]; then
modiso="ubcd4win"
if [ ! -d "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/minint" ]; then
osname="minint"
osicone="multisystem-ubcd4win"
osnamemodif="UBCD4Win"
ligne1="title ${osnamemodif}"
ligne2="find --set-root --ignore-floppies --ignore-cd /ntldr"
ligne3="chainloader /ntldr"
ligne4="boot"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_GRUB4DOS)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/menu.lst"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/I386/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/minint"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/PROGRAMS/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/PROGRAMS"
cp -f /tmp/multisystem/multisystem-mountpoint-iso/I386/NTDETECT.COM "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/ntdetect.com"
cp -f /tmp/multisystem/multisystem-mountpoint-iso/I386/SETUPLDR.BIN "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/ntldr"
else
zenity --error --text "$(eval_gettext "Erreur: LiveCD déjà présent.")"
fi

#UBCD4Win desactivé par version au dessus!
elif [ "$(grep 'The Ultimate Boot CD for Windows' /tmp/multisystem/multisystem-mountpoint-iso/menu.lst 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osicone="multisystem-ubcd4win"
FCT_DOS2
#FCT_DOS1
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_GRUB4DOS)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/menu.lst"

#HDClone
#http://www.miray.de/download/sat.hdclone.html
elif [ "$(grep 'label=HDClone' /tmp/multisystem/multisystem-mountpoint-iso/autorun.inf 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osicone="multisystem-hdclone"
FCT_DOS2
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_GRUB4DOS)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/menu.lst"

#BartPE Ramdisk
#http://users.telenet.be/Robvdb/BootPEUSB_UK.htm
#http://www.microsoft.com/downloads/thankyou.aspx?familyId=22cfc239-337c-4d81-8354-72593b1c1f43&displayLang=fr
#http://www.microsoft.com/downloads/details.aspx?displaylang=nl&FamilyID=22cfc239-337c-4d81-8354-72593b1c1f43
#http://download.microsoft.com/download/1/2/7/127c5938-d36a-4405-9df1-f00d57495652/WindowsServer2003-KB889101-SP1-x86-ENU.exe
#NTDETECT.COM
#SETUPLDR.BIN
#RAMDISK.SY_
#RAMDISK.SYS
elif [[ "$(grep -i 'Nu2Menu & Nu2MenuMsg' /tmp/multisystem/multisystem-mountpoint-iso/programs/nu2menu/nu2menu.lic 2>/dev/null)" || "$(grep -i 'Nu2Menu & Nu2MenuMsg' /tmp/multisystem/multisystem-mountpoint-iso/PROGRAMS/Nu2Menu/nu2menu.lic 2>/dev/null)" ]]; then
if [ -f "$HOME"/.multisystem/nonfree/NTDETECT.COM ]; then
echo
if [ ! "$(find "$(cat /tmp/multisystem/multisystem-mountpoint-usb)" -iname "*winpe*")" ]; then
osname="winpe-1.iso"
else
osname="$(echo "winpe-$(($(find "$(cat /tmp/multisystem/multisystem-mountpoint-usb)" -iname "*winpe*" | wc -l)+1)).iso")"
fi
osicone="multisystem-pebuilder"
modiso="bartpe"
osnamemodif="BartPE RamDisk$(($(find "$(cat /tmp/multisystem/multisystem-mountpoint-usb)" -iname "*winpe*" | wc -l)+1))"
#FCT_DOS2
FCT_DOS1
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_GRUB4DOS)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/menu.lst"
#NTDETECT.COM cdce1413695a6ace7304e77f35aa3a37
#RAMDISK.SY_ df3bcfecde97400e645d4c1a73cce598
#RAMDISK.SYS 0f1ce9cbcd35a30d285c1eb672092778
#SETUPLDR.BIN 4352373bc08ffa6d8ffdb20a3ba5bc9a
#sudo find /xxx -iname *RAMDISK* -execdir md5sum {} \;
mkdir /tmp/multisystem/multisystem-bartpe
mkdir /tmp/multisystem/multisystem-bartpe/iso
mkdir /tmp/multisystem/multisystem-bartpe/I386
mkdir /tmp/multisystem/multisystem-bartpemodif
#Démonter
sudo umount "/tmp/multisystem/multisystem-mountpoint-iso" 2>/dev/null
sleep 2
#recreer avant de remonter
mkdir "/tmp/multisystem/multisystem-mountpoint-iso"
echo -e '[SetupData]\r\nBootDevice = "ramdisk(0)"\r\nBootPath = "\I386\system32\"\r\nOsLoadOptions="/noguiboot /fastdetect /minint /rdexportascd /rdpath=\iso\winpe.iso"' >/tmp/multisystem/multisystem-bartpe/winnt.sif
echo -e "\E[37;44m\033[1m $(eval_gettext 'Veuillez saisir votre mot de passe d\047administrateur') \033[0m"
sudo chown -R $SUDO_USER:$SUDO_USER "$(cat /tmp/multisystem/multisystem-mountpoint-usb)"
#remonter iso pour noms en majuscules
sudo umount "/tmp/multisystem/multisystem-mountpoint-iso" 2>/dev/null
sudo mount -o loop,map=off "${option2}" "/tmp/multisystem/multisystem-mountpoint-iso"
#remplacer NTDETECT.COM dans iso origine,, et reconstruire iso
sudo rsync -avS --progress "/tmp/multisystem/multisystem-mountpoint-iso/." /tmp/multisystem/multisystem-bartpemodif
#zenity --info --text "Attente1"
sudo cp -f "$HOME"/.multisystem/nonfree/NTDETECT.COM /tmp/multisystem/multisystem-bartpemodif/I386/NTDETECT.COM
sudo cp -f "$HOME"/.multisystem/nonfree/SETUPLDR.BIN /tmp/multisystem/multisystem-bartpemodif/I386/SETUPLDR.BIN
sudo cp -f "$HOME"/.multisystem/nonfree/RAMDISK.SY_ /tmp/multisystem/multisystem-bartpemodif/I386/RAMDISK.SY_
sudo cp -f "$HOME"/.multisystem/nonfree/RAMDISK.SYS /tmp/multisystem/multisystem-bartpemodif/I386/SYSTEM32/DRIVERS/RAMDISK.SYS
sudo cp -f "$HOME"/.multisystem/nonfree/BOOTSECT.BIN /tmp/multisystem/multisystem-bartpemodif/BOOTSECT.BIN
#zenity --info --text "Attente2"
cd /tmp/multisystem/multisystem-bartpemodif
sudo genisoimage -iso-level 4 -volid "BartPE" -A PEBUILDER/MKISOFS -sysid "Win32" -no-emul-boot -b BOOTSECT.BIN -hide BOOTSECT.BIN -o "/tmp/multisystem/winpe.iso" /tmp/multisystem/multisystem-bartpemodif
cd -
#zenity --info --text "Attente3"
sudo rm -R /tmp/multisystem/multisystem-bartpemodif
#rsync -avS --progress "${option2}" /tmp/multisystem/multisystem-bartpe/iso/winpe.iso
sudo mv /tmp/multisystem/winpe.iso /tmp/multisystem/multisystem-bartpe/iso/winpe.iso
cp "$HOME"/.multisystem/nonfree//NTDETECT.COM /tmp/multisystem/multisystem-bartpe/I386/NTDETECT.COM
cp "$HOME"/.multisystem/nonfree//SETUPLDR.BIN /tmp/multisystem/multisystem-bartpe/I386/SETUPLDR.BIN
cp /tmp/multisystem/multisystem-bartpe/I386/SETUPLDR.BIN /tmp/multisystem/multisystem-bartpe/I386/ntldr
cp "$HOME"/.multisystem/nonfree/BOOTSECT.BIN /tmp/multisystem/multisystem-bartpe/BOOTSECT.BIN
#zenity --info --text "Attente4"
cd /tmp/multisystem/multisystem-bartpe
genisoimage -iso-level 4 -volid "BartPE" -A PEBUILDER/MKISOFS -sysid "Win32" -no-emul-boot -b BOOTSECT.BIN -hide BOOTSECT.BIN -o "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}" /tmp/multisystem/multisystem-bartpe
cd -
sudo rm -R /tmp/multisystem/multisystem-bartpe
sudo rm /tmp/multisystem/winpe.iso
else
zenity --error --text "$(eval_gettext "Erreur: veuillez installer les fichiers nécessaire, menu Non-Libre")"
FCT_RELOAD
exit 0
fi

#FreeDos 1.0
#http://www.freedos.org/
elif [ "$(grep 'standard FreeDOS bootdisk' /tmp/multisystem/multisystem-mountpoint-iso/isolinux/isolinux.cfg 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osicone="multisystem-freedos"
osnamemodif="FreeDos"
#FCT_DOS2
FCT_DOS1
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_GRUB4DOS)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/menu.lst"

#Winlsd Sp3 French Iso
#le mot de passe administrateur est rockmyroot
#http://uploading.com/files/8d3dbcef/WinLSD_SP3.FRENCH.iso/

#Windows XP install firadisk /boot/img/firadisk.ima
#http://www.downflex.com/telecharger-tag/windows-xp-professionnel/
elif [[ "$(grep 'WinLSD' /tmp/multisystem/multisystem-mountpoint-iso/README.HTA 2>/dev/null)" || "$(grep 'microsoft_windows xp_release_notes' /tmp/multisystem/multisystem-mountpoint-iso/readme.htm 2>/dev/null)" || "$(grep 'microsoft_windows xp_release_notes' /tmp/multisystem/multisystem-mountpoint-iso/lisezmoi.htm 2>/dev/null)" || "$(grep 'Windows XP' -R /tmp/multisystem/multisystem-mountpoint-iso/DOCS/ 2>/dev/null)" ]]; then
#http://diddy.boot-land.net/firadisk/
#http://diddy.boot-land.net/firadisk/files/win_iso_install.htm
#http://www.boot-land.net/forums/index.php?act=attach&type=post&id=10118
echo
if [ -f "$HOME"/.multisystem/nonfree/firadisk.ima ]; then
cp -f "$HOME"/.multisystem/nonfree/firadisk.ima "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/img/firadisk.ima"
function FCT_GRUB4DOS_XP()
{
dater="$(date +%d-%m-%Y-%T-%N)"
tailleiso="$(($(du -sB 1 "${option2}" | awk '{print $1}')/1024/1024))Mio"
if [ ! "$osnamemodif" ]; then
osnamemodif="$osname"
fi
cat <<EOF
#MULTISYSTEM_MENU_DEBUT|${dater}|${osname}|${osicone}|${tailleiso}|\n${lignexp}\n#MULTISYSTEM_MENU_FIN|${dater}|${osname}|${osicone}|${tailleiso}|
EOF
}
osname="$(basename "${option2}")"
osnamemodif="Windows XP install firadisk"
osicone="multisystem-windows"
#lignexp="title 1-XP setup from iso (firadisk)\nfind --set-root /${osname}\nmap (hd0) (hd1)\nmap (hd1) (hd0)\nmap --mem /boot/img/firadisk.ima (fd1)\nmap --mem (md)0x6000+800 (fd0)\nmap --mem /${osname} (0xff)\nmap --hook\ndd if=(fd1) of=(fd0) count=1\nchainloader (0xff)\n\ntitle 2-Continue XP setup\nfind --set-root /${osname}\nmap (hd0) (hd1)\nmap (hd1) (hd0)\nmap --mem /${osname} (0xff)\nmap --hook\nchainloader (hd0)+1"
lignexp="title 1-XP setup from iso (firadisk)\nfind --set-root /${osname}\nmap (hd0) (hd1)\nmap (hd1) (hd0)\nmap --mem /boot/img/firadisk.ima (fd1)\nmap --mem (md)0x6000+800 (fd0)\nmap --mem /${osname} (0xff)\nmap --hook\ndd if=(fd1) of=(fd0) count=1\nchainloader (0xff)\n\ntitle 2-Continue XP setup\nfind --set-root /${osname}\nmap (hd0) (hd1)\nmap (hd1) (hd0)\nmap --mem /${osname} (0xff)\nmap --hook\nfind --set-root --ignore-floppies --ignore-cd /ntldr\nchainloader /ntldr"
FCT_DOS5
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_GRUB4DOS_XP)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/menu.lst"
else
zenity --error --text "$(eval_gettext "Erreur: veuillez installer les fichiers nécessaire, menu Non-Libre")"
FCT_RELOAD
exit 0
fi

#Console Win XP
#http://fspsa.free.fr/
elif [ "$(grep 'http://fspsa.free.fr/fspsa.css' /tmp/multisystem/multisystem-mountpoint-iso/_lire.htm 2>/dev/null)" ]; then
#http://diddy.boot-land.net/firadisk/
#http://diddy.boot-land.net/firadisk/files/win_iso_install.htm
#http://www.boot-land.net/forums/index.php?act=attach&type=post&id=10118
echo
if [ -f "$HOME"/.multisystem/nonfree/firadisk.ima ]; then
cp -f "$HOME"/.multisystem/nonfree/firadisk.ima "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/img/firadisk.ima"
function FCT_GRUB4DOS_XP()
{
dater="$(date +%d-%m-%Y-%T-%N)"
tailleiso="$(($(du -sB 1 "${option2}" | awk '{print $1}')/1024/1024))Mio"
if [ ! "$osnamemodif" ]; then
osnamemodif="$osname"
fi
cat <<EOF
#MULTISYSTEM_MENU_DEBUT|${dater}|${osname}|${osicone}|${tailleiso}|\n${lignexp}\n#MULTISYSTEM_MENU_FIN|${dater}|${osname}|${osicone}|${tailleiso}|
EOF
}
osname="$(basename "${option2}")"
osnamemodif="Console de Recuperation"
osicone="multisystem-windows"
lignexp="title Console de Recuperation (firadisk)\nfind --set-root /${osname}\nmap (hd0) (hd1)\nmap (hd1) (hd0)\nmap --mem /boot/img/firadisk.ima (fd1)\nmap --mem (md)0x6000+800 (fd0)\nmap --mem /${osname} (0xff)\nmap --hook\ndd if=(fd1) of=(fd0) count=1\nchainloader (0xff)"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_GRUB4DOS_XP)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/menu.lst"
else
zenity --error --text "$(eval_gettext "Erreur: veuillez installer les fichiers nécessaire, menu Non-Libre")"
FCT_RELOAD
exit 0
fi

#kolibri Kolibri OS
#http://www.kolibrios.org/
elif [ "$(grep 'Kolibri OS' /tmp/multisystem/multisystem-mountpoint-iso/readme.txt 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osicone="multisystem-menuetos"
#FCT_DOS2
FCT_DOS1
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_GRUB4DOS)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/menu.lst"

#kon-boot bypass passwords
#http://www.piotrbania.com/all/kon-boot/
##title Kon-Boot
##map --mem /konboot-1.1-2in1.img (fd0)
##map --hook
##chainloader (fd0)+1
##map (hd1) (hd0)
##map --hooack
##rootnoverify (fd0)
#
#
#LABEL konboot
#MENU LABEL Kon-Boot
#TEXT HELP
#                    Log into Linux systems as root user without the password (using 'kon-usr').
#                    Also log into any password-protected profile on Windows systems (WinXP and
#                    above) without the password.
#                    Web: http://www.piotrbania.com/all/kon-boot/
#ENDTEXT
#LINUX /boot/syslinux/memdisk
#INITRD /images/[base]/konboot.img.gz
#APPEND raw
#
#
elif [ "$(echo "${option2}" | grep -i "konboot.*.img")" ]; then
osname="$(basename "${option2}")"
osicone="multisystem-konboot"
osnamemodif="Kon-Boot bypass passwords"
ligne1="title ${osnamemodif}"
ligne2="find --set-root /${osname}"
ligne3="map --mem /${osname} (fd0)"
ligne4="map --hook"
ligne5="chainloader (fd0)+1"
ligne6="rootnoverify (fd0)"
ligne7="map --floppies=1\nboot"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_GRUB4DOS)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/menu.lst"

#Menuetos
#http://menuetos.net/download.htm
elif [ "$(echo "${option2}" | grep "M32.*.IMG")" ]; then
osname="$(basename "${option2}")"
osicone="multisystem-menuetos"
FCT_DOS3
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_GRUB4DOS)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/menu.lst"

#Entrée generique pour images disquettes .img
#Entrée generique pour images disquettes .img
elif [[ "$(echo "${option2}" | grep -i ".*.img")" && $(($(du -sB 1 "${option2}" | awk '{print $1}')/1024)) -le "1445" ]]; then
osname="$(basename "${option2}")"
osicone="multisystem-img"
osloopback="search --set -f \"/${osname}\""
vintrd="initrd16"
vkernel="linux16"
#Corriger pour grub2 v1.96
if [ "$(grub-install -v | grep 1.96)" ]; then
vintrd="initrd"
vkernel="linux"
fi
oskernel="${vkernel} /boot/syslinux/memdisk"
osinitrd="${vintrd} \"/${osname}\""
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#Acronis true image
#http://www.acronis.fr/homecomputing/products/trueimage/
elif [ "$(echo "$(basename "${option2}")" | grep -i "acronis.*iso")" ]; then
osname="$(basename "${option2}")"
osicone="multisystem-acronis"
FCT_DOS2
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_GRUB4DOS)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/menu.lst"

#haiku
#http://www.haiku-os.org/get-haiku
#elif [ -f "/tmp/multisystem/multisystem-mountpoint-iso/haiku-boot-floppy.image" ]; then
#osname="$(basename "${option2}")"
#osicone="multisystem-acronis"
#FCT_DOS2
#sed -i "s@^#MULTISYSTEM_STOP@$(FCT_GRUB4DOS)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/menu.lst"

#ReactOS
#http://www.reactos.org/fr/download.html

#Windows Vista
#http://www.downflex.com/telecharger/
elif [ "$(grep 'installing Windows Vista' /tmp/multisystem/multisystem-mountpoint-iso/sources/readme.rtf 2>/dev/null)" ]; then
modiso="Vista"
if [ ! -d "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/sources" ]; then
osname="sources"
osicone="multisystem-windows"
osnamemodif="Windows Vista install"
#ligne1="title ${osnamemodif}"
#ligne2="kernel /boot/syslinux/memdisk"
#ligne3="initrd /boot/syslinux/redir.img"
#sed -i "s@^#MULTISYSTEM_STOP@$(FCT_GRUB4DOS)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/menu.lst"
#menu syslinux
ligne1="label Vista"
ligne2="MENU LABEL ${osnamemodif}"
ligne3="kernel chain.c32 hd0 1 ntldr=/bootmgr"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_SYSLINUX)\n#MULTISYSTEM_STOP@" "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/syslinux/syslinux.cfg"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Veuillez saisir votre mot de passe d\047administrateur') \033[0m"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/."
else
zenity --error --text "$(eval_gettext "Erreur: LiveCD déjà présent.")"
fi

#Windows 7 seven
#Download Windows 7 System Recovery Discs
#http://neosmart.net/blog/2008/windows-vista-recovery-disc-download/
#Neosmart: Windows 7 32-bit Repair Disc.iso
#http://www.downflex.com/telecharger/
elif [ -f "/tmp/multisystem/multisystem-mountpoint-iso/sources/boot.wim" ]; then
modiso="win7"
if [ ! -d "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/sources" ]; then
osname="sources"
osicone="multisystem-windows"
osnamemodif="Windows install"
#ligne1="title ${osnamemodif}"
#ligne2="find --set-root --ignore-floppies --ignore-cd /bootmgr"
#ligne3="map (hd0) (hd0)"
#ligne4="map (hd0) (hd0)"
#ligne5="map --rehook"
#ligne6="find --set-root --ignore-floppies --ignore-cd /bootmgr"
#ligne7="chainloader /bootmgr\nboot"
#sed -i "s@^#MULTISYSTEM_STOP@$(FCT_SYSLINUX)\n#MULTISYSTEM_STOP@" "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/grub/menu.lst"
ligne1="label win"
ligne2="MENU LABEL ${osnamemodif}"
ligne3="KERNEL chain.c32 hd0 1 ntldr=/bootmgr"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_SYSLINUX)\n#MULTISYSTEM_STOP@" "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/syslinux/syslinux.cfg"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Veuillez saisir votre mot de passe d\047administrateur') \033[0m"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/."
else
zenity --error --text "$(eval_gettext "Erreur: LiveCD déjà présent.")"
fi

#MEPIS deviens ==> antiX l/p root/root
#http://antix.mepis.com/index.php/Main_Page#Downloads
#ne passe pas dans grub2 ???
elif [ -f "/tmp/multisystem/multisystem-mountpoint-iso/antiX/antiX" ]; then
modiso="copycontent"
if [ ! -d "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/antiX" ]; then
osname="antiX"
osicone="multisystem-antix"
osnamemodif="antiX"
ligne1="title antiX"
ligne2="kernel /antiX/vmlinuz quiet lean noxorg blab=$(cat /tmp/multisystem/multisystem-selection-label-usb) bdir=antiX vga=791"
ligne3="initrd /antiX/initrd.gz"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_GRUB4DOS)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/menu.lst"
mkdir "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/antiX"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/boot/vmlinuz "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/antiX/vmlinuz"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/boot/initrd.gz "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/antiX/initrd.gz"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/antiX/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/antiX/."
else
zenity --error --text "$(eval_gettext "Erreur: LiveCD déjà présent.")"
fi

#Paragon
#http://www.paragon-software.com/home/systembackup/
#http://www.sharewareconnection.com/download-paragon-drive-backup-personal-from-sharecon.html
#append="splash=silent vga=0x314 language=fr_FR.UTF-8 medialable=PARAGON"
elif [ "$(grep 'Paragon' /tmp/multisystem/multisystem-mountpoint-iso/cd.cfg 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osicone="multisystem-paragon"
#FCT_DOS2
FCT_DOS1
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_GRUB4DOS)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/menu.lst"

#Kaspersky Rescue Disk
#http://rescuedisk.kaspersky-labs.com/rescuedisk/updatable/
#http://support.kaspersky.com/faq?qid=208285003#top
#http://sites.google.com/site/rmprepusb/tutorials/kasperkyrescue
elif [ "$(grep '10.0.' /tmp/multisystem/multisystem-mountpoint-iso/rescue/KRD.VERSION 2>/dev/null)" ]; then
modiso="copycontent"
if [ ! -f "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/rescue/rescue.iso" ]; then
osname="rescue"
osnamemodif="Kaspersky Rescue USB Type ALT+TAB and then A to accept the EULA"
osicone="multisystem-Kaspersky"
function FCT_KASPERSKY()
{
if [ ! "$osnamemodif" ]; then
osnamemodif="$osname"
fi
ligne1="title Kaspersky Rescue Disk"
ligne2="find --set-root /rescue/rescue.iso"
ligne3="map /rescue/rescue.iso (0xff) || map --mem /rescue/rescue.iso (0xff)"
ligne4="map --hook"
ligne5="chainloader (0xff)"
ligne6="boot"
ligne7=""
}
FCT_KASPERSKY
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_GRUB4DOS)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/menu.lst"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/rescue/help"
rsync -avS --progress "${option2}" "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/rescue/rescue.iso"
>"$(cat /tmp/multisystem/multisystem-mountpoint-usb)/liveusb"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/rescue/help/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/rescue/help/."
else
zenity --error --text "$(eval_gettext "Erreur: LiveCD déjà présent.")"
fi

#ReactOS
#http://www.reactos.org/fr/
elif [ "$(grep 'ReactOS' /tmp/multisystem/multisystem-mountpoint-iso/freeldr.ini 2>/dev/null)" ]; then
modiso="reactos"
if [ ! -f "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/freeldr.ini" ]; then
osname="reactos"
osicone="multisystem-reactos"
osnamemodif="ReactOS"
ligne1="title ${osnamemodif}"
ligne2="find --set-root --ignore-floppies --ignore-cd /loader/setupldr.sys"
ligne3="root (hd0,0)"
ligne4="chainloader /loader/setupldr.sys"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_GRUB4DOS)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/menu.lst"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Veuillez saisir votre mot de passe d\047administrateur') \033[0m"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/loader/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/loader"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/Profiles/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/Profiles"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/reactos/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/reactos"
cp -f /tmp/multisystem/multisystem-mountpoint-iso/freeldr.ini "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/freeldr.ini"
else
zenity --error --text "$(eval_gettext "Erreur: LiveCD déjà présent.")"
fi

#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒/Grub4Dos#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒



#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒Syslinux#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒

#pfSense
#http://www.pfsense.org/mirror.php?section=downloads
elif [ "$(grep 'pfSense' /tmp/multisystem/multisystem-mountpoint-iso/boot/scripts/freebsd_installer 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osnamemodif="pfSense"
osicone="multisystem-pfSense"
ligne1="label $(echo $RANDOM)"
ligne2="MENU LABEL ${osnamemodif}"
ligne3="KERNEL memdisk"
ligne4="APPEND iso raw initrd=/${osname}"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_SYSLINUX)\n#MULTISYSTEM_STOP@" "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/syslinux/syslinux.cfg"

#FreeBSD bootonly (v9.0 ne passe plus je supprime support ...)
#ftp://ftp.freebsd.org/pub/FreeBSD/ISO-IMAGES-i386/8.1/
elif [ "$(grep 'zzZZzzFreeBSD' /tmp/multisystem/multisystem-mountpoint-iso/boot/defaults/loader.conf 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osnamemodif="FreeBSD"
osicone="multisystem-bsd"
ligne1="label $(echo $RANDOM)"
ligne2="MENU LABEL ${osnamemodif}"
ligne3="KERNEL memdisk"
ligne4="APPEND iso raw initrd=/${osname}"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_SYSLINUX)\n#MULTISYSTEM_STOP@" "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/syslinux/syslinux.cfg"

#NetbootCD (tinycore based)
#http://netbootcd.tuxfamily.org/#Downloads
elif [ "$(grep 'NetbootCD' /tmp/multisystem/multisystem-mountpoint-iso/boot/isolinux/isolinux.cfg 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osnamemodif="NetbootCD"
osicone="multisystem-tinycore"
ligne1="label $(echo $RANDOM)"
ligne2="MENU LABEL ${osnamemodif}"
ligne3="KERNEL memdisk"
ligne4="APPEND iso raw initrd=/${osname}"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_SYSLINUX)\n#MULTISYSTEM_STOP@" "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/syslinux/syslinux.cfg"

#PLD RescueCD
#http://rescuecd.pld-linux.org/
elif [ "$(grep 'PLD RescueCD' /tmp/multisystem/multisystem-mountpoint-iso/boot/isolinux/boot.msg 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osnamemodif="PLD RescueCD"
osicone="multisystem-rescue"
ligne1="label $(echo $RANDOM)"
ligne2="MENU LABEL ${osnamemodif}"
ligne3="KERNEL memdisk"
ligne4="APPEND iso raw initrd=/${osname}"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_SYSLINUX)\n#MULTISYSTEM_STOP@" "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/syslinux/syslinux.cfg"

#wifiway login/pass root:toor puis startx (xdm start)
#http://www.seguridadwireless.net/
#http://foro.seguridadwireless.net/live-cd-wifiway-1-0-renovation-kde/wifiway-2-0-1-wifiway-2-0-1-small/
#http://www.wifiway.org/index.php
elif [ "$(grep 'INCLUDE /boot/wifiway.cfg' /tmp/multisystem/multisystem-mountpoint-iso/boot/isolinux/isolinux.cfg 2>/dev/null)" ]; then
modiso="copycontent"
if [ ! -d "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/wifiway" ]; then
osname="wifiway"
osicone="multisystem-wifiway"
osnamemodif="Wifiway"
ligne1="label $(echo $RANDOM)"
ligne2="MENU LABEL ${osnamemodif}"
ligne3="CONFIG /wifiway/boot/wifiway.cfg"
ligne4=""
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_SYSLINUX)\n#MULTISYSTEM_STOP@" "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/syslinux/syslinux.cfg"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/wifiway/boot"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress "/tmp/multisystem/multisystem-mountpoint-iso/boot/." "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/wifiway/boot"
rsync -avS --progress "/tmp/multisystem/multisystem-mountpoint-iso/wifiway/." "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/wifiway"
cp -f "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/syslinux/vesamenu.c32" "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/wifiway/boot/vesamenu.c32"
sed -i "s%/boot/%/wifiway/boot/%g" "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/wifiway/boot/wifiway.cfg"
else
zenity --error --text "$(eval_gettext "Erreur: LiveCD déjà présent.")"
fi

#Wifislax
#http://www.seguridadwireless.es/
elif [ "$(grep 'INCLUDE /boot/wifislax.cfg' /tmp/multisystem/multisystem-mountpoint-iso/boot/isolinux/isolinux.cfg 2>/dev/null)" ]; then
modiso="copycontent"
if [ ! -d "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/wifislax" ]; then
osname="wifislax"
osicone="multisystem-wifislax"
osnamemodif="Wifislax"
ligne1="label $(echo $RANDOM)"
ligne2="MENU LABEL ${osnamemodif}"
ligne3="CONFIG /wifislax/boot/wifislax.cfg"
ligne4=""
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_SYSLINUX)\n#MULTISYSTEM_STOP@" "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/syslinux/syslinux.cfg"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/wifislax/boot"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress "/tmp/multisystem/multisystem-mountpoint-iso/boot/." "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/wifislax/boot"
rsync -avS --progress "/tmp/multisystem/multisystem-mountpoint-iso/wifislax/." "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/wifislax"
cp -f "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/syslinux/vesamenu.c32" "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/wifislax/boot/vesamenu.c32"
sed -i "s%/boot/%/wifislax/boot/%g" "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/wifislax/boot/wifislax.cfg"
else
zenity --error --text "$(eval_gettext "Erreur: LiveCD déjà présent.")"
fi

#beakOS L/P root/beakos beakos/beakos (pour demarrer ==> gdm start)
#http://www.beakos.com.mx/
elif [ "$(grep 'Run beakos' /tmp/multisystem/multisystem-mountpoint-iso/boot/isolinux/isolinux.cfg 2>/dev/null)" ]; then
modiso="copycontent"
if [ ! -d "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/beakos" ]; then
osname="beakos"
osicone="multisystem-beakos"
osnamemodif="beakOS"
ligne1="label $(echo $RANDOM)"
ligne2="MENU LABEL ${osnamemodif}"
ligne3="CONFIG /beakos/boot/syslinux/syslinux.cfg"
ligne4=""
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_SYSLINUX)\n#MULTISYSTEM_STOP@" "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/syslinux/syslinux.cfg"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/beakos/boot"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress "/tmp/multisystem/multisystem-mountpoint-iso/boot/." "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/beakos/boot"
rsync -avS --progress "/tmp/multisystem/multisystem-mountpoint-iso/beakos/." "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/beakos"
cp -f "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/syslinux/vesamenu.c32" "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/beakos/boot/vesamenu.c32"
sed -i "s%/boot/%/beakos/boot/%g" "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/beakos/boot/syslinux/syslinux.cfg"
else
zenity --error --text "$(eval_gettext "Erreur: LiveCD déjà présent.")"
fi

#Porteus
#http://www.porteus.org/distro-download.html
elif [ "$(grep 'INCLUDE /boot/porteus.cfg' /tmp/multisystem/multisystem-mountpoint-iso/boot/isolinux/isolinux.cfg 2>/dev/null)" ]; then
modiso="copycontent"
if [ ! -d "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/porteus" ]; then
osname="porteus"
osicone="multisystem-porteus"
osnamemodif="porteus"
ligne1="label $(echo $RANDOM)"
ligne2="MENU LABEL ${osnamemodif}"
ligne3="CONFIG /porteus/boot/porteus.cfg"
ligne4=""
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_SYSLINUX)\n#MULTISYSTEM_STOP@" "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/syslinux/syslinux.cfg"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/porteus/boot"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress "/tmp/multisystem/multisystem-mountpoint-iso/boot/." "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/porteus/boot"
rsync -avS --progress "/tmp/multisystem/multisystem-mountpoint-iso/porteus/." "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/porteus"
cp -f "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/syslinux/vesamenu.c32" "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/porteus/boot/vesamenu.c32"
sed -i "s%/boot/%/porteus/boot/%g" "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/porteus/boot/porteus.cfg"
else
zenity --error --text "$(eval_gettext "Erreur: LiveCD déjà présent.")"
fi

#Slax login/pass root:toor puis startx
#http://www.slax.org/get_slax.php
elif [ "$(grep 'INCLUDE /boot/slax.cfg' /tmp/multisystem/multisystem-mountpoint-iso/boot/isolinux/isolinux.cfg 2>/dev/null)" ]; then
modiso="copycontent"
if [ ! -d "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/slax" ]; then
osname="slax"
osicone="multisystem-slax"
osnamemodif="Slax"
ligne1="label $(echo $RANDOM)"
ligne2="MENU LABEL ${osnamemodif}"
ligne3="CONFIG /slax/boot/slax.cfg"
ligne4=""
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_SYSLINUX)\n#MULTISYSTEM_STOP@" "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/syslinux/syslinux.cfg"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/slax/boot"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress "/tmp/multisystem/multisystem-mountpoint-iso/boot/." "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/slax/boot"
rsync -avS --progress "/tmp/multisystem/multisystem-mountpoint-iso/slax/." "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/slax"
cp -f "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/syslinux/vesamenu.c32" "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/slax/boot/vesamenu.c32"
sed -i "s%/boot/%/slax/boot/%g" "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/slax/boot/slax.cfg"
else
zenity --error --text "$(eval_gettext "Erreur: LiveCD déjà présent.")"
fi

#liberte (Gentoo)
#http://sourceforge.net/projects/liberte/
elif [ "$(grep 'DEFAULT liberte' /tmp/multisystem/multisystem-mountpoint-iso/liberte/boot/syslinux/syslinux.cfg 2>/dev/null)" ]; then
modiso="copycontent"
if [ ! -d "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/liberte" ]; then
osname="liberte"
osicone="multisystem-liberte"
osnamemodif="liberte"
ligne1="label $(echo $RANDOM)"
ligne2="MENU LABEL ${osnamemodif}"
ligne3="CONFIG /liberte/boot/syslinux/syslinux.cfg"
ligne4=""
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_SYSLINUX)\n#MULTISYSTEM_STOP@" "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/syslinux/syslinux.cfg"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/liberte"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress "/tmp/multisystem/multisystem-mountpoint-iso/liberte/." "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/liberte"
cp -f "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/syslinux/menu.c32" "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/liberte/boot/syslinux/menu.c32"
else
zenity --error --text "$(eval_gettext "Erreur: LiveCD déjà présent.")"
fi

#Frugalware Linux (netinstall)
#http://frugalware.org/download
elif [ "$(grep 'menu title Frugalware Linux' /tmp/multisystem/multisystem-mountpoint-iso/boot/syslinux/syslinux.cfg 2>/dev/null)" ]; then
modiso="copycontent"
if [ ! -d "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/frugalware-i686" ]; then
osname="frugalware-i686"
osicone="multisystem-frugalware"
osnamemodif="Frugalware"
ligne1="label $(echo $RANDOM)"
ligne2="MENU LABEL ${osnamemodif}"
ligne3="CONFIG /frugalware-i686/boot/syslinux/syslinux.cfg"
ligne4=""
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_SYSLINUX)\n#MULTISYSTEM_STOP@" "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/syslinux/syslinux.cfg"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/frugalware-i686/boot"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/frugalware-i686/docs"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress "/tmp/multisystem/multisystem-mountpoint-iso/frugalware-i686/." "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/frugalware-i686"
rsync -avS --progress "/tmp/multisystem/multisystem-mountpoint-iso/boot/." "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/frugalware-i686/boot"
rsync -avS --progress "/tmp/multisystem/multisystem-mountpoint-iso/docs/." "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/frugalware-i686/docs"
cp -f "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/syslinux/vesamenu.c32" "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/frugalware-i686/boot/syslinux/vesamenu.c32"
sed -i "s%/boot/%/frugalware-i686/boot/%g" "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/frugalware-i686/boot/syslinux/syslinux.cfg"
else
zenity --error --text "$(eval_gettext "Erreur: LiveCD déjà présent.")"
fi

#Slitaz
#Login/pass Slitaz
#User: tux/(pas de mot de passe)
#Administrateur: root/root
#http://www.slitaz.org/en/get/
elif [ "$(grep -i 'label slitaz' /tmp/multisystem/multisystem-mountpoint-iso/boot/isolinux/isolinux.cfg 2>/dev/null)" ]; then
modiso="copycontent"
echo "slitaz1" >/tmp/multisystem/multisystem-nomdistro
chemindeb="$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/slitaz"
find "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")" -maxdepth 1 -path "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/slitaz[0-9]" | while read line
do
echo "slitaz$(($(echo $line | sed "s@${chemindeb}@@g")+1))" >/tmp/multisystem/multisystem-nomdistro
done
osname="$(cat /tmp/multisystem/multisystem-nomdistro)"
osnamemodif="slitaz"
osicone="multisystem-slitaz"
ligne1="label $(echo $RANDOM)"
ligne2="MENU LABEL ${osnamemodif}"
ligne3="KERNEL /${osname}/boot/bzImage"
if [ -f "/tmp/multisystem/multisystem-mountpoint-iso/boot/rootfs4.gz" ]; then
ligne4="append initrd=/${osname}/boot/rootfs4.gz,/${osname}/boot/rootfs3.gz,/${osname}/boot/rootfs2.gz,/${osname}/boot/rootfs1.gz rw root=/dev/null autologin"
else
ligne4="append initrd=/${osname}/boot/rootfs.gz rw root=/dev/null autologin"
fi
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_SYSLINUX)\n#MULTISYSTEM_STOP@" "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/syslinux/syslinux.cfg"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${osname}"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/."

#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒/Syslinux#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒



#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒divers#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒

#Lightweight Portable Security (LPS)
#http://www.spi.dod.mil/lipose.htm
elif [ "$(grep 'install LPS' /tmp/multisystem/multisystem-mountpoint-iso/InstallToUSB/USBInstall.bat 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osnamemodif="LPS"
osicone="multisystem-lps"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/vmlinuz loadramdisk=1 ramdisk_blocksize=4096 root=/dev/ram0 ramdisk_size=524288 splash=silent console=ttyS3"
osinitrd="initrd (loop)/initrd"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#netboot.me
#http://netboot.me
elif [ "$(grep 'DEFAULT gpxe.krn' /tmp/multisystem/multisystem-mountpoint-iso/isolinux.cfg 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osnamemodif="netboot.me"
osicone="multisystem-netbootme"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux16 (loop)/GPXE.KRN"
osinitrd=""
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#LightDesktop
#http://lightdesktop.com/
elif [ "$(grep '/boot/bstrap.img' /tmp/multisystem/multisystem-mountpoint-iso/boot/grub/grub.conf 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osnamemodif="LightDesktop"
osicone="multisystem-tux"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/boot/bzimage"
osinitrd="initrd (loop)/boot/bstrap.img"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#EASEUS Disk Copy
#http://www.easeus.com/disk-copy/download.htm
elif [ "$(grep 'Start Disk Copy' /tmp/multisystem/multisystem-mountpoint-iso/boot/grub/menu.lst 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osnamemodif="EASEUS Disk Copy"
osicone="multisystem-diskcopy"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/boot/bzImage load_ramdisk=1 prompt_ramdisk=0 ramdisk_size=204800 rw root=/dev/ram0"
osinitrd="initrd (loop)/boot/initrd.img"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#KXStudio
#http://kxstudio.sourceforge.net/
#ATTENTION en mode copycontent virer dans ramdisk ==> .../conf/uuid.conf
elif [ "$(grep 'KXStudio' /tmp/multisystem/multisystem-mountpoint-iso/.disk/info 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osnamemodif="$(basename "${option2}")"
osicone="multisystem-kxstudio"
gen_champ="$(grep -m1 'file=.*\.seed' -o /tmp/multisystem/multisystem-mountpoint-iso/isolinux/text.cfg)"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*vmlinuz*")) root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) ${gen_champ} locale=$(echo "${LANG}" | sed "s/\..*//") bootkbd=${XKBLAYOUT} console-setup/layoutcode=${XKBLAYOUT} console-setup/variantcode=${XKBVARIANT} iso-scan/filename=/${osname} boot=casper noprompt quiet splash --"
osinitrd="initrd (loop)/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*initrd*"))"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#Caixa Mágica
#http://www.caixamagica.pt/pag/b_down00.php
elif [ "$(grep 'CaixaMagica' /tmp/multisystem/multisystem-mountpoint-iso/.disk/info 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osnamemodif="$(basename "${option2}")"
osicone="multisystem-caixamagica"
gen_champ="$(grep -m1 'file=.*\.seed' -o /tmp/multisystem/multisystem-mountpoint-iso/isolinux/txt.cfg)"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*vmlinuz*")) root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) ${gen_champ} ${ubuntu_lang} iso-scan/filename=/${osname} boot=casper noprompt quiet splash --"
osinitrd="initrd (loop)/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*initrd*"))"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#JoldzicOS 3
#http://www.joldzic.net/
elif [ "$(grep 'Joldzic OS' /tmp/multisystem/multisystem-mountpoint-iso/isolinux/isolinux.cfg 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osnamemodif="JoldzicOS"
osicone="multisystem-joldzic"
gen_champ="$(grep -m1 'file=.*\.seed' -o /tmp/multisystem/multisystem-mountpoint-iso/isolinux/isolinux.cfg)"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/casper/vmlinuz root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) ${gen_champ} ${ubuntu_lang} iso-scan/filename=/${osname} boot=casper noprompt quiet splash --"
osinitrd="initrd (loop)/casper/initrd.lz"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#Kiwi Linux
#http://kiwilinux.org/en/download.html
elif [ "$(grep 'Kiwi Linux' /tmp/multisystem/multisystem-mountpoint-iso/.disk/info 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osnamemodif="$(basename "${option2}")"
osicone="multisystem-kiwi"
gen_champ="$(grep -m1 'file=.*\.seed' -o /tmp/multisystem/multisystem-mountpoint-iso/isolinux/text.cfg)"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*vmlinuz*")) root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) ${gen_champ} locale=$(echo "${LANG}" | sed "s/\..*//") bootkbd=${XKBLAYOUT} console-setup/layoutcode=${XKBLAYOUT} console-setup/variantcode=${XKBVARIANT} iso-scan/filename=/${osname} boot=casper noprompt quiet splash --"
osinitrd="initrd (loop)/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*initrd*"))"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#Hybryde NirvanOS
#http://hybryde.org/index.php?option=com_content&view=article&id=50&Itemid=86&lang=fr
elif [ "$(grep 'HYBRYDE LIVE' /tmp/multisystem/multisystem-mountpoint-iso/isolinux/txt.cfg 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osnamemodif="$(basename "${option2}")"
osicone="multisystem-hybryde"
gen_champ="$(grep -m1 'file=.*\.seed' -o /tmp/multisystem/multisystem-mountpoint-iso/isolinux/txt.cfg)"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*vmlinuz*")) root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) ${gen_champ} ${ubuntu_lang} iso-scan/filename=/${osname} boot=casper noprompt quiet splash --"
osinitrd="initrd (loop)/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*initrd*"))"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#AOSS
#http://www.pctools.com/aoss/details/
elif [ -f "/tmp/multisystem/multisystem-mountpoint-iso/system/stage3" ]; then
osname="$(basename "${option2}")"
osnamemodif="AOSS pctools"
osicone="multisystem-aoss"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/system/stage1 root=/dev/ram0 rw rdinit=/linuxrc video=vesa:ywrap,mtrr vga=0x303 loglevel=0 splash boot=cdrom LANG=en_US"
osinitrd="initrd (loop)/system/stage2"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#Salix Live (login/pass root/live puis startx)
#http://sourceforge.net/projects/salix/files/
#ramdisk_size=6666 root=/dev/ram0 rw grub2=install nosplash 2
elif [ "$(grep 'LABEL salixlive' /tmp/multisystem/multisystem-mountpoint-iso/boot/syslinux/syslinux.cfg 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osnamemodif="Salix Live"
osicone="multisystem-salix"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/boot/vmlinuz from=/${osname} ramdisk_size=6666 root=/dev/ram0 rw grub2=install nosplash"
osinitrd="initrd (loop)/boot/initrd.gz"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#Salix Live => salixlive-13.1.1.iso (login/pass root/live puis startx)
#http://sourceforge.net/projects/salix/files/
#ramdisk_size=6666 root=/dev/ram0 rw grub2=install nosplash 2
elif [ "$(grep '"Lancer Salix Live"' /tmp/multisystem/multisystem-mountpoint-iso/boot/grub/locale/fr_FR.utf8.cfg 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osnamemodif="Salix Live"
osicone="multisystem-salix"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/boot/vmlinuz root=/dev/ram0 rw quiet from=/${osname} lang=${LANG} keyb=${XKBLAYOUT} changes=slxsave.xfs"
osinitrd="initrd (loop)/boot/initrd.gz"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#Salix Live => salixlive-xfce-13.37-32.iso
#http://sourceforge.net/projects/salix/files/
#ramdisk_size=6666 root=/dev/ram0 rw grub2=install nosplash 2
#login ==> one
#pass ==> rien
elif [ -d "/tmp/multisystem/multisystem-mountpoint-iso/salixlive" ]; then
osname="$(basename "${option2}")"
osnamemodif="Salix Live"
osicone="multisystem-salix"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/boot/vmlinuz root=/dev/ram0 rw quiet fromiso=/${osname} lang=${LANG} keyb=${XKBLAYOUT}"
osinitrd="initrd (loop)/boot/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/boot -iname "*initrd*"))"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#Salix Non-Live!
#http://sourceforge.net/projects/salix/files/
elif [ "$(grep 'Salix' /tmp/multisystem/multisystem-mountpoint-iso/isolinux/message.txt 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osnamemodif="Salix Non-Live"
osicone="multisystem-salix"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/kernels/huge.s/bzImage from=/${osname} load_ramdisk=1 prompt_ramdisk=0 rw SLACK_KERNEL=huge.s"
osinitrd="initrd (loop)/isolinux/initrd.img"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#Slackel => (salixlive)  (login/pass root/live puis startx)
#http://sourceforge.net/projects/slackel/files/
elif [ -d "/tmp/multisystem/multisystem-mountpoint-iso/slackellive" ]; then
osname="$(basename "${option2}")"
osnamemodif="$(basename "${option2}")"
osicone="multisystem-slackel"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/boot/vmlinuz root=/dev/ram0 rw quiet max_loop=20 from=/${osname} lang=${LANG} keyb=${XKBLAYOUT} autologin"
osinitrd="initrd (loop)/boot/initrd.xz"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#AVG Rescue CD
#http://www.avg.com/ww-en/avg-rescue-cd-download
elif [ "$(grep 'AVG Technologies' /tmp/multisystem/multisystem-mountpoint-iso/CHANGELOG 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osnamemodif="AVG Rescue CD"
osicone="multisystem-avg"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/isolinux/vmlinuz  max_loop=255 video=vesafb:off init=linuxrc"
osinitrd="initrd (loop)/isolinux/initrd.lzm"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#Qimo 4 Kids
#http://www.qimo4kids.com/page/Download.aspx
elif [ "$(grep 'Qimo' /tmp/multisystem/multisystem-mountpoint-iso/.disk/info 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osnamemodif="Qimo 4 Kids"
osicone="multisystem-qimo"
gen_champ="$(grep -m1 'file=.*\.seed' -o /tmp/multisystem/multisystem-mountpoint-iso/isolinux/text.cfg)"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*vmlinuz*")) root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) ${gen_champ} locale=$(echo "${LANG}" | sed "s/\..*//") bootkbd=${XKBLAYOUT} console-setup/layoutcode=${XKBLAYOUT} console-setup/variantcode=${XKBVARIANT} iso-scan/filename=/${osname} boot=casper noprompt quiet splash --"
osinitrd="initrd (loop)/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*initrd*"))"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#Netrunner
#http://www.netrunner-os.com/
elif [ "$(grep 'Netrunner' /tmp/multisystem/multisystem-mountpoint-iso/.disk/info 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osnamemodif="Netrunner"
osicone="multisystem-netrunner"
gen_champ="$(grep -m1 'file=.*\.seed' -o /tmp/multisystem/multisystem-mountpoint-iso/isolinux/text.cfg)"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*vmlinuz*")) root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) ${gen_champ} locale=$(echo "${LANG}" | sed "s/\..*//") bootkbd=${XKBLAYOUT} console-setup/layoutcode=${XKBLAYOUT} console-setup/variantcode=${XKBVARIANT} iso-scan/filename=/${osname} boot=casper noprompt quiet splash --"
osinitrd="initrd (loop)/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*initrd*"))"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#Peppermint OS: 
#http://peppermintos.com/download
elif [ "$(grep 'Peppermint' /tmp/multisystem/multisystem-mountpoint-iso/.disk/info 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osicone="multisystem-peppermint"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/casper/vmlinuz root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) locale=$(echo "${LANG}" | sed "s/\..*//") bootkbd=${XKBLAYOUT} console-setup/layoutcode=${XKBLAYOUT} console-setup/variantcode=${XKBVARIANT} iso-scan/filename=/${osname} boot=casper file=/cdrom/preseed/mint.seed noprompt quiet splash --"
osinitrd="initrd (loop)/casper/initrd.lz"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#EasyPeasy
#http://www.geteasypeasy.com/
elif [ "$(grep 'EasyPeasy' /tmp/multisystem/multisystem-mountpoint-iso/.disk/info 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osnamemodif="EasyPeasy"
osicone="multisystem-easypeasy"
gen_champ="$(grep -m1 'file=.*\.seed' -o /tmp/multisystem/multisystem-mountpoint-iso/isolinux/text.cfg)"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*vmlinuz*")) root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) ${gen_champ} locale=$(echo "${LANG}" | sed "s/\..*//") bootkbd=${XKBLAYOUT} console-setup/layoutcode=${XKBLAYOUT} console-setup/variantcode=${XKBVARIANT} iso-scan/filename=/${osname} boot=casper noprompt quiet splash --"
osinitrd="initrd (loop)/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*initrd*"))"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#moonOS
#http://moonos.org/download
elif [ "$(grep 'moonOS' /tmp/multisystem/multisystem-mountpoint-iso/.disk/info 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osnamemodif="moonOS"
osicone="multisystem-moonos"
gen_champ="$(grep -m1 'file=.*\.seed' -o /tmp/multisystem/multisystem-mountpoint-iso/isolinux/isolinux.cfg)"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*vmlinuz*")) root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) ${gen_champ} ${ubuntu_lang} iso-scan/filename=/${osname} boot=casper noprompt quiet splash --"
osinitrd="initrd (loop)/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*initrd*"))"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#Darik's Boot And Nuke
#http://www.dban.org/
elif [ "$(grep 'Boot and Nuke: About' /tmp/multisystem/multisystem-mountpoint-iso/isolinux/about.txt 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osnamemodif="Darik\'s Boot And Nuke"
osicone="multisystem-dban"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/ISOLINUX/DBAN.BZI nuke=\"dwipe --autonuke\" silent"
osinitrd=""
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#Darik's Boot And Nuke >= 2.2.6
#http://www.dban.org/
elif [ -f "/tmp/multisystem/multisystem-mountpoint-iso/dban.bzi" ]; then
osname="$(basename "${option2}")"
osnamemodif="Darik\'s Boot And Nuke"
osicone="multisystem-dban"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/DBAN.BZI nuke=\"dwipe --autonuke\" silent"
osinitrd=""
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#Thinstation
#http://www.thinstation.org/LiveCD/
elif [ "$(md5sum /tmp/multisystem/multisystem-mountpoint-iso/isolinux.cfg 2>/dev/null | awk '{print $1}')" == "92d86a4b7e0d5be5f639af7cf5100dc4" ]; then
osname="$(basename "${option2}")"
osnamemodif="Thinstation LiveCD"
osicone="multisystem-thinstation"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/vmlinuz load_ramdisk=1 ramdisk_blocksize=4096 root=/dev/ram0 ramdisk_size=524288 splash=silent console=ttyS3"
osinitrd="initrd (loop)/initrd"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#elementary
#http://www.elementary-project.com/
elif [ "$(grep 'elementary' /tmp/multisystem/multisystem-mountpoint-iso/.disk/info 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osnamemodif="$(basename "${option2}")"
osicone="multisystem-elementary"
gen_champ="$(grep -m1 'file=.*\.seed' -o /tmp/multisystem/multisystem-mountpoint-iso/isolinux/isolinux.cfg)"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*vmlinuz*")) root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) ${gen_champ} locale=$(echo "${LANG}" | sed "s/\..*//") bootkbd=${XKBLAYOUT} console-setup/layoutcode=${XKBLAYOUT} console-setup/variantcode=${XKBVARIANT} iso-scan/filename=/${osname} boot=casper noprompt quiet splash --"
osinitrd="initrd (loop)/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*initrd*"))"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#Red Hat Enterprise Linux Server ==> RHEL6.0-20100414.0-AP-i386-DVD1.iso
#http://www.redhat.com/
elif [ "$(grep 'Red Hat Enterprise Linux 6.0' /tmp/multisystem/multisystem-mountpoint-iso/.discinfo 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osnamemodif="Red Hat Enterprise Linux 6.0"
osicone="multisystem-redhat"
osloopback=""
oskernel="linux16 /boot/syslinux/memdisk"
osinitrd="initrd16 /images/install.img"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
mkdir "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/images"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/images/install.img "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/images/install.img"

#VortexBox
#http://vortexbox.org/downloads/

#trixbox basée sur CentOS
#http://fonality.com/trixbox/downloads
elif [ "$(grep 'trixbox' /tmp/multisystem/multisystem-mountpoint-iso/.discinfo 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osnamemodif="trixbox Install"
osicone="multisystem-trixbox"
osloopback=""
oskernel="linux16 /boot/syslinux/memdisk"
osinitrd="initrd16 /trixbox.img"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/images/diskboot.img "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/trixbox.img"

#Red Hat Enterprise Linux Server
#http://www.redhat.com/
elif [ "$(grep 'Red Hat Enterprise Linux Server 5' /tmp/multisystem/multisystem-mountpoint-iso/.discinfo 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osnamemodif="Red Hat Enterprise Linux Server"
osicone="multisystem-redhat"
osloopback=""
oskernel="linux16 /boot/syslinux/memdisk"
osinitrd="initrd16 /redhat.img"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/images/diskboot.img "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/redhat.img"

#Vine Linux
#http://www.vinelinux.org/download.html
elif [ "$(grep 'Vine Linux' /tmp/multisystem/multisystem-mountpoint-iso/isolinux/isolinux.cfg 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osnamemodif="Vine Linux"
osicone="multisystem-vine"
osloopback=""
oskernel="linux16 /boot/syslinux/memdisk"
osinitrd="initrd16 /vine.img"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress "/tmp/multisystem/multisystem-mountpoint-iso/images/diskboot.img" "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/vine.img"

#Parsix
#http://sourceforge.net/projects/xfardic/files/Parsix-Mirror/
elif [ "$(grep 'menu label Start or install Parsix' /tmp/multisystem/multisystem-mountpoint-iso/boot/isolinux/isolinux.cfg 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osicone="multisystem-parsix"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
#fromiso=/${osname}
oskernel="linux (loop)/boot/isolinux/linux fromiso=/${osname} boot=parsix nomce quiet --"
osinitrd="initrd (loop)/boot/isolinux/initrd"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#Parsix => 3.5/3.6
#http://sourceforge.net/projects/xfardic/files/Parsix-Mirror/
elif [ "$(grep 'Parsix GNU/Linux 3.' /tmp/multisystem/multisystem-mountpoint-iso/boot/grub/grub.cfg 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osicone="multisystem-parsix"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
#fromiso=/${osname}
oskernel="linux (loop)/boot/linux fromiso=/${osname} boot=parsix quiet lang=us"
osinitrd="initrd (loop)/boot/initrd"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#Phinx Desktop (base PCLinuxOS)
#http://phinxdesktop.slyip.net/phinxdesktop/?page_id=11
elif [[ "$(grep -i 'phinxdesktop' <<<"$(basename "${option2}")")" && "$(grep -E '(theme=PCLinuxOS)' /tmp/multisystem/multisystem-mountpoint-iso/isolinux/gfxboot.cfg 2>/dev/null)" ]]; then
osname="$(basename "${option2}")"
osicone="multisystem-phinx"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/isolinux/vmlinuz fromusb root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) bootfromiso=/${osname} livecd=livecd root=/dev/rd/3 acpi=on vga=788 keyb=us vmalloc=256M nokmsboot splash=silent"
osinitrd="initrd (loop)/isolinux/initrd.gz"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#PCLinuxOS l/p root/root
#http://www.pclinuxos.com/
#changes_dev=
#changes_file=
#initrd ==> /etc/rc.d/rc.sysinit
#pas reussit a faire fonctionner mode persistent! ...
#dd if=/dev/zero of="$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/pclinuxos.save" bs=1M count=512
#mkfs.ext2 -L pclinuxos -F "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/pclinuxos.save"
#changes_dev=/dev/hda1 changes_file=/pclinuxos.save
elif [ "$(grep -E '(theme=PCLinuxOS)' /tmp/multisystem/multisystem-mountpoint-iso/isolinux/gfxboot.cfg 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osicone="multisystem-pclinuxos"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/isolinux/vmlinuz fromusb root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) bootfromiso=/${osname} livecd=livecd apci=on splash=silent fstab=rw,noauto unionfs"
osinitrd="initrd (loop)/isolinux/initrd.gz"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#ArtistX 1.2
#http://www.artistx.org/site3/download.html
elif [ "$(grep '^ArtistX' /tmp/multisystem/multisystem-mountpoint-iso/.disk/info 2>/dev/null)" ]; then
modiso="copycontent"
echo "artistx1" >/tmp/multisystem/multisystem-nomdistro
chemindeb="$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/artistx"
find "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")" -maxdepth 1 -path "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/artistx[0-9]" | while read line
do
echo "artistx$(($(echo $line | sed "s@${chemindeb}@@g")+1))" >/tmp/multisystem/multisystem-nomdistro
done
osname="$(cat /tmp/multisystem/multisystem-nomdistro)"
osnamemodif="ArtistX DVD"
osicone="multisystem-artistx"
osloopback=""
oskernel="linux /${osname}/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*vmlinuz*")) live-media-path=/${osname}/casper root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) file=/cdrom/${osname}/preseed/custom.seed locale=$(echo "${LANG}" | sed "s/\..*//") bootkbd=${XKBLAYOUT} console-setup/layoutcode=${XKBLAYOUT} console-setup/variantcode=${XKBVARIANT} boot=casper noprompt quiet splash --"
osinitrd="initrd /${osname}/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*initrd*"))"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${osname}"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/."

#JabirOS
#http://jabirproject.org/
elif [ "$(grep 'JabirOS' /tmp/multisystem/multisystem-mountpoint-iso/isolinux/isolinux.cfg 2>/dev/null)" ]; then
modiso="copycontent"
echo "ubuntu1" >/tmp/multisystem/multisystem-nomdistro
chemindeb="$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/ubuntu"
find "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")" -maxdepth 1 -path "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/ubuntu[0-9]" | while read line
do
echo "ubuntu$(($(echo $line | sed "s@${chemindeb}@@g")+1))" >/tmp/multisystem/multisystem-nomdistro
done
osname="$(cat /tmp/multisystem/multisystem-nomdistro)"
osnamemodif="$(basename "${option2}")"
osicone="multisystem-jabir"
gen_champ="$(grep -m1 'file=.*\.seed' -o /tmp/multisystem/multisystem-mountpoint-iso/isolinux/*.cfg 2>/dev/null)"
oskernel="linux /${osname}/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*vmlinuz*")) live-media-path=/${osname}/casper root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) $(sed 's%/cdrom/preseed/%/cdrom/'${osname}'/preseed/%' <<<"${gen_champ}") ${ubuntu_lang} boot=casper showmounts ignore_uuid noprompt quiet splash --"
osinitrd="initrd /${osname}/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*initrd*"))"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${osname}"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/."

#DarkRacer
#http://www.darkracer.org/download.html
elif [ "$(grep '^DarkRacer' /tmp/multisystem/multisystem-mountpoint-iso/.disk/info 2>/dev/null)" ]; then
modiso="copycontent"
echo "ubuntu1" >/tmp/multisystem/multisystem-nomdistro
chemindeb="$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/ubuntu"
find "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")" -maxdepth 1 -path "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/ubuntu[0-9]" | while read line
do
echo "ubuntu$(($(echo $line | sed "s@${chemindeb}@@g")+1))" >/tmp/multisystem/multisystem-nomdistro
done
osname="$(cat /tmp/multisystem/multisystem-nomdistro)"
osnamemodif="$(basename "${option2}")"
osicone="multisystem-darkracer"
gen_champ="$(grep -m1 'file=.*\.seed' -o /tmp/multisystem/multisystem-mountpoint-iso/isolinux/*.cfg 2>/dev/null)"
oskernel="linux /${osname}/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*vmlinuz*")) live-media-path=/${osname}/casper root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) $(sed 's%/cdrom/preseed/%/cdrom/'${osname}'/preseed/%' <<<"${gen_champ}") ${ubuntu_lang} boot=casper showmounts ignore_uuid noprompt quiet splash --"
osinitrd="initrd /${osname}/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*initrd*"))"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${osname}"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/."

#LuninuX OS
#http://luninuxos.com/?page_id=18
elif [ "$(grep '^LuninuX OS' /tmp/multisystem/multisystem-mountpoint-iso/.disk/info 2>/dev/null)" ]; then
modiso="copycontent"
echo "luninuxos1" >/tmp/multisystem/multisystem-nomdistro
chemindeb="$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/luninuxos"
find "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")" -maxdepth 1 -path "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/luninuxos[0-9]" | while read line
do
echo "luninuxos$(($(echo $line | sed "s@${chemindeb}@@g")+1))" >/tmp/multisystem/multisystem-nomdistro
done
osname="$(cat /tmp/multisystem/multisystem-nomdistro)"
osnamemodif="LuninuX OS"
osicone="multisystem-luninux"
osloopback=""
oskernel="linux /${osname}/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*vmlinuz*")) live-media-path=/${osname}/casper root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) file=/cdrom/${osname}/preseed/custom.seed ${ubuntu_lang} boot=casper noprompt quiet splash --"
osinitrd="initrd /${osname}/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*initrd*"))"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${osname}"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/."

#Blender-boot
#https://sourceforge.net/projects/blenderboot/
elif [ "$(grep '^Blender-boot' /tmp/multisystem/multisystem-mountpoint-iso/.disk/info 2>/dev/null)" ]; then
modiso="copycontent"
echo "blenderboot1" >/tmp/multisystem/multisystem-nomdistro
chemindeb="$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/blenderboot"
find "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")" -maxdepth 1 -path "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/blenderboot[0-9]" | while read line
do
echo "blenderboot$(($(echo $line | sed "s@${chemindeb}@@g")+1))" >/tmp/multisystem/multisystem-nomdistro
done
osname="$(cat /tmp/multisystem/multisystem-nomdistro)"
osnamemodif="Blender-boot"
osicone="multisystem-blenderboot"
osloopback=""
oskernel="linux /${osname}/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*vmlinuz*")) live-media-path=/${osname}/casper root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) file=/cdrom/${osname}/preseed/custom.seed ${ubuntu_lang} boot=casper noprompt quiet splash --"
osinitrd="initrd /${osname}/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*initrd*"))"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${osname}"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/."

#IPFire
#http://www.ipfire.org/download
elif [ "$(grep 'IPFire' /tmp/multisystem/multisystem-mountpoint-iso/README.txt 2>/dev/null)" ]; then
modiso="copycontent"
osname="$(basename $(ls /tmp/multisystem/multisystem-mountpoint-iso/ipfire-*.tlz))"
if [ ! -f "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/$osname" ]; then
osnamemodif="IPFire"
osicone="multisystem-ipfire"
osloopback=""
oskernel="linux /boot/bootdistro/ipfire/vmlinuz vga=791 splash=silent ro"
osinitrd="initrd /boot/bootdistro/ipfire/instroot"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/bootdistro/ipfire"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress "/tmp/multisystem/multisystem-mountpoint-iso/$osname" "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/$osname"
rsync -avS --progress "/tmp/multisystem/multisystem-mountpoint-iso/boot/isolinux/instroot" "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/bootdistro/ipfire/instroot"
rsync -avS --progress "/tmp/multisystem/multisystem-mountpoint-iso/boot/isolinux/vmlinuz" "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/bootdistro/ipfire/vmlinuz"
#zenity --info --text "osname:$osname"
else
zenity --error --text "$(eval_gettext "Erreur: LiveCD déjà présent.")"
fi

#AriOS
#http://arioslinux.org/download/
elif [ "$(grep '^AriOS' /tmp/multisystem/multisystem-mountpoint-iso/.disk/info 2>/dev/null)" ]; then
modiso="copycontent"
echo "arios1" >/tmp/multisystem/multisystem-nomdistro
chemindeb="$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/arios"
find "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")" -maxdepth 1 -path "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/arios[0-9]" | while read line
do
echo "arios$(($(echo $line | sed "s@${chemindeb}@@g")+1))" >/tmp/multisystem/multisystem-nomdistro
done
osname="$(cat /tmp/multisystem/multisystem-nomdistro)"
osnamemodif="AriOS"
osicone="multisystem-arios"
osloopback=""
gen_champ="$(grep -m1 'file=.*\.seed' -o /tmp/multisystem/multisystem-mountpoint-iso/isolinux/isolinux.cfg)"
oskernel="linux /${osname}/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*vmlinuz*")) live-media-path=/${osname}/casper root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) ${gen_champ} ${ubuntu_lang} boot=casper noprompt quiet splash --"
osinitrd="initrd /${osname}/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*initrd*"))"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${osname}"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/."

#ShilaOS
#https://sourceforge.net/projects/shilaos/
elif [ "$(grep 'ShilaOS' /tmp/multisystem/multisystem-mountpoint-iso/isolinux/isolinux.cfg 2>/dev/null)" ]; then
modiso="copycontent"
echo "ubuntu1" >/tmp/multisystem/multisystem-nomdistro
chemindeb="$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/ubuntu"
find "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")" -maxdepth 1 -path "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/ubuntu[0-9]" | while read line
do
echo "ubuntu$(($(echo $line | sed "s@${chemindeb}@@g")+1))" >/tmp/multisystem/multisystem-nomdistro
done
osname="$(cat /tmp/multisystem/multisystem-nomdistro)"
osnamemodif="ShilaOS"
osicone="multisystem-shilaos"
gen_champ="$(grep -m1 'file=.*\.seed' -o /tmp/multisystem/multisystem-mountpoint-iso/isolinux/*.cfg 2>/dev/null)"
oskernel="linux /${osname}/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*vmlinuz*")) live-media-path=/${osname}/casper root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) $(sed 's%/cdrom/preseed/%/cdrom/'${osname}'/preseed/%' <<<"${gen_champ}") ${ubuntu_lang} boot=casper showmounts ignore_uuid noprompt quiet splash --"
osinitrd="initrd /${osname}/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*initrd*"))"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${osname}"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/."

#APODIO jaunty (manque lupin-casper)
#http://sourceforge.net/projects/apodio/files/
elif [ "$(grep 'Try APODIO without any change to your computer' /tmp/multisystem/multisystem-mountpoint-iso/isolinux/isolinux.cfg 2>/dev/null)" ]; then
modiso="copycontent"
if [ ! -d "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/apodio" ]; then
osname="apodio"
osicone="multisystem-apodio"
osloopback="search --set -f \"/apodio/$(basename "${option2}")\"\nloopback loop \"/apodio/$(basename "${option2}")\""
oskernel="linux (loop)/casper/vmlinuz root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) locale=$(echo "${LANG}" | sed "s/\..*//") bootkbd=${XKBLAYOUT} console-setup/layoutcode=${XKBLAYOUT} console-setup/variantcode=${XKBVARIANT} iso-scan/filename=/apodio/$(basename "${option2}") boot=casper file=/cdrom/preseed/ubuntu.seed noprompt quiet splash --"
osinitrd="initrd /apodio/initrd.gz"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
mkdir "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/apodio"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress "${option2}" "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/apodio/$(basename "${source}")"
mkdir /tmp/multisystem/multisystem-modinitrd 2>/dev/null
cd /tmp/multisystem/multisystem-modinitrd
gzip -dc /tmp/multisystem/multisystem-mountpoint-iso/casper/initrd.gz | cpio -i
cp "${dossier}/divers/lupin-jaunty/05mountpoints_lupin" /tmp/multisystem/multisystem-modinitrd/scripts/casper-bottom/05mountpoints_lupin
cp "${dossier}/divers/lupin-jaunty/10custom_installation" /tmp/multisystem/multisystem-modinitrd/scripts/casper-bottom/10custom_installation
cp "${dossier}/divers/lupin-jaunty/10ntfs_3g" /tmp/multisystem/multisystem-modinitrd/scripts/casper-bottom/10ntfs_3g
cp "${dossier}/divers/lupin-jaunty/20iso_scan" /tmp/multisystem/multisystem-modinitrd/scripts/casper-premount/20iso_scan
cp "${dossier}/divers/lupin-jaunty/30custom_installation" /tmp/multisystem/multisystem-modinitrd/scripts/casper-premount/30custom_installation
cp "${dossier}/divers/lupin-jaunty/lupin-helpers" /tmp/multisystem/multisystem-modinitrd/scripts/lupin-helpers
find . | cpio -o -H newc | gzip -9 > "$(cat /tmp/multisystem/multisystem-mountpoint-usb)"/apodio/initrd.gz
cd -
rm -R /tmp/multisystem/multisystem-modinitrd
else
zenity --error --text "$(eval_gettext "Erreur: LiveCD déjà présent.")"
fi

#APODIO-7.03-BETA - Release i386
#http://www.apodio.org/?tag=download
#http://sourceforge.net/projects/apodio/files/
elif [ "$(grep 'APODIO-7' /tmp/multisystem/multisystem-mountpoint-iso/.disk/info 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osnamemodif="Apodio"
osicone="multisystem-apodio"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/casper/vmlinuz locale=$(echo "${LANG}" | sed "s/\..*//") bootkbd=${XKBLAYOUT} console-setup/layoutcode=${XKBLAYOUT} console-setup/variantcode=${XKBVARIANT} iso-scan/filename=/${osname} file=/cdrom/preseed/custom.seed boot=casper noprompt quiet splash --"
osinitrd="initrd /boot/bootdistro/apodio/initrd.gz"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
#Modifier ramdisk pour ajouter support option de boot ==> iso-scan/filename=/${osname}
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/bootdistro/apodio"
mkdir /tmp/multisystem/multisystem-modinitrd 2>/dev/null
cd /tmp/multisystem/multisystem-modinitrd
gzip -dc /tmp/multisystem/multisystem-mountpoint-iso/casper/initrd.gz | cpio -i
cp "${dossier}/divers/lupin-karmic/05mountpoints_lupin" /tmp/multisystem/multisystem-modinitrd/scripts/casper-bottom/05mountpoints_lupin
cp "${dossier}/divers/lupin-karmic/10custom_installation" /tmp/multisystem/multisystem-modinitrd/scripts/casper-bottom/10custom_installation
cp "${dossier}/divers/lupin-karmic/10ntfs_3g" /tmp/multisystem/multisystem-modinitrd/scripts/casper-bottom/10ntfs_3g
cp "${dossier}/divers/lupin-karmic/20iso_scan" /tmp/multisystem/multisystem-modinitrd/scripts/casper-premount/20iso_scan
cp "${dossier}/divers/lupin-karmic/30custom_installation" /tmp/multisystem/multisystem-modinitrd/scripts/casper-premount/30custom_installation
cp "${dossier}/divers/lupin-karmic/lupin-helpers" /tmp/multisystem/multisystem-modinitrd/scripts/lupin-helpers
find . | cpio -o -H newc | gzip -9 > "$(cat /tmp/multisystem/multisystem-mountpoint-usb)"/boot/bootdistro/apodio/initrd.gz
cd -
sudo rm -R /tmp/multisystem/multisystem-modinitrd

#Asturix (v3,v4 manque lupin-casper!)
#http://asturix.com/index.php
elif [ "$(grep '^Asturix' /tmp/multisystem/multisystem-mountpoint-iso/.disk/info 2>/dev/null)" ]; then
modiso="copycontent"
echo "asturix1" >/tmp/multisystem/multisystem-nomdistro
chemindeb="$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/asturix"
find "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")" -maxdepth 1 -path "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/asturix[0-9]" | while read line
do
echo "asturix$(($(echo $line | sed "s@${chemindeb}@@g")+1))" >/tmp/multisystem/multisystem-nomdistro
done
osname="$(cat /tmp/multisystem/multisystem-nomdistro)"
osnamemodif="Asturix"
osicone="multisystem-asturix"
osloopback=""
oskernel="linux /${osname}/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*vmlinuz*")) live-media-path=/${osname}/casper root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) file=/cdrom/${osname}/preseed/custom.seed ${ubuntu_lang} boot=casper noprompt quiet splash --"
osinitrd="initrd /${osname}/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*initrd*"))"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${osname}"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/."

#LUbuntu 9.10 Live i386 karmic
#https://launchpad.net/~lubuntu-desktop/+archive/ppa
#https://wiki.ubuntu.com/Lubuntu http://lubuntu.net/
elif [ "$(grep 'LUbuntu 9.10 Live i386' /tmp/multisystem/multisystem-mountpoint-iso/.disk/info 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osnamemodif="LUbuntu 9.10 Live i386"
osicone="multisystem-lubuntu"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/casper/vmlinuz locale=$(echo "${LANG}" | sed "s/\..*//") bootkbd=${XKBLAYOUT} console-setup/layoutcode=${XKBLAYOUT} console-setup/variantcode=${XKBVARIANT} iso-scan/filename=/${osname} boot=casper file=/cdrom/preseed/ubuntu.seed noprompt quiet splash --"
osinitrd="initrd /boot/bootdistro/lubuntu/initrd.gz"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
#Modifier ramdisk pour ajouter support option de boot ==> iso-scan/filename=/${osname}
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/bootdistro/lubuntu"
mkdir /tmp/multisystem/multisystem-modinitrd 2>/dev/null
cd /tmp/multisystem/multisystem-modinitrd
gzip -dc /tmp/multisystem/multisystem-mountpoint-iso/casper/initrd.gz | cpio -i
cp "${dossier}/divers/lupin-karmic/05mountpoints_lupin" /tmp/multisystem/multisystem-modinitrd/scripts/casper-bottom/05mountpoints_lupin
cp "${dossier}/divers/lupin-karmic/10custom_installation" /tmp/multisystem/multisystem-modinitrd/scripts/casper-bottom/10custom_installation
cp "${dossier}/divers/lupin-karmic/10ntfs_3g" /tmp/multisystem/multisystem-modinitrd/scripts/casper-bottom/10ntfs_3g
cp "${dossier}/divers/lupin-karmic/20iso_scan" /tmp/multisystem/multisystem-modinitrd/scripts/casper-premount/20iso_scan
cp "${dossier}/divers/lupin-karmic/30custom_installation" /tmp/multisystem/multisystem-modinitrd/scripts/casper-premount/30custom_installation
cp "${dossier}/divers/lupin-karmic/lupin-helpers" /tmp/multisystem/multisystem-modinitrd/scripts/lupin-helpers
find . | cpio -o -H newc | gzip -9 > "$(cat /tmp/multisystem/multisystem-mountpoint-usb)"/boot/bootdistro/lubuntu/initrd.gz
cd -
rm -R /tmp/multisystem/multisystem-modinitrd

#Tiny Core Linux (Micro Core)
#http://distro.ibiblio.org/pub/linux/distributions/tinycorelinux/
elif [ "$(grep -E '(tinycorelinux)' /tmp/multisystem/multisystem-mountpoint-iso/boot/isolinux/boot.msg 2>/dev/null)" ]; then
modiso="copycontent"
if [ ! -d "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/cde" ]; then
osname="cde"
osicone="multisystem-tinycore"
osnamemodif="Tiny Core Linux"
osloopback=""
oskernel="linux /cde/boot/vmlinuz quiet cde showapps desktop=flwm_topside"
osinitrd="initrd /cde/boot/core.gz"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/cde/boot"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/cde/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/cde/."
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/boot/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/cde/boot/."
else
zenity --error --text "$(eval_gettext "Erreur: LiveCD déjà présent.")"
fi

#Thinstation v5.0 (passe pas, à retester ...)
#Détection du squashfs se fait par rapport à la variable initrd=/path/initrd
#http://www.thinstation.org/LiveCD/
elif [ -f "/zzZZzz/tmp/multisystem/multisystem-mountpoint-iso/isolinux.cfg.tpl" ]; then
modiso="copycontent"
if [ ! -d "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/thinstation" ]; then
osname="thinstation"
osicone="multisystem-thinstation"
osnamemodif="Thinstation"
osloopback=""
oskernel="linux /thinstation/vmlinuz initrd=/thinstation/initrd intel_iommu=off amd_iommu=off video=uvesafb:800x600-32,mtrr:0,ywrap splash=silent,theme:default console=tty1 loglevel=3 LM=2"
osinitrd="initrd /thinstation/initrd"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/thinstation"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/thinstation/."
else
zenity --error --text "$(eval_gettext "Erreur: LiveCD déjà présent.")"
fi

#CAElinux 2010
#http://www.caelinux.com/CMS/
elif [ "$(grep '^CAELinux2010' /tmp/multisystem/multisystem-mountpoint-iso/.disk/info 2>/dev/null)" ]; then
modiso="copycontent"
echo "caelinux1" >/tmp/multisystem/multisystem-nomdistro
chemindeb="$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/caelinux"
find "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")" -maxdepth 1 -path "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/caelinux[0-9]" | while read line
do
echo "caelinux$(($(echo $line | sed "s@${chemindeb}@@g")+1))" >/tmp/multisystem/multisystem-nomdistro
done
osname="$(cat /tmp/multisystem/multisystem-nomdistro)"
osnamemodif="CAElinux"
osicone="multisystem-cae"
osloopback=""
oskernel="linux /${osname}/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*vmlinuz*")) rw live-media-path=/${osname}/casper root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) file=/cdrom/${osname}/preseed/custom.seed locale=$(echo "${LANG}" | sed "s/\..*//") bootkbd=${XKBLAYOUT} console-setup/layoutcode=${XKBLAYOUT} console-setup/variantcode=${XKBVARIANT} boot=casper noprompt quiet splash --"
osinitrd="initrd /${osname}/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*initrd*"))"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${osname}"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/."

#Poseidon
#http://sites.google.com/site/poseidonlinux/
elif [ "$(grep '^Poseidon' /tmp/multisystem/multisystem-mountpoint-iso/.disk/info 2>/dev/null)" ]; then
modiso="copycontent"
echo "poseidon1" >/tmp/multisystem/multisystem-nomdistro
chemindeb="$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/poseidon"
find "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")" -maxdepth 1 -path "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/poseidon[0-9]" | while read line
do
echo "poseidon$(($(echo $line | sed "s@${chemindeb}@@g")+1))" >/tmp/multisystem/multisystem-nomdistro
done
osname="$(cat /tmp/multisystem/multisystem-nomdistro)"
osnamemodif="Poseidon"
osicone="multisystem-poseidon"
osloopback=""
oskernel="linux /${osname}/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*vmlinuz*")) rw live-media-path=/${osname}/casper root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) file=/cdrom/${osname}/preseed/custom.seed locale=$(echo "${LANG}" | sed "s/\..*//") bootkbd=${XKBLAYOUT} console-setup/layoutcode=${XKBLAYOUT} console-setup/variantcode=${XKBVARIANT} boot=casper noprompt quiet splash --"
osinitrd="initrd /${osname}/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*initrd*"))"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${osname}"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/."

#Element login element pass (rien)
#http://www.elementmypc.com/main/get-element
#http://manpages.ubuntu.com/manpages/lucid/man7/casper.7.html
elif [ "$(grep 'Element v1.4 Live CD' /tmp/multisystem/multisystem-mountpoint-iso/.disk/info 2>/dev/null)" ]; then
modiso="copycontent"
echo "element1" >/tmp/multisystem/multisystem-nomdistro
chemindeb="$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/element"
find "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")" -maxdepth 1 -path "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/element[0-9]" | while read line
do
echo "element$(($(echo $line | sed "s@${chemindeb}@@g")+1))" >/tmp/multisystem/multisystem-nomdistro
done
osname="$(cat /tmp/multisystem/multisystem-nomdistro)"
osnamemodif="Element v1.4 Live CD"
osicone="multisystem-element"
osloopback=""
oskernel="linux /${osname}/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*vmlinuz*")) live-media-path=/${osname}/casper root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) file=/cdrom/${osname}/preseed/custom.seed locale=$(echo "${LANG}" | sed "s/\..*//") bootkbd=${XKBLAYOUT} console-setup/layoutcode=${XKBLAYOUT} console-setup/variantcode=${XKBVARIANT} boot=casper noprompt quiet splash --"
osinitrd="initrd /${osname}/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*initrd*"))"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${osname}"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/."

#Element login element pass (rien)
#http://www.elementmypc.com/main/get-element
elif [ "$(grep 'Element v1.3 Live CD' /tmp/multisystem/multisystem-mountpoint-iso/.disk/info 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osnamemodif="Element"
osicone="multisystem-element"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/casper/vmlinuz locale=$(echo "${LANG}" | sed "s/\..*//") bootkbd=${XKBLAYOUT} console-setup/layoutcode=${XKBLAYOUT} console-setup/variantcode=${XKBVARIANT} iso-scan/filename=/${osname} boot=casper file=/cdrom/preseed/custom.seed noprompt quiet splash --"
osinitrd="initrd /boot/bootdistro/element/initrd.gz"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
#Modifier ramdisk pour ajouter support option de boot ==> iso-scan/filename=/${osname}
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/bootdistro/element"
mkdir /tmp/multisystem/multisystem-modinitrd 2>/dev/null
cd /tmp/multisystem/multisystem-modinitrd
gzip -dc /tmp/multisystem/multisystem-mountpoint-iso/casper/initrd.gz | cpio -i
cp "${dossier}/divers/lupin-karmic/05mountpoints_lupin" /tmp/multisystem/multisystem-modinitrd/scripts/casper-bottom/05mountpoints_lupin
cp "${dossier}/divers/lupin-karmic/10custom_installation" /tmp/multisystem/multisystem-modinitrd/scripts/casper-bottom/10custom_installation
cp "${dossier}/divers/lupin-karmic/10ntfs_3g" /tmp/multisystem/multisystem-modinitrd/scripts/casper-bottom/10ntfs_3g
cp "${dossier}/divers/lupin-karmic/20iso_scan" /tmp/multisystem/multisystem-modinitrd/scripts/casper-premount/20iso_scan
cp "${dossier}/divers/lupin-karmic/30custom_installation" /tmp/multisystem/multisystem-modinitrd/scripts/casper-premount/30custom_installation
cp "${dossier}/divers/lupin-karmic/lupin-helpers" /tmp/multisystem/multisystem-modinitrd/scripts/lupin-helpers
find . | cpio -o -H newc | gzip -9 > "$(cat /tmp/multisystem/multisystem-mountpoint-usb)"/boot/bootdistro/element/initrd.gz
cd -
rm -R /tmp/multisystem/multisystem-modinitrd

#Likinux
#http://www.likinux.tk/
elif [ "$(grep '^Likinux' /tmp/multisystem/multisystem-mountpoint-iso/.disk/info 2>/dev/null)" ]; then
modiso="copycontent"
echo "likinux1" >/tmp/multisystem/multisystem-nomdistro
chemindeb="$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/likinux"
find "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")" -maxdepth 1 -path "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/likinux[0-9]" | while read line
do
echo "likinux$(($(echo $line | sed "s@${chemindeb}@@g")+1))" >/tmp/multisystem/multisystem-nomdistro
done
osname="$(cat /tmp/multisystem/multisystem-nomdistro)"
osnamemodif="Likinux"
osicone="multisystem-likinux"
osloopback=""
oskernel="linux /${osname}/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*vmlinuz*")) live-media-path=/${osname}/casper root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) file=/cdrom/${osname}/preseed/custom.seed boot=casper noprompt quiet splash --"
osinitrd="initrd /${osname}/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*initrd*"))"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${osname}"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/."

#PC Global Services
#http://www.services.com/gratuit/
#http://www.gpcservices.com/live-cd/
elif [ "$(grep 'gpcservices.ico' /tmp/multisystem/multisystem-mountpoint-iso/autorun.inf 2>/dev/null)" ]; then
modiso="copycontent"
echo "gpc1" >/tmp/multisystem/multisystem-nomdistro
chemindeb="$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/gpc"
find "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")" -maxdepth 1 -path "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/gpc[0-9]" | while read line
do
echo "gpc$(($(echo $line | sed "s@${chemindeb}@@g")+1))" >/tmp/multisystem/multisystem-nomdistro
done
osname="$(cat /tmp/multisystem/multisystem-nomdistro)"
osicone="multisystem-gpcservices"
#Menu 1
ligne1="menuentry \"GPC Reparer les erreurs sur le disque dur\" {"
ligne2=""
ligne3="linux16 /boot/syslinux/memdisk"
ligne4="initrd16 /${osname}/install/chkdsk.ima"
ligne5="}"
#Menu 2
ligne6="menuentry \"GPC Defragmenter le disque dur\" {"
ligne7=""
ligne8="linux16 /boot/syslinux/memdisk"
ligne9="initrd16 /${osname}/install/dfrgntfs.ima"
ligne10="}"
#Menu 3
ligne11="menuentry \"GPC Effacer les disques durs\" {"
ligne12=""
ligne13="linux16 /boot/syslinux/memdisk"
ligne14="initrd16 /${osname}/install/dban.ima"
ligne15="}"
#Menu 4
ligne16="menuentry \"GPC Demarrer Ubuntu\" {"
ligne17=""
ligne18="linux /${osname}/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*vmlinuz*")) live-media-path=/${osname}/casper root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) ${ubuntu_lang} file=/cdrom/${osname}/preseed/custom.seed boot=casper noprompt quiet splash --"
ligne19="initrd /${osname}/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*initrd*"))"
ligne20="}"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD4)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${osname}"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/."

#Parted Magic depuis 6.7 nouvelles option de boot !
#http://partedmagic.com/download.html
elif [ "$(grep 'Parted Magic' /tmp/multisystem/multisystem-mountpoint-iso/mkgriso 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osicone="multisystem-partedmagic"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/pmagic/bzImage uuid=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) iso_filename=/$(basename "${option2}") edd=off load_ramdisk=1 prompt_ramdisk=0 rw vga=normal loglevel=9 max_loop=256 vmalloc=256MiB $(echo "${LANG}" | sed "s/\..*//")"
if [ -f "/tmp/multisystem/multisystem-mountpoint-iso/pmagic/initrd.img" ]; then
osinitrd="initrd (loop)/pmagic/initrd.img"
else
osinitrd="initrd (loop)/pmagic/initramfs"
fi
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#OCZ OCZ Technology Linux SSD Tools (basée sur Parted Magic 6.4)
#http://www.ocztechnology.com/ssd_tools/
#blacklist
#directory
#iso_location
#iso_filename
#root
#label
#modprobe
#uuid
elif [ "$(grep 'OCZ Technology Linux SSD Tools' /tmp/multisystem/multisystem-mountpoint-iso/boot/syslinux/syslinux.cfg 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osnamemodif="OCZ Technology Linux SSD Tools"
osicone="multisystem-partedmagic"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/pmagic/bzImage uuid=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) iso_filename=/$(basename "${option2}") edd=off load_ramdisk=1 prompt_ramdisk=0 rw vga=normal nosshd nobluetooth nosmart numlock=on loglevel=9 max_loop=256 vmalloc=256MiB"
osinitrd="initrd (loop)/pmagic/initramfs"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#Redo Backup and Recovery (Xpud based) 0.9.9
#http://redobackup.org/
elif [ "$(grep -E '(MENU BACKGROUND bg_redo.png)' /tmp/multisystem/multisystem-mountpoint-iso/isolinux/isolinux.cfg 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osicone="multisystem-redo"
#Menu 1
ligne1="menuentry \"Redo Backup and Recovery\" {"
ligne2="loopback loop \"/${osname}\""
ligne3="linux (loop)/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*vmlinuz*")) root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) ${ubuntu_lang} iso-scan/filename=/${osname} boot=casper noprompt quiet splash --"
ligne4="initrd (loop)/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*initrd*"))"
ligne5="}"
#Menu 2
ligne6="menuentry \"Redo Backup and Recovery xforcevesa\" {"
ligne7="loopback loop \"/${osname}\""
ligne8="linux (loop)/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*vmlinuz*")) root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) ${ubuntu_lang} iso-scan/filename=/${osname} boot=casper noprompt xforcevesa quiet splash --"
ligne9="initrd (loop)/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*initrd*"))"
ligne10="}"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD2)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#Redo Backup and Recovery (Xpud based)
#http://redobackup.org/
elif [ "$(grep 'MENU BACKGROUND /boot/bg_redo.png' /tmp/multisystem/multisystem-mountpoint-iso/isolinux.cfg 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osicone="multisystem-redo"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/boot/bzImage noisapnp quiet lang=$(echo "${LANG}" | awk -F "_" '{print $1 }') kmap=${XKBLAYOUT}"
osinitrd="initrd (loop)/opt/core (loop)/opt/media"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#Xpud French
#http://www.xpud.org/
elif [ "$(grep 'KERNEL /boot/xpud' /tmp/multisystem/multisystem-mountpoint-iso/isolinux.cfg 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osicone="multisystem-xpud"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/boot/xpud noisapnp quiet lang=$(echo "${LANG}" | awk -F "_" '{print $1 }') kmap=${XKBLAYOUT}"
osinitrd=""
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#Xpud New!
#http://www.xpud.org/
#http://wiki.github.com/penk/mkxpud
#http://download.xpud.org/devel/
#http://github.com/penk/mkxpud
elif [ "$(grep 'KERNEL /boot/bzImage noisapnp quiet' /tmp/multisystem/multisystem-mountpoint-iso/isolinux.cfg 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osicone="multisystem-xpud"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/boot/bzImage noisapnp quiet lang=$(echo "${LANG}" | awk -F "_" '{print $1 }') kmap=${XKBLAYOUT}"
osinitrd="initrd (loop)/opt/core (loop)/opt/media"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#SMS Superb Mini Server
#http://sms.it-ccs.com/downloads.html
#
#http://sms.it-ccs.com/about.html
#Default passwords are:
#root password is toor
#Webmin Login: admin : admin
#TorrentFlux Login: admin : admin
elif [ "$(grep 'MENU LABEL Run SMS' /tmp/multisystem/multisystem-mountpoint-iso/boot/sms.cfg 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osnamemodif="SMS Superb Mini Server"
osicone="multisystem-sms"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/boot/vmlinuz slax from=/${osname} ramdisk_size=8888 root=/dev/ram0 rw"
osinitrd="initrd (loop)/boot/initrd.gz"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#RMS Rose
#http://rmsgnulinux.org/
elif [ "$(grep 'MENU LABEL RMS Graphics mode' /tmp/multisystem/multisystem-mountpoint-iso/boot/rms.cfg 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osicone="multisystem-grub"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/boot/vmlinuz slax from=/${osname} ramdisk_size=6666 root=/dev/ram0 rw autoexec=xconf autoexec=telinit~4 changes=/rms/"
osinitrd="initrd (loop)/boot/initrd.gz"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#zxmamecd
#http://www.zxmamecd.eu/
elif [ "$(grep 'MENU LABEL ZXMAMECD' /tmp/multisystem/multisystem-mountpoint-iso/boot/isolinux/isolinux.cfg 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osicone="multisystem-zxmame"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/boot/vmlinuz slax from=/${osname} ramdisk_size=6666 root=/dev/ram0 rw load=User locale=english noxconf nodhcp nofirewall faster changes=/zxmamecd/ run.x"
osinitrd="initrd (loop)/boot/initrd.gz"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#GoblinX
#http://www.uoc.lkams.kernel.org/pub/dist/goblinx/GoblinX-3.0/g.Standard-3.0.iso
elif [ "$(grep 'goblinx adduser=username' /tmp/multisystem/multisystem-mountpoint-iso/goblinx/cheatcodes.txt 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osicone="multisystem-goblinx"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/boot/vmlinuz slax from=/${osname} ramdisk_size=6666 root=/dev/ram0 rw load=KUser splash=silent changes=/goblinx/ kdm go.$(echo "${LANG}" | awk -F "_" '{print $1 }')"
osinitrd="initrd (loop)/boot/initrd.gz"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#Slax-LFI login/pass root:toor puis startx
#http://www.slaxlfi.fr/
elif [ "$(grep 'Slax-LFI' /tmp/multisystem/multisystem-mountpoint-iso/boot/slaxlfi.cfg 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osicone="multisystem-slax"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/boot/vmlinuz slax from=/${osname} ramdisk_size=6666 root=/dev/ram0 rw autoexec=telinit~4"
osinitrd="initrd (loop)/boot/initrd.gz"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#Imagineos (anciennement GoblinX) based on Slackware 13.1
#login/pass imagine/imagine root/ios08dez
#http://www.imagineos.com.br/ 
elif [ "$(grep -i 'MENU TITLE Imagineos' /tmp/multisystem/multisystem-mountpoint-iso//boot/isolinux/isolinux.cfg 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osicone="multisystem-imagineos"
#Menu 1
ligne1="menuentry \"Imagineos Kde (Desktop Mode)\" {"
ligne2="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
ligne3="linux (loop)/boot/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/boot -iname "*vmlinuz*")) from=/${osname} vga=788 ramdisk_size=9999 root=/dev/ram0 rw quiet splash=silent logo.nologo load=Skel Desktop changes=/imagineos/ kdm"
ligne4="initrd (loop)/boot/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/boot -iname "*initrd*"))"
ligne5="}"
#Menu 2
ligne6="menuentry \"Imagineos Kde (Netbook Mode)\" {"
ligne7="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
ligne8="linux (loop)/boot/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/boot -iname "*vmlinuz*")) from=/${osname} vga=788 ramdisk_size=9999 root=/dev/ram0 rw quiet splash=silent logo.nologo load=Netbook Netbook changes=/imagineos/ kdm"
ligne9="initrd (loop)/boot/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/boot -iname "*initrd*"))"
ligne10="}"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD2)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
#Dream Studio
#http://sourceforge.net/projects/dreamstudio/files/
elif [ "$(grep 'DreamStudio' /tmp/multisystem/multisystem-mountpoint-iso/.disk/info 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osnamemodif="Dream Studio"
osicone="multisystem-dreamstudio"
gen_champ="$(grep -m1 'file=.*\.seed' -o /tmp/multisystem/multisystem-mountpoint-iso/isolinux/txt.cfg)"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*vmlinuz*")) root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) ${gen_champ} ${ubuntu_lang} iso-scan/filename=/${osname} boot=casper noprompt quiet splash --"
osinitrd="initrd (loop)/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*initrd*"))"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#CDlinux
#http://cdlinux.info/wiki/doku.php/download/latest
elif [ -f "/tmp/multisystem/multisystem-mountpoint-iso/CDlinux/bzImage" ]; then
osname="$(basename "${option2}")"
#osnamemodif="cdlinux"
osicone="multisystem-cdlinux"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/CDlinux/bzImage quiet CDL_DEV=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) CDL_DIR=/ CDL_IMG=/${osname}"
osinitrd="initrd (loop)/CDlinux/initrd"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#Kongoni GNU/Linux OK! base slax peux aussi se mettre en copycotent voir Slax
#http://sourceforge.net/projects/kongoni/files/
elif [ "$(grep -i 'kongoni' /tmp/multisystem/multisystem-mountpoint-iso/boot/isolinux/isolinux.cfg 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
#osnamemodif="kongoni"
osicone="multisystem-kongoni"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/boot/vmlinuz from=/${osname} root=/dev/ram0 rw quiet"
osinitrd="initrd (loop)/boot/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/boot -iname "*initrd*"))"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#Wolvix
#http://wolvix.org/get.php
elif [ "$(grep 'MENU LABEL Run wolvix' /tmp/multisystem/multisystem-mountpoint-iso/boot/isolinux/isolinux.cfg 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
#osnamemodif="Wolvix"
osicone="multisystem-wolvix"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/boot/vmlinuz from=/${osname} changes=wolvixsave.xfs max_loop=255 ramdisk_size=6666 root=/dev/ram0 rw"
osinitrd="initrd (loop)/boot/initrd.gz"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#Grml
#http://grml.org/download/  findiso=     ignore_bootid
elif [ "$(grep -E "(DEFAULT grml)|(grml-team)" /tmp/multisystem/multisystem-mountpoint-iso/boot/isolinux/isolinux.cfg 2>/dev/null)" ]; then
modiso="copycontent"
echo "debian1" >/tmp/multisystem/multisystem-nomdebian
chemindeb="$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/debian"
find "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")" -maxdepth 1 -path "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/debian[0-9]" | while read line
do
echo "debian$(($(echo $line | sed "s@${chemindeb}@@g")+1))" >/tmp/multisystem/multisystem-nomdebian
done
osname="$(cat /tmp/multisystem/multisystem-nomdebian)"
osicone="multisystem-grml"
osnamemodif="Grml"
osloopback=""
oskernel="linux /${osname}$(ls /tmp/multisystem/multisystem-mountpoint-iso/boot/grml*/vmlinuz* | sed 's%/tmp/multisystem/multisystem-mountpoint-iso%%') rw root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) live-media-path=/${osname}/live/$(ls /tmp/multisystem/multisystem-mountpoint-iso/live* | sed 's%/tmp/multisystem/multisystem-mountpoint-iso%%') ignore_bootid boot=live apm=power-off vga=791 nomce startx lang=$(echo "${LANG}" | awk -F "_" '{print $1 }')"
osinitrd="initrd /${osname}$(ls /tmp/multisystem/multisystem-mountpoint-iso/boot/grml*/initrd* | sed 's%/tmp/multisystem/multisystem-mountpoint-iso%%')"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
mkdir "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${osname}"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/."

#DeLi Linux
#http://www.delilinux.org/wiki/doku.php?id=download
elif [ "$(grep 'DeLi Linux Wiki' /tmp/multisystem/multisystem-mountpoint-iso/INSTALL 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osicone="multisystem-deli"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/isolinux/bzImage load_ramdisk=1 prompt_ramdisk=0 ramdisk_size=6464 rw root=/dev/ram"
osinitrd="initrd (loop)/isolinux/initrd.gz"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#Joli OS ==> Jolicloud
#http://www.jolicloud.com/download
elif [ "$(grep 'Joli OS' /tmp/multisystem/multisystem-mountpoint-iso/.disk/info 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osnamemodif="Joli OS"
osicone="multisystem-Jolicloud"
gen_champ="$(grep -m1 'file=.*\.seed' -o /tmp/multisystem/multisystem-mountpoint-iso/isolinux/text.cfg)"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*vmlinuz*")) root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) ${gen_champ} ${ubuntu_lang} iso-scan/filename=/${osname} boot=casper noprompt quiet splash --"
osinitrd="initrd (loop)/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*initrd*"))"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#Jolicloud 1.1 "robby"
#http://www.jolicloud.com/download
elif [ "$(grep 'Jolicloud 1.1 "robby"' /tmp/multisystem/multisystem-mountpoint-iso/.disk/info 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osnamemodif="Jolicloud"
osicone="multisystem-Jolicloud"
gen_champ="$(grep -m1 'file=.*\.seed' -o /tmp/multisystem/multisystem-mountpoint-iso/isolinux/text.cfg)"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*vmlinuz*")) root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) ${gen_champ} locale=$(echo "${LANG}" | sed "s/\..*//") bootkbd=${XKBLAYOUT} console-setup/layoutcode=${XKBLAYOUT} console-setup/variantcode=${XKBVARIANT} iso-scan/filename=/${osname} boot=casper noprompt quiet splash --"
osinitrd="initrd (loop)/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*initrd*"))"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#jolicloud 1.0
#http://www.jolicloud.com/download
elif [ "$(grep 'Jolicloud' /tmp/multisystem/multisystem-mountpoint-iso/.disk/info 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osnamemodif="Jolicloud"
osicone="multisystem-Jolicloud"
gen_champ="$(grep -m1 'file=.*\.seed' -o /tmp/multisystem/multisystem-mountpoint-iso/isolinux/isolinux.cfg)"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*vmlinuz*")) root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) ${gen_champ} locale=$(echo "${LANG}" | sed "s/\..*//") bootkbd=${XKBLAYOUT} console-setup/layoutcode=${XKBLAYOUT} console-setup/variantcode=${XKBVARIANT} iso-scan/filename=/${osname} boot=casper noprompt quiet splash --"
osinitrd="initrd (loop)/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*initrd*"))"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#Guadalinex >= v8
#http://www.guadalinex.org/noticias/noticias/publicamos-la-prueba-de-concepto-de-guadalinex-v8/
elif [ "$(grep 'Guadalinex v8' /tmp/multisystem/multisystem-mountpoint-iso/isolinux/txt.cfg 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osnamemodif="$(basename "${option2}")"
osicone="multisystem-guadalinex"
gen_champ="$(grep -m1 'file=.*\.seed' -o /tmp/multisystem/multisystem-mountpoint-iso/isolinux/txt.cfg)"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*vmlinuz*")) root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) ${gen_champ} ${ubuntu_lang} iso-scan/filename=/${osname} boot=casper noprompt quiet splash --"
osinitrd="initrd (loop)/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*initrd*"))"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#UPR Ubuntu Privacy Remix
#https://www.privacy-cd.org/en/using-upr/download
elif [ "$(grep 'Ubuntu Privacy Remix' /tmp/multisystem/multisystem-mountpoint-iso/README.diskdefines 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osnamemodif="Ubuntu Privacy Remix"
osicone="multisystem-upr"
gen_champ="$(grep -m1 'file=.*\.seed' -o /tmp/multisystem/multisystem-mountpoint-iso/isolinux/txt.cfg)"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*vmlinuz*")) root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) ${gen_champ} ${ubuntu_lang} iso-scan/filename=/${osname} boot=casper noprompt quiet splash --"
osinitrd="initrd (loop)/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*initrd*"))"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#Linux_Mint 7
#http://www.linuxmint.com/download.php
elif [ "$(grep '^Linux_Mint' /tmp/multisystem/multisystem-mountpoint-iso/.disk/info 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osicone="multisystem-linuxmint"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/casper/vmlinuz boot=casper locale=$(echo "${LANG}" | sed "s/\..*//") bootkbd=${XKBLAYOUT} console-setup/layoutcode=${XKBLAYOUT} console-setup/variantcode=${XKBVARIANT} iso-scan/filename=/${osname} noprompt quiet splash --"
osinitrd="initrd (loop)/casper/initrd.gz"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#Linux_Mint 8/9
#http://www.linuxmint.com/download.php
elif [ "$(grep '^Linux Mint' /tmp/multisystem/multisystem-mountpoint-iso/.disk/info 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osicone="multisystem-linuxmint"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*vmlinuz*")) file=$(grep '\.seed' /tmp/multisystem/multisystem-mountpoint-iso/isolinux/isolinux.cfg | tail -n1 | cut -d= -f2 | cut -d" " -f1) boot=casper locale=$(echo "${LANG}" | sed "s/\..*//") bootkbd=${XKBLAYOUT} console-setup/layoutcode=${XKBLAYOUT} console-setup/variantcode=${XKBVARIANT} iso-scan/filename=/${osname} noprompt quiet splash --"
osinitrd="initrd (loop)/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*initrd*"))"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#LinuxMint Debian (LMDE)
#http://www.linuxmint.com/download.php
elif [[ "$(grep 'boot=live' /tmp/multisystem/multisystem-mountpoint-iso/isolinux/isolinux.cfg 2>/dev/null)" && "$(grep 'Linux Mint' /tmp/multisystem/multisystem-mountpoint-iso/isolinux/isolinux.cfg 2>/dev/null)" ]]; then
osname="$(basename "${option2}")"
osicone="multisystem-linuxmint"
#Menu 1
ligne1="menuentry \"${osname}\" {"
ligne2="loopback loop \"/${osname}\""
ligne3="linux (loop)/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*vmlinuz*")) root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) fromiso=/dev/disk/by-uuid/$(cat /tmp/multisystem/multisystem-selection-uuid-usb)/${osname}  boot=live config initrd=/casper/initrd.lz live-media-path=/casper noprompt quickreboot quiet splash --"
ligne4="initrd (loop)/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*initrd*"))"
ligne5="}"
#Menu 2
ligne6="menuentry \"${osname} (xforcevesa)\" {"
ligne7="loopback loop \"/${osname}\""
ligne8="linux (loop)/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*vmlinuz*")) fromiso=/dev/disk/by-uuid/$(cat /tmp/multisystem/multisystem-selection-uuid-usb)/${osname}  boot=live config xforcevesa initrd=/casper/initrd.lz live-media-path=/casper ramdisk_size=1048576 root=/dev/ram rw noapic noapci nosplash irqpoll noprompt quickreboot --"
ligne9="initrd (loop)/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*initrd*"))"
ligne10="}"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD2)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#LinuxMint Debian (LMDE)
#Install ne fonctionne pas car bug dans installeur sur chemin du squashfs
#http://forum.ubuntu-fr.org/viewtopic.php?pid=5866571#p5866571
#http://www.linuxmint.com/download.php
elif [[ "$(grep 'boot=live' /tmp/multisystem/multisystem-mountpoint-iso/isolinux/isolinux.cfg 2>/dev/null)" && "$(grep 'Linux Mint' /tmp/multisystem/multisystem-mountpoint-iso/isolinux/isolinux.cfg 2>/dev/null)" ]]; then
modiso="copycontent"
echo "lmde1" >/tmp/multisystem/multisystem-nomlmde
chemindeb="$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/lmde"
find "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")" -maxdepth 1 -path "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/lmde[0-9]" | while read line
do
echo "lmde$(($(echo $line | sed "s@${chemindeb}@@g")+1))" >/tmp/multisystem/multisystem-nomlmde
done
osname="$(cat /tmp/multisystem/multisystem-nomlmde)"
osicone="multisystem-linuxmint"
if [ "$(grep '32-bit' /tmp/multisystem/multisystem-mountpoint-iso/isolinux/isolinux.cfg 2>/dev/null)" ]; then
archlmde="32-bit"
elif [ "$(grep '64-bit' /tmp/multisystem/multisystem-mountpoint-iso/isolinux/isolinux.cfg 2>/dev/null)" ]; then
archlmde="64-bit"
fi
#Menu 1
ligne1="menuentry \"Linux Mint Debian (LMDE) ${archlmde}\" {"
ligne2=""
ligne3="linux /${osname}/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*vmlinuz*")) rw ignore_uuid root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) rootfstype=vfat boot=live config live-media-path=/${osname}/casper noprompt quickreboot quiet splash --"
ligne4="initrd /${osname}/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*initrd*"))"
ligne5="}"
#Menu 2
ligne6="menuentry \"Linux Mint Debian (LMDE) xforcevesa ${archlmde}\" {"
ligne7=""
ligne8="linux /${osname}/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*vmlinuz*")) rw ignore_uuid root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) rootfstype=vfat boot=live config xforcevesa live-media-path=/${osname}/casper ramdisk_size=1048576 root=/dev/ram rw noapic noapci nosplash irqpoll noprompt quickreboot --"
ligne9="initrd /${osname}/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*initrd*"))"
ligne10="}"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD2)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${osname}"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/."

#MoLinux ok
#http://www.molinux.info/index.php?option=com_remository
elif [ "$(grep 'Molinux' /tmp/multisystem/multisystem-mountpoint-iso/.disk/info 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osicone="multisystem-molinux"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/casper/vmlinuz locale=$(echo "${LANG}" | sed "s/\..*//") bootkbd=${XKBLAYOUT} console-setup/layoutcode=${XKBLAYOUT} console-setup/variantcode=${XKBVARIANT} iso-scan/filename=/${osname} boot=casper file=/cdrom/preseed/ubuntu.seed noprompt quiet splash --"
osinitrd="initrd (loop)/casper/initrd.gz"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#VectorLinux
#http://vector2.ecosq.com/downloads
elif [ "$(grep 'MENU TITLE Vector Linux Live' /tmp/multisystem/multisystem-mountpoint-iso/boot/isolinux/isolinux.cfg 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osicone="multisystem-vector"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
#v7
if [ -f "/tmp/multisystem/multisystem-mountpoint-iso/boot/initrd.xz" ]; then
oskernel="linux (loop)/boot/vmlinuz slax from=/${osname} vga=769 ramdisk_size=8666 root=/dev/ram0 rw"
osinitrd="initrd (loop)/boot/initrd.xz"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
#v6
elif [ -f "/tmp/multisystem/multisystem-mountpoint-iso/boot/initrd.gz" ]; then
oskernel="linux (loop)/boot/vmlinuz slax from=/${osname} auto2 splash=silent ramdisk_size=6666 root=/dev/ram0 rw"
osinitrd="initrd (loop)/boot/initrd.gz"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
else
zenity --error --text "$(eval_gettext "Erreur:iso non supporté actuellement.")"
FCT_RELOAD
exit 0
fi

#VectorLinux non-live
#http://vector2.ecosq.com/downloads
elif [ "$(grep 'Vector Linux' /tmp/multisystem/multisystem-mountpoint-iso/README 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osicone="multisystem-vector"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
#v7
if [ -f "/tmp/multisystem/multisystem-mountpoint-iso/isolinux/init.lz" ]; then
oskernel="linux (loop)/isolinux/kernel/sata from=/${osname} vga=normal splash=silent load_ramdisk=1 prompt_ramdisk=0 rw root=/dev/ram"
osinitrd="initrd (loop)/isolinux/init.lz"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
#v6
elif [ -f "/tmp/multisystem/multisystem-mountpoint-iso/isolinux/init.gz" ]; then
oskernel="linux (loop)/isolinux/kernel/sata from=/${osname} splash=verbose load_ramdisk=1 prompt_ramdisk=0 ramdisk_size=75000 rw root=/dev/ram"
osinitrd="initrd (loop)/isolinux/init.gz"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
else
zenity --error --text "$(eval_gettext "Erreur:iso non supporté actuellement.")"
FCT_RELOAD
exit 0
fi

#SLAMPP Live
#http://slampp.abangadek.com/info/index.php?page=download
elif [ "$(grep 'MENU LABEL Start ^SLAMPP' /tmp/multisystem/multisystem-mountpoint-iso/boot/isolinux/isolinux.cfg 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osicone="multisystem-slampp"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/boot/vmlinuz slax from=/${osname} max_loop=255 init=linuxrc load_ramdisk=1 prompt_ramdisk=0 ramdisk_size=6666 root=/dev/ram0 rw splash=silent keyb=us lang=en_US autologin"
osinitrd="initrd (loop)/boot/initrd.gz"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#"Ubuntu Electronics Remix" ok vu comme Ubuntu

#Super OS ok vu omme Ubuntu multisystem-superos.png
#http://hacktolive.org/wiki/Super_OS#DVD-ISO_download

#Zencafe: http://www.zencafe.web.id/downloads/
#http://www.zencafe.web.id/downloads/
elif [ "$(grep 'Zencafe' /tmp/multisystem/multisystem-mountpoint-iso/zenwalk/PACKAGES.TXT 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osicone="multisystem-zencafe"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/kernel/bzImage from=/${osname} load_ramdisk=1 prompt_ramdisk=0 rw root=/dev/null ZENWALK_KERNEL=ata nomodeset"
osinitrd="initrd (loop)/isolinux/initrd.img"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#Zenwalk Linux <= 6.2
#http://www.zenwalk.org/modules/tinycontent/index.php?id=1
elif [ "$(grep 'linux-live distros on one disk' /tmp/multisystem/multisystem-mountpoint-iso/zenlive/livecd.sgn 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osicone="multisystem-zenwalk"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/boot/vmlinuz from=/${osname} max_loop=255  init=linuxrc load_ramdisk=1 prompt_ramdisk=0 ramdisk_size=6666 root=/dev/ram0 rw splash=silent keyb=fr-latin9 lang=fr_FR.utf8 autologin changes=zensave.xfs"
osinitrd="initrd (loop)/boot/initrd.gz"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#Zenwalk Linux => 6.2 (pas encore de version livecd! en 6.2)
#http://www.zenwalk.org/modules/tinycontent/index.php?id=1
elif [ "$(grep 'Zenwalk' /tmp/multisystem/multisystem-mountpoint-iso/VERSION 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osicone="multisystem-zenwalk"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/kernel/bzImage from=/${osname} load_ramdisk=1 prompt_ramdisk=0 rw root=/dev/null ZENWALK_KERNEL=auto"
osinitrd="initrd (loop)/isolinux/initrd.img"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#Zenwalk 6.4
#init=linuxrc load_ramdisk=1 prompt_ramdisk=0 ramdisk_size=6666 root=/dev/ram0 rw vga=791 splash=silent keyb=fr-latin9 lang=fr_FR.utf8 autologin changes=zensave.xfs 

#Zenwalk Linux 7.0
#http://www.zenwalk.org/modules/tinycontent/index.php?id=1
elif [ "$(grep 'Zenwalk' /tmp/multisystem/multisystem-mountpoint-iso/zenwalk/PACKAGES.TXT 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osicone="multisystem-zenwalk"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/kernel/bzImage from=/${osname} load_ramdisk=1 prompt_ramdisk=0 rw root=/dev/null ZENWALK_KERNEL=auto"
osinitrd="initrd (loop)/isolinux/initrd.img"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#Beini
#http://www.ibeini.com/es/index.htm
elif [ "$(grep -E 'Start Beini' /tmp/multisystem/multisystem-mountpoint-iso/boot/isolinux/isolinux.cfg 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osnamemodif="Beini Core Linux"
osicone="multisystem-tinycore"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/boot/bzImage quiet waitusb=6"
osinitrd="initrd (loop)/boot/tinycore.gz"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#Linuxfx
#https://sourceforge.net/projects/linuxfxdevil/
elif [ "$(grep 'Linuxfx' /tmp/multisystem/multisystem-mountpoint-iso/isolinux/txt.cfg 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osnamemodif="Linuxfx"
osicone="multisystem-linuxfx"
gen_champ="$(grep -m1 'file=.*\.seed' -o /tmp/multisystem/multisystem-mountpoint-iso/isolinux/txt.cfg)"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*vmlinuz*")) root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) ${gen_champ} ${ubuntu_lang} iso-scan/filename=/${osname} boot=casper noprompt quiet splash --"
osinitrd="initrd (loop)/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*initrd*"))"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#Partition Wizard new
#http://www.partitionwizard.com/download.html
elif [ "$(grep 'Partition Wizard Boot Disc' /tmp/multisystem/multisystem-mountpoint-iso/BOOT/ISOLINUX/ISOLINUX.CFG 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osnamemodif="Partition Wizard"
osicone="multisystem-partition-wizard"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/BOOT/BZIMAGE ramdisk_size=92160 root=/dev/ram0 rw"
osinitrd="initrd (loop)/BOOT/tinycore.gz"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#Partition Wizard old
#http://www.partitionwizard.com/download.html
elif [ "$(grep 'Partition Wizard Boot Disc' /tmp/multisystem/multisystem-mountpoint-iso/boot/isolinux/isolinux.cfg 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osnamemodif="Partition Wizard"
osicone="multisystem-partition-wizard"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/boot/bzImage ramdisk_size=87040 root=/dev/ram0 rw"
osinitrd="initrd (loop)/boot/tinycore.gz"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#RIPLinuX
#http://www.tux.org/pub/people/kent-robotti/looplinux/rip/
elif [ "$(grep 'MENU TITLE RIPLinuX' /tmp/multisystem/multisystem-mountpoint-iso/boot/isolinux/isolinux.cfg 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osnamemodif="RIPLinuX"
osicone="multisystem-riplinux"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/boot/kernel32 root=/dev/ram0 rw"
osinitrd="initrd (loop)/boot/rootfs.cgz"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#Sidux
#persist
#http://www.sidux.com/module-Content-view-pid-2.html
elif [ "$(grep 'sidux 686' /tmp/multisystem/multisystem-mountpoint-iso/boot/grub/menu.lst 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
#osnamemodif="Sidux"
osicone="multisystem-sidux"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/boot/`find /tmp/multisystem/multisystem-mountpoint-iso/boot -iname "*vmlinuz-*-sidux-686" -exec basename {} \;` fromiso=/${osname} boot=fll quiet"
osinitrd="initrd (loop)/boot/`find /tmp/multisystem/multisystem-mountpoint-iso/boot -iname "*initrd.img-*-sidux-686" -exec basename {} \;`"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#Sidux new
#persist
#http://www.sidux.com/module-Content-view-pid-2.html
elif [ "$(grep 'sidux 686' /tmp/multisystem/multisystem-mountpoint-iso/boot/grub/grub.cfg 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
#osnamemodif="Sidux"
osicone="multisystem-sidux"
if [ "$(ls /tmp/multisystem/multisystem-mountpoint-iso/boot/vmlinuz* | wc -w)" == "1" ]; then
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/boot/`find /tmp/multisystem/multisystem-mountpoint-iso/boot -iname "*vmlinuz*" -exec basename {} \;` fromiso=/${osname} boot=fll quiet"
osinitrd="initrd (loop)/boot/`find /tmp/multisystem/multisystem-mountpoint-iso/boot -iname "*initrd*" -exec basename {} \;`"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
elif [ "$(ls /tmp/multisystem/multisystem-mountpoint-iso/boot/vmlinuz* | wc -w)" == "2" ]; then
#Menu i386
ligne1="menuentry \"Sidux i386\" {"
ligne2="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
ligne3="linux (loop)/boot/`find /tmp/multisystem/multisystem-mountpoint-iso/boot -iname "*vmlinuz*686" -exec basename {} \;` fromiso=/${osname} boot=fll quiet"
ligne4="initrd (loop)/boot/`find /tmp/multisystem/multisystem-mountpoint-iso/boot -iname "*initrd*686" -exec basename {} \;`"
ligne5="}"
#Menu amd
ligne6="menuentry \"Sidux amd\" {"
ligne7="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
ligne8="linux (loop)/boot/`find /tmp/multisystem/multisystem-mountpoint-iso/boot -iname "*vmlinuz*amd" -exec basename {} \;` fromiso=/${osname} boot=fll quiet"
ligne9="initrd (loop)/boot/`find /tmp/multisystem/multisystem-mountpoint-iso/boot -iname "*initrd*amd" -exec basename {} \;`"
ligne10="}"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD2)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
else
zenity --error --text "$(eval_gettext "Erreur:") Sidux"
fi

#VENENUX GNU/Linux passe pas reessayer avec fromiso, testé fromiso passe pas non plus .... 
#http://distrowatch.com/table.php?distribution=venenux
elif [ "$(grep 'VENENUX' /tmp/multisystem/multisystem-mountpoint-iso/boot/grub/menu.lst 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
#osnamemodif="VENENUX"
osicone="multisystem-venenux"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/boot/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/boot -iname "*vmlinuz*")) fromiso=/${osname} boot=fll quiet acpi_enforce_resources=lax"
osinitrd="initrd (loop)/boot/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/boot -iname "*initrd*"))"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#aptosid
#persist=/aptosid-rw
#http://manual.aptosid.com/en/hd-install-opts-en.htm#grub2-fromiso
elif [ "$(grep 'label aptosid' /tmp/multisystem/multisystem-mountpoint-iso/boot/isolinux/isolinux.cfg 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
#osnamemodif="aptosid"
osicone="multisystem-aptosid"
if [ "$(ls /tmp/multisystem/multisystem-mountpoint-iso/boot/vmlinuz* | wc -w)" == "1" ]; then
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/boot/`find /tmp/multisystem/multisystem-mountpoint-iso/boot -iname "*vmlinuz*" -exec basename {} \;` fromiso=/${osname} boot=fll quiet"
osinitrd="initrd (loop)/boot/`find /tmp/multisystem/multisystem-mountpoint-iso/boot -iname "*initrd*" -exec basename {} \;`"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
elif [ "$(ls /tmp/multisystem/multisystem-mountpoint-iso/boot/vmlinuz* | wc -w)" == "2" ]; then
#Menu i386
ligne1="menuentry \"aptosid i386\" {"
ligne2="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
ligne3="linux (loop)/boot/`find /tmp/multisystem/multisystem-mountpoint-iso/boot -iname "*vmlinuz*686" -exec basename {} \;` fromiso=/${osname} boot=fll quiet"
ligne4="initrd (loop)/boot/`find /tmp/multisystem/multisystem-mountpoint-iso/boot -iname "*initrd*686" -exec basename {} \;`"
ligne5="}"
#Menu amd
ligne6="menuentry \"aptosid amd\" {"
ligne7="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
ligne8="linux (loop)/boot/`find /tmp/multisystem/multisystem-mountpoint-iso/boot -iname "*vmlinuz*amd" -exec basename {} \;` fromiso=/${osname} boot=fll quiet"
ligne9="initrd (loop)/boot/`find /tmp/multisystem/multisystem-mountpoint-iso/boot -iname "*initrd*amd" -exec basename {} \;`"
ligne10="}"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD2)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
else
zenity --error --text "$(eval_gettext "Erreur:") aptosid"
fi

#ArchBang Linux SYMBIOSIS 2011
#http://www.archlinux.org/download/
#L/P root, et arch, km pour changer de clavier, Install /arch/setup
elif [ "$(grep 'ArchBang Linux' /tmp/multisystem/multisystem-mountpoint-iso/arch/boot/syslinux/syslinux.cfg 2>/dev/null)" ]; then
modiso="copycontent"
echo "arch1" >/tmp/multisystem/multisystem-nomdistro
chemindeb="$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/arch"
find "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")" -maxdepth 1 -path "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/arch[0-9]" | while read line
do
echo "arch$(($(echo $line | sed "s@${chemindeb}@@g")+1))" >/tmp/multisystem/multisystem-nomdistro
done
osname="$(cat /tmp/multisystem/multisystem-nomdistro)"
osicone="multisystem-archbang"
#Menu 1
ligne1="menuentry \"Boot ArchBang Linux [Xorg autodetect]\" {"
ligne2=""
ligne3="linux /${osname}/$(find /tmp/multisystem/multisystem-mountpoint-iso/arch/boot/ -iname "*vmlinuz*" | sed "s%/tmp/multisystem/multisystem-mountpoint-iso/arch/%%") archisobasedir=${osname} archisolabel=$(cat /tmp/multisystem/multisystem-selection-label-usb) locale=${LANG} quiet"
ligne4="initrd /${osname}/$(find /tmp/multisystem/multisystem-mountpoint-iso/arch/boot/ -iname "*archiso*" | sed "s%/tmp/multisystem/multisystem-mountpoint-iso/arch/%%")"
ligne5="}"
#Menu 2
ligne6="menuentry \"Boot ArchBang Linux [vesa]\" {"
ligne7=""
ligne8="linux /${osname}/$(find /tmp/multisystem/multisystem-mountpoint-iso/arch/boot/ -iname "*vmlinuz*" | sed "s%/tmp/multisystem/multisystem-mountpoint-iso/arch/%%") archisobasedir=${osname} archisolabel=$(cat /tmp/multisystem/multisystem-selection-label-usb) locale=${LANG} quiet xorg=vesa nomodeset"
ligne9="initrd /${osname}/$(find /tmp/multisystem/multisystem-mountpoint-iso/arch/boot/ -iname "*archiso*" | sed "s%/tmp/multisystem/multisystem-mountpoint-iso/arch/%%")"
ligne10="}"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD2)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${osname}"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/arch/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/."

#Archlemur
#http://liquidlemur.com/cms/downloads
elif [ "$(grep 'Liquid Lemur Linux' /tmp/multisystem/multisystem-mountpoint-iso/lemur/boot/syslinux/syslinux.cfg 2>/dev/null)" ]; then
modiso="copycontent"
echo "arch1" >/tmp/multisystem/multisystem-nomdistro
chemindeb="$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/arch"
find "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")" -maxdepth 1 -path "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/arch[0-9]" | while read line
do
echo "arch$(($(echo $line | sed "s@${chemindeb}@@g")+1))" >/tmp/multisystem/multisystem-nomdistro
done
osname="$(cat /tmp/multisystem/multisystem-nomdistro)"
osicone="multisystem-liquidlemur"
#Menu 1
ligne1="menuentry \"Archlemur\" {"
ligne2=""
ligne3="linux /${osname}/$(find /tmp/multisystem/multisystem-mountpoint-iso/lemur/boot/ -iname "*vmlinuz*" | sed "s%/tmp/multisystem/multisystem-mountpoint-iso/lemur/%%") archisobasedir=${osname} archisolabel=$(cat /tmp/multisystem/multisystem-selection-label-usb) locale=${LANG} quiet"
ligne4="initrd /${osname}/$(find /tmp/multisystem/multisystem-mountpoint-iso/lemur/boot/ -iname "*archiso*" | sed "s%/tmp/multisystem/multisystem-mountpoint-iso/lemur/%%")"
ligne5="}"
#Menu 2
ligne6="menuentry \"Archlemur [vesa]\" {"
ligne7=""
ligne8="linux /${osname}/$(find /tmp/multisystem/multisystem-mountpoint-iso/lemur/boot/ -iname "*vmlinuz*" | sed "s%/tmp/multisystem/multisystem-mountpoint-iso/arch/%%") archisobasedir=${osname} archisolabel=$(cat /tmp/multisystem/multisystem-selection-label-usb) locale=${LANG} quiet xorg=vesa nomodeset"
ligne9="initrd /${osname}/$(find /tmp/multisystem/multisystem-mountpoint-iso/lemur/boot/ -iname "*archiso*" | sed "s%/tmp/multisystem/multisystem-mountpoint-iso/arch/%%")"
ligne10="}"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD2)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${osname}"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/lemur/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/."

#IMPORTANT laisser au dessus de Archlinux !!!
#Nosonja
#https://plus.google.com/102479162698978916755/posts
elif [ "$(grep 'LABEL nosonja-normal' /tmp/multisystem/multisystem-mountpoint-iso/arch/boot/syslinux/archiso_sys.cfg 2>/dev/null)" ]; then
modiso="copycontent"
echo "arch1" >/tmp/multisystem/multisystem-nomdistro
chemindeb="$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/arch"
find "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")" -maxdepth 1 -path "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/arch[0-9]" | while read line
do
echo "arch$(($(echo $line | sed "s@${chemindeb}@@g")+1))" >/tmp/multisystem/multisystem-nomdistro
done
osname="$(cat /tmp/multisystem/multisystem-nomdistro)"
osicone="multisystem-nosonja"
osnamemodif="Nosonja"
oskernel="linux /${osname}/boot/i686/vmlinuz archisobasedir=${osname} archisolabel=$(cat /tmp/multisystem/multisystem-selection-label-usb) locale=fr_FR.UTF-8 rw_branch_size=75% ro quiet loglevel=3 console=tty1 splash=silent,theme:nosonja"
osinitrd="initrd /${osname}/boot/i686/archiso.img"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${osname}"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/arch/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/."

#Arch live
#http://godane.wordpress.com/
#findiso=/path/to/archiso-live-2009-08-19.iso.
#root password is ArchLinux
#arch password is arch
#http://arch-live.isawsome.net/iso/archiso/20090924/archiso-live-2009-09-24.iso
elif [ "$(grep 'MENU LABEL Archiso-Live CD' /tmp/multisystem/multisystem-mountpoint-iso/boot/isolinux/isolinux.cfg 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
#osnamemodif="RIPLinuX"
osicone="multisystem-arch"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/boot/vmlinuz findiso=/${osname} elevator=deadline lang=$(echo "${LANG}" | sed "s/\..*//") keyb=${XKBLAYOUT} session=xfce load=overlay usbdelay=5 acpi=off noapic pci=bios noxconf nohd"
osinitrd="initrd (loop)/boot/initrd.img"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#Arch live 2010
#http://godane.wordpress.com/
elif [ "$(grep 'Boot the Arch Linux live medium' /tmp/multisystem/multisystem-mountpoint-iso/boot/syslinux/syslinux.cfg 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
#osnamemodif="RIPLinuX"
osicone="multisystem-arch"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/boot/vmlinuz findiso=/${osname} locale=${LANG} load=overlay cdname=archiso-live session=xfce"
osinitrd="initrd (loop)/boot/initrd.img"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#archlinux Core ISOs:
#http://www.archlinux.org/download/
#Pas reussit passe pas!
#root=/dev/disk/by-uuid/xxx-xxx
elif [ "$(grep 'archisolabel=ARCHISO_AHCOHH6O' /tmp/multisystem/multisystem-mountpoint-iso/boot/isolinux/isolinux.cfg 2>/dev/null)" ]; then
modiso="copycontent"
if [ ! -f "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/isomounts" ]; then
osname="archlinux.iso"
osnamemodif="Archlinux Core ISOs"
osicone="multisystem-arch"
FCT_DOS1
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_GRUB4DOS)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/menu.lst"
#essai de reconstruction iso
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
mkdir -p /tmp/multisystem/multisystem-rebuildiso
rsync -avS --progress "/tmp/multisystem/multisystem-mountpoint-iso/." /tmp/multisystem/multisystem-rebuildiso
sudo cp /tmp/multisystem/multisystem-rebuildiso/boot/grub/menu.lst /tmp/multisystem/multisystem-rebuildiso/menu.lst
sudo cp "${dossier}/boot/img/grldr" /tmp/multisystem/multisystem-rebuildiso/grldr
sudo apt-get install -y git-core
cd /tmp/multisystem
git clone git://projects.archlinux.org/archiso.git
cd -
sudo mkdir /tmp/multisystem/multisystem-rebuildiso/boot/decomp
sudo mv /tmp/multisystem/multisystem-rebuildiso/boot/archiso_ide.img /tmp/multisystem/multisystem-rebuildiso/boot/archiso_ide.img.gz
sudo gzip -d /tmp/multisystem/multisystem-rebuildiso/boot/archiso_ide.img.gz
cd /tmp/multisystem/multisystem-rebuildiso/boot/decomp
sudo cpio -i --no-absolute-filenames < /tmp/multisystem/multisystem-rebuildiso/boot/archiso_ide.img
sudo cp -f /tmp/multisystem/archiso/archiso/hooks/archiso /tmp/multisystem/multisystem-rebuildiso/boot/decomp/hooks/archiso
sudo cp -f /tmp/multisystem/archiso/archiso/hooks/archiso-early /tmp/multisystem/multisystem-rebuildiso/boot/decomp/hooks/archiso-early
sudo rm /tmp/multisystem/multisystem-rebuildiso/boot/archiso_ide.img
find . | cpio -o -H newc | gzip -9 > /tmp/multisystem/archiso_ide.img
sudo mv /tmp/multisystem/archiso_ide.img /tmp/multisystem/multisystem-rebuildiso/boot/archiso_ide.img
sudo rm -R /tmp/multisystem/multisystem-rebuildiso/boot/decomp
cd -
sudo mkdir /tmp/multisystem/multisystem-rebuildiso/boot/decomp
sudo mv /tmp/multisystem/multisystem-rebuildiso/boot/archiso_pata.img /tmp/multisystem/multisystem-rebuildiso/boot/archiso_pata.img.gz
sudo gzip -d /tmp/multisystem/multisystem-rebuildiso/boot/archiso_pata.img.gz
cd /tmp/multisystem/multisystem-rebuildiso/boot/decomp
sudo cpio -i --no-absolute-filenames < /tmp/multisystem/multisystem-rebuildiso/boot/archiso_pata.img
sudo cp -f /tmp/multisystem/archiso/archiso/hooks/archiso /tmp/multisystem/multisystem-rebuildiso/boot/decomp/hooks/archiso
sudo cp -f /tmp/multisystem/archiso/archiso/hooks/archiso-early /tmp/multisystem/multisystem-rebuildiso/boot/decomp/hooks/archiso-early
sudo rm /tmp/multisystem/multisystem-rebuildiso/boot/archiso_pata.img
find . | cpio -o -H newc | gzip -9 > /tmp/multisystem/archiso_pata.img
sudo mv /tmp/multisystem/archiso_pata.img /tmp/multisystem/multisystem-rebuildiso/boot/archiso_pata.img
sudo rm -R /tmp/multisystem/multisystem-rebuildiso/boot/decomp
cd -
sudo rm -R /tmp/multisystem/archiso
sudo chmod 644 /tmp/multisystem/multisystem-rebuildiso/menu.lst
sudo cp -f /tmp/multisystem/multisystem-rebuildiso/core-pkgs.sqfs "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/core-pkgs.sqfs"
sudo cp -f /tmp/multisystem/multisystem-rebuildiso/isomounts "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/isomounts"
sudo cp -f /tmp/multisystem/multisystem-rebuildiso/overlay.sqfs "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/overlay.sqfs"
sudo cp -f /tmp/multisystem/multisystem-rebuildiso/root-image.sqfs "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/root-image.sqfs"
labelarch="$(cat /tmp/multisystem/multisystem-selection-label-usb)"
if [ "$labelarch" ]; then
sudo mlabel -i $(cat /tmp/multisystem/multisystem-selection-usb) ::multisystem
fi
sudo sed -i "s/ARCHISO_AHCOHH6O/\$labelarch/g" /tmp/multisystem/multisystem-rebuildiso/menu.lst
sudo rm /tmp/multisystem/multisystem-rebuildiso/core-pkgs.sqfs
sudo rm /tmp/multisystem/multisystem-rebuildiso/isomounts
sudo rm /tmp/multisystem/multisystem-rebuildiso/overlay.sqfs
sudo rm /tmp/multisystem/multisystem-rebuildiso/root-image.sqfs
#echo Attente, appuyez sur enter pour continuer.
#read
genisoimage -R -b grldr -V kingston -no-emul-boot -boot-load-seg 0x1000 -o "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/archlinux.iso" /tmp/multisystem/multisystem-rebuildiso
sudo rm -R /tmp/multisystem/multisystem-rebuildiso
else
zenity --error --text "$(eval_gettext "Erreur: LiveCD déjà présent.")"
fi

#Archlinux Core ISOs 2010
#http://www.archlinux.org/download/
#L/P root, et arch, km pour changer de clavier, Install /arch/setup
elif [ "$(grep 'archisolabel=ARCH_2010' /tmp/multisystem/multisystem-mountpoint-iso/boot/*linux/*linux.cfg 2>/dev/null)" ]; then
modiso="copycontent"
if [ ! -f "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/isomounts" ]; then
osname="archlinux"
osicone="multisystem-arch"
osloopback=""
#Dual architecture
if [[ "$(grep "i686" /tmp/multisystem/multisystem-mountpoint-iso/isomounts)" && "$(grep "x86_64" /tmp/multisystem/multisystem-mountpoint-iso/isomounts)" ]]; then
#Menu 1
ligne1="menuentry \"Archlinux 2010 Install 32Bits\" {"
ligne2=""
ligne3="linux /archlinux/boot/i686/vmlinuz26 archisolabel=$(cat /tmp/multisystem/multisystem-selection-label-usb) tmpfs_size=75% locale=${LANG}"
ligne4="initrd /archlinux/boot/i686/archiso.img"
ligne5="}"
#Menu 2
ligne6="menuentry \"Archlinux 2010 Install 64Bits\" {"
ligne7=""
ligne8="linux /archlinux/boot/x86_64/vmlinuz26 archisolabel=$(cat /tmp/multisystem/multisystem-selection-label-usb) tmpfs_size=75% locale=${LANG}"
ligne9="initrd /archlinux/boot/x86_64/archiso.img"
ligne10="}"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD2)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
#32Bits architecture
elif [ "$(grep "i686" /tmp/multisystem/multisystem-mountpoint-iso/isomounts)" ]; then
osnamemodif="Archlinux 2010 Install 32Bits"
oskernel="linux /archlinux/boot/vmlinuz26 locale=${LANG} archisolabel=$(cat /tmp/multisystem/multisystem-selection-label-usb) tmpfs_size=75%"
osinitrd="initrd /archlinux/boot/archiso.img"
#http://www.archbang.org/
if [ -f "/tmp/multisystem/multisystem-mountpoint-iso/boot/archbang.img" ]; then
osinitrd="initrd /archlinux/boot/archbang.img"
fi
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
#64Bits architecture
elif [ "$(grep "x86_64" /tmp/multisystem/multisystem-mountpoint-iso/isomounts)" ]; then
osnamemodif="Archlinux 2010 Install 64Bits"
oskernel="linux /archlinux/boot/vmlinuz26 locale=${LANG} archisolabel=$(cat /tmp/multisystem/multisystem-selection-label-usb) tmpfs_size=75%"
osinitrd="initrd /archlinux/boot/archiso.img"
#http://www.archbang.org/
if [ -f "/tmp/multisystem/multisystem-mountpoint-iso/boot/archbang.img" ]; then
osinitrd="initrd /archlinux/boot/archbang.img"
fi
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
fi
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/archlinux"
#Dual
if [[ "$(grep 'i686' /tmp/multisystem/multisystem-mountpoint-iso/isomounts)" && "$(grep 'x86_64' /tmp/multisystem/multisystem-mountpoint-iso/isomounts)" ]]; then
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/isomounts "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/isomounts"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/archlinux/."
sed -i "s@i686/@archlinux/i686/@" "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/isomounts"
sed -i "s@x86_64/@archlinux/x86_64/@" "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/isomounts"
sed -i "s@any/@archlinux/any/@" "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/isomounts"
#32Bits ou 64Bits
else
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/isomounts "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/isomounts"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/archlinux/."
sed -i "s@overlay.sqfs@archlinux/overlay.sqfs@" "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/isomounts"
sed -i "s@core-pkgs.sqfs@archlinux/core-pkgs.sqfs@" "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/isomounts"
sed -i "s@root-image.sqfs@archlinux/root-image.sqfs@" "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/isomounts"
fi
else
zenity --error --text "$(eval_gettext "Erreur: LiveCD déjà présent.")"
fi

#Archlinux Core ISOs 2011
#http://www.archlinux.org/download/
#L/P root, et arch, km pour changer de clavier, Install /arch/setup
elif [ -f "/tmp/multisystem/multisystem-mountpoint-iso/arch/aitab" ]; then
modiso="copycontent"
echo "arch1" >/tmp/multisystem/multisystem-nomdistro
cheminarch="$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/arch"
find "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")" -maxdepth 1 -path "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/arch[0-9]" | while read line
do
echo "arch$(($(echo $line | sed "s@${cheminarch}@@g")+1))" >/tmp/multisystem/multisystem-nomdistro
done
osname="$(cat /tmp/multisystem/multisystem-nomdistro)"
osicone="multisystem-arch"
#Dual architecture
if [[ "$(grep "i686" /tmp/multisystem/multisystem-mountpoint-iso/arch/aitab)" && "$(grep "x86_64" /tmp/multisystem/multisystem-mountpoint-iso/arch/aitab)" ]]; then
#Menu 1
ligne1="menuentry \"Archlinux 2011 Install 32Bits\" {"
ligne2=""
ligne3="linux /${osname}/boot/i686/vmlinuz archisobasedir=${osname} archisolabel=$(cat /tmp/multisystem/multisystem-selection-label-usb)"
ligne4="initrd /${osname}/boot/i686/archiso.img"
ligne5="}"
#Menu 2
ligne6="menuentry \"Archlinux 2011 Install 64Bits\" {"
ligne7=""
ligne8="linux /${osname}/boot/x86_64/vmlinuz archisobasedir=${osname} archisolabel=$(cat /tmp/multisystem/multisystem-selection-label-usb)"
ligne9="initrd /${osname}/boot/x86_64/archiso.img"
ligne10="}"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD2)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
#32Bits architecture i686
elif [ "$(grep "i686" /tmp/multisystem/multisystem-mountpoint-iso/arch/aitab)" ]; then
osnamemodif="Archlinux 2011 Install 32Bits"
oskernel="linux /${osname}/boot/i686/vmlinuz archisobasedir=${osname} archisolabel=$(cat /tmp/multisystem/multisystem-selection-label-usb)"
osinitrd="initrd /${osname}/boot/i686/archiso.img"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
#64Bits architecture x86_64
elif [ "$(grep "x86_64" /tmp/multisystem/multisystem-mountpoint-iso/arch/aitab)" ]; then
osnamemodif="Archlinux 2011 Install 64Bits"
oskernel="linux /${osname}/boot/x86_64/vmlinuz archisobasedir=${osname} archisolabel=$(cat /tmp/multisystem/multisystem-selection-label-usb)"
osinitrd="initrd /${osname}/boot/x86_64/archiso.img"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
fi
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${osname}"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/arch/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/."

#ArchLinux Live
#http://arch.alwaysdata.net/
elif [ "$(grep 'ArchLinux Live' /tmp/multisystem/multisystem-mountpoint-iso/syslinux/syslinux.cfg 2>/dev/null)" ]; then
modiso="copycontent"
echo "arch1" >/tmp/multisystem/multisystem-nomdistro
chemindeb="$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/arch"
find "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")" -maxdepth 1 -path "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/arch[0-9]" | while read line
do
echo "arch$(($(echo $line | sed "s@${chemindeb}@@g")+1))" >/tmp/multisystem/multisystem-nomdistro
done
osname="$(cat /tmp/multisystem/multisystem-nomdistro)"
osicone="multisystem-arch"
osnamemodif="ArchLinux Live"
oskernel="linux /${osname}/$(find /tmp/multisystem/multisystem-mountpoint-iso/arch/boot/ -iname "*vmlinuz*" | sed "s%/tmp/multisystem/multisystem-mountpoint-iso/arch/%%") archisobasedir=${osname} archisolabel=$(cat /tmp/multisystem/multisystem-selection-label-usb) locale=fr_FR.UTF-8 rw_branch_size=75%"
osinitrd="initrd /${osname}/$(find /tmp/multisystem/multisystem-mountpoint-iso/arch/boot/ -iname "*archiso*" | sed "s%/tmp/multisystem/multisystem-mountpoint-iso/arch/%%")"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${osname}"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/arch/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/."

#Manjaro
#http://manjarolinux.org/hp/download.html
elif [ "$(grep 'archisobasedir=manjaro' /tmp/multisystem/multisystem-mountpoint-iso/manjaro/boot/syslinux/syslinux.cfg 2>/dev/null)" ]; then
modiso="copycontent"
echo "manjaro1" >/tmp/multisystem/multisystem-nomdistro
chemindeb="$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/manjaro"
find "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")" -maxdepth 1 -path "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/manjaro[0-9]" | while read line
do
echo "manjaro$(($(echo $line | sed "s@${chemindeb}@@g")+1))" >/tmp/multisystem/multisystem-nomdistro
done
osname="$(cat /tmp/multisystem/multisystem-nomdistro)"
osicone="multisystem-manjaro"
#Menu 1
ligne1="menuentry \"Boot Manjaro Linux English\" {"
ligne2=""
ligne3="linux /${osname}/boot/x86_64/vmlinuz26 archisobasedir=${osname} archisolabel=$(cat /tmp/multisystem/multisystem-selection-label-usb) nouveau.modeset=1 i915.modeset=1 radeon.modeset=1"
ligne4="initrd /${osname}/boot/x86_64/manjaro.img"
ligne5="}"
#Menu 2
ligne6="menuentry \"Boot Manjaro Linux German\" {"
ligne7=""
ligne8="linux /${osname}/boot/x86_64/vmlinuz26 archisobasedir=${osname} archisolabel=$(cat /tmp/multisystem/multisystem-selection-label-usb)  nouveau.modeset=1 i915.modeset=1 radeon.modeset=1 lang=de"
ligne9="initrd /${osname}/boot/x86_64/manjaro.img"
ligne10="}"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD2)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${osname}"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/manjaro/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/."

#linuX-gamers Live DVD
#http://live.linux-gamers.net/?s=download
#overlay.sqfs Trop Gros! passe pas sur fat...

#linuX-gamers Live version >= 0.9.7 (version Lite edition) (base archlinux)
#http://live.linux-gamers.net/?s=download
elif [ "$(grep 'archisolabel=lglive' /tmp/multisystem/multisystem-mountpoint-iso/syslinux/syslinux.cfg 2>/dev/null)" ]; then
modiso="copycontent"
if [ ! -f "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/lglive" ]; then
osname="lglive"
osnamemodif="linuX-gamers"
osicone="multisystem-linuxgamers"
osloopback=""
oskernel="linux /lglive/boot/i686/vmlinuz26 lang=$(echo "${LANG}" | sed "s/_.*//") locale=${LANG} archisobasedir=lglive archisolabel=$(cat /tmp/multisystem/multisystem-selection-label-usb) rw_branch_size=25% changes=/lglive"
osinitrd="initrd /lglive/boot/i686/lglive.img"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/lglive"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/lglive/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/lglive/."
else
zenity --error --text "$(eval_gettext "Erreur: LiveCD déjà présent.")"
fi

#Ophcrack LiveCD XP
#http://sourceforge.net/projects/ophcrack/files/
elif [ "$(grep 'table0.bin' /tmp/multisystem/multisystem-mountpoint-iso//tables/xp_free_small/md5sum.txt 2>/dev/null)" ]; then
modiso="copycontent"
if [ ! -d "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/tables/xp_free_small" ]; then
osname="xp_free_small"
osnamemodif="$(basename "${option2}")"
osicone="multisystem-ophcrack"
osloopback=""
oskernel="linux /tables/xp_free_small/boot/bzImage rw root=/dev/null vga=normal autologin"
osinitrd="initrd /tables/xp_free_small/boot/rootfs.gz"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/tables/xp_free_small"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/boot "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/tables/xp_free_small/."
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/tables/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/tables/."
else
zenity --error --text "$(eval_gettext "Erreur: LiveCD déjà présent.")"
fi

#Ophcrack LiveCD Vista
#http://sourceforge.net/projects/ophcrack/files/
elif [ "$(grep 'table0.bin' /tmp/multisystem/multisystem-mountpoint-iso//tables/vista_free/md5sum.txt 2>/dev/null)" ]; then
modiso="copycontent"
if [ ! -d "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/tables/vista_free" ]; then
osname="vista_free"
osnamemodif="$(basename "${option2}")"
osicone="multisystem-ophcrack"
osloopback=""
oskernel="linux /tables/vista_free/boot/bzImage rw root=/dev/null vga=normal autologin"
osinitrd="initrd /tables/vista_free/boot/rootfs.gz"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/tables/vista_free"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/boot "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/tables/vista_free/."
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/tables/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/tables/."
else
zenity --error --text "$(eval_gettext "Erreur: LiveCD déjà présent.")"
fi

#linuX-gamers Live (version Lite edition) (base archlinux)
#http://live.linux-gamers.net/?s=download
elif [ "$(grep 'archisolabel=lglive' /tmp/multisystem/multisystem-mountpoint-iso/boot/isolinux/isolinux.cfg 2>/dev/null)" ]; then
modiso="copycontent"
if [ ! -f "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/isomounts" ]; then
osname="linuxgamers"
osnamemodif="linuX-gamers"
osicone="multisystem-linuxgamers"
osloopback=""
oskernel="linux /linuxgamers/boot/vmlinuz26 lang=$(echo "${LANG}" | sed "s/_.*//") locale=${LANG} archisolabel=$(cat /tmp/multisystem/multisystem-selection-label-usb) tmpfs_size=25% radeon.modeset=0 changes=/linuxgamers"
osinitrd="initrd /linuxgamers/boot/lglive.img"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/linuxgamers"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/isomounts "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/isomounts"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/linuxgamers/."
sed -i "s@root-image.sqfs@linuxgamers/root-image.sqfs@" "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/isomounts"
sed -i "s@overlay.sqfs@linuxgamers/overlay.sqfs@" "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/isomounts"
else
zenity --error --text "$(eval_gettext "Erreur: LiveCD déjà présent.")"
fi

#CTKarchLive 0.7
#dommage ont viré le fichier isomounts qui permettait d'en mettre plusieurs voir v0.6...
#http://calimeroteknik.free.fr/ctkarchlive/
elif [ "$(grep 'CTKArch 0.7' /tmp/multisystem/multisystem-mountpoint-iso/boot/syslinux/syslinux.cfg 2>/dev/null)" ]; then
modiso="copycontent"
if [ ! -f "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/root-image.sqfs" ]; then
osname="root-image.sqfs"
osicone="multisystem-arch"
#Menu 1
ligne1="menuentry \"CTKarchLive fr\" {"
ligne2=""
ligne3="linux /boot/bootdistro/root-image.sqfs/vmlinuz26 archisolabel=$(cat /tmp/multisystem/multisystem-selection-label-usb) locale=fr_FR.UTF-8 keymap=fr-pc,fr- quiet"
ligne4="initrd /boot/bootdistro/root-image.sqfs/archiso.img"
ligne5="}"
#Menu 2
ligne6="menuentry \"CTKarchLive en\" {"
ligne7=""
ligne8="linux /boot/bootdistro/root-image.sqfs/vmlinuz26 archisolabel=$(cat /tmp/multisystem/multisystem-selection-label-usb) locale=en_US.UTF-8 keymap=us,us- quiet"
ligne9="initrd /boot/bootdistro/root-image.sqfs/archiso.img"
ligne10="}"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD2)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/bootdistro/root-image.sqfs"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/root-image.sqfs "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/root-image.sqfs"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/boot/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/bootdistro/root-image.sqfs/."
else
zenity --error --text "$(eval_gettext "Erreur: LiveCD déjà présent.")"
fi

#CTKarchLive 0.6
#http://calimeroteknik.free.fr/ctkarchlive/
elif [ "$(grep 'CTKArch' /tmp/multisystem/multisystem-mountpoint-iso/boot/syslinux/syslinux.cfg 2>/dev/null)" ]; then
modiso="copycontent"
if [ ! -f "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/isomounts" ]; then
osname="ctkarchlive"
osicone="multisystem-arch"
#Menu 1
ligne1="menuentry \"CTKarchLive fr\" {"
ligne2=""
ligne3="linux /ctkarchlive/boot/vmlinuz26 archisolabel=$(cat /tmp/multisystem/multisystem-selection-label-usb) locale=fr_FR.UTF-8 keymap=fr-pc,fr- quiet"
ligne4="initrd /ctkarchlive/boot/archiso.img"
ligne5="}"
#Menu 2
ligne6="menuentry \"CTKarchLive en\" {"
ligne7=""
ligne8="linux /ctkarchlive/boot/vmlinuz26 archisolabel=$(cat /tmp/multisystem/multisystem-selection-label-usb) locale=en_US.UTF-8 keymap=us,us- quiet"
ligne9="initrd /ctkarchlive/boot/archiso.img"
ligne10="}"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD2)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/ctkarchlive"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/isomounts "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/isomounts"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/ctkarchlive/."
sed -i "s@root-image.sqfs@ctkarchlive/root-image.sqfs@" "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/isomounts"
sed -i "s@overlay.sqfs@ctkarchlive/overlay.sqfs@" "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/isomounts"
else
zenity --error --text "$(eval_gettext "Erreur: LiveCD déjà présent.")"
fi

#CentOS
#http://www.centos.org/modules/tinycontent/index.php?id=15
elif [[ -d "/tmp/multisystem/multisystem-mountpoint-iso/LiveOS" && "$(grep 'CentOS' /tmp/multisystem/multisystem-mountpoint-iso/isolinux/isolinux.cfg 2>/dev/null)" ]]; then
modiso="copycontent"
if [ ! -d "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/LiveOS" ]; then
osname="liveos"
osnamemodif="CentOS"
osicone="multisystem-centos"
osloopback=""
oskernel="linux /boot/bootdistro/liveos/vmlinuz0 root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) rootfstype=vfat ro quiet liveimg "
osinitrd="initrd /boot/bootdistro/liveos/initrd0.img"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/LiveOS"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/bootdistro/liveos"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/isolinux/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/bootdistro/liveos/."
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/LiveOS/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/LiveOS/."
else
zenity --error --text "$(eval_gettext "Erreur: LiveCD déjà présent.")"
fi

#CentOS netinstall (version 5.7)
#http://mirror.its.sfu.ca/mirror/CentOS/
elif [[ "$(grep '^D ISOLINUX' /tmp/multisystem/multisystem-mountpoint-iso/TRANS.TBL 2>/dev/null)" && "$(wc -l /tmp/multisystem/multisystem-mountpoint-iso/TRANS.TBL 2>/dev/null | awk '{print $1}')" = "1" ]]; then
osname="$(basename "${option2}")"
osicone="multisystem-centos"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/isolinux/vmlinuz"
osinitrd="initrd (loop)/isolinux/initrd.img "
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#CentOS netinstall
#http://mirror.its.sfu.ca/mirror/CentOS/
elif [ "$(grep '^F INSTALL.IMG;1' /tmp/multisystem/multisystem-mountpoint-iso/images/TRANS.TBL 2>/dev/null)" ]; then
modiso="copycontent"
if [ ! -d "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/centos" ]; then
osname="centos"
osicone="multisystem-centos"
osnamemodif="CentOS netinstall"
osloopback=""
oskernel="linux /centos/isolinux/vmlinuz"
osinitrd="initrd /centos/isolinux/initrd.img"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/centos"
#centos/images/install.img
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/centos/."
else
zenity --error --text "$(eval_gettext "Erreur: LiveCD déjà présent.")"
fi

#KnoppiXMAME
#http://sourceforge.net/projects/knoppixmame/
elif [ "$(grep 'zzZZzzKnoppiXMAME' /tmp/multisystem/multisystem-mountpoint-iso/isolinux/isolinux.cfg 2>/dev/null)" ]; then
modiso="copycontent"
if [ ! -d "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/roms" ]; then
osname="roms"
osicone="multisystem-knoppix"
#Menu 1
ligne1="menuentry \"KnoppiXMAME \" {"
ligne2=""
ligne3="linux /roms/KnoppiXMAME elevator=cfq reallyquiet init=/etc/init lang=us noapm vga=791 nomce rw BOOT_IMAGE=knoppix"
ligne4="initrd /roms/miniroot.gz"
ligne5="}"
#Menu 2
ligne6="menuentry \"KnoppiXMAME addroms\" {"
ligne7=""
ligne8="linux /roms/KnoppiXMAME elevator=cfq reqllyquiet init=/etc/init lang=us noapm vga=791 nomce rw BOOT_IMAGE=knoppix addroms"
ligne9="initrd /roms/miniroot.gz"
ligne10="}"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD2)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/roms"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/rootsquash "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/rootsquash"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/isolinux/miniroot.gz "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/roms/miniroot.gz"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/isolinux/KnoppiXMAME "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/roms/KnoppiXMAME"
else
zenity --error --text "$(eval_gettext "Erreur: LiveCD déjà présent.")"
fi

#AUSTRUMI
#http://cyti.latgola.lv/ruuni/
elif [ "$(grep 'LABEL austrumi' /tmp/multisystem/multisystem-mountpoint-iso/isolinux.cfg 2>/dev/null)" ]; then
modiso="copycontent"
if [ ! -d "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/austrumi" ]; then
osname="austrumi"
osnamemodif="AUSTRUMI"
osicone="multisystem-austrumi"
osloopback=""
oskernel="linux /austrumi/bzImage dousb"
osinitrd="initrd /austrumi/initrd.gz"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/austrumi"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/austrumi/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/austrumi/."
else
zenity --error --text "$(eval_gettext "Erreur: LiveCD déjà présent.")"
fi

#VBA vba32rescue VirusBlokAda (vbarescue.iso)
#ftp://anti-virus.by/pub/vbarescue.iso
elif [ "$(grep 'vba32rescue' /tmp/multisystem/multisystem-mountpoint-iso/vba/grub/grub.cfg 2>/dev/null)" ]; then
modiso="copycontent"
if [ ! -d "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/vba" ]; then
osname="vba"
osnamemodif="vba32rescue"
osicone="multisystem-vba"
osloopback=""
oskernel="linux /vba/kernel looptype=squashfs loop=/vba/vba.squash quiet"
osinitrd="initrd /vba/initrd"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/vba"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/vba/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/vba/."
else
zenity --error --text "$(eval_gettext "Erreur: LiveCD déjà présent.")"
fi

#Avira AntiVir Rescue System
#http://dlpro.antivir.com/package/rescue_system/common/en/rescue_system-common-en.iso
elif [ "$(grep 'Avira Rescue System' /tmp/multisystem/multisystem-mountpoint-iso/license.txt 2>/dev/null)" ]; then
modiso="copycontent"
if [ ! -d "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/antivir" ]; then
osname="antivir"
osnamemodif="Avira AntiVir Rescue System"
osicone="multisystem-avira"
osloopback=""
oskernel="linux /antivir/vmlinuz ramdisk_size=133551 root=/dev/ram0 rw  console=/dev/vc/4"
osinitrd="initrd /antivir/initrd.gz"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/antivir"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/avupdate"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/antivir/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/antivir/."
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/avupdate/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/avupdate/."
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/initrd.gz "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/antivir/initrd.gz"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/vmlinuz "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/antivir/vmlinuz"
else
zenity --error --text "$(eval_gettext "Erreur: LiveCD déjà présent.")"
fi

#UHU-Linux
#http://uhulinux.hu/office/letoltes
elif [ "$(grep 'UHU-Linux' /tmp/multisystem/multisystem-mountpoint-iso/boot/isolinux/isolinux.cfg 2>/dev/null)" ]; then
modiso="copycontent"
if [ ! -f "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/uhulinux.img" ]; then
osname="uhulinux.img"
osicone="multisystem-uhu"
#Menu 1
ligne1="menuentry \"UHU-Linux 32 Bits\" {"
ligne2=""
ligne3="linux /boot/bootdistro/uhulinux.img/bzimage.32 lang=en boot=livecd:$(cat /tmp/multisystem/multisystem-selection-label-usb)"
ligne4="initrd /boot/bootdistro/uhulinux.img/initram.32"
ligne5="}"
#Menu 2
ligne6="menuentry \"UHU-Linux 64 Bits\" {"
ligne7=""
ligne8="linux /boot/bootdistro/uhulinux.img/bzimage.64 lang=en boot=livecd:$(cat /tmp/multisystem/multisystem-selection-label-usb)"
ligne9="initrd /boot/bootdistro/uhulinux.img/initram.64"
ligne10="}"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD2)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/bootdistro/uhulinux.img"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/boot/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/bootdistro/uhulinux.img/."
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/uhulinux.img "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/uhulinux.img"
else
zenity --error --text "$(eval_gettext "Erreur: LiveCD déjà présent.")"
fi

#LinuxConsole
#http://linuxconsole.org/old-index/wikifr/doku.php?id=man:admin10
#http://linuxconsole.org/1.0/book/lc2008fr.pdf
elif [ "$(grep 'LinuxConsole.*Yann Le Doare' /tmp/multisystem/multisystem-mountpoint-iso/isolinux/isolinux.cfg 2>/dev/null)" ]; then
modiso="copycontent"
if [ ! -d "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/linuxconsole" ]; then
osname="linuxconsole"
osicone="multisystem-linuxconsole"
#relever init et kernel
linuxconsole_k="$(grep -m1 KERNEL /tmp/multisystem/multisystem-mountpoint-iso/isolinux/isolinux.cfg | awk '{print $2}')"
grep -m1 'initrd=.*' -o /tmp/multisystem/multisystem-mountpoint-iso/isolinux/isolinux.cfg >/tmp/multisystem/var_initrd
. /tmp/multisystem/var_initrd
linuxconsole_i="${initrd}"
#Menu 1
ligne1="menuentry \"LinuxConsole Francais\" {"
ligne2=""
ligne3="linux /linuxconsole/isolinux/${linuxconsole_k} max_loop=255 quiet quiet loglevel=0 vga=785  lang=fr"
ligne4="initrd /linuxconsole/isolinux/${linuxconsole_i}"
ligne5="}"
#Menu 2
ligne6="menuentry \"LinuxConsole English\" {"
ligne7=""
ligne8="linux /linuxconsole/isolinux/${linuxconsole_k} max_loop=255 quiet quiet loglevel=0 vga=785  lang=en"
ligne9="initrd /linuxconsole/isolinux/${linuxconsole_i}"
ligne10="}"
#Menu 3
ligne11="menuentry \"LinuxConsole Italiano\" {"
ligne12=""
ligne13="linux /linuxconsole/isolinux/${linuxconsole_k} max_loop=255 quiet quiet loglevel=0 vga=785  lang=it"
ligne14="initrd /linuxconsole/isolinux/${linuxconsole_i}"
ligne15="}"
#Menu 4
ligne16="menuentry \"LinuxConsole Deutch\" {"
ligne17=""
ligne18="linux /linuxconsole/isolinux/${linuxconsole_k} max_loop=255 quiet quiet loglevel=0 vga=785  lang=de"
ligne19="initrd /linuxconsole/isolinux/${linuxconsole_i}"
ligne20="}"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD4)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/linuxconsole"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/linuxconsole/."
else
zenity --error --text "$(eval_gettext "Erreur: LiveCD déjà présent.")"
fi

#Absolute Linux
#http://www.absolutelinux.org/download.shtml
elif [ "$(grep 'Absolute' /tmp/multisystem/multisystem-mountpoint-iso/isolinux/message.txt 2>/dev/null)" ]; then
modiso="copycontent"
if [ ! -d "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/absolute" ]; then
osname="absolute"
osnamemodif="Absolute Linux non-live"
osicone="multisystem-absolute"
osloopback=""
oskernel="linux /absolute/kernels/hugesmp.s/bzImage load_ramdisk=1 prompt_ramdisk=0 rw SLACK_KERNEL=hugesmp.s"
osinitrd="initrd /absolute/isolinux/initrd.img"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/absolute"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/absolute/."
else
zenity --error --text "$(eval_gettext "Erreur: LiveCD déjà présent.")"
fi

#Dynebolic
#http://www.dynebolic.org/index.php?show=available
elif [ -f "/tmp/multisystem/multisystem-mountpoint-iso/dyne/initrd.gz" ]; then
modiso="copycontent"
if [ ! -d "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/dyne" ]; then
osname="dyne"
osnamemodif="Dynebolic"
osicone="multisystem-dynebolic"
osloopback=""
oskernel="linux /dyne/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/dyne -iname "*krn")) root=/dev/ram0 rw load_ramdisk=1 max_loop=64"
osinitrd="initrd /dyne/initrd.gz"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/dyne"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/dyne/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/dyne/."
else
zenity --error --text "$(eval_gettext "Erreur: LiveCD déjà présent.")"
fi

#Dynebolic >= 3.0
#http://www.dynebolic.org/index.php?show=available
elif [ -f "/tmp/multisystem/multisystem-mountpoint-iso/pure.seed" ]; then
modiso="copycontent"
echo "debian1" >/tmp/multisystem/multisystem-nomdebian
chemindeb="$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/debian"
find "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")" -maxdepth 1 -path "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/debian[0-9]" | while read line
do
echo "debian$(($(echo $line | sed "s@${chemindeb}@@g")+1))" >/tmp/multisystem/multisystem-nomdebian
done
osname="$(cat /tmp/multisystem/multisystem-nomdebian)"
osicone="multisystem-dynebolic"
#Menu 1
ligne1="menuentry \"Dynebolic\" {"
ligne2=""
ligne3="linux /${osname}/live/vmlinuz rw root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) live-media-path=/${osname}/live boot=live quickreboot username=luther hostname=mir union=aufs"
ligne4="initrd /${osname}/live/initrd.img"
ligne5="}"
#Menu 2
ligne6="menuentry \"Dynebolic (failsafe)\" {"
ligne7=""
ligne8="linux /${osname}/live/vmlinuz rw root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) live-media-path=/${osname}/live boot=live quickreboot username=luther hostname=mir union=aufs  noapic noapm nodma nomce nolapic nosmp vga=normal"
ligne9="initrd /${osname}/live/initrd.img"
ligne10="}"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD2)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
mkdir "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${osname}"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/."

#MeeGo
#http://meego.com/downloads
elif [ "$(grep 'Welcome to MeeGo' /tmp/multisystem/multisystem-mountpoint-iso/isolinux/isolinux.cfg 2>/dev/null)" ]; then
modiso="copycontent"
if [ ! -d "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/LiveOS" ]; then
osname="liveos"
osnamemodif="MeeGo"
osicone="multisystem-meego"
osloopback=""
oskernel="linux /boot/bootdistro/liveos/vmlinuz0 live_locale=${LANG} root=CDLABEL=$(cat /tmp/multisystem/multisystem-selection-label-usb) rootfstype=vfat rw liveimg quiet"
osinitrd="initrd /boot/bootdistro/liveos/initrd0.img"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/LiveOS"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/bootdistro/liveos"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/isolinux/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/bootdistro/liveos/."
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/LiveOS/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/LiveOS/."
else
zenity --error --text "$(eval_gettext "Erreur: LiveCD déjà présent.")"
fi

#Moblin ==> en ram ==> live_ram
#passe pas sur vfat apparement...
#http://moblin.org/downloads
elif [ "$(grep -i 'menu title Welcome to Moblin' /tmp/multisystem/multisystem-mountpoint-iso/isolinux/isolinux.cfg 2>/dev/null)" ]; then
modiso="copycontent"
if [ ! -d "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/LiveOS" ]; then
osname="liveos"
osnamemodif="Moblin"
osicone="multisystem-moblin"
osloopback=""
oskernel="linux /boot/bootdistro/liveos/vmlinuz0 live_locale=${LANG} root=CDLABEL=$(cat /tmp/multisystem/multisystem-selection-label-usb) rootfstype=vfat rw liveimg quiet"
osinitrd="initrd /boot/bootdistro/liveos/initrd0.img"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/LiveOS"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/bootdistro/liveos"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/isolinux/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/bootdistro/liveos/."
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/LiveOS/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/LiveOS/."
else
zenity --error --text "$(eval_gettext "Erreur: LiveCD déjà présent.")"
fi

#Slackware
#http://www.slackware.com/getslack/
elif [ -f "/tmp/multisystem/multisystem-mountpoint-iso/usb-and-pxe-installers/usbboot.img" ]; then
modiso="copycontent"
if [ ! -d "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/slackware" ]; then
osname="slackware"
osnamemodif="Slackware"
osicone="multisystem-slackware"
osloopback=""
oskernel="linux16 /boot/syslinux/memdisk"
osinitrd="initrd16 /slackware/usbboot.img"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/slackware"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/usb-and-pxe-installers/usbboot.img "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/slackware/usbboot.img"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/slackware/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/slackware/."
else
zenity --error --text "$(eval_gettext "Erreur: LiveCD déjà présent.")"
fi

#Linvo (based on Slackware)
#http://www.linvo.org/?page=getit
elif [ "$(grep -i 'Start Linvo' /tmp/multisystem/multisystem-mountpoint-iso/boot/syslinux/syslinux.cfg 2>/dev/null)" ]; then
modiso="copycontent"
if [ ! -d "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/linvo" ]; then
osname="linvo"
osicone="multisystem-linvo"
#Menu 1
ligne1="menuentry \"Start Linvo\" {"
ligne2="linux /linvo/boot/vmlinuz from=/linvo/ runlevel:runlevel/desktop vga=0x314 quiet ramdisk_size=6666 rw guest=linvo splash lang=en_US.utf8 +service/xorgconf vmalloc=256MB root=/dev/ram0 noresume"
ligne3="initrd /linvo/boot/initrd.lz"
ligne4=""
ligne5="}"
#Menu 2
ligne6="menuentry \"Start Linvo (save changes)\" {"
ligne7="linux /linvo/boot/vmlinuz from=/linvo/ runlevel:runlevel/desktop vga=0x314 quiet ramdisk_size=6666 rw guest=linvo splash lang=en_US.utf8 changes=/linvo/save/ +service/xorgconf vmalloc=256MB root=/dev/ram0 noresume"
ligne8="initrd /linvo/boot/initrd.lz"
ligne9=""
ligne10="}"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD2)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/linvo/save"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/linvo/boot"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/boot/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/linvo/boot/."
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/linvo/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/linvo/."
else
zenity --error --text "$(eval_gettext "Erreur: LiveCD déjà présent.")"
fi

#chakra i686
#http://chakra-project.org/download.html
#MENU BACKGROUND chakra.png
#ok ==> chakra-2011.04-r1-i686.iso
elif [ -f "/tmp/multisystem/multisystem-mountpoint-iso/chakra/boot/i686/chakraiso.img" ]; then
modiso="copycontent"
if [ ! -d "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/chakra" ]; then
osname="chakra"
osnamemodif="Chakra"
osicone="multisystem-chakra"
osloopback=""
oskernel="linux /chakra/boot/i686/chakraiso chakraisolabel=$(cat /tmp/multisystem/multisystem-selection-label-usb) quiet lang=$(echo "${LANG}" | awk -F "_" '{print $1 }') nonfree=yes xdriver=no"
osinitrd="initrd /chakra/boot/i686/chakraiso.img"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
#chakra
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/chakra"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/chakra/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/chakra/."
else
zenity --error --text "$(eval_gettext "Erreur: LiveCD déjà présent.")"
fi

#chakra x86_64
#http://chakra-project.org/download.html
#MENU BACKGROUND chakra.png
#ok ==> chakra-2011.04-r1-x86_64.iso
elif [ -f "/tmp/multisystem/multisystem-mountpoint-iso/chakra/boot/x86_64/chakraiso.img" ]; then
modiso="copycontent"
if [ ! -d "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/chakra" ]; then
osname="chakra"
osnamemodif="Chakra"
osicone="multisystem-chakra"
osloopback=""
oskernel="linux /chakra/boot/x86_64/chakraiso chakraisolabel=$(cat /tmp/multisystem/multisystem-selection-label-usb) quiet lang=$(echo "${LANG}" | awk -F "_" '{print $1 }') nonfree=yes xdriver=no"
osinitrd="initrd /chakra/boot/x86_64/chakraiso.img"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
#chakra
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/chakra"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/chakra/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/chakra/."
else
zenity --error --text "$(eval_gettext "Erreur: LiveCD déjà présent.")"
fi

#chakra archlinux
#http://chakra-project.org/download.html
#MENU BACKGROUND chakra.png
#ok ==> chakra-0.2.3-i686.iso
#passe plus! ==> chakra-0.2.65.1-i686.iso #Apparement ne supporte plus de booter sur support en fat32 !
elif [ "$(grep 'MENU BACKGROUND chakra.png' /tmp/multisystem/multisystem-mountpoint-iso/isolinux/isolinux.cfg 2>/dev/null)" ]; then
modiso="copycontent"
if [ ! -d "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/larch" ]; then
osname="chakra"
osnamemodif="Chakra"
osicone="multisystem-chakra"
osloopback=""
oskernel="linux /larch/larch.kernel quiet lang=$(echo "${LANG}" | awk -F "_" '{print $1 }') nonfree=yes xdriver=no"
osinitrd="initrd /larch/larch.img"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
#chakra
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/larch"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/isolinux/larch.kernel "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/larch/larch.kernel"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/isolinux/larch.img "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/larch/larch.img"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/larch/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/larch/."
else
zenity --error --text "$(eval_gettext "Erreur: LiveCD déjà présent.")"
fi

#chakra archlinux
#http://chakra-project.org/download.html
#chakra-0.2.4-i686.iso & 3.0 ok
elif [ "$(grep 'MENU BACKGROUND chakra.png' /tmp/multisystem/multisystem-mountpoint-iso/boot/isolinux/isolinux.cfg 2>/dev/null)" ]; then
modiso="copycontent"
if [ ! -d "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/larch" ]; then
osname="chakra"
osnamemodif="Chakra"
osicone="multisystem-chakra"
osloopback=""
oskernel="linux /larch/vmlinuz26 uuid=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) rootfstype=vfat lang=$(echo "${LANG}" | awk -F "_" '{print $1 }') nonfree=yes xdriver=no"
osinitrd="initrd /larch/larch.img"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
#chakra
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/larch"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/boot/vmlinuz26 "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/larch/vmlinuz26"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/boot/larch.img "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/larch/larch.img"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/larch/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/larch/."
else
zenity --error --text "$(eval_gettext "Erreur: LiveCD déjà présent.")"
fi

#KahelOS
#http://www.kahelos.org/downloads.php
elif [ "$(grep 'KahelOS' /tmp/multisystem/multisystem-mountpoint-iso/boot/isolinux/isolinux.cfg 2>/dev/null)" ]; then
modiso="copycontent"
if [ ! -d "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/larch" ]; then
osname="larch"
osnamemodif="KahelOS"
osicone="multisystem-kahelos"
osloopback=""
oskernel="linux /larch/vmlinuz26 uuid=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) rootfstype=vfat lang=$(echo "${LANG}" | awk -F "_" '{print $1 }') drm_kms_helper.poll=0"
osinitrd="initrd /larch/larch.img"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/larch"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/boot/vmlinuz26 "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/larch/vmlinuz26"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/boot/larch.img "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/larch/larch.img"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/larch/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/larch/."
else
zenity --error --text "$(eval_gettext "Erreur: LiveCD déjà présent.")"
fi

#Dr.Web LiveCD minDrWebLiveCD
#http://www.freedrweb.com/livecd/
elif [ "$(grep 'Dr.Web LiveCD' /tmp/multisystem/multisystem-mountpoint-iso//boot/isolinux/isolinux.cfg 2>/dev/null)" ]; then
#Relever $BOOT_ID
. /tmp/multisystem/multisystem-mountpoint-iso/boot/config
modiso="copycontent"
if [ ! -d "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/drweb" ]; then
osname="drweb"
osnamemodif="minDrWebLiveCD"
osicone="multisystem-drweb"
osloopback=""
oskernel="linux /drweb/vmlinuz ID=$BOOT_ID rw slowusb init=/linuxrc init_opts=4 quiet splash=silent,theme:drweb CONSOLE=/dev/tty1"
osinitrd="initrd /drweb/initrd"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/drweb"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/boot/vmlinuz "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/drweb/vmlinuz"
sudo rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/boot/initrd "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/drweb/initrd"
#
rsync -avS --progress "${option2}" "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/drweb/$(basename "${source}")"
mv -f "$(cat /tmp/multisystem/multisystem-mountpoint-usb)"/drweb/*.iso "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/drweb/drweb.iso"
#modifier initrd
mkdir /tmp/multisystem/multisystem-modinitrd 2>/dev/null
echo -e "\E[37;44m\033[1m $(eval_gettext 'Veuillez saisir votre mot de passe d\047administrateur') \033[0m"
sudo unsquashfs -d /tmp/multisystem/multisystem-modinitrd/. -f "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/drweb/initrd"
#mount -t iso9660 -o loop ${1}/drweb/drweb.iso ${1} >/dev/null 2>&1
sudo sed -i 's@-d \${DIR}/boot/module@-f \${1}/drweb/drweb.iso@' /tmp/multisystem/multisystem-modinitrd/linuxrc
sudo sed -i 's@. \${1}/boot/config@mount -t iso9660 -o loop \${1}/drweb/drweb.iso \${1} >/dev/null 2>\&1\n. \${1}/boot/config@' /tmp/multisystem/multisystem-modinitrd/linuxrc
sudo sed -i 's@mount -t auto@sleep 1     \nmount -t auto@' /tmp/multisystem/multisystem-modinitrd/linuxrc
# >= version 6.0
if [ -f "/tmp/multisystem/multisystem-modinitrd/sbin/find_root" ]; then
sudo sed -i 's@mount -t auto \${i} \${MDIR} >/dev/null .*@mount -t auto \${i} \${MDIR} >/dev/null 2>\&1\n            mount -t iso9660 -o loop \${MDIR}/drweb/drweb.iso \${MDIR} >/dev/null 2>\&1@' /tmp/multisystem/multisystem-modinitrd/sbin/find_root
#desactiver ntfs
sudo sed -i 's@/bin/ntfs-3g@/bin/ntfs-3gzzzzzzzz@' /tmp/multisystem/multisystem-modinitrd/sbin/find_root
sudo sed -i 's@rm -r ${MDIR}@rm -r ${MDIR} >/dev/null 2>\&1@' /tmp/multisystem/multisystem-modinitrd/sbin/find_root
fi
#sudo gedit /tmp/multisystem/multisystem-modinitrd/sbin/find_root
#sudo gedit /tmp/multisystem/multisystem-modinitrd/linuxrc
#echo Attente
#read
rm "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/drweb/initrd"
sudo mksquashfs /tmp/multisystem/multisystem-modinitrd/ "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/drweb/initrd"
sudo rm -R /tmp/multisystem/multisystem-modinitrd
else
zenity --error --text "$(eval_gettext "Erreur: LiveCD déjà présent.")"
fi

#Zenwalk ok depuis v7.0
#http://www.zenwalk.org/modules/news/article.php?storyid=117
elif [ "$(grep 'Zenlive' /tmp/multisystem/multisystem-mountpoint-iso/make_iso.sh 2>/dev/null)" ]; then
modiso="copycontent"
if [ ! -d "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/zenwalk" ]; then
osname="zenwalk"
osnamemodif="Zenlive"
osicone="multisystem-zenwalk"
osloopback=""
oskernel="linux /zenwalk/vmlinuz vga=791 locale=fr_FR.UTF-8 keymap=fr splash=silent"
osinitrd="initrd /zenwalk/initrd.gz"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/zenwalk"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/boot/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/zenwalk/."
mkdir /tmp/multisystem/multisystem-modinitrd 2>/dev/null
cd /tmp/multisystem/multisystem-modinitrd
gzip -dc /tmp/multisystem/multisystem-mountpoint-iso/boot/initrd.gz | cpio -i
sed -i 's@/boot@/zenwalk@g' /tmp/multisystem/multisystem-modinitrd/init
#gedit /tmp/multisystem/multisystem-modinitrd/init
#echo Attente
#read
find . | cpio -o -H newc | gzip -9 > "$(cat /tmp/multisystem/multisystem-mountpoint-usb)"/zenwalk/initrd.gz
cd -
rm -R /tmp/multisystem/multisystem-modinitrd
else
zenity --error --text "$(eval_gettext "Erreur: LiveCD déjà présent.")"
fi

#Frugalware Linux (netinstall)
#http://www7.frugalware.org/pub/frugalware/frugalware-current-iso
elif [ "$(grep 'title Frugalware' /tmp/multisystem/multisystem-mountpoint-iso/boot/grub/menu.lst 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osnamemodif="Frugalware Linux"
osicone="multisystem-frugalware"
namekernel="$(grep kernel /tmp/multisystem/multisystem-mountpoint-iso/boot/grub/menu.lst | head -n 1 | awk '{print $2 }')"
nameinitrd="$(grep 'initrd /boot/' /tmp/multisystem/multisystem-mountpoint-iso/boot/grub/menu.lst | head -n 1 | awk '{print $2 }')"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)${namekernel} load_ramdisk=1 prompt_ramdisk=0 ramdisk_size=61576 rw root=/dev/ram quiet"
osinitrd="initrd (loop)${nameinitrd}"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#Frugalware version livecd (base Fedora) login/pass fwlive/fwlive
elif [ "$(grep "root=live:CDLABEL=fwlive" /tmp/multisystem/multisystem-mountpoint-iso/boot/syslinux/syslinux.cfg 2>/dev/null)" ]; then
modiso="copycontent"
echo "frugalware1" >/tmp/multisystem/multisystem-nomfrugalware
chemindeb="$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/frugalware"
find "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")" -maxdepth 1 -path "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/frugalware[0-9]" | while read line
do
echo "frugalware$(($(echo $line | sed "s@${chemindeb}@@g")+1))" >/tmp/multisystem/multisystem-nomfrugalware
done
osname="$(cat /tmp/multisystem/multisystem-nomfrugalware)"
osnamemodif="$(basename "${option2}")"
osicone="multisystem-frugalware"
osloopback=""
oskernel="linux /${osname}/boot/vmlinuz live_dir=/${osname}/LiveOS root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) rootfstype=auto ro liveimg rd.plymouth=0"
osinitrd="initrd /${osname}/boot/initrd"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${osname}"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/."

#Elive
#http://www.elivecd.org/Download/Development
elif [ "$(grep 'title  Elive Normal Mode' /tmp/multisystem/multisystem-mountpoint-iso/boot/grub/menu.lst 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osicone="multisystem-elive"
osnamemodif="Elive"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
#fromiso=/${osname}
oskernel="linux (loop)/boot/vmlinuz-2.6.30.9-elive-686 boot=eli quiet resolution fromiso=/${osname}"
osinitrd="initrd (loop)/boot/initrd.img-2.6.30.9-elive-686"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#MADBOX
#http://download.tuxfamily.org/madbox/madbox-11.10/madbox-11.10-i386.iso
elif [ -f "/tmp/multisystem/multisystem-mountpoint-iso/madbox.png" ]; then
osname="$(basename "${option2}")"
osicone="multisystem-madbox"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*vmlinuz*")) boot=casper root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) iso-scan/filename=/${osname} debian-installer/language=fr console-setup/layoutcode=fr locale=fr_FR quiet splash noprompt--"
osinitrd="initrd (loop)/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*initrd*"))"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#Emmabuntüs2 Patrick Ablard
#http://sourceforge.net/projects/emmubuntu/files/Emmabuntus%20Equitable/
elif [ "$(grep '^Emmabuntus Equitable 2' /tmp/multisystem/multisystem-mountpoint-iso/.disk/info 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osicone="multisystem-emmabuntus"
#Menu 1
ligne1="menuentry \"Tester Emmabuntüs 2 sans installation\" {"
ligne2="loopback loop \"/${osname}\""
ligne3="linux (loop)/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*vmlinuz*")) root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) iso-scan/filename=/${osname} noprompt file=/cdrom/preseed/xubuntu.seed boot=casper debian-installer/locale=fr_FR.utf8 debian-installer/language=fr kbd-chooser/method=fr console-setup/layoutcode=fr console-setup/variantcode=oss initrd=/casper/initrd.lz quiet splash --"
ligne4="initrd (loop)/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*initrd*"))"
ligne5="}"
#Menu 2
ligne6="menuentry \"Install Emmabuntüs 2 ( Classique )\" {"
ligne7="loopback loop \"/${osname}\""
ligne8="linux (loop)/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*vmlinuz*")) root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) iso-scan/filename=/${osname} noprompt file=/cdrom/preseed/xubuntu.seed boot=casper debian-installer/locale=fr_FR.utf8 debian-installer/language=fr kbd-chooser/method=fr console-setup/layoutcode=fr console-setup/variantcode=oss only-ubiquity initrd=/casper/initrd.lz quiet splash --"
ligne9="initrd (loop)/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*initrd*"))"
ligne10="}"
#Menu 3
ligne11="menuentry \"Install Emmabuntus 2 Dual-boot (Pwd=?, Manual Part, Grub=>MBR)\" {"
ligne12="loopback loop \"/${osname}\""
ligne13="linux (loop)/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*vmlinuz*")) root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) iso-scan/filename=/${osname} file=/cdrom/preseed/emmaus_dual_boot_user.seed boot=casper debian-installer/locale=fr_FR.utf8 debian-installer/language=fr kbd-chooser/method=fr console-setup/layoutcode=fr console-setup/variantcode=oss only-ubiquity automatic-ubiquity noprompt debian-installer/locale=fr_FR console-setup/ask_detect=false console-setup/layoutcode=fr initrd=/casper/initrd.lz quiet splash --"
ligne14="initrd (loop)/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*initrd*"))"
ligne15="}"
#Menu 4
ligne16="menuentry \"Install Emmabuntus 2 Dual-boot (Pwd=avenir, Manual Part, Grub=>MBR)\" {"
ligne17="loopback loop \"/${osname}\""
ligne18="linux (loop)/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*vmlinuz*")) root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) iso-scan/filename=/${osname} file=/cdrom/preseed/emmaus_dual_boot.seed boot=casper debian-installer/locale=fr_FR.utf8 debian-installer/language=fr kbd-chooser/method=fr console-setup/layoutcode=fr console-setup/variantcode=oss only-ubiquity automatic-ubiquity noprompt debian-installer/locale=fr_FR console-setup/ask_detect=false console-setup/layoutcode=fr initrd=/casper/initrd.lz quiet splash --"
ligne19="initrd (loop)/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*initrd*"))"
ligne20="}"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD4)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#Emmabuntüs Patrick Ablard
#http://sourceforge.net/projects/emmubuntu/files/Emmabuntus%20Equitable/
elif [ "$(grep '^Emmabuntus' /tmp/multisystem/multisystem-mountpoint-iso/.disk/info 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osicone="multisystem-emmabuntus"
#Menu 1
ligne1="menuentry \"Tester Emmabuntüs sans installation\" {"
ligne2="loopback loop \"/${osname}\""
ligne3="linux (loop)/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*vmlinuz*")) root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) ${ubuntu_lang} iso-scan/filename=/${osname} file=/cdrom/preseed/ubuntu.seed boot=casper noprompt quiet splash --"
ligne4="initrd (loop)/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*initrd*"))"
ligne5="}"
#Menu 2
ligne6="menuentry \"Install Emmabuntüs ( Classique )\" {"
ligne7="loopback loop \"/${osname}\""
ligne8="linux (loop)/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*vmlinuz*")) root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) ${ubuntu_lang} iso-scan/filename=/${osname} file=/cdrom/preseed/ubuntu.seed boot=casper noprompt only-ubiquity quiet splash -nomodeset --"
ligne9="initrd (loop)/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*initrd*"))"
ligne10="}"
#Menu 3
ligne11="menuentry \"Install Emmabuntüs Dual-boot + compte admin ( Partition Manuelle )\" {"
ligne12="loopback loop \"/${osname}\""
ligne13="linux (loop)/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*vmlinuz*")) root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) ${ubuntu_lang} iso-scan/filename=/${osname} noprompt file=/cdrom/preseed/emmaus_dual_boot_user.seed boot=casper automatic-ubiquity noprompt quiet splash -nomodeset --"
ligne14="initrd (loop)/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*initrd*"))"
ligne15="}"
#Menu 4
ligne16="menuentry \"Install Emmabuntüs Dual-boot (Password=avenir) ( Partition Manuelle )\" {"
ligne17="loopback loop \"/${osname}\""
ligne18="linux (loop)/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*vmlinuz*")) root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) ${ubuntu_lang} iso-scan/filename=/${osname} file=/cdrom/preseed/emmaus_dual_boot.seed boot=casper automatic-ubiquity noprompt quiet splash -nomodeset --"
ligne19="initrd (loop)/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*initrd*"))"
ligne20="}"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD4)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#Ocariabuntus Patrick Ablard
#http://sourceforge.net/projects/emmubuntu/
elif [ "$(grep 'Ocariabuntus' /tmp/multisystem/multisystem-mountpoint-iso/.disk/info 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osicone="multisystem-emmabuntus"
#Menu 1
ligne1="menuentry \"Ocarinabuntüs Live\" {"
ligne2="loopback loop \"/${osname}\""
ligne3="linux (loop)/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*vmlinuz*")) root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) ${ubuntu_lang} iso-scan/filename=/${osname} file=/cdrom/preseed/ubuntu.seed boot=casper noprompt quiet splash --"
ligne4="initrd (loop)/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*initrd*"))"
ligne5="}"
#Menu 2
ligne6="menuentry \"Ocarinabuntüs Install\" {"
ligne7="loopback loop \"/${osname}\""
ligne8="linux (loop)/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*vmlinuz*")) root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) ${ubuntu_lang} iso-scan/filename=/${osname} file=/cdrom/preseed/ubuntu.seed boot=casper only-ubiquity quiet splash -nomodeset --"
ligne9="initrd (loop)/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*initrd*"))"
ligne10="}"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD2)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#Lemmabuntus
#http://sourceforge.net/projects/emmubuntu/files/Lemmabuntus%20Equitable/
elif [ "$(grep '^Lemmabuntus' /tmp/multisystem/multisystem-mountpoint-iso/.disk/info 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osicone="multisystem-emmabuntus"
#Menu 1
ligne1="menuentry \"Try Lemmabuntus without installation\" {"
ligne2="loopback loop \"/${osname}\""
ligne3="linux (loop)/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*vmlinuz*")) root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) ${ubuntu_lang} iso-scan/filename=/${osname} file=/cdrom/preseed/ubuntu.seed boot=casper noprompt quiet splash --"
ligne4="initrd (loop)/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*initrd*"))"
ligne5="}"
#Menu 2
ligne6="menuentry \"Install Lemmabuntus ( Classic Installation )\" {"
ligne7="loopback loop \"/${osname}\""
ligne8="linux (loop)/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*vmlinuz*")) root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) ${ubuntu_lang} iso-scan/filename=/${osname} file=/cdrom/preseed/ubuntu.seed boot=casper only-ubiquity quiet splash --"
ligne9="initrd (loop)/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*initrd*"))"
ligne10="}"
#Menu 3
ligne11="menuentry \"Install Lemmabuntus Dual-boot (Pwd = ?, Manual Partition, Grub => MBR)\" {"
ligne12="loopback loop \"/${osname}\""
ligne13="linux (loop)/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*vmlinuz*")) root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) ${ubuntu_lang} iso-scan/filename=/${osname} file=/cdrom/preseed/lemmaus_dual_boot_user.seed boot=casper only-ubiquity automatic-ubiquity noprompt quiet splash --"
ligne14="initrd (loop)/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*initrd*"))"
ligne15="}"
#Menu 4
ligne16="menuentry \"Install Lemmabuntus Dual-boot (Pwd=avenir, Manual Partition, Grub => MBR)\" {"
ligne17="loopback loop \"/${osname}\""
ligne18="linux (loop)/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*vmlinuz*")) root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) ${ubuntu_lang} iso-scan/filename=/${osname} file=/cdrom/preseed/lemmaus_dual_boot.seed boot=casper only-ubiquity automatic-ubiquity noprompt quiet splash --"
ligne19="initrd (loop)/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*initrd*"))"
ligne20="}"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD4)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#Trisquel >= 4.5.1
##http://trisquel.info/en/download
elif [ "$(grep 'Trisquel' /tmp/multisystem/multisystem-mountpoint-iso/.disk/info 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osnamemodif="$(basename "${option2}")"
osicone="multisystem-trisquel"
gen_champ="$(grep -m1 'file=.*\.seed' -o /tmp/multisystem/multisystem-mountpoint-iso/isolinux/txt.cfg)"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*vmlinuz*")) root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) ${gen_champ} ${ubuntu_lang} iso-scan/filename=/${osname} boot=casper noprompt quiet splash --"
osinitrd="initrd (loop)/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*initrd*"))"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#TurnKey Linux 11.1
#http://distrowatch.com/table.php?distribution=turnkey
#http://manpages.ubuntu.com/manpages/lucid/man7/casper.7.html
elif [ -f "/tmp/multisystem/multisystem-mountpoint-iso/casper/10root.squashfs" ]; then
modiso="copycontent"
echo "turnkey1" >/tmp/multisystem/multisystem-nomdistro
chemindeb="$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/turnkey"
find "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")" -maxdepth 1 -path "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/turnkey[0-9]" | while read line
do
echo "turnkey$(($(echo $line | sed "s@${chemindeb}@@g")+1))" >/tmp/multisystem/multisystem-nomdistro
done
osname="$(cat /tmp/multisystem/multisystem-nomdistro)"
osicone="multisystem-turnkey"
#Menu 1
ligne1="menuentry \"TurnKey Install\" {"
ligne2="linux /${osname}/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*vmlinuz*")) live-media-path=/${osname}/casper boot=casper root=/dev/ram rw showmounts debug di-live single --"
ligne3="initrd /${osname}/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*initrd*"))"
ligne4=""
ligne5="}"
#Menu 2
ligne6="menuentry \"TurnKey live\" {"
ligne7="linux /${osname}/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*vmlinuz*")) live-media-path=/${osname}/casper boot=casper root=/dev/ram rw showmounts debug --"
ligne8="initrd /${osname}/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*initrd*"))"
ligne9=""
ligne10="}"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD2)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${osname}"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/."

#Sn0wL1nuX
#http://sourceforge.net/projects/sn0wl1nux/
elif [ "$(grep 'Sn0wL1nuX' /tmp/multisystem/multisystem-mountpoint-iso/.disk/info 2>/dev/null)" ]; then
modiso="copycontent"
echo "ubuntu1" >/tmp/multisystem/multisystem-nomdistro
chemindeb="$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/ubuntu"
find "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")" -maxdepth 1 -path "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/ubuntu[0-9]" | while read line
do
echo "ubuntu$(($(echo $line | sed "s@${chemindeb}@@g")+1))" >/tmp/multisystem/multisystem-nomdistro
done
osname="$(cat /tmp/multisystem/multisystem-nomdistro)"
osicone="multisystem-Sn0wL1nuX"
#Menu 1
ligne1="menuentry \"Sn0wL1nuX live\" {"
ligne2="linux /${osname}/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*vmlinuz*")) live-media-path=/${osname}/casper root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) file=/cdrom/${osname}/preseed/custom.seed boot=casper noprompt quiet splash --"
ligne3="initrd /${osname}/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*initrd*"))"
ligne4=""
ligne5="}"
#Menu 2
ligne6="menuentry \"Sn0wL1nuX Install\" {"
ligne7="linux /${osname}/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*vmlinuz*")) live-media-path=/${osname}/casper root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) file=/cdrom/${osname}/preseed/custom.seed boot=casper only-ubiquity quiet splash --"
ligne8="initrd /${osname}/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*initrd*"))"
ligne9=""
ligne10="}"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD2)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${osname}"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/."

#openArtist
#http://openartisthq.org/
elif [ "$(grep 'openArtist' /tmp/multisystem/multisystem-mountpoint-iso/casper/README.diskdefines 2>/dev/null)" ]; then
modiso="copycontent"
echo "openartist1" >/tmp/multisystem/multisystem-nomdistro
chemindeb="$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/openartist"
find "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")" -maxdepth 1 -path "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/openartist[0-9]" | while read line
do
echo "openartist$(($(echo $line | sed "s@${chemindeb}@@g")+1))" >/tmp/multisystem/multisystem-nomdistro
done
osname="$(cat /tmp/multisystem/multisystem-nomdistro)"
osnamemodif="openArtist"
osicone="multisystem-openartist"
osloopback=""
oskernel="linux /${osname}/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*vmlinuz*")) live-media-path=/${osname}/casper root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) file=/cdrom/${osname}/preseed/custom.seed locale=$(echo "${LANG}" | sed "s/\..*//") bootkbd=${XKBLAYOUT} console-setup/layoutcode=${XKBLAYOUT} console-setup/variantcode=${XKBVARIANT} boot=casper noprompt quiet splash --"
osinitrd="initrd /${osname}/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*initrd*"))"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${osname}"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/."

#Karoshi
#http://karoshi.linuxgfx.co.uk/
elif [ "$(grep 'Karoshi' /tmp/multisystem/multisystem-mountpoint-iso/.disk/info 2>/dev/null)" ]; then
modiso="copycontent"
echo "karoshi1" >/tmp/multisystem/multisystem-nomdistro
chemindeb="$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/karoshi"
find "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")" -maxdepth 1 -path "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/karoshi[0-9]" | while read line
do
echo "karoshi$(($(echo $line | sed "s@${chemindeb}@@g")+1))" >/tmp/multisystem/multisystem-nomdistro
done
osname="$(cat /tmp/multisystem/multisystem-nomdistro)"
osnamemodif="Karoshi"
osicone="multisystem-karoshi"
osloopback=""
oskernel="linux /${osname}/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*vmlinuz*")) live-media-path=/${osname}/casper root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) file=/cdrom/${osname}/preseed/custom.seed locale=$(echo "${LANG}" | sed "s/\..*//") bootkbd=${XKBLAYOUT} console-setup/layoutcode=${XKBLAYOUT} console-setup/variantcode=${XKBVARIANT} boot=casper noprompt quiet splash --"
osinitrd="initrd /${osname}/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*initrd*"))"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${osname}"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/."

#UberStudent
#http://downloads.uberstudent.org/
elif [ "$(grep 'UberStudent' /tmp/multisystem/multisystem-mountpoint-iso/.disk/info 2>/dev/null)" ]; then
modiso="copycontent"
echo "uberstudent1" >/tmp/multisystem/multisystem-nomdistro
chemindeb="$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/uberstudent"
find "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")" -maxdepth 1 -path "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/uberstudent[0-9]" | while read line
do
echo "uberstudent$(($(echo $line | sed "s@${chemindeb}@@g")+1))" >/tmp/multisystem/multisystem-nomdistro
done
osname="$(cat /tmp/multisystem/multisystem-nomdistro)"
osnamemodif="UberStudent"
osicone="multisystem-uberstudent"
osloopback=""
oskernel="linux /${osname}/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*vmlinuz*")) live-media-path=/${osname}/casper root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) file=/cdrom/${osname}/preseed/custom.seed locale=$(echo "${LANG}" | sed "s/\..*//") bootkbd=${XKBLAYOUT} console-setup/layoutcode=${XKBLAYOUT} console-setup/variantcode=${XKBVARIANT} boot=casper noprompt quiet splash --"
osinitrd="initrd /${osname}/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*initrd*"))"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${osname}"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/."

#Pinguy OS
#http://ubuntuforums.org/showthread.php?p=9572021
elif [ "$(grep 'Pinguy OS' /tmp/multisystem/multisystem-mountpoint-iso/.disk/info 2>/dev/null)" ]; then
modiso="copycontent"
echo "pinguy1" >/tmp/multisystem/multisystem-nomdistro
chemindeb="$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/pinguy"
find "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")" -maxdepth 1 -path "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/pinguy[0-9]" | while read line
do
echo "pinguy$(($(echo $line | sed "s@${chemindeb}@@g")+1))" >/tmp/multisystem/multisystem-nomdistro
done
osname="$(cat /tmp/multisystem/multisystem-nomdistro)"
osnamemodif="Pinguy OS"
osicone="multisystem-pinguy"
osloopback=""
oskernel="linux /${osname}/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*vmlinuz*")) live-media-path=/${osname}/casper root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) file=/cdrom/${osname}/preseed/custom.seed locale=$(echo "${LANG}" | sed "s/\..*//") bootkbd=${XKBLAYOUT} console-setup/layoutcode=${XKBLAYOUT} console-setup/variantcode=${XKBVARIANT} boot=casper noprompt quiet splash --"
osinitrd="initrd /${osname}/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*initrd*"))"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${osname}"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/."

#Pinguy OS Nouvelle version ==> 11.04.1
#http://ubuntuforums.org/showthread.php?p=9572021
elif [ "$(grep 'Ping-Eee OS' /tmp/multisystem/multisystem-mountpoint-iso/.disk/info 2>/dev/null)" ]; then
modiso="copycontent"
echo "pinguy1" >/tmp/multisystem/multisystem-nomdistro
chemindeb="$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/pinguy"
find "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")" -maxdepth 1 -path "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/pinguy[0-9]" | while read line
do
echo "pinguy$(($(echo $line | sed "s@${chemindeb}@@g")+1))" >/tmp/multisystem/multisystem-nomdistro
done
osname="$(cat /tmp/multisystem/multisystem-nomdistro)"
osnamemodif="Pinguy OS"
osicone="multisystem-pinguy"
osloopback=""
oskernel="linux /${osname}/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*vmlinuz*")) live-media-path=/${osname}/casper root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) file=/cdrom/${osname}/preseed/custom.seed ${ubuntu_lang} boot=casper noprompt quiet splash --"
osinitrd="initrd /${osname}/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*initrd*"))"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${osname}"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/."

#Netrunner
#http://www.netrunner-os.com/?page_id=3
#http://manpages.ubuntu.com/manpages/lucid/man7/casper.7.html
elif [ "$(grep 'Netrunner' /tmp/multisystem/multisystem-mountpoint-iso/.disk/info 2>/dev/null)" ]; then
modiso="copycontent"
echo "netrunner1" >/tmp/multisystem/multisystem-nomdistro
chemindeb="$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/netrunner"
find "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")" -maxdepth 1 -path "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/netrunner[0-9]" | while read line
do
echo "netrunner$(($(echo $line | sed "s@${chemindeb}@@g")+1))" >/tmp/multisystem/multisystem-nomdistro
done
osname="$(cat /tmp/multisystem/multisystem-nomdistro)"
osnamemodif="Netrunner"
osicone="multisystem-netrunner"
osloopback=""
oskernel="linux /${osname}/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*vmlinuz*")) live-media-path=/${osname}/casper root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) file=/cdrom/${osname}/preseed/netrunner.seed locale=$(echo "${LANG}" | sed "s/\..*//") bootkbd=${XKBLAYOUT} console-setup/layoutcode=${XKBLAYOUT} console-setup/variantcode=${XKBVARIANT} boot=casper noprompt quiet splash --"
osinitrd="initrd /${osname}/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*initrd*"))"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${osname}"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/."

#ConnochaetOS
#http://sourceforge.net/projects/connochaetos/
elif [ "$(grep 'ConnochaetOS' /tmp/multisystem/multisystem-mountpoint-iso/boot/grub/menu.lst 2>/dev/null)" ]; then
modiso="copycontent"
if [ ! -d "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/os" ]; then
osname="os"
osnamemodif="ConnochaetOS"
osicone="multisystem-connochaet"
osloopback=""
oskernel="linux /os/vmlinuz"
osinitrd="initrd /os/initrd.img"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/os"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/os/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/os/."
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/boot/isolinux/initrd.img "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/os/initrd.img"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/boot/isolinux/vmlinuz "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/os/vmlinuz"
else
zenity --error --text "$(eval_gettext "Erreur: LiveCD déjà présent.")"
fi

#AlpineLinux
#http://www.alpinelinux.org/wiki/Downloads
elif [ "$(grep 'alpine_dev' /tmp/multisystem/multisystem-mountpoint-iso/syslinux.cfg 2>/dev/null)" ]; then
modiso="copycontent"
if [ ! -d "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/apks" ]; then
osname="apks"
osnamemodif="AlpineLinux"
osicone="multisystem-alpine"
osloopback=""
oskernel="linux /apks/boot/grsec alpine_dev=usbdisk:vfat modules=loop,cramfs,sd-mod,usb-storage quiet"
osinitrd="initrd /apks/boot/grsec.gz"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/apks/boot"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/apks/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/apks/."
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/boot/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/apks/boot/."
else
zenity --error --text "$(eval_gettext "Erreur: LiveCD déjà présent.")"
fi

#wattOS login:guest pass:(rien,sans)
#http://www.planetwatt.com/?module=Downloads
#http://manpages.ubuntu.com/manpages/lucid/man7/casper.7.html
elif [ "$(grep 'wattOS' /tmp/multisystem/multisystem-mountpoint-iso/.disk/info 2>/dev/null)" ]; then
modiso="copycontent"
echo "wattos1" >/tmp/multisystem/multisystem-nomdistro
chemindeb="$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/wattos"
find "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")" -maxdepth 1 -path "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/wattos[0-9]" | while read line
do
echo "wattos$(($(echo $line | sed "s@${chemindeb}@@g")+1))" >/tmp/multisystem/multisystem-nomdistro
done
osname="$(cat /tmp/multisystem/multisystem-nomdistro)"
osnamemodif="wattOS"
osicone="multisystem-wattos"
osloopback=""
oskernel="linux /${osname}/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*vmlinuz*")) live-media-path=/${osname}/casper root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) file=/cdrom/${osname}/preseed/custom.seed locale=$(echo "${LANG}" | sed "s/\..*//") bootkbd=${XKBLAYOUT} console-setup/layoutcode=${XKBLAYOUT} console-setup/variantcode=${XKBVARIANT} boot=casper noprompt quiet splash --"
osinitrd="initrd /${osname}/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*initrd*"))"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${osname}"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/."

#La Boîte à Outils
#http://www.lulu-search.com/boite-a-outils/telechargement.html
#Nom d'utilisateur : root
#Mot de passe : toor
elif [ "$(grep 'boite-a-outils' /tmp/multisystem/multisystem-mountpoint-iso/.disk/info 2>/dev/null)" ]; then
modiso="copycontent"
echo "bao1" >/tmp/multisystem/multisystem-nomdistro
chemindeb="$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/bao"
find "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")" -maxdepth 1 -path "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/bao[0-9]" | while read line
do
echo "bao$(($(echo $line | sed "s@${chemindeb}@@g")+1))" >/tmp/multisystem/multisystem-nomdistro
done
osname="$(cat /tmp/multisystem/multisystem-nomdistro)"
osnamemodif="La-Boite-a-Outils"
osicone="multisystem-tux"
osloopback=""
oskernel="linux /${osname}/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*vmlinuz*")) live-media-path=/${osname}/casper root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) file=/cdrom/${osname}/preseed/custom.seed boot=casper noprompt quiet splash --"
osinitrd="initrd /${osname}/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*initrd*"))"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${osname}"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/."

#Guadalinex >= v7
#http://www.guadalinex.org/donde-conseguirlo
#http://manpages.ubuntu.com/manpages/lucid/man7/casper.7.html
elif [ "$(grep 'Guadalinex V7' /tmp/multisystem/multisystem-mountpoint-iso/.disk/info 2>/dev/null)" ]; then
modiso="copycontent"
echo "guadalinex1" >/tmp/multisystem/multisystem-nomdistro
chemindeb="$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/guadalinex"
find "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")" -maxdepth 1 -path "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/guadalinex[0-9]" | while read line
do
echo "guadalinex$(($(echo $line | sed "s@${chemindeb}@@g")+1))" >/tmp/multisystem/multisystem-nomdistro
done
osname="$(cat /tmp/multisystem/multisystem-nomdistro)"
osnamemodif="Guadalinex"
osicone="multisystem-guadalinex"
osloopback=""
oskernel="linux /${osname}/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*vmlinuz*")) live-media-path=/${osname}/casper root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) file=/cdrom/${osname}/preseed/guada.seed locale=$(echo "${LANG}" | sed "s/\..*//") bootkbd=${XKBLAYOUT} console-setup/layoutcode=${XKBLAYOUT} console-setup/variantcode=${XKBVARIANT} boot=casper noprompt quiet splash --"
osinitrd="initrd /${osname}/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*initrd*"))"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${osname}"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/."
#Virer /conf/uuid.conf
rm -R /tmp/multisystem/multisystem-modinitrd 2>/dev/null
mkdir /tmp/multisystem/multisystem-modinitrd 2>/dev/null
cd /tmp/multisystem/multisystem-modinitrd
unlzma -c -S .lz "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/casper/initrd.lz" | cpio -id
rm /tmp/multisystem/multisystem-modinitrd/conf/uuid.conf
find . | cpio --quiet --dereference -o -H newc | lzma -9 > "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/casper/initrd.lz"
cd -
rm -R /tmp/multisystem/multisystem-modinitrd

#Vinux
#http://vinux.org.uk/downloads.html
#http://manpages.ubuntu.com/manpages/lucid/man7/casper.7.html
elif [ "$(grep '^Vinux ' /tmp/multisystem/multisystem-mountpoint-iso/.disk/info 2>/dev/null)" ]; then
modiso="copycontent"
echo "vinux1" >/tmp/multisystem/multisystem-nomdistro
chemindeb="$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/vinux"
find "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")" -maxdepth 1 -path "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/vinux[0-9]" | while read line
do
echo "vinux$(($(echo $line | sed "s@${chemindeb}@@g")+1))" >/tmp/multisystem/multisystem-nomdistro
done
osname="$(cat /tmp/multisystem/multisystem-nomdistro)"
osicone="multisystem-vinux"
#Menu 1
ligne1="menuentry \"Vinux live - boot the Live System from the CD\" {"
ligne2=""
ligne3="linux /${osname}/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*vmlinuz*")) live-media-path=/${osname}/casper root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) file=/cdrom/${osname}/preseed/custom.seed ${ubuntu_lang} access=v3 boot=casper noprompt quiet splash --"
ligne4="initrd /${osname}/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*initrd*"))"
ligne5="}"
#Menu 2
ligne6="menuentry \"Vinux toram - copy the Live System into RAM\" {"
ligne7=""
ligne8="linux /${osname}/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*vmlinuz*")) live-media-path=/${osname}/casper root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) file=/cdrom/${osname}/preseed/custom.seed ${ubuntu_lang} access=v3 boot=casper noprompt quiet splash toram --"
ligne9="initrd /${osname}/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*initrd*"))"
ligne10="}"
#Menu 3
ligne11="menuentry \"Vinux xforcevesa - boot Live in safe graphics mode\" {"
ligne12=""
ligne13="linux /${osname}/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*vmlinuz*")) live-media-path=/${osname}/casper root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) file=/cdrom/${osname}/preseed/custom.seed ${ubuntu_lang} access=v3 xforcevesa boot=casper noprompt quiet splash --"
ligne14="initrd /${osname}/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*initrd*"))"
ligne15="}"
#Menu 4
ligne16="menuentry \"Vinux install - start the installer directly\" {"
ligne17=""
ligne18="linux /${osname}/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*vmlinuz*")) live-media-path=/${osname}/casper root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) file=/cdrom/${osname}/preseed/custom.seed ${ubuntu_lang} access=v3 only-ubiquity boot=casper noprompt quiet splash --"
ligne19="initrd /${osname}/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*initrd*"))"
ligne20="}"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD4)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${osname}"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/."

#Monomaxos v5
#http://www.monomaxos.gr/download.htm
#http://manpages.ubuntu.com/manpages/lucid/man7/casper.7.html
elif [ "$(grep 'Monomaxos' /tmp/multisystem/multisystem-mountpoint-iso/.disk/info 2>/dev/null)" ]; then
modiso="copycontent"
echo "monomaxos1" >/tmp/multisystem/multisystem-nomdistro
chemindeb="$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/monomaxos"
find "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")" -maxdepth 1 -path "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/monomaxos[0-9]" | while read line
do
echo "monomaxos$(($(echo $line | sed "s@${chemindeb}@@g")+1))" >/tmp/multisystem/multisystem-nomdistro
done
osname="$(cat /tmp/multisystem/multisystem-nomdistro)"
osnamemodif="Monomaxos"
osicone="multisystem-monomaxos"
osloopback=""
oskernel="linux /${osname}/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*vmlinuz*")) live-media-path=/${osname}/casper root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) file=/cdrom/${osname}/preseed/custom.seed locale=$(echo "${LANG}" | sed "s/\..*//") bootkbd=${XKBLAYOUT} console-setup/layoutcode=${XKBLAYOUT} console-setup/variantcode=${XKBVARIANT} boot=casper noprompt quiet splash --"
osinitrd="initrd /${osname}/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*initrd*"))"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${osname}"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/."

#Zorin OS v3/v4/v5/v6
#http://zorin-os.webs.com/download.htm
#http://manpages.ubuntu.com/manpages/lucid/man7/casper.7.html
elif [ "$(grep 'Zorin OS' /tmp/multisystem/multisystem-mountpoint-iso/.disk/info 2>/dev/null)" ]; then
modiso="copycontent"
echo "zorin1" >/tmp/multisystem/multisystem-nomdistro
chemindeb="$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/zorin"
find "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")" -maxdepth 1 -path "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/zorin[0-9]" | while read line
do
echo "zorin$(($(echo $line | sed "s@${chemindeb}@@g")+1))" >/tmp/multisystem/multisystem-nomdistro
done
osname="$(cat /tmp/multisystem/multisystem-nomdistro)"
osnamemodif="Zorin OS"
osicone="multisystem-zorin"
osloopback=""
oskernel="linux /${osname}/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*vmlinuz*")) live-media-path=/${osname}/casper root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) file=/cdrom/${osname}/preseed/custom.seed ${ubuntu_lang} boot=casper noprompt quiet splash --"
osinitrd="initrd /${osname}/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*initrd*"))"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${osname}"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/."

#Deepin
#http://linux.deepin.org/download
#http://manpages.ubuntu.com/manpages/lucid/man7/casper.7.html
elif [ "$(grep 'Deepin' /tmp/multisystem/multisystem-mountpoint-iso/.disk/info 2>/dev/null)" ]; then
modiso="copycontent"
echo "deepin1" >/tmp/multisystem/multisystem-nomdistro
chemindeb="$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/deepin"
find "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")" -maxdepth 1 -path "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/deepin[0-9]" | while read line
do
echo "deepin$(($(echo $line | sed "s@${chemindeb}@@g")+1))" >/tmp/multisystem/multisystem-nomdistro
done
osname="$(cat /tmp/multisystem/multisystem-nomdistro)"
osnamemodif="Deepin"
osicone="multisystem-deepin"
osloopback=""
oskernel="linux /${osname}/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*vmlinuz*")) live-media-path=/${osname}/casper root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) file=/cdrom/${osname}/preseed/deepin.seed boot=casper noprompt quiet splash --"
osinitrd="initrd /${osname}/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*initrd*"))"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${osname}"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/."

#BlankOn
#http://blankonlinux.or.id/download.html
#http://manpages.ubuntu.com/manpages/lucid/man7/casper.7.html
elif [ "$(grep 'BlankOn' /tmp/multisystem/multisystem-mountpoint-iso/.disk/info 2>/dev/null)" ]; then
modiso="copycontent"
echo "blankon1" >/tmp/multisystem/multisystem-nomdistro
chemindeb="$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/blankon"
find "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")" -maxdepth 1 -path "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/blankon[0-9]" | while read line
do
echo "blankon$(($(echo $line | sed "s@${chemindeb}@@g")+1))" >/tmp/multisystem/multisystem-nomdistro
done
osname="$(cat /tmp/multisystem/multisystem-nomdistro)"
osnamemodif="BlankOn"
osicone="multisystem-blankon"
osloopback=""
oskernel="linux /${osname}/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*vmlinuz*")) live-media-path=/${osname}/casper root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) locale=$(echo "${LANG}" | sed "s/\..*//") bootkbd=${XKBLAYOUT} console-setup/layoutcode=${XKBLAYOUT} console-setup/variantcode=${XKBVARIANT} boot=casper noprompt quiet splash --"
osinitrd="initrd /${osname}/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*initrd*"))"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${osname}"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/."

#Bodhi Linux
#http://www.bodhilinux.com/download.html
#http://manpages.ubuntu.com/manpages/lucid/man7/casper.7.html
elif [ "$(grep 'Bodhi Linux' /tmp/multisystem/multisystem-mountpoint-iso/.disk/info 2>/dev/null)" ]; then
modiso="copycontent"
echo "bodhilinux1" >/tmp/multisystem/multisystem-nomdistro
chemindeb="$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/bodhilinux"
find "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")" -maxdepth 1 -path "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/bodhilinux[0-9]" | while read line
do
echo "bodhilinux$(($(echo $line | sed "s@${chemindeb}@@g")+1))" >/tmp/multisystem/multisystem-nomdistro
done
osname="$(cat /tmp/multisystem/multisystem-nomdistro)"
osnamemodif="Bodhi"
osicone="multisystem-bodhilinux"
osloopback=""
oskernel="linux /${osname}/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*vmlinuz*")) live-media-path=/${osname}/casper root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) locale=$(echo "${LANG}" | sed "s/\..*//") bootkbd=${XKBLAYOUT} console-setup/layoutcode=${XKBLAYOUT} console-setup/variantcode=${XKBVARIANT} file=/cdrom/${osname}/preseed/custom.seed boot=casper noprompt quiet splash --"
osinitrd="initrd /${osname}/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*initrd*"))"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${osname}"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/."

#AbulÉdulive
#http://www.abuledu.org/abuledu/monoposte
elif [ "$(grep 'abuledulive' /tmp/multisystem/multisystem-mountpoint-iso/md5sum.txt 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osnamemodif="AbulÉdulive"
osicone="multisystem-abuledulive"
gen_champ="$(grep -m1 'file=.*\.seed' -o /tmp/multisystem/multisystem-mountpoint-iso/isolinux/isolinux.cfg)"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*vmlinuz*")) root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) ${gen_champ} locale=$(echo "${LANG}" | sed "s/\..*//") bootkbd=${XKBLAYOUT} console-setup/layoutcode=${XKBLAYOUT} console-setup/variantcode=${XKBVARIANT} iso-scan/filename=/${osname} boot=casper noprompt quiet splash --"
osinitrd="initrd (loop)/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*initrd*"))"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"


#AbulÉdulive
#Le mot de passe par défaut pour le compte adulte est: ryxeo

#Ylmf-OS
#http://www.ylmf.org/download.html
elif [ "$(grep '^Ylmf' /tmp/multisystem/multisystem-mountpoint-iso/.disk/info 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osnamemodif="Ylmf-OS"
osicone="multisystem-ylmf"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/casper/vmlinuz locale=$(echo "${LANG}" | sed "s/\..*//") bootkbd=${XKBLAYOUT} console-setup/layoutcode=${XKBLAYOUT} console-setup/variantcode=${XKBVARIANT} iso-scan/filename=/${osname} boot=casper file=/cdrom/preseed/ylmf.seed noprompt quiet splash --"
osinitrd="initrd (loop)/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*initrd*"))"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#DEFT Linux pour lancer mode graphique commande ==> deft-gui
#http://www.deftlinux.net/download/
elif [ "$(grep 'DEFT Linux' /tmp/multisystem/multisystem-mountpoint-iso/.disk/info 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osnamemodif="DEFT Linux"
osicone="multisystem-deft"
gen_champ="$(grep -m1 'file=.*\.seed' -o /tmp/multisystem/multisystem-mountpoint-iso/isolinux/txt.cfg)"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*vmlinuz*")) root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) ${gen_champ} ${ubuntu_lang} iso-scan/filename=/${osname} boot=casper noprompt quiet splash --"
osinitrd="initrd (loop)/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*initrd*"))"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#DEFT Linux pour lancer mode graphique commande ==> deft-gui
#http://www.deftlinux.net/download/
elif [ "$(grep 'zzZZzzDEFT Linux live cd' /tmp/multisystem/multisystem-mountpoint-iso/isolinux/text.cfg 2>/dev/null)" ]; then
modiso="copycontent"
echo "deft1" >/tmp/multisystem/multisystem-nomdistro
chemindeb="$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/deft"
find "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")" -maxdepth 1 -path "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/deft[0-9]" | while read line
do
echo "deft$(($(echo $line | sed "s@${chemindeb}@@g")+1))" >/tmp/multisystem/multisystem-nomdistro
done
osname="$(cat /tmp/multisystem/multisystem-nomdistro)"
osnamemodif="DEFT Linux"
osicone="multisystem-deft"
osloopback=""
oskernel="linux /${osname}/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*vmlinuz*")) rw rootfstype=vfat ignore_uuid live-media-path=/${osname}/casper root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) file=/cdrom/${osname}/preseed/ubuntu.seed locale=$(echo "${LANG}" | sed "s/\..*//") bootkbd=${XKBLAYOUT} console-setup/layoutcode=${XKBLAYOUT} console-setup/variantcode=${XKBVARIANT} boot=casper noprompt quiet splash --"
osinitrd="initrd /${osname}/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*initrd*"))"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${osname}"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/."

#caine 2.5.1 (manque lupin-casper) (passe pas attendre v?...)...
#http://www.caine-live.net/
#http://cainelive.aforumfree.com/bugs-problems-questions-f15/problem-liveusb-t141.htm
elif [ "$(grep 'zzZZzz^Caine' /tmp/multisystem/multisystem-mountpoint-iso/.disk/info 2>/dev/null)" ]; then
modiso="copycontent"
echo "caine1" >/tmp/multisystem/multisystem-nomdistro
chemindeb="$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/caine"
find "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")" -maxdepth 1 -path "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/caine[0-9]" | while read line
do
echo "caine$(($(echo $line | sed "s@${chemindeb}@@g")+1))" >/tmp/multisystem/multisystem-nomdistro
done
osname="$(cat /tmp/multisystem/multisystem-nomdistro)"
osnamemodif="Caine"
osicone="multisystem-caine"
osloopback=""
oskernel="linux /${osname}/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*vmlinuz*")) ignore_uuid live-media-path=/${osname}/casper root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) file=/cdrom/${osname}/preseed/custom.seed ${ubuntu_lang} boot=casper noprompt quiet splash --"
osinitrd="initrd /${osname}/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*initrd*"))"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${osname}"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/."

#MCNLive
#http://www.mcnlive.info/index.php?page=download
elif [ "$(grep 'menu title Welcome to MCNLive Kris!' /tmp/multisystem/multisystem-mountpoint-iso/isolinux/isolinux.cfg 2>/dev/null)" ]; then
modiso="copycontent"
if [ ! -d "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/mcnlive" ]; then
osname="mcnlive"
osnamemodif="MCNLive"
osicone="multisystem-mcnlive"
osloopback="search --set -f \"/mcnlive/mcnlive.iso\"\nloopback loop \"/mcnlive/mcnlive.iso\""
oskernel="linux (loop)/isolinux/vmlinuz keyb=us splash=verbose speedboot=no"
osinitrd="initrd /mcnlive/initrd.img"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/mcnlive"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress "${option2}" "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/mcnlive/$(basename "${source}")"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/isolinux/initrd.img "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/mcnlive/initrd.img"
mv "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/mcnlive/"*.iso "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/mcnlive/mcnlive.iso"
mkdir /tmp/multisystem/multisystem-modinitrd 2>/dev/null
cd /tmp/multisystem/multisystem-modinitrd
gzip -dc /tmp/multisystem/multisystem-mountpoint-iso/isolinux/initrd.img | cpio -i
sed -i 's@	mount -o ro LABEL=kris /mnt/hotmedia > /dev/null 2>\&1 \&\& okmsg || failmsg@mount -o ro UUID='$(cat /tmp/multisystem/multisystem-selection-uuid-usb)' /mnt/hotmedia > /dev/null 2>\&1 \&\& okmsg || failmsg\n\tmount -o loop /mnt/hotmedia/mcnlive/mcnlive.iso /mnt/hotmedia > /dev/null 2>\&1 \&\& okmsg || failmsg@' /tmp/multisystem/multisystem-modinitrd/init
#gedit /tmp/multisystem/multisystem-modinitrd/init
#echo Attente
#read
find . | cpio -o -H newc | gzip -9 > "$(cat /tmp/multisystem/multisystem-mountpoint-usb)"/mcnlive/initrd.img
cd -
rm -R /tmp/multisystem/multisystem-modinitrd
else
zenity --error --text "$(eval_gettext "Erreur: LiveCD déjà présent.")"
fi

#TinyMe ATTENTION laisser au dessus de Unity !!!
#http://www.tinymelinux.com/doku.php/download
elif [ "$(echo $(basename "${option2}") | grep 'TinyMe')" ]; then
osname="$(basename "${option2}")"
osnamemodif="TinyMe"
osicone="multisystem-tinyme"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
#Nouvelle version 2012
if [ -f "/tmp/multisystem/multisystem-mountpoint-iso/isolinux/live.gz" ]; then
oskernel="linux (loop)/isolinux/vmlinuz init=linuxrc root=/dev/rd/3 fromusb bootfromiso=/${osname} livecd=livecd ramdisk_size=32768 vga=788 keyb=${XKBLAYOUT} nopat rd_NO_LUKS rd_NO_MD noiswmd fstab=rw,noauto splash=silent"
osinitrd="initrd (loop)/isolinux/live.gz"
else
oskernel="linux (loop)/isolinux/vmlinuz livecd=livecd nocd nohd fromusb noeject bootfromiso=/${osname} root=/dev/rd/3 splash=silent keyb=${XKBLAYOUT} nopat fstab=rw,noauto"
osinitrd="initrd (loop)/isolinux/initrd.gz"
fi
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#Unity (base mandriva) Linux L/P guest/guest ==> NOUVEAU ==> unitycli-i586-20120222.iso
#http://unity-linux.org/downloads/  bootfromiso
elif [ "$(grep 'Unity Linux' /tmp/multisystem/multisystem-mountpoint-iso/isolinux/isolinux.cfg 2>/dev/null)" ]; then
#Changer nom car sinon passe pas avec option bootfromiso=
#mv "${option2}" "$(dirname "${option2}")/unity.iso"
#option2="$(dirname "${option2}")/unity.iso"
osname="$(basename "${option2}")"
osnamemodif="Unity Linux"
osicone="multisystem-unity"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/isolinux/vmlinuz init=linuxrc root=/dev/rd/3 fromusb bootfromiso=/${osname} livecd=livecd ramdisk_size=32768 vga=788 keyb=${XKBLAYOUT} nopat rd_NO_LUKS rd_NO_MD noiswmd fstab=rw,noauto splash=silent"
osinitrd="initrd (loop)/isolinux/live.gz"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#Unity Linux L/P guest/guest (ancienne version)
#http://unity-linux.org/downloads/  bootfromiso
elif [ "$(grep 'Unity Linux Live' /tmp/multisystem/multisystem-mountpoint-iso/isolinux/isolinux.cfg 2>/dev/null)" ]; then
#Changer nom car sinon passe pas avec option bootfromiso=
#mv "${option2}" "$(dirname "${option2}")/unity.iso"
#option2="$(dirname "${option2}")/unity.iso"
osname="$(basename "${option2}")"
osnamemodif="Unity Linux"
osicone="multisystem-unity"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/isolinux/vmlinuz fromusb bootfromiso=/${osname} livecd=livecd root=/dev/rd/3 splash=silent keyb=${XKBLAYOUT} nopat"
osinitrd="initrd (loop)/isolinux/initrd.gz"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#Chameleon OS (base unity-linux) L/P guest/guest
#http://chameleonos.wordpress.com/download-chamelonos/
elif [ "$(grep -i 'chameleonos' <<<"$(basename "${option2}")")" ]; then
#Changer nom car sinon passe pas avec option bootfromiso=
osname="$(basename "${option2}")"
osnamemodif="Chameleon OS"
osicone="multisystem-chameleonos"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/isolinux/vmlinuz fromusb bootfromiso=/${osname} livecd=livecd root=/dev/rd/3 splash=silent keyb=${XKBLAYOUT}"
osinitrd="initrd (loop)/isolinux/initrd.gz"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#BackBox
#BackBox Linux: http://www.backbox.org/content/download
#Distrowatch: http://distrowatch.com/table.php?distribution=backbox
elif [ "$(grep '^BackBox' /tmp/multisystem/multisystem-mountpoint-iso/.disk/info 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osnamemodif="$(basename "${option2}")"
osicone="multisystem-backbox"
gen_champ="$(grep -m1 'file=.*\.seed' -o /tmp/multisystem/multisystem-mountpoint-iso/isolinux/isolinux.cfg)"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*vmlinuz*")) root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) ${gen_champ} ${ubuntu_lang} iso-scan/filename=/${osname} boot=casper noprompt quiet splash --"
osinitrd="initrd (loop)/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*initrd*"))"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#Estobuntu
#http://estobuntu.org/allalaadimine
elif [ "$(grep '^Estobuntu' /tmp/multisystem/multisystem-mountpoint-iso/.disk/info 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osnamemodif="$(basename "${option2}")"
osicone="multisystem-estobuntu"
gen_champ="$(grep -m1 'file=.*\.seed' -o /tmp/multisystem/multisystem-mountpoint-iso/isolinux/t*xt.cfg)"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*vmlinuz*")) root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) ${gen_champ} ${ubuntu_lang} iso-scan/filename=/${osname} boot=casper noprompt quiet splash --"
osinitrd="initrd (loop)/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*initrd*"))"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#BackTrack (v3)
#http://www.remote-exploit.org/backtrack_download.html
elif [ "$(grep 'MENU LABEL BT3 Graphics mode (KDE)' /tmp/multisystem/multisystem-mountpoint-iso/boot/syslinux/syslinux.cfg 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osnamemodif="BackTrack v3 Graphics mode (VESA KDE)"
osicone="multisystem-backtrack"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/boot/vmlinuz from=/${osname} ramdisk_size=6666 root=/dev/ram0 rw autoexec=kdm"
osinitrd="initrd (loop)/boot/initrd.gz"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#PureOSlight login/pass root/root guest/guest
#http://pureos.org/
elif [ "$(grep -i 'PureOSlight' /tmp/multisystem/multisystem-mountpoint-iso/boot/isolinux/isolinux.cfg 2>/dev/null)" ]; then
modiso="copycontent"
if [ ! -d "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/PureOSlight" ]; then
osname="PureOSlight"
osnamemodif="PureOSlight"
osicone="multisystem-pureos"
osloopback=""
oskernel="linux /boot/bootdistro/pureoslight/vmlinuz max_loop=255 init=linuxrc load_ramdisk=1 prompt_ramdisk=0 ramdisk_size=10240 root=/dev/ram0 rw"
osinitrd="initrd /boot/bootdistro/pureoslight/initrd.gz"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
#PureOS
mkdir "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/PureOSlight"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/bootdistro/pureoslight"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/boot/vmlinuz "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/bootdistro/pureoslight/vmlinuz"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/boot/initrd.gz "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/bootdistro/pureoslight/initrd.gz"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/PureOSlight/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/PureOSlight/."
else
zenity --error --text "$(eval_gettext "Erreur: LiveCD déjà présent.")"
fi

#PureOS login/pass root/root guest/guest
#http://pureos.org/
elif [ "$(grep 'DEFAULT pureos' /tmp/multisystem/multisystem-mountpoint-iso/boot/isolinux/isolinux.cfg 2>/dev/null)" ]; then
modiso="copycontent"
if [ ! -d "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/PureOS" ]; then
osname="PureOS"
osnamemodif="PureOS"
osicone="multisystem-pureos"
osloopback=""
oskernel="linux /boot/bootdistro/pureos/vmlinuz max_loop=255 init=linuxrc load_ramdisk=1 prompt_ramdisk=0 ramdisk_size=10240 root=/dev/ram0 rw"
osinitrd="initrd /boot/bootdistro/pureos/initrd.gz"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
#PureOS
mkdir "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/PureOS"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/bootdistro/pureos"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/boot/vmlinuz "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/bootdistro/pureos/vmlinuz"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/boot/initrd.gz "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/bootdistro/pureos/initrd.gz"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/PureOS/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/PureOS/."
else
zenity --error --text "$(eval_gettext "Erreur: LiveCD déjà présent.")"
fi

#PureOS Gnome 1.0 2010 login/pass root/root guest/guest
#http://pureos.org/
elif [ "$(grep 'LABEL pureos' /tmp/multisystem/multisystem-mountpoint-iso/boot/isolinux/isolinux.cfg 2>/dev/null)" ]; then
modiso="copycontent"
if [ ! -d "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/PureOS" ]; then
osname="PureOS"
osnamemodif="PureOS"
osicone="multisystem-pureos"
osloopback=""
oskernel="linux /boot/bootdistro/pureos/vmlinuz ramdisk_size=11264 root=/dev/ram0 rw locale=${LANG} keyb=${XKBLAYOUT}"
osinitrd="initrd /boot/bootdistro/pureos/initrd.gz"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
#PureOS
mkdir "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/PureOS"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/bootdistro/pureos"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/boot/vmlinuz "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/bootdistro/pureos/vmlinuz"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/boot/initrd.gz "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/bootdistro/pureos/initrd.gz"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/PureOS/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/PureOS/."
else
zenity --error --text "$(eval_gettext "Erreur: LiveCD déjà présent.")"
fi

#PureWebOS
#http://www.freetorrent.fr/details.php?id=0613a4153cbbfe013bc1593085c764958b4f4894
elif [ "$(grep 'purewebos' /tmp/multisystem/multisystem-mountpoint-iso/boot/isolinux/isolinux.cfg 2>/dev/null)" ]; then
modiso="copycontent"
if [ ! -d "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/PureWebOS" ]; then
osname="PureWebOS"
osnamemodif="PureWebOS"
osicone="multisystem-pureos"
osloopback=""
oskernel="linux /boot/bootdistro/PureWebOS/vmlinuz ramdisk_size=11264 root=/dev/ram0 rw locale=${LANG} keyb=${XKBLAYOUT}"
osinitrd="initrd /boot/bootdistro/PureWebOS/initrd.gz"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
#PureWebOS
mkdir "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/PureWebOS"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/bootdistro/PureWebOS"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/boot/vmlinuz "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/bootdistro/PureWebOS/vmlinuz"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/boot/initrd.gz "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/bootdistro/PureWebOS/initrd.gz"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/PureWebOS/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/PureWebOS/."
else
zenity --error --text "$(eval_gettext "Erreur: LiveCD déjà présent.")"
fi

#NimbleX 2010 login/pass root/toor
#http://www.nimblex.net/index.php?option=com_content&task=view&id=1&Itemid=1
#http://distrowatch.com/?newsid=06037
elif [ "$(grep 'title NimbleX 2010' /tmp/multisystem/multisystem-mountpoint-iso/boot/grub/menu.lst 2>/dev/null)" ]; then
modiso="copycontent"
if [ ! -d "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/nimblex" ]; then
osname="nimblex"
osnamemodif="NimbleX"
osicone="multisystem-nimblex"
osloopback=""
oskernel="linux  /nimblex/vmlinuz-nx10 quiet splash=silent changes=/nimblex/ autoexec=xconf autoexec=kdm"
osinitrd="initrd /nimblex/initrd-nx10.gz"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
mkdir "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/nimblex"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/boot/vmlinuz-nx10 "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/nimblex/vmlinuz-nx10"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/boot/initrd-nx10.gz "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/nimblex/initrd-nx10.gz"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/nimblex/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/nimblex/."
else
zenity --error --text "$(eval_gettext "Erreur: LiveCD déjà présent.")"
fi

#Android-x86 Live
#http://www.androidx86.org/downloads.html
#http://code.google.com/p/android-x86/downloads/list
#ajouter un mode persistent ?
#dd if=/dev/zero of="/media/multisystem/android1/data.img"  bs=1M count=1024
#mkfs.ext3 -L android-rw -F "/media/multisystem/android1/data.img"
elif [ "$(grep -E "(menu title Android-x86 Live)|(Run Android without installation)" /tmp/multisystem/multisystem-mountpoint-iso/isolinux/isolinux.cfg 2>/dev/null)" ]; then
modiso="copycontent"
echo "android1" >/tmp/multisystem/multisystem-nomdistro
chemindeb="$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/android"
find "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")" -maxdepth 1 -path "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/android[0-9]" | while read line
do
echo "android$(($(echo $line | sed "s@${chemindeb}@@g")+1))" >/tmp/multisystem/multisystem-nomdistro
done
osname="$(cat /tmp/multisystem/multisystem-nomdistro)"
osicone="multisystem-android"
#Mode persistent
function MOD_PERSIST_ANDROID()
{
while true
do
tpersistent="$(zenity --scale --text "$(eval_gettext "Taille du mode persistent en Mio")" --min-value=0 --max-value=4096 --value=0 --step 128)"
stop="$?"
#bt annuler
if [ "$stop" -ne "0" ]; then
echo stop
break
#pas assez de place!
elif [ "$(($(df | grep ^$(cat /tmp/multisystem/multisystem-selection-usb) | awk '{print $4}')/1024))" -lt "${tpersistent}" ]; then
zenity --error --text "<b>$(eval_gettext "Erreur pas suffisament d\047espace libre dans $(cat /tmp/multisystem/multisystem-selection-usb)\n\nSouhaité:${tpersistent}\nDisponible:$(($(df | grep ^$(cat /tmp/multisystem/multisystem-selection-usb) | awk '{print $4}')/1024))")</b>"
#pas de persistet
elif [ "${tpersistent}" == "0" ]; then
echo stop
break
#ok
elif [ "${tpersistent}" != "0" ]; then
echo tpersistent:"${tpersistent}"
function ddgraph()
{
mkdir "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${osname}" 2>/dev/null
dd if="/dev/zero" of="$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${osname}/data.img" bs=1M count=${tpersistent} 2>/tmp/multisystem/tampondd &
sleep 1
pid=$!
while kill -USR1 $pid
do
sleep .5
copie="$(sed -n 3p /tmp/multisystem/tampondd | awk '{print $1}')"
taillemio="$(echo $copie/1024/1024|bc 2>/dev/null)"
if [ "$taillemio" ]; then
echo "# ${taillemio}Mio $(eval_gettext "de") ${tpersistent}Mio $(echo "scale=2; $copie/$(($tpersistent*1024*1024))*100;"|bc)%"
echo "$(echo "scale=2; $copie/$(($tpersistent*1024*1024))*100;"|bc)"
fi
>/tmp/multisystem/tampondd
done | zenity --progress --auto-close --width=400 || kill $pid
}
ddgraph
#Formater le fichier image persistent
mkfs.ext3 -L android-rw -F "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${osname}/data.img"
break
fi
done
}
MOD_PERSIST_ANDROID
if [ "$(grep append /tmp/multisystem/multisystem-mountpoint-iso/isolinux/isolinux.cfg | wc -l)" = "5" ]; then
android1="$(grep append /tmp/multisystem/multisystem-mountpoint-iso/isolinux/isolinux.cfg | head -1 | tail -1 | sed "s%.*append initrd=/initrd.img %%" | sed "s%SRC=%SRC=${osname}%")"
android2="$(grep append /tmp/multisystem/multisystem-mountpoint-iso/isolinux/isolinux.cfg | head -3 | tail -1 | sed "s%.*append initrd=/initrd.img %%" | sed "s%SRC=%SRC=${osname}%")"
android3="$(grep append /tmp/multisystem/multisystem-mountpoint-iso/isolinux/isolinux.cfg | head -4 | tail -1 | sed "s%.*append initrd=/initrd.img %%" | sed "s%SRC=%SRC=${osname}%")"
android4="$(grep append /tmp/multisystem/multisystem-mountpoint-iso/isolinux/isolinux.cfg | head -5 | tail -1 | sed "s%.*append initrd=/initrd.img %%" | sed "s%SRC=%SRC=${osname}%")"
else
android1="$(grep append /tmp/multisystem/multisystem-mountpoint-iso/isolinux/isolinux.cfg | head -1 | tail -1 | sed "s%.*append initrd=/initrd.img %%" | sed "s%SRC=%SRC=${osname}%")"
android2="$(grep append /tmp/multisystem/multisystem-mountpoint-iso/isolinux/isolinux.cfg | head -2 | tail -1 | sed "s%.*append initrd=/initrd.img %%" | sed "s%SRC=%SRC=${osname}%")"
android3="$(grep append /tmp/multisystem/multisystem-mountpoint-iso/isolinux/isolinux.cfg | head -3 | tail -1 | sed "s%.*append initrd=/initrd.img %%" | sed "s%SRC=%SRC=${osname}%")"
android4="$(grep append /tmp/multisystem/multisystem-mountpoint-iso/isolinux/isolinux.cfg | head -4 | tail -1 | sed "s%.*append initrd=/initrd.img %%" | sed "s%SRC=%SRC=${osname}%")"
fi
#Menu 1
ligne1="menuentry \"Android-x86 Live\" {"
ligne2=""
ligne3="linux /${osname}/kernel ${android1}"
ligne4="initrd /${osname}/initrd.img"
ligne5="}"
#Menu 2
ligne6="menuentry \"Android-x86 Live VESA mode\" {"
ligne7=""
ligne8="linux /${osname}/kernel ${android2}"
ligne9="initrd /${osname}/initrd.img"
ligne10="}"
#Menu 3
ligne11="menuentry \"Android-x86 Live Debug mode\" {"
ligne12=""
ligne13="linux /${osname}/kernel ${android3}"
ligne14="initrd /${osname}/initrd.img"
ligne15="}"
#Menu 4
ligne16="menuentry \"Android-x86 Live Installation\" {"
ligne17=""
ligne18="linux /${osname}/kernel ${android4}"
ligne19="initrd /${osname}/initrd.img"
ligne20="}"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD4)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
#android
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${osname}"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/."
#Modifier ramdisk
mkdir /tmp/multisystem/multisystem-modinitrd 2>/dev/null
cd /tmp/multisystem/multisystem-modinitrd
gzip -dc /tmp/multisystem/multisystem-mountpoint-iso/initrd.img | cpio -i
sed -i 's@export PATH@export PATH\nSRC="'${osname}'"\nexport SRC@' /tmp/multisystem/multisystem-modinitrd/init
sed -i 's%mount.ntfs-3g -o rw,force $@%mount -t vfat -o rw $@%' /tmp/multisystem/multisystem-modinitrd/init
#gedit /tmp/multisystem/multisystem-modinitrd/init
#echo Attente1
#read
sudo rm "$(cat /tmp/multisystem/multisystem-mountpoint-usb)"/${osname}/initrd.img
find . | cpio -o -H newc | gzip -9 > "$(cat /tmp/multisystem/multisystem-mountpoint-usb)"/${osname}/initrd.img
cd -
sudo rm -R /tmp/multisystem/multisystem-modinitrd

#Càtix login/pass catix/catix pour boot en gnome
#http://www.catix.cat/
elif [ "$(find /tmp/multisystem/multisystem-mountpoint-iso -maxdepth 1 -name "catix-*-586.ic" | wc -l)" == "1" ]; then
catixname="$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso -maxdepth 1 -name "catix-*-586.ic"))"
modiso="copysqfs"
if [ ! -f "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${catixname}" ]; then
osname="${catixname}"
osnamemodif="Catix"
osicone="multisystem-catix"
function FCT_CATIX()
{
dater="$(date +%d-%m-%Y-%T-%N)"
tailleiso="$(($(du -sB 1 "${option2}" | awk '{print $1}')/1024/1024))Mio"
if [ ! "$osnamemodif" ]; then
osnamemodif="$osname"
fi
cat <<EOF
#MULTISYSTEM_MENU_DEBUT|${dater}|${osname}|${osicone}|${tailleiso}|\n${varcatix}\n#MULTISYSTEM_MENU_FIN|${dater}|${osname}|${osicone}|${tailleiso}|
EOF
}
varcatix="menuentry \"Catix gnome\" {\nlinux /boot/bootdistro/catix/linux root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) usb splash quiet lleuger gdm gnome\n}\nmenuentry \"Catix kde\" {\nlinux /boot/bootdistro/catix/linux root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) usb splash quiet lleuger kdm kde\n}"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_CATIX)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
#catix
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/bootdistro/catix"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/boot/isolinux/linux "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/bootdistro/catix/linux"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/${catixname} "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${catixname}"
else
zenity --error --text "$(eval_gettext "Erreur: LiveCD déjà présent.")"
fi

#Puppy Linux 
#http://www.puppylinux.org/downloads
#Toutoulinux
#http://toutoulinux.free.fr/download.php
#Macpup
#http://macpup.org/
#TEENpup
#http://pupweb.org/wikka/TeenPup
#Hacao
#http://hacao.com/
#psubdir=xxx
#Quirky
#http://bkhome.org/quirky/
#PuppyStudio
#http://puppystudio.tiddlyspot.com/
elif [ "$(grep -E "(stud_.*.sfs)|(eduprofs_.*.sfs)|(edu.*full_.*.sfs)|(wary_.*.sfs)|(edu-431.sfs)|(puppy.*.sfs)|(lupu.*.sfs)|(qrky.*.sfs)|(quirky-.*.sfs)|(pup-.*.sfs)|(pup_.*m.sfs)|(pup_.*.sfs)|(pup_.*toutou.sfs)|(ttl-.*.sfs)" <<<$(ls /tmp/multisystem/multisystem-mountpoint-iso 2>/dev/null))" ]; then
modiso="copycontent"
echo "puppy1" >/tmp/multisystem/multisystem-nompuppy
cheminpuppy="$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/puppy"
find "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")" -maxdepth 1 -path "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/puppy[0-9]" | while read line
do
echo "puppy$(($(echo $line | sed "s@${cheminpuppy}@@g")+1))" >/tmp/multisystem/multisystem-nompuppy
done
osname="$(cat /tmp/multisystem/multisystem-nompuppy)"
osnamemodif="$(sed "s/.iso//"  <<< "$(basename "${option2}")")"
#Attribuer la bonne icone!
##framadvd http://framadvd.org
if [ "$(grep 'Ludo-éducative ASRI éducation' /tmp/multisystem/multisystem-mountpoint-iso/boot/grub/menu.lst 2>/dev/null)" ]; then
osicone="multisystem-framadvd"
osnamemodif="FramaDVD"
#ASRI éducation: http://asri-education.org/
elif [ "$(grep -i 'ludo-éducative' /tmp/multisystem/multisystem-mountpoint-iso/boot/grub/menu.lst 2>/dev/null)" ]; then
osicone="multisystem-asri"
osnamemodif="ASRI"
#ASRI éducation: http://asri-education.org/
elif [ "$(grep -i 'ASRI Edu' /tmp/multisystem/multisystem-mountpoint-iso/boot/grub/menu.lst 2>/dev/null)" ]; then
osicone="multisystem-asri"
osnamemodif="ASRI"
#Toutoulinux
elif [ "$(find /tmp/multisystem/multisystem-mountpoint-iso/ -name "*ttl-*.sfs")" ]; then
osicone="multisystem-toutou"
#Toutoulinux
elif [ "$(find /tmp/multisystem/multisystem-mountpoint-iso/ -name "*toutou*.sfs")" ]; then
osicone="multisystem-toutou"
#EeeToutou
elif [ "$(grep 'EeeToutou' '/tmp/multisystem/multisystem-mountpoint-iso/boot.msg' 2>/dev/null)" ]; then
osicone="multisystem-toutou"
#TEENpup
elif [ "$(grep 'TEENpup' '/tmp/multisystem/multisystem-mountpoint-iso/boot.msg' 2>/dev/null)" ]; then
osicone="multisystem-teenpup"
#Hacao
elif [ "$(grep 'Hacao' '/tmp/multisystem/multisystem-mountpoint-iso/boot.msg' 2>/dev/null)" ]; then
osicone="multisystem-hacao"
#Macpup
elif [ "$(grep 'ttuuxxx' '/tmp/multisystem/multisystem-mountpoint-iso/boot.msg' 2>/dev/null)" ]; then
osicone="multisystem-macpup"
#Quirky 110
elif [ "$(find /tmp/multisystem/multisystem-mountpoint-iso/ -name "*qrky*.sfs")" ]; then
osicone="multisystem-quirky"
osnamemodif="Quirky"
#Quirky
elif [ "$(find /tmp/multisystem/multisystem-mountpoint-iso/ -name "*quirky-*.sfs")" ]; then
osicone="multisystem-quirky"
osnamemodif="Quirky"
#Legacy-OS
elif [ "$(grep -i 'legacy' <<<"$(basename "${option2}")")" ]; then
osicone="multisystem-legacy"
osnamemodif="Legacy-OS"
else
osicone="multisystem-puppylinux"
fi
osloopback=""
#kernel with /proc/ide...
#pmedia= usbflash|usbhd|usbcd|ideflash|idehd|idecd|idezip|satahd|satacd|scsihd|scsicd|cd
#kernel without /proc/ide (libata PATA)...
#pmedia= usbflash|usbhd|usbcd|ataflash|atahd|atacd|atazip|scsihd|scsicd|cd
#pour Vbox mettre ideflash et choisir xvesa!
oskernel="linux /${osname}/vmlinuz psubdir=${osname} pmedia=usbflash"
osinitrd="initrd /${osname}/initrd.gz"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${osname}"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/."

#Watchdog puppy (pas reussit a le booter...)
#http://www.doubleburgerbar.com/watchdog/wd2.iso
#http://puppylinux.org/wikka/Watchdog
elif [ "$(grep 'Start Watchdog' /tmp/multisystem/multisystem-mountpoint-iso/isolinux/isolinux.cfg 2>/dev/null)" ]; then
modiso="copycontent"
if [ ! -d "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/casper" ]; then
osname="casper"
osicone="multisystem-watchdog"
#Menu 1
ligne1="menuentry \"Start Watchdog Debian Live\" {"
ligne2=""
ligne3="linux /casper/vmlinuz1 rootfstype=vfat rw root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) boot=casper username=user hostname=debian keyboard=uk xkeyboard=gb locale=uk persistent"
ligne4="initrd /casper/initrd1.img"
ligne5="}"
#Menu 2
ligne6="menuentry \"Start Debian Live Failsafe\" {"
ligne7=""
ligne8="linux /casper/vmlinuz1 rootfstype=vfat rw root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) boot=casper username=user hostname=debian  noapic noapm nodma nomce nolapic nosmp vga=normal"
ligne9="initrd /casper/initrd1.img"
ligne10="}"
#Menu 3
ligne11="menuentry \"Start Debian Live 686\" {"
ligne12=""
ligne13="linux /casper/vmlinuz2 rootfstype=vfat rw root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) boot=casper username=user hostname=debian"
ligne14="initrd /casper/initrd2.img"
ligne15="}"
#Menu 4
ligne16="menuentry \"Start Debian Live 686 Failsafe\" {"
ligne17=""
ligne18="linux /casper/vmlinuz2 rootfstype=vfat rw root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) boot=casper username=user hostname=debian  noapic noapm nodma nomce nolapic nosmp vga=normal"
ligne19="initrd /casper/initrd2.img"
ligne20="}"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD4)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/casper"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/casper/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/casper/."
else
zenity --error --text "$(eval_gettext "Erreur: LiveCD déjà présent.")"
fi

#Vu comme un Xubuntu
#Blue cherry video security http://hivelocity.dl.sourceforge.net/project/zoneminder-cd/Xubuntu%20Zoneminder%20Live%20CD_s/Version%202%20beta/bluecherry-zm-livecd-2.0b.iso

#Debris 
#http://debrislinux.org/?cat=6
#bug ont pas mis le module vfat ? ==> /lib/modules/2.6.28-dl-10/kernel/fs
#si dev corrige bug module vfat ajouter 2 menus gnome et openbox!
elif [ "$(grep 'zzZZzzDebris Linux' /tmp/multisystem/multisystem-mountpoint-iso/boot/grub/menu.lst 2>/dev/null)" ]; then
modiso="copysqfs"
if [ ! -f "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/debris" ]; then
osname="debris"
osnamemodif="Debris"
osicone="multisystem-debris"
osloopback=""
oskernel="linux /boot/bootdistro/debris/vmlinuz toram fromusb root=/dev/ram0 ramdisk_size=1048576 rw quiet gnome lang=$(echo "${LANG}" | awk -F "_" '{print $1 }')"
osinitrd="initrd /boot/bootdistro/debris/initrd.img-DLL"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/bootdistro/debris"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/boot/vmlinuz "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/bootdistro/debris/vmlinuz"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/boot/initrd.img-DLL "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/bootdistro/debris//initrd.img-DLL"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/debris "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/debris"
else
zenity --error --text "$(eval_gettext "Erreur: LiveCD déjà présent.")"
fi

#GeeXboX >= 2.0 version i386
#http://www.geexbox.org/download/
elif [ "$(grep 'TITLE Welcome to GeeXboX i386 2.0' /tmp/multisystem/multisystem-mountpoint-iso/isolinux/isolinux.cfg 2>/dev/null)" ]; then
modiso="copycontent"
if [ ! -f "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/rootfs-i386" ]; then
osname="rootfs-i386"
osicone="multisystem-geexbox"
#Menu 1
ligne1="menuentry \"GeeXboX i386 live\" {"
ligne2=""
ligne3="linux /boot/bootdistro/rootfs-i386/vmlinuz persistent loglevel=3"
ligne4="initrd /boot/bootdistro/rootfs-i386/initrd"
ligne5="}"
#Menu 2
ligne6="menuentry \"GeeXboX i386 Install\" {"
ligne7=""
ligne8="linux /boot/bootdistro/rootfs-i386/vmlinuz installator quiet loglevel=3"
ligne9="initrd /boot/bootdistro/rootfs-i386/initrd"
ligne10="}"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD2)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/bootdistro/rootfs-i386"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/vmlinuz "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/bootdistro/rootfs-i386/vmlinuz"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/initrd "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/bootdistro/rootfs-i386/initrd"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/rootfs "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/rootfs-i386"
function MOD_PERSIST_geexbox()
{
while true
do
tpersistent="$(zenity --scale --text "$(eval_gettext "Taille du mode persistent en Mio")" --min-value=0 --max-value=4096 --value=0 --step 128)"
stop="$?"
#bt annuler
if [ "$stop" -ne "0" ]; then
echo stop
break
#pas assez de place!
elif [ "$(($(df | grep ^$(cat /tmp/multisystem/multisystem-selection-usb) | awk '{print $4}')/1024))" -lt "${tpersistent}" ]; then
zenity --error --text "<b>$(eval_gettext "Erreur pas suffisament d\047espace libre dans $(cat /tmp/multisystem/multisystem-selection-usb)\n\nSouhaité:${tpersistent}\nDisponible:$(($(df | grep ^$(cat /tmp/multisystem/multisystem-selection-usb) | awk '{print $4}')/1024))")</b>"
#pas de persistet
elif [ "${tpersistent}" == "0" ]; then
echo stop
break
#ok
elif [ "${tpersistent}" != "0" ]; then
echo tpersistent:"${tpersistent}"
function ddgraph()
{
mkdir "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${osname}" 2>/dev/null
dd if="/dev/zero" of="$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/geexbox-i386-rw" bs=1M count=${tpersistent} 2>/tmp/multisystem/tampondd &
sleep 1
pid=$!
while kill -USR1 $pid
do
sleep .5
copie="$(sed -n 3p /tmp/multisystem/tampondd | awk '{print $1}')"
taillemio="$(echo $copie/1024/1024|bc 2>/dev/null)"
if [ "$taillemio" ]; then
echo "# ${taillemio}Mio $(eval_gettext "de") ${tpersistent}Mio $(echo "scale=2; $copie/$(($tpersistent*1024*1024))*100;"|bc)%"
echo "$(echo "scale=2; $copie/$(($tpersistent*1024*1024))*100;"|bc)"
fi
>/tmp/multisystem/tampondd
done | zenity --progress --auto-close --width=400 || kill $pid
}
ddgraph
#Formater le fichier image persistent
mkfs.ext2 -L geexbox-i386-rw -F "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/geexbox-i386-rw"
break
fi
done
}
MOD_PERSIST_geexbox
#Modifier ramdisk
#http://permalink.gmane.org/gmane.comp.embedded.openbricks.devel/277
#xz --decompress --stdout "/home/frafa/Distro/initrd" | cpio -i
mkdir /tmp/multisystem/multisystem-modinitrd 2>/dev/null
cd /tmp/multisystem/multisystem-modinitrd
xz --decompress --stdout "/tmp/multisystem/multisystem-mountpoint-iso/initrd" | cpio -i
#Renommer casper-rw pour ne pas mélanger avec Ubuntu ...
sed -i 's@DATA=/mnt/casper-rw@DATA=/mnt/geexbox-i386-rw@' /tmp/multisystem/multisystem-modinitrd/init
#Dans qemu/vbox et pas pal de pc /sys/block/$dev/removable n'est pas présent si support est usb ...
sed -i 's@$(cat /sys/block/$dev/removable) = 1@-n /dev/${dev}1@' /tmp/multisystem/multisystem-modinitrd/init
#Renommer rootfs
sed -i 's@/mnt/rootfs@/mnt/rootfs-i386@g' /tmp/multisystem/multisystem-modinitrd/init
#gedit /tmp/multisystem/multisystem-modinitrd/init
#echo Attente1
#read
sudo rm "$(cat /tmp/multisystem/multisystem-mountpoint-usb)"/boot/bootdistro/rootfs-i386/initrd
find . | cpio -o -H newc | xz -9 --check=crc32 > "$(cat /tmp/multisystem/multisystem-mountpoint-usb)"/boot/bootdistro/rootfs-i386/initrd
cd -
sudo rm -R /tmp/multisystem/multisystem-modinitrd
else
zenity --error --text "$(eval_gettext "Erreur: LiveCD déjà présent.")"
fi

#GeeXboX >= 2.0 version x86_64
#http://www.geexbox.org/download/
elif [ "$(grep 'TITLE Welcome to GeeXboX x86_64 2.0' /tmp/multisystem/multisystem-mountpoint-iso/isolinux/isolinux.cfg 2>/dev/null)" ]; then
modiso="copycontent"
if [ ! -f "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/rootfs-x86_64" ]; then
osname="rootfs-x86_64"
osicone="multisystem-geexbox"
#Menu 1
ligne1="menuentry \"GeeXboX x86_64 live\" {"
ligne2=""
ligne3="linux /boot/bootdistro/rootfs-x86_64/vmlinuz persistent loglevel=3"
ligne4="initrd /boot/bootdistro/rootfs-x86_64/initrd"
ligne5="}"
#Menu 2
ligne6="menuentry \"GeeXboX x86_64 Install\" {"
ligne7=""
ligne8="linux /boot/bootdistro/rootfs-x86_64/vmlinuz installator quiet loglevel=3"
ligne9="initrd /boot/bootdistro/rootfs-x86_64/initrd"
ligne10="}"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD2)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/bootdistro/rootfs-x86_64"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/vmlinuz "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/bootdistro/rootfs-x86_64/vmlinuz"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/initrd "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/bootdistro/rootfs-x86_64/initrd"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/rootfs "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/rootfs-x86_64"
function MOD_PERSIST_geexbox()
{
while true
do
tpersistent="$(zenity --scale --text "$(eval_gettext "Taille du mode persistent en Mio")" --min-value=0 --max-value=4096 --value=0 --step 128)"
stop="$?"
#bt annuler
if [ "$stop" -ne "0" ]; then
echo stop
break
#pas assez de place!
elif [ "$(($(df | grep ^$(cat /tmp/multisystem/multisystem-selection-usb) | awk '{print $4}')/1024))" -lt "${tpersistent}" ]; then
zenity --error --text "<b>$(eval_gettext "Erreur pas suffisament d\047espace libre dans $(cat /tmp/multisystem/multisystem-selection-usb)\n\nSouhaité:${tpersistent}\nDisponible:$(($(df | grep ^$(cat /tmp/multisystem/multisystem-selection-usb) | awk '{print $4}')/1024))")</b>"
#pas de persistet
elif [ "${tpersistent}" == "0" ]; then
echo stop
break
#ok
elif [ "${tpersistent}" != "0" ]; then
echo tpersistent:"${tpersistent}"
function ddgraph()
{
mkdir "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${osname}" 2>/dev/null
dd if="/dev/zero" of="$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/geexbox-x86_64-rw" bs=1M count=${tpersistent} 2>/tmp/multisystem/tampondd &
sleep 1
pid=$!
while kill -USR1 $pid
do
sleep .5
copie="$(sed -n 3p /tmp/multisystem/tampondd | awk '{print $1}')"
taillemio="$(echo $copie/1024/1024|bc 2>/dev/null)"
if [ "$taillemio" ]; then
echo "# ${taillemio}Mio $(eval_gettext "de") ${tpersistent}Mio $(echo "scale=2; $copie/$(($tpersistent*1024*1024))*100;"|bc)%"
echo "$(echo "scale=2; $copie/$(($tpersistent*1024*1024))*100;"|bc)"
fi
>/tmp/multisystem/tampondd
done | zenity --progress --auto-close --width=400 || kill $pid
}
ddgraph
#Formater le fichier image persistent
mkfs.ext2 -L geexbox-x86_64-rw -F "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/geexbox-x86_64-rw"
break
fi
done
}
MOD_PERSIST_geexbox
#Modifier ramdisk
#http://permalink.gmane.org/gmane.comp.embedded.openbricks.devel/277
#xz --decompress --stdout "/home/frafa/Distro/initrd" | cpio -i
mkdir /tmp/multisystem/multisystem-modinitrd 2>/dev/null
cd /tmp/multisystem/multisystem-modinitrd
xz --decompress --stdout "/tmp/multisystem/multisystem-mountpoint-iso/initrd" | cpio -i
#Renommer casper-rw pour ne pas mélanger avec Ubuntu ...
sed -i 's@DATA=/mnt/casper-rw@DATA=/mnt/geexbox-x86_64-rw@' /tmp/multisystem/multisystem-modinitrd/init
#Dans qemu/vbox et pas pal de pc /sys/block/$dev/removable n'est pas présent si support est usb ...
sed -i 's@$(cat /sys/block/$dev/removable) = 1@-n /dev/${dev}1@' /tmp/multisystem/multisystem-modinitrd/init
#Renommer rootfs
sed -i 's@/mnt/rootfs@/mnt/rootfs-x86_64@g' /tmp/multisystem/multisystem-modinitrd/init
#gedit /tmp/multisystem/multisystem-modinitrd/init
#echo Attente1
#read
sudo rm "$(cat /tmp/multisystem/multisystem-mountpoint-usb)"/boot/bootdistro/rootfs-x86_64/initrd
find . | cpio -o -H newc | xz -9 --check=crc32 > "$(cat /tmp/multisystem/multisystem-mountpoint-usb)"/boot/bootdistro/rootfs-x86_64/initrd
cd -
sudo rm -R /tmp/multisystem/multisystem-modinitrd
else
zenity --error --text "$(eval_gettext "Erreur: LiveCD déjà présent.")"
fi

#Mandriva Linux One 2010.2
#http://www.mandriva.com/en/download
elif [ "$(md5sum /tmp/multisystem/multisystem-mountpoint-iso/boot/vmlinuz 2>/dev/null | awk '{print $1}')" == "b4b2654b480d09e3212010346ddbcfb6" ]; then
modiso="copycontent"
echo "mandriva1" >/tmp/multisystem/multisystem-nomdistro
chemindeb="$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/mandriva"
find "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")" -maxdepth 1 -path "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/mandriva[0-9]" | while read line
do
echo "mandriva$(($(echo $line | sed "s@${chemindeb}@@g")+1))" >/tmp/multisystem/multisystem-nomdistro
done
osname="$(cat /tmp/multisystem/multisystem-nomdistro)"
osicone="multisystem-mandriva"
#Menu 1
ligne1="menuentry \"Mandriva ONE 2010\" {"
ligne2=""
ligne3="linux /boot/bootdistro/${osname}/vmlinuz splash=silent init=linuxrc root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb)"
ligne4="initrd /boot/bootdistro/${osname}/initrd.gz"
ligne5="}"
#Menu 2
ligne6="menuentry \"Mandriva ONE 2010 Install\" {"
ligne7=""
ligne8="linux /boot/bootdistro/${osname}/vmlinuz splash=silent init=linuxrc root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) install"
ligne9="initrd /boot/bootdistro/${osname}/initrd.gz"
ligne10="}"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD2)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${osname}"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/bootdistro/${osname}"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
cp /tmp/multisystem/multisystem-mountpoint-iso/boot/cdrom/initrd.gz "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/bootdistro/${osname}/initrd.gz"
cp /tmp/multisystem/multisystem-mountpoint-iso/boot/vmlinuz "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/bootdistro/${osname}/vmlinuz"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/loopbacks/distrib-lzma.sqfs "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/distrib-lzma.sqfs"
#echo attente
#read
sudo ${dossier}/divers/mandriva_one_2010.sh ${osname}

#Mandriva Linux One 2010 Spring
#http://www.mandriva.com/en/download
elif [ "$(md5sum /tmp/multisystem/multisystem-mountpoint-iso/boot/vmlinuz 2>/dev/null | awk '{print $1}')" == "126c1681ac105884d73ec06c858c232f" ]; then
modiso="copycontent"
echo "mandriva1" >/tmp/multisystem/multisystem-nomdistro
chemindeb="$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/mandriva"
find "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")" -maxdepth 1 -path "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/mandriva[0-9]" | while read line
do
echo "mandriva$(($(echo $line | sed "s@${chemindeb}@@g")+1))" >/tmp/multisystem/multisystem-nomdistro
done
osname="$(cat /tmp/multisystem/multisystem-nomdistro)"
osicone="multisystem-mandriva"
#Menu 1
ligne1="menuentry \"Mandriva ONE 2010\" {"
ligne2=""
ligne3="linux /boot/bootdistro/${osname}/vmlinuz splash=silent init=linuxrc root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb)"
ligne4="initrd /boot/bootdistro/${osname}/initrd.gz"
ligne5="}"
#Menu 2
ligne6="menuentry \"Mandriva ONE 2010 Install\" {"
ligne7=""
ligne8="linux /boot/bootdistro/${osname}/vmlinuz splash=silent init=linuxrc root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) install"
ligne9="initrd /boot/bootdistro/${osname}/initrd.gz"
ligne10="}"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD2)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${osname}"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/bootdistro/${osname}"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
cp /tmp/multisystem/multisystem-mountpoint-iso/boot/cdrom/initrd.gz "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/bootdistro/${osname}/initrd.gz"
cp /tmp/multisystem/multisystem-mountpoint-iso/boot/vmlinuz "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/bootdistro/${osname}/vmlinuz"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/loopbacks/distrib-lzma.sqfs "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/distrib-lzma.sqfs"
#echo attente
#read
sudo ${dossier}/divers/mandriva_one_2010.sh ${osname}

#Mandriva-linux-instanton-2010
#http://www.mandriva.com/fr/instanton/
elif [ "$(grep 'mandriva-linux-instanton-2010' /tmp/multisystem/multisystem-mountpoint-iso/images/list 2>/dev/null)" ]; then
modiso="copycontent"
if [ ! -d "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/i586" ]; then
osname="i586"
osnamemodif="Mandriva-linux-instanton-2010"
osicone="multisystem-mandriva"
osloopback=""
#method:disk,disk:sda,partition:sda1,directory:/${osname} #passe pas ???
oskernel="linux /i586/boot/vmlinuz root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) splash=silent vga=788 automatic=method:disk directory=/i586 keepmounted vga=788 "
osinitrd="initrd /i586/boot/cdrom/initrd.gz"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/i586"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/i586/."
else
zenity --error --text "$(eval_gettext "Erreur: LiveCD déjà présent.")"
fi

#Mandriva 2010
#http://www.mandriva.com/en/download
elif [ "$(md5sum /tmp/multisystem/multisystem-mountpoint-iso/boot/vmlinuz 2>/dev/null | awk '{print $1}')" == "8dd18eab184f013f947e90315a04fb52" ]; then
modiso="copycontent"
echo "mandriva1" >/tmp/multisystem/multisystem-nomdistro
chemindeb="$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/mandriva"
find "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")" -maxdepth 1 -path "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/mandriva[0-9]" | while read line
do
echo "mandriva$(($(echo $line | sed "s@${chemindeb}@@g")+1))" >/tmp/multisystem/multisystem-nomdistro
done
osname="$(cat /tmp/multisystem/multisystem-nomdistro)"
osnamemodif="Mandriva ONE 2010"
osicone="multisystem-mandriva"
osloopback=""
oskernel="linux /boot/bootdistro/${osname}/vmlinuz splash=silent init=linuxrc root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb)"
osinitrd="initrd /boot/bootdistro/${osname}/initrd.gz"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${osname}"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/bootdistro/${osname}"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
cp /tmp/multisystem/multisystem-mountpoint-iso/boot/cdrom/initrd.gz "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/bootdistro/${osname}/initrd.gz"
cp /tmp/multisystem/multisystem-mountpoint-iso/boot/vmlinuz "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/bootdistro/${osname}/vmlinuz"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/loopbacks/distrib-lzma.sqfs "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/distrib-lzma.sqfs"
sudo ${dossier}/divers/mandriva_one_2010.sh ${osname}

#Mandriva 2009
#http://www.mandriva.com/en/download
#modifs special mandriva remplacer initrd et kernel
#http://lordikc.free.fr/wordpress/?page_id=158
#http://lordikc.free.fr/sources/kit_2009.1.tgz
elif [ "$(md5sum /tmp/multisystem/multisystem-mountpoint-iso/boot/vmlinuz 2>/dev/null | awk '{print $1}')" == "5a0ad52ba1d798eb428041b62707cefe" ]; then
modiso="copycontent"
if [ ! -d "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/loopbacks" ]; then
#telecharger archive et decompresser dans /tmp
#http://lordikc.free.fr/sources/kit_2009.1.tgz
wget -nd http://lordikc.free.fr/sources/kit_2009.1.tgz -O /tmp/multisystem/kit_2009.1.tgz 2>&1 \
| sed -u 's/\([ 0-9]\+K\)[ \.]*\([0-9]\+%\) \(.*\)/\2\n#Transfert : \1 (\2) à \3/' \
| zenity --progress --auto-close --width 400 --title "$(eval_gettext 'Téléchargement en cours...')"
if [ -f "/tmp/multisystem/kit_2009.1.tgz" ]; then
#Décompresser archive
cd /tmp/multisystem
mkdir /tmp/multisystem/multisystem-decompress
cd /tmp/multisystem/multisystem-decompress
tar -xvzf /tmp/multisystem/kit_2009.1.tgz
cd -
#copier fichiers aux bons endroits
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/bootdistro/loopbacks"
mv /tmp/multisystem/multisystem-decompress/boot/initrd.usb "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/bootdistro/loopbacks/initrd.usb"
mv /tmp/multisystem/multisystem-decompress/vmlinuz "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/bootdistro/loopbacks/vmlinuz"
#virer archives
rm -R /tmp/multisystem/multisystem-decompress
rm /tmp/multisystem/kit_2009.1.tgz
#
osname="loopbacks"
osnamemodif="Mandriva ONE 2009"
osicone="multisystem-mandriva"
osloopback=""
oskernel="linux /boot/bootdistro/loopbacks/vmlinuz splash=silent"
osinitrd="initrd /boot/bootdistro/loopbacks/initrd.usb"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
#
mkdir "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/loopbacks"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/bootdistro/loopbacks"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/loopbacks/distrib-lzma.sqfs "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/loopbacks/distrib-lzma.sqfs"

#Changer label
if [ ! "$(grep 'mtools_skip_check=1' ~/.mtoolsrc)" ]; then
echo mtools_skip_check=1 >> ~/.mtoolsrc
fi
sudo mlabel -i $(cat /tmp/multisystem/multisystem-selection-usb) ::MANDRIVAONE
zenity --error --text "$(eval_gettext "<b>ATTENTION:</b> pour Mandriva le script est obligé de changer\nle label de votre clé USB elle se nomme maintenant MANDRIVAONE\nveillez à ne pas changer ce label sous peine de ne plus pouvoir démarrer Mandriva,\n\nVeuliiez <b>débrancher/rebrancher</b> votre clé usb pour que votre système affiche le changement.")"
else
zenity --error --text "$(eval_gettext "Erreur: impossible de télécharger l\047archive.")"
fi
else
zenity --error --text "$(eval_gettext "Erreur: LiveCD déjà présent.")"
fi

#knoppix 6.4.4 (dual-arch)
#http://knopper.net/knoppix-mirrors/
elif [ "$(grep -E 'LABEL knoppix64' /tmp/multisystem/multisystem-mountpoint-iso/boot/isolinux/isolinux.cfg 2>/dev/null)" ]; then
modiso="copycontent"
echo "knoppix1" >/tmp/multisystem/multisystem-nomdistro
chemindeb="$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/knoppix"
find "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")" -maxdepth 1 -path "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/knoppix[0-9]" | while read line
do
echo "knoppix$(($(echo $line | sed "s@${chemindeb}@@g")+1))" >/tmp/multisystem/multisystem-nomdistro
done
osname="$(cat /tmp/multisystem/multisystem-nomdistro)"
osnamemodif="knoppix"
osicone="multisystem-knoppix"
#Mode persistent
function MOD_KNOPPIX_PERSIST()
{
while true
do
tpersistent="$(zenity --scale --text "$(eval_gettext "Taille du mode persistent en Mio")" --min-value=0 --max-value=4096 --value=0 --step 128)"
stop="$?"
#bt annuler
if [ "$stop" -ne "0" ]; then
echo stop
break
#pas assez de place!
elif [ "$(($(df | grep ^$(cat /tmp/multisystem/multisystem-selection-usb) | awk '{print $4}')/1024))" -lt "${tpersistent}" ]; then
zenity --error --text "<b>$(eval_gettext "Erreur pas suffisament d\047espace libre dans $(cat /tmp/multisystem/multisystem-selection-usb)\n\nSouhaité:${tpersistent}\nDisponible:$(($(df | grep ^$(cat /tmp/multisystem/multisystem-selection-usb) | awk '{print $4}')/1024))")</b>"
#pas de persistet
elif [ "${tpersistent}" == "0" ]; then
echo stop
break
#ok
elif [ "${tpersistent}" != "0" ]; then
echo tpersistent:"${tpersistent}"
function ddgraph()
{
mkdir "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${osname}" 2>/dev/null
dd if="/dev/zero" of="$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${osname}/knoppix-data.img" bs=1M count=${tpersistent} 2>/tmp/multisystem/tampondd &
sleep 1
pid=$!
while kill -USR1 $pid
do
sleep .5
copie="$(sed -n 3p /tmp/multisystem/tampondd | awk '{print $1}')"
taillemio="$(echo $copie/1024/1024|bc 2>/dev/null)"
if [ "$taillemio" ]; then
echo "# ${taillemio}Mio $(eval_gettext "de") ${tpersistent}Mio $(echo "scale=2; $copie/$(($tpersistent*1024*1024))*100;"|bc)%"
echo "$(echo "scale=2; $copie/$(($tpersistent*1024*1024))*100;"|bc)"
fi
>/tmp/multisystem/tampondd
done | zenity --progress --auto-close --width=400 || kill $pid
}
ddgraph
#Formater le fichier image persistent
mkfs.ext2 -L KNOPPIX -F "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${osname}/knoppix-data.img"
break
fi
done
}
MOD_KNOPPIX_PERSIST
#persistent
if [ -f "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${osname}/knoppix-data.img" ]; then
#Menu 1
ligne1="menuentry \"knoppix\" {"
ligne2=""
ligne3="linux /${osname}/isolinux/linux knoppix_dir=${osname} lang=$(echo "${LANG}" | awk -F "_" '{print $1 }') ramdisk_size=100000 vt.default_utf8=0 apm=power-off nomce libata.force=noncq loglevel=1 tz=localtime noimage"
ligne4="initrd /${osname}/isolinux/minirt.gz"
ligne5="}"
#Menu 2
ligne6="menuentry \"knoppix persistent\" {"
ligne7=""
ligne8="linux /${osname}/isolinux/linux knoppix_dir=${osname} lang=$(echo "${LANG}" | awk -F "_" '{print $1 }') ramdisk_size=100000 vt.default_utf8=0 apm=power-off nomce libata.force=noncq loglevel=1 tz=localtime"
ligne9="initrd /${osname}/isolinux/minirt.gz"
ligne10="}"
#Menu 3
ligne11="menuentry \"knoppix64\" {"
ligne12=""
ligne13="linux /${osname}/isolinux/linux64 knoppix_dir=${osname} lang=$(echo "${LANG}" | awk -F "_" '{print $1 }') ramdisk_size=100000 vt.default_utf8=0 apm=power-off nomce libata.force=noncq loglevel=1 tz=localtime noimage"
ligne14="initrd /${osname}/isolinux/minirt.gz"
ligne15="}"
#Menu 4
ligne16="menuentry \"knoppix64 persistent\" {"
ligne17=""
ligne18="linux /${osname}/isolinux/linux64 knoppix_dir=${osname} lang=$(echo "${LANG}" | awk -F "_" '{print $1 }') ramdisk_size=100000 vt.default_utf8=0 apm=power-off nomce libata.force=noncq loglevel=1 tz=localtime"
ligne19="initrd /${osname}/isolinux/minirt.gz"
ligne20="}"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD4)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
#non persistent
else
#Menu 1
ligne1="menuentry \"knoppix\" {"
ligne2=""
ligne3="linux /${osname}/isolinux/linux knoppix_dir=${osname} lang=$(echo "${LANG}" | awk -F "_" '{print $1 }') ramdisk_size=100000 vt.default_utf8=0 apm=power-off nomce libata.force=noncq loglevel=1 tz=localtime noimage"
ligne4="initrd /${osname}/isolinux/minirt.gz"
ligne5="}"
#Menu 2
ligne6="menuentry \"knoppix64\" {"
ligne7=""
ligne8="linux /${osname}/isolinux/linux64 knoppix_dir=${osname} lang=$(echo "${LANG}" | awk -F "_" '{print $1 }') ramdisk_size=100000 vt.default_utf8=0 apm=power-off nomce libata.force=noncq loglevel=1 tz=localtime noimage"
ligne9="initrd /${osname}/isolinux/minirt.gz"
ligne10="}"
#Menu 3
ligne11="menuentry \"knoppix adriane\" {"
ligne12=""
ligne13="linux /${osname}/isolinux/linux knoppix_dir=${osname} lang=$(echo "${LANG}" | awk -F "_" '{print $1 }') ramdisk_size=100000 vt.default_utf8=0 apm=power-off nomce libata.force=noncq loglevel=1 tz=localtime video=640x480 adriane noimage"
ligne14="initrd /${osname}/isolinux/minirt.gz"
ligne15="}"
#Menu 4
ligne16="menuentry \"knoppix adriane64\" {"
ligne17=""
ligne18="linux /${osname}/isolinux/linux64 knoppix_dir=${osname} lang=$(echo "${LANG}" | awk -F "_" '{print $1 }') ramdisk_size=100000 vt.default_utf8=0 apm=power-off nomce libata.force=noncq loglevel=1 tz=localtime video=640x480 adriane noimage"
ligne19="initrd /${osname}/isolinux/minirt.gz"
ligne20="}"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD4)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
mkdir "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${osname}" 2>/dev/null
fi
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/boot/ "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/KNOPPIX/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/."

#knoppix 6.x
#http://knopper.net/knoppix-mirrors/
elif [ "$(grep -E 'DEFAULT adriane|DEFAULT knoppix' /tmp/multisystem/multisystem-mountpoint-iso/boot/isolinux/isolinux.cfg 2>/dev/null)" ]; then
modiso="copycontent"
echo "knoppix1" >/tmp/multisystem/multisystem-nomdistro
chemindeb="$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/knoppix"
find "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")" -maxdepth 1 -path "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/knoppix[0-9]" | while read line
do
echo "knoppix$(($(echo $line | sed "s@${chemindeb}@@g")+1))" >/tmp/multisystem/multisystem-nomdistro
done
osname="$(cat /tmp/multisystem/multisystem-nomdistro)"
osnamemodif="knoppix"
osicone="multisystem-knoppix"
#Mode persistent
function MOD_KNOPPIX_PERSIST()
{
while true
do
tpersistent="$(zenity --scale --text "$(eval_gettext "Taille du mode persistent en Mio")" --min-value=0 --max-value=4096 --value=0 --step 128)"
stop="$?"
#bt annuler
if [ "$stop" -ne "0" ]; then
echo stop
break
#pas assez de place!
elif [ "$(($(df | grep ^$(cat /tmp/multisystem/multisystem-selection-usb) | awk '{print $4}')/1024))" -lt "${tpersistent}" ]; then
zenity --error --text "<b>$(eval_gettext "Erreur pas suffisament d\047espace libre dans $(cat /tmp/multisystem/multisystem-selection-usb)\n\nSouhaité:${tpersistent}\nDisponible:$(($(df | grep ^$(cat /tmp/multisystem/multisystem-selection-usb) | awk '{print $4}')/1024))")</b>"
#pas de persistet
elif [ "${tpersistent}" == "0" ]; then
echo stop
break
#ok
elif [ "${tpersistent}" != "0" ]; then
echo tpersistent:"${tpersistent}"
function ddgraph()
{
mkdir "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${osname}" 2>/dev/null
dd if="/dev/zero" of="$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${osname}/knoppix-data.img" bs=1M count=${tpersistent} 2>/tmp/multisystem/tampondd &
sleep 1
pid=$!
while kill -USR1 $pid
do
sleep .5
copie="$(sed -n 3p /tmp/multisystem/tampondd | awk '{print $1}')"
taillemio="$(echo $copie/1024/1024|bc 2>/dev/null)"
if [ "$taillemio" ]; then
echo "# ${taillemio}Mio $(eval_gettext "de") ${tpersistent}Mio $(echo "scale=2; $copie/$(($tpersistent*1024*1024))*100;"|bc)%"
echo "$(echo "scale=2; $copie/$(($tpersistent*1024*1024))*100;"|bc)"
fi
>/tmp/multisystem/tampondd
done | zenity --progress --auto-close --width=400 || kill $pid
}
ddgraph
#Formater le fichier image persistent
mkfs.ext2 -L KNOPPIX -F "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${osname}/knoppix-data.img"
break
fi
done
}
MOD_KNOPPIX_PERSIST
#persistent
if [ -f "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${osname}/knoppix-data.img" ]; then
#Menu 1
ligne1="menuentry \"KNOPPIX non-persistent\" {"
ligne2=""
ligne3="linux /${osname}/isolinux/linux knoppix_dir=${osname} ramdisk_size=100000 lang=$(echo "${LANG}" | awk -F "_" '{print $1 }') vt.default_utf8=0 apm=power-off nomce quiet loglevel=0 nolapic_timer knoppix noimage"
ligne4="initrd /${osname}/isolinux/minirt.gz"
ligne5="}"
#Menu 2
ligne6="menuentry \"KNOPPIX persistent\" {"
ligne7=""
ligne8="linux /${osname}/isolinux/linux knoppix_dir=${osname} ramdisk_size=100000 lang=$(echo "${LANG}" | awk -F "_" '{print $1 }') vt.default_utf8=0 apm=power-off nomce quiet loglevel=0 nolapic_timer knoppix"
ligne9="initrd /${osname}/isolinux/minirt.gz"
ligne10="}"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD2)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
#non persistent
else
oskernel="linux /${osname}/isolinux/linux knoppix_dir=${osname} ramdisk_size=100000 lang=$(echo "${LANG}" | awk -F "_" '{print $1 }') vt.default_utf8=0 apm=power-off nomce quiet loglevel=0 nolapic_timer knoppix noimage"
osinitrd="initrd /${osname}/isolinux/minirt.gz"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
mkdir "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${osname}" 2>/dev/null
fi
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/boot/ "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/KNOPPIX/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/."

#TOOROX nouvelle version => Toorox_03.2012-32bit_KDE.iso
#http://toorox.de/index.php/en/download
elif [ "$(grep 'MENU TITLE Toorox' /tmp/multisystem/multisystem-mountpoint-iso/boot/isolinux/menu.cfg 2>/dev/null)" ]; then
modiso="copycontent"
if [ ! -d "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/TOOROX" ]; then
osname="TOOROX"
osnamemodif="TOOROX"
osicone="multisystem-toorox"
osloopback=""
oskernel="linux /boot/bootdistro/TOOROX/linux rw root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) ramdisk_size=100000 init=/sbin/init lang=$(echo "${LANG}" | awk -F "_" '{print $1 }') nomce noapic initrd=minirt.gz BOOT_IMAGE=TOOROX"
osinitrd="initrd /boot/bootdistro/TOOROX/minirt.gz"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
mkdir "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/TOOROX"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/bootdistro/TOOROX/"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/boot/isolinux/ "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/bootdistro/TOOROX/"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/TOOROX/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/TOOROX/."
else
zenity --error --text "$(eval_gettext "Erreur: LiveCD déjà présent.")"
fi

#TOOROX
#http://toorox.de/index.php/en/download
elif [ "$(grep 'MENU TITLE Toorox' /tmp/multisystem/multisystem-mountpoint-iso/boot/isolinux/english.cfg 2>/dev/null)" ]; then
modiso="copycontent"
if [ ! -d "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/TOOROX" ]; then
osname="TOOROX"
osicone="multisystem-toorox"
#Menu 1
ligne1="menuentry \"TOOROX English\" {"
ligne2=""
ligne3="linux /boot/bootdistro/TOOROX/linux rw root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) ramdisk_size=100000 init=/sbin/init lang=us nomce noapic initrd=minirt.gz BOOT_IMAGE=TOOROX"
ligne4="initrd /boot/bootdistro/TOOROX/minirt.gz"
ligne5="}"
#Menu 2
ligne6="menuentry \"TOOROX German\" {"
ligne7=""
ligne8="linux /boot/bootdistro/TOOROX/linux rw root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) ramdisk_size=100000 init=/sbin/init lang=de nomce noapic initrd=minirt.gz BOOT_IMAGE=TOOROX"
ligne9="initrd /boot/bootdistro/TOOROX/minirt.gz"
ligne10="}"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD2)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
mkdir "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/TOOROX"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/bootdistro/TOOROX/"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/boot/isolinux/ "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/bootdistro/TOOROX/"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/TOOROX/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/TOOROX/."
else
zenity --error --text "$(eval_gettext "Erreur: LiveCD déjà présent.")"
fi

#Finnix
#http://www.finnix.org/Download
elif [ "$(grep 'MENU TITLE Finnix' /tmp/multisystem/multisystem-mountpoint-iso/isolinux/isolinux.cfg 2>/dev/null)" ]; then
modiso="copycontent"
if [ ! -d "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/FINNIX" ]; then
osname="FINNIX"
osicone="multisystem-finnix"
#Menu 1
ligne1="menuentry \"Finnix (32-bit)\" {"
ligne2=""
ligne3="linux /boot/bootdistro/finnix/linux apm=power-off quiet rw"
ligne4="initrd /boot/bootdistro/finnix/initrd.xz"
ligne5="}"
#Menu 2
ligne6="menuentry \"Finnix (64-bit)\" {"
ligne7=""
ligne8="linux /boot/bootdistro/finnix/linux64 apm=power-off quiet rw"
ligne9="initrd /boot/bootdistro/finnix/initrd.xz"
ligne10="}"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD2)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
mkdir "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/finnix"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/bootdistro/finnix/"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/isolinux/ "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/bootdistro/finnix/"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/finnix/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/finnix/."
else
zenity --error --text "$(eval_gettext "Erreur: LiveCD déjà présent.")"
fi

#Quantian
#http://quantian.alioth.debian.org/
elif [ "$(grep '7f44bf90da2269e1e7ead8a8fb33c3ae' /tmp/multisystem/multisystem-mountpoint-iso/KNOPPIX/md5sums 2>/dev/null)" ]; then
modiso="copycontent"
if [ ! -d "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/quantian" ]; then
osname="quantian"
osnamemodif="Quantian"
osicone="multisystem-quantian"
osloopback=""
oskernel="linux /quantian/linux26 knoppix_dir=quantian ramdisk_size=100000 init=/etc/init lang=us apm=power-off nomce rw quiet BOOT_IMAGE=knoppix"
osinitrd="initrd /quantian/minirt26.gz"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
#Quantian
mkdir "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/quantian"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/boot/isolinux/linux26 "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/quantian/linux26"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/boot/isolinux/minirt26.gz "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/quantian/minirt26.gz"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/KNOPPIX/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/quantian/."
else
zenity --error --text "$(eval_gettext "Erreur: LiveCD déjà présent.")"
fi

#ClefAgreg (passe pas dans VBox !)
#http://clefagreg.dnsalias.org/telechargements.html
elif [ -f "/tmp/multisystem/multisystem-mountpoint-iso/agreg/agreg" ]; then
modiso="copycontent"
if [ ! -d "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/agreg" ]; then
osname="agreg"
osnamemodif="ClefAgreg"
osicone="multisystem-agreg"
osloopback=""
oskernel="linux /agreg/linux26 root=UUID=/dev/disk/by-uuid/$(cat /tmp/multisystem/multisystem-selection-uuid-usb) rootfstype=vfat knoppix_dir=agreg rw ramdisk_size=100000 init=/etc/init lang=fr apm=power-off vga=791 quiet BOOT_IMAGE=agreg"
osinitrd="initrd /agreg/minirt26.gz"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
#agreg
mkdir "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/agreg"
mkdir "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/home"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/isolinux/linux26 "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/agreg/linux26"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/isolinux/minirt26.gz "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/agreg/minirt26.gz"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/agreg/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/agreg/."
else
zenity --error --text "$(eval_gettext "Erreur: LiveCD déjà présent.")"
fi

#Kaella, Knoppix Linux Azur (passe pas ...)
#http://www.kaella.org/#telechargement

#SuperGamer (base VectorLinux)
#http://SuperGamer.org/get.htm
elif [ -d "/tmp/multisystem/multisystem-mountpoint-iso/SuperGamer" ]; then
modiso="copycontent"
if [ ! -d "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/SuperGamer" ]; then
osname="SuperGamer"
osnamemodif="SuperGamer"
osicone="multisystem-supergamer"
osloopback=""
oskernel="linux /SuperGamer/vmlinuz splash=silent max_loop=255 init=linuxrc load_ramdisk=1 prompt_ramdisk=0 ramdisk_size=10000  root=/dev/ram0 rw"
osinitrd="initrd /SuperGamer/initrd"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
#SuperGamer
mkdir "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/SuperGamer"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Veuillez saisir votre mot de passe d\047administrateur') \033[0m"
#Remonter
sudo umount /tmp/multisystem/multisystem-mountpoint-iso
sleep 2
mkdir /tmp/multisystem/multisystem-mountpoint-iso
sudo mount -o loop "${option2}" /tmp/multisystem/multisystem-mountpoint-iso
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
sudo rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/boot/initrd "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/SuperGamer/initrd"
sudo rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/boot/vmlinuz "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/SuperGamer/vmlinuz"
sudo rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/SuperGamer/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/SuperGamer/."
else
zenity --error --text "$(eval_gettext "Erreur: LiveCD déjà présent.")"
fi

#Damn Small Linux DSL
#http://www.damnsmalllinux.org/download.html
elif [ "$(grep 'John@damnsmalllinux.org' /tmp/multisystem/multisystem-mountpoint-iso/index.html 2>/dev/null)" ]; then
modiso="copycontent"
if [ ! -d "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/damnsmall" ]; then
osname="damnsmall"
osnamemodif="Damn Small Linux"
osicone="multisystem-damnsmall"
osloopback=""
vintrd="initrd16"
vkernel="linux16"
#Corriger pour grub2 v1.96
if [ "$(grub-install -v | grep 1.96)" ]; then
vintrd="initrd"
vkernel="linux"
fi
oskernel="${vkernel} /boot/bootdistro/damnsmall/isolinux/linux24 knoppix_dir=damnsmall ramdisk_size=100000 lang=$(echo "${LANG}" | awk -F "_" '{print $1 }') apm=power-off nomce noapic quiet BOOT_IMAGE=knoppix"
osinitrd="${vintrd} /boot/bootdistro/damnsmall/isolinux/minirt24.gz"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
#damnsmall
mkdir "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/damnsmall"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/bootdistro/damnsmall/isolinux"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/boot/ "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/bootdistro/damnsmall/"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/KNOPPIX/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/damnsmall/."
else
zenity --error --text "$(eval_gettext "Erreur: LiveCD déjà présent.")"
fi

#Damn Small Linux DSL dsl-n
#http://www.damnsmalllinux.org/download.html
elif [ "$(grep 'LABEL dsl' /tmp/multisystem/multisystem-mountpoint-iso/isolinux/isolinux.cfg 2>/dev/null)" ]; then
modiso="copycontent"
if [ ! -d "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/dsl-n" ]; then
osname="dsl-n"
osnamemodif="Damn Small Linux dsl-n"
osicone="multisystem-damnsmall"
osloopback=""
vintrd="initrd16"
vkernel="linux16"
#Corriger pour grub2 v1.96
if [ "$(grub-install -v | grep 1.96)" ]; then
vintrd="initrd"
vkernel="linux"
fi
oskernel="${vkernel} /boot/bootdistro/dsl-n/linux knoppix_dir=dsl-n ramdisk_size=100000 lang=$(echo "${LANG}" | awk -F "_" '{print $1 }') apm=power-off nomce noapic quiet BOOT_IMAGE=knoppix"
osinitrd="${vintrd} /boot/bootdistro/dsl-n/minirt.gz"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
#dsl-n
mkdir "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/dsl-n"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/bootdistro/dsl-n/isolinux"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/isolinux/ "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/bootdistro/dsl-n/"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/KNOPPIX/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/dsl-n/."
else
zenity --error --text "$(eval_gettext "Erreur: LiveCD déjà présent.")"
fi

#STUX
#http://www.gpstudio.com/stux/download.html
elif [ -f "/tmp/multisystem/multisystem-mountpoint-iso/STUX/STUX" ]; then
modiso="copycontent"
if [ ! -d "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/STUX" ]; then
osname="STUX"
osicone="multisystem-stux"
osloopback=""
oskernel="linux /boot/bootdistro/stux/isolinux/linux ramdisk_size=100000 init=/etc/init lang=$(echo "${LANG}" | awk -F "_" '{print $1 }') apm=power-off nomce highres=off loglevel=0 libata.atapi_enabled=1 quiet SELINUX_INIT=NO nmi_watchdog=0 BOOT_IMAGE=stux"
osinitrd="initrd /boot/bootdistro/stux/isolinux/minirt.gz"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
#STUX
mkdir "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/STUX"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/bootdistro/stux/isolinux"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/boot/ "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/bootdistro/stux/"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/STUX/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/STUX/."
else
zenity --error --text "$(eval_gettext "Erreur: LiveCD déjà présent.")"
fi

#kademar
#http://www.kademar.org/kademar-linux/
elif [ -f "/tmp/multisystem/multisystem-mountpoint-iso/kademar/base/kademar.lzm" ]; then
modiso="copycontent"
if [ ! -d "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/kademar" ]; then
osname="kademar"
osicone="multisystem-kdemar"
osloopback=""
oskernel="linux /kademar/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/boot -iname "*vmlinuz*")) ramdisk_size=20000 SELINUX_INIT=NO root=/dev/ram0 rw splash=silent console=tty1 quiet vga=791  lang=$(echo "${LANG}" | awk -F "_" '{print $1 }')"
osinitrd="initrd /kademar/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/boot -iname "*initrd*"))"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
mkdir "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/kademar"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/boot/initrd-* "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/kademar/"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/boot/vmlinuz-* "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/kademar/"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/kademar/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/kademar/."
else
zenity --error --text "$(eval_gettext "Erreur: LiveCD déjà présent.")"
fi

#INSERT - Inside Security rescue toolkit:
#http://www.inside-security.de/download_en.html
#trop vieux ramdisk de knoppix, ne supporte que le boot sur ext2, pas possible en vfat...

#yoper
#passe pas...
#http://www.yoper.com/?action=downloads

#MEPIS Linux
#http://www.mepis.org/mirrors
#SimplyMEPIS-CD_8.0.06-rel_32.iso SimplyMEPIS-CD_8.0.12-rel_32.iso ok
elif [ "$(grep 'SimplyMEPIS' /tmp/multisystem/multisystem-mountpoint-iso/version 2>/dev/null)" ]; then
modiso="copycontent"
if [ ! -d "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/mepis" ]; then
osname="mepis"
osnamemodif="MEPIS Linux"
osicone="multisystem-mepis"
osloopback=""
oskernel="linux /boot/bootdistro/mepis/vmlinuz init=/etc/init rw quiet splash"
osinitrd="initrd /boot/bootdistro/mepis/initrd.gz"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
#mepis
mkdir "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/mepis"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/bootdistro/mepis/"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/boot/ "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/bootdistro/mepis/"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/mepis/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/mepis/."
else
zenity --error --text "$(eval_gettext "Erreur: LiveCD déjà présent.")"
fi

#SystemRescueCd isoloop=/xxx.iso rdinit=/linuxrc2
#http://www.sysresccd.org/Download
elif [ "$(grep -i 'default rescuecd' /tmp/multisystem/multisystem-mountpoint-iso/isolinux/isolinux.cfg 2>/dev/null)" ]; then
modiso="copycontent"
if [ ! -d "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/systemrescuecd" ]; then
osname="systemrescuecd"
osicone="multisystem-systemrescue"
#Menu 1
ligne1="menuentry \"SystemRescueCd 32bit\" {"
ligne2=""
ligne3="linux /systemrescuecd/isolinux/rescuecd rootfs=/systemrescuecd subdir=systemrescuecd dostartx setkmap=${XKBLAYOUT}"
ligne4="initrd /systemrescuecd/isolinux/initram.igz"
ligne5="}"
#Menu 2
ligne6="menuentry \"SystemRescueCd 64bit\" {"
ligne7=""
ligne8="linux /systemrescuecd/isolinux/rescue64 rootfs=/systemrescuecd subdir=systemrescuecd dostartx setkmap=${XKBLAYOUT}"
ligne9="initrd /systemrescuecd/isolinux/initram.igz"
ligne10="}"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD2)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
#systemrescuecd
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/systemrescuecd"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/systemrescuecd/."
else
zenity --error --text "$(eval_gettext "Erreur: LiveCD déjà présent.")"
fi

#oscar systemrescuecd
#
elif [ "$(grep -i 'oscar docache' /tmp/multisystem/multisystem-mountpoint-iso/isolinux/isolinux.cfg 2>/dev/null)" ]; then
modiso="copycontent"
if [ ! -d "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/oscar" ]; then
osname="oscar"
osnamemodif="oscar"
osicone="multisystem-systemrescue"
osloopback=""
oskernel="linux /oscar/isolinux/oscar rootfs=/oscar subdir=oscar setkmap=azerty cdoscar fin_ligne"
osinitrd="initrd /oscar/isolinux/oscar.igz"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
#oscar
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/oscar"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/oscar/."
else
zenity --error --text "$(eval_gettext "Erreur: LiveCD déjà présent.")"
fi

#Calculate (base Gentoo)
#http://www.calculate-linux.org/main/en/download
elif [ "$(grep 'MENU TITLE Welcome to Calculate Linux' /tmp/multisystem/multisystem-mountpoint-iso/isolinux/isolinux.cfg 2>/dev/null)" ]; then
modiso="copycontent"
echo "calculate1" >/tmp/multisystem/multisystem-nomdistro
chemindeb="$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/calculate"
find "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")" -maxdepth 1 -path "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/calculate[0-9]" | while read line
do
echo "calculate$(($(echo $line | sed "s@${chemindeb}@@g")+1))" >/tmp/multisystem/multisystem-nomdistro
done
osname="$(cat /tmp/multisystem/multisystem-nomdistro)"
osicone="multisystem-calculate"
#Menu 1
ligne1="menuentry \"Calculate Linux Desktop LiveDVD\" {"
ligne2=""
ligne3="linux /${osname}/boot/vmlinuz subdir=${osname} root=/dev/ram0 init=/linuxrc looptype=squashfs unionfs cdroot_type=vfat doload=vfat,nls_cp866,nls_utf8,squashfs,isofs,unionfs loop=/${osname}/livecd.squashfs nodevfs cdroot video=uvesafb:ywrap,1024x768-32\@60,mtrr:3,splash=silent,theme:tty1 console=tty1 udev quiet noresume doscsi scandelay=2"
ligne4="initrd /${osname}/boot/initrd"
ligne5="}"
#Menu 2
ligne6="menuentry \"Calculate Linux Desktop LiveDVD (RAM)\" {"
ligne7=""
ligne8="linux /${osname}/boot/vmlinuz subdir=${osname} root=/dev/ram0 init=/linuxrc looptype=squashfs unionfs cdroot_type=vfat doload=vfat,nls_cp866,nls_utf8,squashfs,isofs,unionfs loop=/${osname}/livecd.squashfs nodevfs cdroot video=uvesafb:ywrap,1024x768-32\@60,mtrr:3,splash=silent,theme:tty1 console=tty1 udev quiet noresume doscsi docache scandelay=2"
ligne9="initrd /${osname}/boot/initrd"
ligne10="}"
#Menu 3
ligne11="menuentry \"Calculate Linux Desktop LiveDVD (No-X)\" {"
ligne12=""
ligne13="linux /${osname}/boot/vmlinuz subdir=${osname} root=/dev/ram0 init=/linuxrc looptype=squashfs unionfs cdroot_type=vfat doload=vfat,nls_cp866,nls_utf8,squashfs,isofs,unionfs loop=/${osname}/livecd.squashfs nodevfs cdroot video=uvesafb:ywrap,1024x768-32\@60,mtrr:3,splash=silent,theme:tty1 console=tty1 udev quiet noresume doscsi nox scandelay=2"
ligne14="initrd /${osname}/boot/initrd"
ligne15="}"
#Menu 4
ligne16="menuentry \"Calculate Linux Desktop LiveDVD Builder\" {"
ligne17=""
ligne18="linux /${osname}/boot/vmlinuz subdir=${osname} root=/dev/ram0 init=/linuxrc looptype=squashfs unionfs cdroot_type=vfat doload=vfat,nls_cp866,nls_utf8,squashfs,isofs,unionfs loop=/${osname}/livecd.squashfs nodevfs cdroot video=uvesafb:ywrap,1024x768-32\@60,mtrr:3,splash=silent,theme:tty1 console=tty1 udev quiet noresume doscsi scratch scandelay=2"
ligne19="initrd /${osname}/boot/initrd"
ligne20="}"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD4)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${osname}"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/."

#UTUTO (base Gentoo)
#http://www.ututo.org/www/modules/downloads/downloads.php
#pas reussit...
elif [ "$(grep 'menu label UTUTO' /tmp/multisystem/multisystem-mountpoint-iso/isolinux/isolinux.cfg 2>/dev/null)" ]; then
modiso="copycontent"
if [ ! -d "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/ututo" ]; then
osname="ututo"
osicone="multisystem-ututo"
osloopback=""
oskernel="linux /ututo/isolinux/ututoata root=/dev/ram0 init=/linuxrc dokeymap looptype=squashfs subdir=ututo loop=/ututo/image.squashfs  cdroot fbcondecor=silent,theme:ututo CONSOLE=/dev/tty1 quiet udev doscsi elevator=cfq"
osinitrd="initrd /ututo/isolinux/ututoata.igz"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/ututo"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/ututo/."
else
zenity --error --text "$(eval_gettext "Erreur: LiveCD déjà présent.")"
fi

#Gentoo Linux - LiveDVD 11.0
#hhttp://gentoo.mirrors.tds.net/pub/gentoo/releases/
#subdir= cdroot_type= real_root=LABEL=label real_root=UUID=uuid real_rootflags
elif [ "$(grep -i 'label gentoo-x86-amd64' /tmp/multisystem/multisystem-mountpoint-iso/isolinux/isolinux.cfg 2>/dev/null)" ]; then
modiso="copycontent"
echo "gentoo1" >/tmp/multisystem/multisystem-nomdistro
chemindeb="$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/gentoo"
find "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")" -maxdepth 1 -path "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/gentoo[0-9]" | while read line
do
echo "gentoo$(($(echo $line | sed "s@${chemindeb}@@g")+1))" >/tmp/multisystem/multisystem-nomdistro
done
osname="$(cat /tmp/multisystem/multisystem-nomdistro)"
osicone="multisystem-gentoo"
if [[ -f "/tmp/multisystem/multisystem-mountpoint-iso/boot/gentoo" && -f "/tmp/multisystem/multisystem-mountpoint-iso/boot/gentoo64" ]]; then
#Menu 1
ligne1="menuentry \"Gentoo x86\" {"
ligne2=""
ligne3="linux /${osname}/boot/gentoo root=/dev/ram0 init=/linuxrc dokeymap looptype=squashfs subdir=${osname} loop=/${osname}/image.squashfs cdroot"
ligne4="initrd /${osname}/boot/gentoo.igz"
ligne5="}"
#Menu 2
ligne6="menuentry \"Gentoo x86-amd64\" {"
ligne7=""
ligne8="linux /${osname}/boot/gentoo64  root=/dev/ram0 init=/linuxrc dokeymap looptype=squashfs subdir=${osname} loop=/${osname}/image.squashfs cdroot"
ligne9="initrd /${osname}/boot/gentoo64.igz"
ligne10="}"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD2)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
else
osnamemodif="Gentoo"
oskernel="linux /${osname}/boot/gentoo root=/dev/ram0 init=/linuxrc dokeymap looptype=squashfs subdir=${osname} loop=/${osname}/image.squashfs cdroot"
osinitrd="initrd /${osname}/boot/gentoo.igz"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
fi
#gentoo
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${osname}"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/."

#Gentoo Minimal CD (install-x86-minimal-20111004.iso)
#http://distfiles.gentoo.org/releases/x86/autobuilds/current-iso/
elif [ "$(grep -i 'gentoo-nofb' /tmp/multisystem/multisystem-mountpoint-iso/isolinux/kernels.msg 2>/dev/null)" ]; then
modiso="copycontent"
echo "gentoo1" >/tmp/multisystem/multisystem-nomdistro
chemindeb="$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/gentoo"
find "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")" -maxdepth 1 -path "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/gentoo[0-9]" | while read line
do
echo "gentoo$(($(echo $line | sed "s@${chemindeb}@@g")+1))" >/tmp/multisystem/multisystem-nomdistro
done
osname="$(cat /tmp/multisystem/multisystem-nomdistro)"
osicone="multisystem-gentoo"
osnamemodif="Gentoo"
oskernel="linux /${osname}/isolinux/gentoo root=/dev/ram0 init=/linuxrc dokeymap looptype=squashfs subdir=${osname} loop=/${osname}/image.squashfs cdroot"
osinitrd="initrd /${osname}/isolinux/gentoo.igz"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${osname}"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/."

#Gentoo Minimal CD (install-alpha-minimal-20111008.iso)
#http://distfiles.gentoo.org/releases/alpha/autobuilds/current-iso/
elif [ "$(grep -i 'gentoo' /tmp/multisystem/multisystem-mountpoint-iso/etc/aboot.conf 2>/dev/null)" ]; then
modiso="copycontent"
echo "gentoo1" >/tmp/multisystem/multisystem-nomdistro
chemindeb="$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/gentoo"
find "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")" -maxdepth 1 -path "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/gentoo[0-9]" | while read line
do
echo "gentoo$(($(echo $line | sed "s@${chemindeb}@@g")+1))" >/tmp/multisystem/multisystem-nomdistro
done
osname="$(cat /tmp/multisystem/multisystem-nomdistro)"
osicone="multisystem-gentoo"
osnamemodif="Gentoo"
oskernel="linux /${osname}/boot/gentoo root=/dev/ram0 init=/linuxrc dokeymap looptype=squashfs subdir=${osname} loop=/${osname}/image.squashfs cdroot"
osinitrd="initrd /${osname}/boot/gentoo.igz"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${osname}"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/."

#PapugLinux base Gentoo >= 11.1
#http://www.papuglinux.net/Download/
elif [ "$(grep 'MENU LABEL Run PapugLinux' /tmp/multisystem/multisystem-mountpoint-iso/boot/livecd.cfg 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osicone="multisystem-papug"
#Menu 1
ligne1="menuentry \"PapugLinux\" {"
ligne2="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
ligne3="linux (loop)/boot/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/boot -iname "*vmlinuz*")) from=/${osname} ramdisk_size=9999 root=/dev/ram0 rw noauto"
ligne4="initrd (loop)/boot/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/boot -iname "*initrd*"))"
ligne5="}"
#Menu 2
ligne6="menuentry \"PapugLinux Copy2Ram\" {"
ligne7="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
ligne8="linux (loop)/boot/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/boot -iname "*vmlinuz*")) from=/${osname} ramdisk_size=9999 root=/dev/ram0 rw noauto copy2ram"
ligne9="initrd (loop)/boot/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/boot -iname "*initrd*"))"
ligne10="}"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD2)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#PapugLinux base Gentoo
#http://www.papuglinux.net/Download/
elif [ "$(grep 'MENU LABEL Run PapugLinux' /tmp/multisystem/multisystem-mountpoint-iso/boot/isolinux/isolinux.cfg 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osnamemodif="PapugLinux"
osicone="multisystem-papug"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/boot/vmlinuz from=/${osname} root=/dev/ram0 copy2ram"
osinitrd="initrd (loop)/boot/initrd.gz"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#Igelle (passe pas en vfat)
#http://www.igelle.com/get-igelle

#sabayonlinux (mettre dans un dossier livecd car sinon install echoue ==> subdir=livecd)
#http://www.sabayonlinux.org/mod/mirrors/
elif [ "$(grep -i 'LABEL.*sabayon' /tmp/multisystem/multisystem-mountpoint-iso/isolinux/isolinux.cfg /tmp/multisystem/multisystem-mountpoint-iso/isolinux/txt.cfg 2>/dev/null)" ]; then
modiso="copycontent"
echo "sabayon1" >/tmp/multisystem/multisystem-nomdistro
chemindeb="$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/sabayon"
find "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")" -maxdepth 1 -path "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/sabayon[0-9]" | while read line
do
echo "sabayon$(($(echo $line | sed "s@${chemindeb}@@g")+1))" >/tmp/multisystem/multisystem-nomdistro
done
osname="$(cat /tmp/multisystem/multisystem-nomdistro)"
osnamemodif="$(sed "s/.iso//"  <<< "$(basename "${option2}")")"
osicone="multisystem-sabayon"
if [ "$(grep 'sabayonmce' /tmp/multisystem/multisystem-mountpoint-iso/isolinux/isolinux.cfg /tmp/multisystem/multisystem-mountpoint-iso/isolinux/txt.cfg 2>/dev/null)" ]; then
#Menu 1
ligne1="menuentry \"${osnamemodif}\" {"
ligne2=""
ligne3="linux /${osname}/boot/sabayon lang=$(echo "${LANG}" | sed "s/\..*//") root=/dev/ram0 aufs init=/linuxrc cdroot subdir=${osname} looptype=squashfs max_loop=64 loop=/${osname}/livecd.squashfs splash=silent,theme:sabayon console=tty1 quiet music --"
ligne4="initrd /${osname}/boot/sabayon.igz"
ligne5="}"
#Menu 2
ligne6="menuentry \"${osnamemodif} Media Center\" {"
ligne7=""
ligne8="linux /${osname}/boot/sabayon lang=$(echo "${LANG}" | sed "s/\..*//") root=/dev/ram0 aufs init=/linuxrc cdroot subdir=${osname} looptype=squashfs max_loop=64 loop=/${osname}/livecd.squashfs splash=silent,theme:sabayon console=tty1 quiet sabayonmce --"
ligne9="initrd /${osname}/boot/sabayon.igz"
ligne10="}"
#Menu 3
ligne11="menuentry \"${osnamemodif} UMPC\" {"
ligne12=""
ligne13="linux /${osname}/boot/sabayon lang=$(echo "${LANG}" | sed "s/\..*//") root=/dev/ram0 aufs init=/linuxrc cdroot subdir=${osname} looptype=squashfs max_loop=64 loop=/${osname}/livecd.squashfs splash=silent,theme:sabayon console=tty1 quiet eeepc --"
ligne14="initrd /${osname}/boot/sabayon.igz"
ligne15="}"
#Menu 4
ligne16="menuentry \"${osnamemodif} Media C. UMPC\" {"
ligne17=""
ligne18="linux /${osname}/boot/sabayon lang=$(echo "${LANG}" | sed "s/\..*//") root=/dev/ram0 aufs init=/linuxrc cdroot subdir=${osname} looptype=squashfs max_loop=64 loop=/${osname}/livecd.squashfs splash=silent,theme:sabayon console=tty1 quiet eeepc sabayonmce --"
ligne19="initrd /${osname}/boot/sabayon.igz"
ligne20="}"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD4)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
else
#Menu 1
ligne1="menuentry \"${osnamemodif} sabayonnomusic\" {"
ligne2=""
ligne3="linux /${osname}/boot/sabayon lang=$(echo "${LANG}" | sed "s/\..*//") root=/dev/ram0 aufs init=/linuxrc cdroot subdir=${osname} looptype=squashfs max_loop=64 loop=/${osname}/livecd.squashfs splash=silent,theme:sabayon console=tty1 quiet --"
ligne4="initrd /${osname}/boot/sabayon.igz"
ligne5="}"
#Menu 2
ligne6="menuentry \"${osnamemodif} Graphical Installation\" {"
ligne7=""
ligne8="linux /${osname}/boot/sabayon lang=$(echo "${LANG}" | sed "s/\..*//") root=/dev/ram0 aufs init=/linuxrc cdroot subdir=${osname} looptype=squashfs max_loop=64 loop=/${osname}/livecd.squashfs splash=silent,theme:sabayon console=tty1 quiet installer-gui --"
ligne9="initrd /${osname}/boot/sabayon.igz"
ligne10="}"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD2)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
fi
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${osname}"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/."

#VLOS (Vidalinux Desktop OS)
#http://os.vidalinux.org/index.php/Download
elif [ "$(grep 'LABEL vidalinux' /tmp/multisystem/multisystem-mountpoint-iso/isolinux/isolinux.cfg 2>/dev/null)" ]; then
modiso="copycontent"
if [ ! -d "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/vidalinux" ]; then
osname="vidalinux"
osicone="multisystem-vlos"
osloopback=""
oskernel="linux /vidalinux/boot/sabayon root=/dev/ram0 initrd=/vidalinux/boot/sabayon.igz aufs init=/linuxrc cdroot subdir=vidalinux looptype=squashfs max_loop=64 loop=/vidalinux/livecd.squashfs splash=silent,theme:sabayon console=tty1 quiet music --"
osinitrd="initrd /vidalinux/boot/sabayon.igz"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
#vidalinux
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/vidalinux"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/vidalinux/."
else
zenity --error --text "$(eval_gettext "Erreur: LiveCD déjà présent.")"
fi

#NuTyX
#http://www.nutyx.org/?p=telechargement
elif [ -d "/tmp/multisystem/multisystem-mountpoint-iso//NuTyX" ]; then
modiso="copycontent"
if [ ! -d "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/NuTyX" ]; then
osname="NuTyX"
osicone="multisystem-nutyx"
osnamemodif="NuTyX"
oskernel="linux /NuTyX/kernel init=init rootfstype=vfat vga=791 rootdelay=1 ro"
osinitrd="initrd /NuTyX/initrd"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
#NuTyX
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/NuTyX"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/NuTyX/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/NuTyX/."
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/isolinux/kernel "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/NuTyX/kernel"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/isolinux/initrd "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/NuTyX/initrd"
else
zenity --error --text "$(eval_gettext "Erreur: LiveCD déjà présent.")"
fi

#NuTyX boot pxe
#http://www.nutyx.org/?p=telechargement
elif [ "$(grep 'NuTyX' /tmp/multisystem/multisystem-mountpoint-iso//isolinux/boot.msg 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osicone="multisystem-nutyx"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/isolinux/kernel vga=791 rootdelay=1 ro quiet"
osinitrd="initrd (loop)/isolinux/initrd"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#pentoo
#http://www.pentoo.ch/download/
elif [ "$(grep 'label pentoo' /tmp/multisystem/multisystem-mountpoint-iso/isolinux/isolinux.cfg 2>/dev/null)" ]; then
modiso="copycontent"
if [ ! -d "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/pentoo" ]; then
osname="pentoo"
osicone="multisystem-pentoo"
osloopback=""
oskernel="linux /pentoo/isolinux/pentoo root=/dev/ram0 init=/linuxrc  aufs max_loop=256 dokeymap looptype=squashfs subdir=pentoo loop=/pentoo/image.squashfs  cdroot video=uvesafb:mtrr:3,ywrap,1024x768-16 usbcore.autosuspend=1 console=tty0"
osinitrd="initrd /pentoo/isolinux/pentoo.igz"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
#pentoo
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/pentoo"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/pentoo/."
else
zenity --error --text "$(eval_gettext "Erreur: LiveCD déjà présent.")"
fi

#Scientific-Linux root/root sluser/
#https://www.scientificlinux.org/download/
elif [ "$(grep 'SL Live CD/DVD' /tmp/multisystem/multisystem-mountpoint-iso/LICENSE 2>/dev/null)" ]; then
modiso="copycontent"
if [ ! -d "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/scientificLinux" ]; then
osname="scientificLinux"
osnamemodif="Scientific-Linux"
osicone="multisystem-scientificLinux"
osloopback=""
oskernel="linux /scientificLinux/boot/vmlinuz init=linuxrc max_loop=32 ramdisk_size=50000 root=/dev/ram0 rw"
osinitrd="initrd /scientificLinux/boot/initrd.gz"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/scientificLinux"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/scientificLinux/."
else
zenity --error --text "$(eval_gettext "Erreur: LiveCD déjà présent.")"
fi

#Scientific-Linux DVD install (base Fedora 15)
#https://www.scientificlinux.org/download/
elif [ "$(grep 'Welcome to Scientific Linux 6!' /tmp/multisystem/multisystem-mountpoint-iso/isolinux/isolinux.cfg 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osicone="multisystem-scientificLinux"
#Menu 1
ligne1="menuentry \"Scientific-Linux install DVD\" {"
ligne2="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
ligne3="linux (loop)/isolinux/vmlinuz linux repo=hd:UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb):/"
ligne4="initrd (loop)/isolinux/initrd.img"
ligne5="}"
#Menu 2
ligne6="menuentry \"Scientific-Linux install DVD vesa\" {"
ligne7="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
ligne8="linux (loop)/isolinux/vmlinuz linux repo=hd:UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb):/ xdriver=vesa nomodeset"
ligne9="initrd (loop)/isolinux/initrd.img"
ligne10="}"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD2)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#LinuxDefender Live! CD - BitDefenderRescueCD
#http://download.bitdefender.com/rescue_cd/bitdefender-rescue-cd.iso
#http://download.bitdefender.com/rescue_cd/
elif [ "$(grep 'menu title BitDefender Rescue Cd' /tmp/multisystem/multisystem-mountpoint-iso/boot/isolinux/isolinux.cfg 2>/dev/null)" ]; then
modiso="copycontent"
if [ ! -d "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/KNOPPIX" ]; then
osname="KNOPPIX"
osnamemodif="LinuxDefender Live"
osicone="multisystem-defender"
osloopback=""
oskernel="linux /boot/bootdistro/knoppix/isolinux/linux BOOT_IMAGE=KNOPPIX rw ramdisk_size=131072 init=/etc/init lang=$(echo "${LANG}" | awk -F "_" '{print $1 }') apm=power-off nomce loglevel=0 quiet"
osinitrd="initrd /boot/bootdistro/knoppix/isolinux/minirt.gz"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
#KNOPPIX
mkdir "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/KNOPPIX"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/bootdistro/knoppix/isolinux"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/boot/ "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/bootdistro/knoppix/"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/KNOPPIX/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/KNOPPIX/."
else
zenity --error --text "$(eval_gettext "Erreur: LiveCD déjà présent.")"
fi

#LinuxDefender Live! CD - BitDefenderRescueCD --- NOUVELLE VERSION !
#http://download.bitdefender.com/rescue_cd/
elif [ "$(grep 'BitDefender' /tmp/multisystem/multisystem-mountpoint-iso/isolinux/isolinux.cfg 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osnamemodif="BitDefender Rescue CD"
osicone="multisystem-defender"
gen_champ="$(grep -m1 'file=.*\.seed' -o /tmp/multisystem/multisystem-mountpoint-iso/isolinux/isolinux.cfg)"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*vmlinuz*")) root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) ${gen_champ} iso-scan/filename=/${osname} boot=casper noprompt quiet splash lang=$(echo "${LANG}" | awk -F "_" '{print $1 }')"
osinitrd="initrd (loop)/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*initrd*"))"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#GParted LiveCD
#http://gparted.sourceforge.net/download.php
elif [ "$(grep 'gparted-live' /tmp/multisystem/multisystem-mountpoint-iso/GParted-Live-Version 2>/dev/null)" ]; then
modiso="copycontent"
echo "gparted1" >/tmp/multisystem/multisystem-nomgparted
chemindeb="$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/gparted"
find "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")" -maxdepth 1 -path "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/gparted[0-9]" | while read line
do
echo "gparted$(($(echo $line | sed "s@${chemindeb}@@g")+1))" >/tmp/multisystem/multisystem-nomgparted
done
osname="$(cat /tmp/multisystem/multisystem-nomgparted)"
osnamemodif="$(basename "${option2}")"
osicone="multisystem-gparted"
osloopback=""
oskernel="linux /${osname}/live/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/live -iname "*vmlinuz*")) root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) live-media-path=/${osname}/live boot=live config noswap nomodeset ip=frommedia nosplash lang=$(echo "${LANG}" | sed "s/\..*//")"
osinitrd="initrd /${osname}/live/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/live -iname "*initrd*"))"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${osname}"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/."

#clonezilla-live-*-natty
#http://www.clonezilla.org/downloads.php
elif [ "$(grep -E "(clonezilla-live-.*-natty)" /tmp/multisystem/multisystem-mountpoint-iso/Clonezilla-Live-Version 2>/dev/null)" ]; then
modiso="copycontent"
echo "debian1" >/tmp/multisystem/multisystem-nomdebian
chemindeb="$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/debian"
find "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")" -maxdepth 1 -path "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/debian[0-9]" | while read line
do
echo "debian$(($(echo $line | sed "s@${chemindeb}@@g")+1))" >/tmp/multisystem/multisystem-nomdebian
done
osname="$(cat /tmp/multisystem/multisystem-nomdebian)"
osnamemodif="Clonezilla Live natty"
osicone="multisystem-clonezilla"
osloopback=""
oskernel="linux /${osname}/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/live -iname "*vmlinuz*")) ro root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) live-media-path=/${osname} boot=live hostname=natty config quiet noswap nolocales edd=on nomodeset ocs_live_run="ocs-live-general" ocs_live_extra_param="" ocs_live_keymap="" ocs_live_batch="no" ocs_lang="" video=uvesafb:mode_option=800x600-16 ip=frommedia  nosplash"
osinitrd="initrd /${osname}/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/live -iname "*initrd*"))"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${osname}"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/live/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/."

#clonezilla-live-*-maverick
##http://www.clonezilla.org/download/sourceforge/
elif [ "$(grep -E "(clonezilla-live-.*-maverick)" /tmp/multisystem/multisystem-mountpoint-iso/Clonezilla-Live-Version 2>/dev/null)" ]; then
modiso="copycontent"
echo "debian1" >/tmp/multisystem/multisystem-nomdebian
chemindeb="$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/debian"
find "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")" -maxdepth 1 -path "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/debian[0-9]" | while read line
do
echo "debian$(($(echo $line | sed "s@${chemindeb}@@g")+1))" >/tmp/multisystem/multisystem-nomdebian
done
osname="$(cat /tmp/multisystem/multisystem-nomdebian)"
osnamemodif="Clonezilla Live maverick"
osicone="multisystem-clonezilla"
osloopback=""
oskernel="linux /${osname}/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/live -iname "*vmlinuz*")) ro root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) live-media-path=/${osname} boot=live hostname=maverick live-config quiet noswap nolocales edd=on nomodeset ocs_live_run="ocs-live-general" ocs_live_extra_param="" ocs_live_keymap="" ocs_live_batch="no" ocs_lang="" video=uvesafb:mode_option=800x600-16 ip=frommedia  nosplash"
osinitrd="initrd /${osname}/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/live -iname "*initrd*"))"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${osname}"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/live/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/."

#clonezilla-live-*-lucid
##http://www.clonezilla.org/download/sourceforge/
elif [ "$(grep -E "(clonezilla-live-.*-lucid)" /tmp/multisystem/multisystem-mountpoint-iso/Clonezilla-Live-Version 2>/dev/null)" ]; then
modiso="copycontent"
echo "debian1" >/tmp/multisystem/multisystem-nomdebian
chemindeb="$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/debian"
find "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")" -maxdepth 1 -path "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/debian[0-9]" | while read line
do
echo "debian$(($(echo $line | sed "s@${chemindeb}@@g")+1))" >/tmp/multisystem/multisystem-nomdebian
done
osname="$(cat /tmp/multisystem/multisystem-nomdebian)"
osnamemodif="Clonezilla Live lucid"
osicone="multisystem-clonezilla"
osloopback=""
oskernel="linux /${osname}/vmlinuz1 ro root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) live-media-path=/${osname} boot=live hostname=lucid quiet noswap nolocales edd=on noprompt ocs_live_run="ocs-live-general" ocs_live_extra_param="" ocs_live_keymap="" ocs_live_batch="no" ocs_lang="" video=uvesafb:mode_option=1024x768-32 ip=frommedia  nosplash"
osinitrd="initrd /${osname}/initrd1.img"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${osname}"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/live/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/."

#clonezilla-live-*-karmic
##http://www.clonezilla.org/download/sourceforge/
elif [ "$(grep -E "clonezilla-live-.*-karmic" /tmp/multisystem/multisystem-mountpoint-iso/Clonezilla-Live-Version 2>/dev/null)" ]; then
modiso="copycontent"
echo "debian1" >/tmp/multisystem/multisystem-nomdebian
chemindeb="$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/debian"
find "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")" -maxdepth 1 -path "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/debian[0-9]" | while read line
do
echo "debian$(($(echo $line | sed "s@${chemindeb}@@g")+1))" >/tmp/multisystem/multisystem-nomdebian
done
osname="$(cat /tmp/multisystem/multisystem-nomdebian)"
osnamemodif="Clonezilla Live karmic"
osicone="multisystem-clonezilla"
osloopback=""
oskernel="linux /${osname}/vmlinuz root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) live-media-path=/${osname} boot=live union=aufs debian-installer/language=$(echo "${LANG}" |  awk -F"_" '{print $1}') debian-installer/locale=${LANG} kbd-chooser/method=${XKBLAYOUT}  console-setup/layoutcode=${XKBLAYOUT} console-setup/variantcode=${XKBVARIANT} console-setup/modelcode=${XKBMODEL}"
osinitrd="initrd /${osname}/initrd.img"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${osname}"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/live/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/."

#Clonezilla Live
#http://www.clonezilla.org/download/sourceforge/
elif [ "$(grep 'clonezilla-live-' /tmp/multisystem/multisystem-mountpoint-iso/Clonezilla-Live-Version 2>/dev/null)" ]; then
modiso="copycontent"
echo "debian1" >/tmp/multisystem/multisystem-nomdebian
chemindeb="$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/debian"
find "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")" -maxdepth 1 -path "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/debian[0-9]" | while read line
do
echo "debian$(($(echo $line | sed "s@${chemindeb}@@g")+1))" >/tmp/multisystem/multisystem-nomdebian
done
osname="$(cat /tmp/multisystem/multisystem-nomdebian)"
osnamemodif="Clonezilla Live"
osicone="multisystem-clonezilla"
osloopback=""
clonezilla_init="$(grep append /tmp/multisystem/multisystem-mountpoint-iso/isolinux/isolinux.cfg | head -1 | sed "s%.*append.*img %%")"
oskernel="linux /${osname}/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/live -iname "*vmlinuz*")) ro root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) live-media-path=/${osname} ${clonezilla_init}"
osinitrd="initrd /${osname}/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/live -iname "*initrd*"))"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${osname}"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/live/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/."

#deSbian
#https://sites.google.com/a/h4ckdr4g.net/desbian/
elif [ "$(grep 'deSbian' /tmp/multisystem/multisystem-mountpoint-iso/isolinux/isolinux.txt 2>/dev/null)" ]; then
modiso="copycontent"
echo "debian1" >/tmp/multisystem/multisystem-nomdebian
chemindeb="$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/debian"
find "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")" -maxdepth 1 -path "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/debian[0-9]" | while read line
do
echo "debian$(($(echo $line | sed "s@${chemindeb}@@g")+1))" >/tmp/multisystem/multisystem-nomdebian
done
osname="$(cat /tmp/multisystem/multisystem-nomdebian)"
osicone="multisystem-debian"
#Menu 1
ligne1="menuentry \"deSbian Live\" {"
ligne2=""
ligne3="linux /${osname}/live/vmlinuz ro root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) live-media-path=/${osname}/live file=/cdrom/${osname}/preseed/custom.seed boot=live quiet splash vga=788 --"
ligne4="initrd /${osname}/live/initrd.gz"
ligne5="}"
#Menu 2
ligne6="menuentry \"deSbian Live xforcevesa\" {"
ligne7=""
ligne8="linux /${osname}/live/vmlinuz ro root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) live-media-path=/${osname}/live file=/cdrom/${osname}/preseed/custom.seed boot=live xforcevesa quiet splash vga=788 --"
ligne9="initrd /${osname}/live/initrd.gz"
ligne10="}"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD2)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
mkdir "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${osname}"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/."

#vyatta login/pass vyatta/vyatta
#http://www.vyatta.org/downloads
elif [ "$(grep -E "(vyatta)" /tmp/multisystem/multisystem-mountpoint-iso//isolinux/live.cfg 2>/dev/null)" ]; then
modiso="copycontent"
echo "debian1" >/tmp/multisystem/multisystem-nomdebian
chemindeb="$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/debian"
find "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")" -maxdepth 1 -path "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/debian[0-9]" | while read line
do
echo "debian$(($(echo $line | sed "s@${chemindeb}@@g")+1))" >/tmp/multisystem/multisystem-nomdebian
done
osname="$(cat /tmp/multisystem/multisystem-nomdebian)"
osnamemodif="Vyatta"
osicone="multisystem-vyatta"
osloopback=""
oskernel="linux /${osname}/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/live -iname "*vmlinuz*")) ro root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) live-media-path=/${osname} console=ttyS0 console=tty0 quiet boot=live nopersistent noautologin nonetworking nouser hostname=vyatta"
osinitrd="initrd /${osname}/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/live -iname "*initrd*"))"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${osname}"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/live/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/."

#Elastix install
elif [ "$(grep 'Elastix' /tmp/multisystem/multisystem-mountpoint-iso/.treeinfo 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osicone="multisystem-elastix"
#Menu 1
ligne1="menuentry \"Elastix install DVD\" {"
ligne2="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
ligne3="linux (loop)/isolinux/vmlinuz linux repo=hd:UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb):/"
ligne4="initrd (loop)/isolinux/initrd.img"
ligne5="}"
#Menu 2
ligne6="menuentry \"Elastix install DVD vesa\" {"
ligne7="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
ligne8="linux (loop)/isolinux/vmlinuz linux repo=hd:UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb):/ xdriver=vesa nomodeset"
ligne9="initrd (loop)/isolinux/initrd.img"
ligne10="}"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD2)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#SME Server
#http://distrowatch.com/table.php?distribution=smeserver
#http://wiki.contribs.org/SME_Server:Download
elif [ "$(grep 'SME Server' /tmp/multisystem/multisystem-mountpoint-iso/.discinfo 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osicone="multisystem-smeserver"
osnamemodif="SME Server"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/isolinux/vmlinuz linux repo=hd:UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb):/"
osinitrd="initrd (loop)/isolinux/initrd.img"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#ClearOS (Fedora based)
#http://distrowatch.com/table.php?distribution=clearos
elif [ "$(grep 'ClearOS' /tmp/multisystem/multisystem-mountpoint-iso/isolinux/isolinux.cfg 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osicone="multisystem-clearos"
#Menu 1
ligne1="menuentry \"ClearOS install\" {"
ligne2="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
ligne3="linux (loop)/isolinux/vmlinuz repo=hd:UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb):/"
ligne4="initrd (loop)/isolinux/initrd.img"
ligne5="}"
#Menu 2
ligne6="menuentry \"ClearOS install vesa\" {"
ligne7="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
ligne8="linux (loop)/isolinux/vmlinuz repo=hd:UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb):/ xdriver=vesa nomodeset"
ligne9="initrd (loop)/isolinux/initrd.img"
ligne10="}"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD2)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#Fedora install DVD Fedora 13
#http://ranjith.zfs.in/fedora-usb-install/
#http://download.fedora.redhat.com/pub/fedora/linux/releases/13/Fedora/i386/os/images/boot.iso
#http://fedoraproject.org/wiki/Anaconda/Kickstart
#http://fedoraproject.org/wiki/Anaconda/Options
elif [[ -f "/tmp/multisystem/multisystem-mountpoint-iso/images/install.img" && "$(grep 'stage2=hd:LABEL="Fedora"' /tmp/multisystem/multisystem-mountpoint-iso/isolinux/isolinux.cfg 2>/dev/null)" ]]; then
modiso="copycontent"
if [ ! -f "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/images/install.img" ]; then
osname="$(basename "${option2}")"
osicone="multisystem-fedora"
#Menu 1
ligne1="menuentry \"Fedora install DVD\" {"
ligne2="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
ligne3="linux (loop)/isolinux/vmlinuz repo=hd:UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb):/"
ligne4="initrd (loop)/isolinux/initrd.img"
ligne5="}"
#Menu 2
ligne6="menuentry \"Fedora install DVD vesa\" {"
ligne7="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
ligne8="linux (loop)/isolinux/vmlinuz repo=hd:UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb):/ xdriver=vesa nomodeset"
ligne9="initrd (loop)/isolinux/initrd.img"
ligne10="}"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD2)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
mkdir "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/images"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
cp /tmp/multisystem/multisystem-mountpoint-iso/images/install.img "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/images/install.img"
rsync -avS --progress "${option2}" "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/$(basename "${source}")"
else
zenity --error --text "$(eval_gettext "Erreur: LiveCD déjà présent.")"
fi

#Fedora install DVD Fedora 15
elif [ "$(grep 'Welcome to Fedora 15!' /tmp/multisystem/multisystem-mountpoint-iso/isolinux/isolinux.cfg 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osicone="multisystem-fedora"
#Menu 1
ligne1="menuentry \"Fedora install DVD\" {"
ligne2="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
ligne3="linux (loop)/isolinux/vmlinuz linux repo=hd:UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb):/"
ligne4="initrd (loop)/isolinux/initrd.img"
ligne5="}"
#Menu 2
ligne6="menuentry \"Fedora install DVD vesa\" {"
ligne7="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
ligne8="linux (loop)/isolinux/vmlinuz linux repo=hd:UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb):/ xdriver=vesa nomodeset"
ligne9="initrd (loop)/isolinux/initrd.img"
ligne10="}"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD2)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#Fedora|xange.sf.net ancien vixta|
#http://www.fedora-fr.org/
#live_dir
elif [ "$(grep -iE '(root=live:CDLABEL=IGN7)|(root=live:CDLABEL=ROSA)|(root=live:CDLABEL=Lite)|(root=CDLABEL=ALDOS)|(root=live:CDLABEL=SL.*LiveCD)|(root=live:CDLABEL=Kororaa)|(root=live:CDLABEL=Fuduntu-)|(root=live:CDLABEL=Fusion)|(root=CDLABEL=nst)|(root=live:CDLABEL=Qomo)|(root=live:CDLABEL=Community-Fedora-Remix)|(root=live:CDLABEL=ojuba)|(root=live:CDLABEL=Fedora)|(root=live:CDLABEL=BLAG)|(root=CDLABEL=2.1-final-x86_64-200911031243)|(root=live:CDLABEL=F13)|(root=live:CDLABEL=xange.sf.net)|(root=live:CDLABEL=OpenXange.org)|(root=CDLABEL=Fedora)|root=CDLABEL=Soas|root=live:CDLABEL=F12|(root=CDLABEL=F12)|(root=CDLABEL=xange.sf.net)' /tmp/multisystem/multisystem-mountpoint-iso/isolinux/isolinux.cfg 2>/dev/null)" ]; then
modiso="copycontent"
#
function MOD_FEDORA()
{
echo "fedora1" >/tmp/multisystem/multisystem-nomfedora
chemindeb="$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/fedora"
find "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")" -maxdepth 1 -path "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/fedora[0-9]" | while read line
do
echo "fedora$(($(echo $line | sed "s@${chemindeb}@@g")+1))" >/tmp/multisystem/multisystem-nomfedora
done
#ALDOS
#http://www.alcancelibre.org/article.php/disponible-aldos-1-4
osname="$(cat /tmp/multisystem/multisystem-nomfedora)"
osnamemodif="$(basename "${option2}")"
osloopback=""
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${osname}"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
#aldos
if [ "$(grep "root=CDLABEL=ALDOS" /tmp/multisystem/multisystem-mountpoint-iso/isolinux/isolinux.cfg 2>/dev/null)" ]; then
osicone="multisystem-aldos"
oskernel="linux /${osname}/isolinux/vmlinuz0 live_dir=/${osname} root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) rootfstype=auto ro liveimg LANG=es_MX.UTF-8 KEYBOARDTYPE=pc KEYTABLE=es noiswmd quiet rhgb elevator=noop rootflags=defaults,noatime,nodiratime,commit=30,data=writeback usbcore.autosuspend=1 selinux=0"
osinitrd="initrd /${osname}/isolinux/initrd0.img"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/LiveOS/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/."
cp -Rf /tmp/multisystem/multisystem-mountpoint-iso/isolinux "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/."
#linpus
elif [ "$(grep "root=live:CDLABEL=Lite" /tmp/multisystem/multisystem-mountpoint-iso/isolinux/isolinux.cfg 2>/dev/null)" ]; then
osicone="multisystem-linpus"
oskernel="linux /${osname}/isolinux/vmlinuz live_dir=/${osname}/LiveOS root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb)  rootfstype=auto ro liveimg quiet rhgb rd_NO_LUKS rd_NO_MD noiswmd pci=nommconf reboot=k"
osinitrd="initrd /${osname}/isolinux/initrd.img"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/."
#Kororaa
elif [ "$(grep "root=live:CDLABEL=Kororaa" /tmp/multisystem/multisystem-mountpoint-iso/isolinux/isolinux.cfg 2>/dev/null)" ]; then
osicone="multisystem-kororaa"
oskernel="linux /${osname}/isolinux/vmlinuz0 live_dir=/${osname}/LiveOS live_locale=${LANG} live_keytable=${XKBLAYOUT} root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) rootfstype=auto ro liveimg quiet  rhgb rd.luks=0 rd.md=0 rd.dm=0"
osinitrd="initrd /${osname}/isolinux/initrd0.img"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/."
#nst
elif [ "$(grep "root=CDLABEL=nst" /tmp/multisystem/multisystem-mountpoint-iso/isolinux/isolinux.cfg 2>/dev/null)" ]; then
osicone="multisystem-nst"
oskernel="linux /${osname}/isolinux/vmlinuz0 live_dir=/${osname}/LiveOS live_locale=${LANG} live_keytable=${XKBLAYOUT} root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) rootfstype=auto ro liveimg quiet  rhgb rd.luks=0 rd.md=0 rd.dm=0"
osinitrd="initrd /${osname}/isolinux/initrd0.img"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/."
#ROSA
#http://distrowatch.com/table.php?distribution=rosa
elif [ "$(grep "root=live:CDLABEL=ROSA" /tmp/multisystem/multisystem-mountpoint-iso/isolinux/isolinux.cfg 2>/dev/null)" ]; then
osicone="multisystem-rosa"
oskernel="linux /${osname}/isolinux/vmlinuz0 live_dir=/${osname}/LiveOS live_locale=${LANG} live_keytable=${XKBLAYOUT} root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) rootfstype=auto ro liveimg vga=788 desktop nopat rd_NO_LUKS rd_NO_MD noiswmd splash=silent logo.nologo nomodeset"
osinitrd="initrd /${osname}/isolinux/initrd0.img"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/."
elif [ "$(grep "root=live:CDLABEL=IGN7" /tmp/multisystem/multisystem-mountpoint-iso/isolinux/isolinux.cfg 2>/dev/null)" ]; then
osicone="multisystem-igos"
oskernel="linux /${osname}/isolinux/vmlinuz0 live_dir=/${osname}/LiveOS live_locale=${LANG} live_keytable=${XKBLAYOUT} root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) rootfstype=auto ro liveimg rd.luks=0 rd.md=0 rd.dm=0 quiet rhgb acpi=force"
osinitrd="initrd /${osname}/isolinux/initrd0.img"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/."
#All
else
osicone="multisystem-fedora"
oskernel="linux /${osname}/isolinux/vmlinuz0 live_locale=${LANG} live_keytable=${XKBLAYOUT} live_dir=/${osname} root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) rootfstype=auto ro liveimg quiet rhgb rd_NO_LUKS rd_NO_MD noiswmd"
osinitrd="initrd /${osname}/isolinux/initrd0.img"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/LiveOS/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/."
cp -Rf /tmp/multisystem/multisystem-mountpoint-iso/isolinux "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/."
fi
}
#Mode persistent
function MOD_FEDORA_PERSIST()
{
if [ "$(grep " " <<<"${option2}")" ]; then
zenity --error --text "$(eval_gettext "Erreur: Veuillez supprimer le caractère espace dans le chemin.")"
exit 0
fi
#determiner nom dossier fedora
echo "fedora1" >/tmp/multisystem/multisystem-nomfedora
chemindeb="$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/fedora"
find "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")" -maxdepth 1 -path "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/fedora[0-9]" | while read line
do
echo "fedora$(($(echo $line | sed "s@${chemindeb}@@g")+1))" >/tmp/multisystem/multisystem-nomfedora
done
osname="$(cat /tmp/multisystem/multisystem-nomfedora)"
osnamemodif="$(basename "${option2}")"
osicone="multisystem-fedora"
osloopback=""
[ "$checkbox3" == "false" ] && crypter="--unencrypted-home"
#--crypted-home
#--unencrypted-home ${crypter}
#overlay=UUID=34F1-F056
#append initrd=initrd0.img root=live:UUID=34F1-F056 rootfstype=vfat rw liveimg overlay=UUID=34F1-F056 quiet  rhgb 
#demande overlay et home separé
if [[ "$checkbox" == "true" && "$checkbox2" == "true" ]]; then
oskernel="linux /${osname}/syslinux/vmlinuz0 live_locale=${LANG} live_keytable=${XKBLAYOUT} live_dir=/${osname} overlay=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) root=live:UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) rootfstype=vfat rw liveimg quiet rhgb rd_NO_LUKS rd_NO_MD noiswmd"
#demande overlay separé
elif [[ "$checkbox" == "true" && "$checkbox2" == "false" ]]; then
oskernel="linux /${osname}/syslinux/vmlinuz0 live_locale=${LANG} live_keytable=${XKBLAYOUT} live_dir=/${osname} overlay=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) root=live:UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) rootfstype=vfat rw liveimg quiet rhgb rd_NO_LUKS rd_NO_MD noiswmd"
#demande home separé
elif [[ "$checkbox" == "false" && "$checkbox2" == "true" ]]; then
oskernel="linux /${osname}/syslinux/vmlinuz0 live_locale=${LANG} live_keytable=${XKBLAYOUT} live_dir=/${osname} root=live:UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) rootfstype=vfat ro liveimg quiet rhgb rd_NO_LUKS rd_NO_MD noiswmd"
fi
osinitrd="initrd /${osname}/syslinux/initrd0.img"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
# [--format] [--reset-mbr] [--noverify] [--overlay-size-mb <size>] [--home-size-mb <size>] [--unencrypted-home] [--skipcopy] <isopath> <usbstick device>"
#demande overlay et home separé
if [[ "$checkbox" == "true" && "$checkbox2" == "true" ]]; then
echo -e "\E[37;44m\033[1m $(eval_gettext 'Veuillez saisir votre mot de passe d\047administrateur') \033[0m"
cp -f /tmp/multisystem/multisystem-mountpoint-iso/LiveOS/livecd-iso-to-disk /tmp/multisystem/livecd-iso-to-disk
sudo umount $(cat /tmp/multisystem/multisystem-selection-usb)
sudo /tmp/multisystem/livecd-iso-to-disk --noverify --overlay-size-mb ${combobox} --home-size-mb ${combobox2} ${crypter} "${option2}" $(cat /tmp/multisystem/multisystem-selection-usb)
#demande overlay separé
elif [[ "$checkbox" == "true" && "$checkbox2" == "false" ]]; then
echo -e "\E[37;44m\033[1m $(eval_gettext 'Veuillez saisir votre mot de passe d\047administrateur') \033[0m"
cp -f /tmp/multisystem/multisystem-mountpoint-iso/LiveOS/livecd-iso-to-disk /tmp/multisystem/livecd-iso-to-disk
sudo umount $(cat /tmp/multisystem/multisystem-selection-usb)
sudo /tmp/multisystem/livecd-iso-to-disk --noverify --overlay-size-mb ${combobox} --unencrypted-home "${option2}" $(cat /tmp/multisystem/multisystem-selection-usb)
#demande home separé
elif [[ "$checkbox" == "false" && "$checkbox2" == "true" ]]; then
echo -e "\E[37;44m\033[1m $(eval_gettext 'Veuillez saisir votre mot de passe d\047administrateur') \033[0m"
cp -f /tmp/multisystem/multisystem-mountpoint-iso/LiveOS/livecd-iso-to-disk /tmp/multisystem/livecd-iso-to-disk
sudo umount $(cat /tmp/multisystem/multisystem-selection-usb)
sudo /tmp/multisystem/livecd-iso-to-disk --noverify --home-size-mb ${combobox2} ${crypter} "${option2}" $(cat /tmp/multisystem/multisystem-selection-usb)
fi
#Mise en forme
echo -e "\E[37;44m\033[1m $(eval_gettext 'Veuillez saisir votre mot de passe d\047administrateur') \033[0m"
sudo rm /tmp/multisystem/livecd-iso-to-disk 2>/dev/null
#remonter dans tmp au cas ou remonte pas dans point de montage precedent
#Renommer dossier LiveOS et deplacer dossier syslinux
sudo mkdir /tmp/multisystem/$(cat /tmp/multisystem/multisystem-selection-uuid-usb)
sudo mount $(cat /tmp/multisystem/multisystem-selection-usb) /tmp/multisystem/$(cat /tmp/multisystem/multisystem-selection-uuid-usb)
sleep 1
#Pas compris... si boot avec iso MS ne crée pas le dossier syslinux !!!
if [ -d "/tmp/multisystem/$(cat /tmp/multisystem/multisystem-selection-uuid-usb)/syslinux" ]; then
sudo rm /tmp/multisystem/$(cat /tmp/multisystem/multisystem-selection-uuid-usb)/syslinux/ldlinux.sys
sudo mv /tmp/multisystem/$(cat /tmp/multisystem/multisystem-selection-uuid-usb)/syslinux /tmp/multisystem/$(cat /tmp/multisystem/multisystem-selection-uuid-usb)/LiveOS/syslinux
sudo mv /tmp/multisystem/$(cat /tmp/multisystem/multisystem-selection-uuid-usb)/LiveOS /tmp/multisystem/$(cat /tmp/multisystem/multisystem-selection-uuid-usb)/${osname}
else
sudo mkdir -p /tmp/multisystem/$(cat /tmp/multisystem/multisystem-selection-uuid-usb)/${osname}/syslinux
sudo rm /tmp/multisystem/$(cat /tmp/multisystem/multisystem-selection-uuid-usb)/ldlinux.sys
sudo mv /tmp/multisystem/$(cat /tmp/multisystem/multisystem-selection-uuid-usb)/boot.cat /tmp/multisystem/$(cat /tmp/multisystem/multisystem-selection-uuid-usb)/${osname}/syslinux/boot.cat
sudo mv /tmp/multisystem/$(cat /tmp/multisystem/multisystem-selection-uuid-usb)/initrd0.img /tmp/multisystem/$(cat /tmp/multisystem/multisystem-selection-uuid-usb)/${osname}/syslinux/initrd0.img
sudo mv /tmp/multisystem/$(cat /tmp/multisystem/multisystem-selection-uuid-usb)/isolinux.bin /tmp/multisystem/$(cat /tmp/multisystem/multisystem-selection-uuid-usb)/${osname}/syslinux/isolinux.bin
sudo mv /tmp/multisystem/$(cat /tmp/multisystem/multisystem-selection-uuid-usb)/memtest /tmp/multisystem/$(cat /tmp/multisystem/multisystem-selection-uuid-usb)/${osname}/syslinux/memtest
sudo mv /tmp/multisystem/$(cat /tmp/multisystem/multisystem-selection-uuid-usb)/syslinux.cfg /tmp/multisystem/$(cat /tmp/multisystem/multisystem-selection-uuid-usb)/${osname}/syslinux/syslinux.cfg
sudo mv /tmp/multisystem/$(cat /tmp/multisystem/multisystem-selection-uuid-usb)/vesamenu.c32 /tmp/multisystem/$(cat /tmp/multisystem/multisystem-selection-uuid-usb)/${osname}/syslinux/vesamenu.c32
sudo mv /tmp/multisystem/$(cat /tmp/multisystem/multisystem-selection-uuid-usb)/vmlinuz0 /tmp/multisystem/$(cat /tmp/multisystem/multisystem-selection-uuid-usb)/${osname}/syslinux/vmlinuz0
#
sudo mv /tmp/multisystem/$(cat /tmp/multisystem/multisystem-selection-uuid-usb)/LiveOS/* /tmp/multisystem/$(cat /tmp/multisystem/multisystem-selection-uuid-usb)/${osname}
sudo rm -R /tmp/multisystem/$(cat /tmp/multisystem/multisystem-selection-uuid-usb)/LiveOS
fi
sudo umount $(cat /tmp/multisystem/multisystem-selection-usb) 2>/dev/null
sudo rmdir /tmp/multisystem/$(cat /tmp/multisystem/multisystem-selection-uuid-usb) 2>/dev/null
sudo umount /tmp/multisystem/multisystem-mountpoint-iso
#remettre le label
sudo dosfslabel $(cat /tmp/multisystem/multisystem-selection-usb) $(cat /tmp/multisystem/multisystem-selection-label-usb)
sleep 1
#remonter via gvfs-mount
#gvfs-mount -l
gvfs-mount -d $(cat /tmp/multisystem/multisystem-selection-usb) 2>/dev/null
#udisks --unmount $(cat /tmp/multisystem/multisystem-selection-usb)
#udisks --mount $(cat /tmp/multisystem/multisystem-selection-usb)
#verif que la clé usb est toujours bien presente sinon exit!
if [ ! "$(mount -l | grep "$(cat /tmp/multisystem/multisystem-selection-usb) .* $(cat "/tmp/multisystem/multisystem-mountpoint-usb")" | grep vfat | grep rw,)" ]; then
zenity --info --text "$(eval_gettext 'Veuillez remonter la clé usb manuellement')"
FCT_KILL
exit 0
fi
}
function MOD_FEDORA_GUI()
{
export INFO='<window title="Fedora"  window_position="1" icon-name="multisystem-icon" decorated="true">
<vbox homogeneous="true">
<hbox>
<checkbox active="false">
<label>"'$(eval_gettext "Activer persistance overlay")'"</label>
<variable>checkbox</variable>
<action>if true enable:combobox</action>
<action>if false disable:combobox</action>
</checkbox>
<combobox allow-empty="false" value-in-list="true">
<variable>combobox</variable>
<item>512</item>
<item>1024</item>
<item>1536</item>
<item>2047</item>
</combobox>
</hbox>
<hbox>
<checkbox active="false">
<label>"'$(eval_gettext "Activer persistance home séparé")'"</label>
<variable>checkbox2</variable>
<action>if true enable:combobox2</action>
<action>if false disable:combobox2</action>
<action>if true enable:checkbox3</action>
<action>if false disable:checkbox3</action>
</checkbox>
<combobox allow-empty="false" value-in-list="true">
<variable>combobox2</variable>
<item>512</item>
<item>1024</item>
<item>1536</item>
<item>2047</item>
</combobox>
</hbox>
<hbox>
<checkbox active="false">
<label>"'$(eval_gettext "Activer encryption des données de home")'"</label>
<variable>checkbox3</variable>
</checkbox>
</hbox>
<hbox>
<button>
<input file stock="gtk-ok"></input>
<label>"'$(eval_gettext "Valider")'"</label>
<action type="exit">exit</action>
</button>
</hbox>
</vbox>
<action signal="show">disable:checkbox3</action>
<action signal="show">disable:combobox</action>
<action signal="show">disable:combobox2</action>
<action signal="show">disable:combobox3</action>
</window>'
#monter gui
I=$IFS; IFS=""
for MENU_INFO in  $(gtkdialog --program=INFO); do
eval $MENU_INFO
done
IFS=$I
}
#proposer persistent si livecd-iso-to-disk est présent!
#bloquer si livecd-iso-to-disk utilise vol_id car existe plus dans karmic!
if [[ ! "$(grep vol_id /tmp/multisystem/multisystem-mountpoint-iso/LiveOS/livecd-iso-to-disk 2>/dev/null)" && -f "/tmp/multisystem/multisystem-mountpoint-iso/LiveOS/livecd-iso-to-disk" ]]; then
unset checkbox combobox2 checkbox checkbox2 checkbox3 combobox combobox2
#lancer gui
MOD_FEDORA_GUI
#remonter gui si?
while true
do
if [[ "$checkbox" == "true" || "$checkbox2" == "true" ]]; then
#verifier espace disponible
tiso="$(($(du -sB 1 "${option2}" | awk '{print $1}')/1024/1024))"
tfree="$(($(echo -e "$(df -B 1 $(cat /tmp/multisystem/multisystem-selection-usb))" | grep ^$(cat /tmp/multisystem/multisystem-selection-usb) | awk '{print $4}')/1024/1024))"
echo fichier:${option2}
echo iso:${tiso}Mio
echo libre:${tfree}Mio
#calculer taille necessaire
#demande overlay et home separé
if [[ "$checkbox" == "true" && "$checkbox2" == "true" ]]; then
tdemand="$(($tiso + $combobox + $combobox2))"
#demande overlay separé
elif [[ "$checkbox" == "true" && "$checkbox2" == "false" ]]; then
tdemand="$(($tiso + $combobox))"
#demande home separé
elif [[ "$checkbox" == "false" && "$checkbox2" == "true" ]]; then
tdemand="$(($tiso + $combobox2))"
fi
#verifier si demande espace user est disponible
if [ "$tdemand" -ge "$tfree" ]; then
zenity --error --text "$(eval_gettext "Erreur: pas suffisament d\047espace libre:") ${tdemand}Mio >= ${tfree}Mio"
MOD_FEDORA_GUI
#si pas suffisament de place remonter gui
else
MOD_FEDORA_PERSIST
break
fi
else
MOD_FEDORA
break
fi
done
#si pas de fichier livecd-iso-to-disk
else
MOD_FEDORA
fi

#Mandriva 2011
#http://distrowatch.com/?newsid=06490
elif [ "$(grep -iE '(root=live:CDLABEL=Mandriva)' /tmp/multisystem/multisystem-mountpoint-iso/isolinux/isolinux.cfg 2>/dev/null)" ]; then
modiso="copycontent"
function MOD_MANDRIVA()
{
echo "mandriva1" >/tmp/multisystem/multisystem-nommandriva
chemindeb="$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/mandriva"
find "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")" -maxdepth 1 -path "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/mandriva[0-9]" | while read line
do
echo "mandriva$(($(echo $line | sed "s@${chemindeb}@@g")+1))" >/tmp/multisystem/multisystem-nommandriva
done
osname="$(cat /tmp/multisystem/multisystem-nommandriva)"
osnamemodif="Mandriva 2011"
osicone="multisystem-mandriva"
#Menu live
ligne1="menuentry \"${osnamemodif} Live\" {"
ligne2=""
ligne3="linux /${osname}/isolinux/vmlinuz0 live_locale=${LANG} live_keytable=${XKBLAYOUT} live_dir=/${osname} root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) rootfstype=auto ro liveimg vga=788 desktop nopat rd_NO_LUKS rd_NO_MD noiswmd splash=silent"
ligne4="initrd /${osname}/isolinux/initrd0.img"
ligne5="}"
#Menu install
ligne6="menuentry \"${osnamemodif} Install\" {"
ligne7=""
ligne8="linux /${osname}/isolinux/vmlinuz0 live_locale=${LANG} live_keytable=${XKBLAYOUT} live_dir=/${osname} root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) rootfstype=auto ro liveimg vga=788 desktop nopat rd_NO_LUKS rd_NO_MD noiswmd splash=silent install"
ligne9="initrd /${osname}/isolinux/initrd0.img"
ligne10="}"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD2)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
#mandriva
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${osname}"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/LiveOS/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/."
cp -Rf /tmp/multisystem/multisystem-mountpoint-iso/isolinux "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/."
}
function MOD_MANDRIVA_PERSIST()
{
#determiner nom dossier mandriva
echo "mandriva1" >/tmp/multisystem/multisystem-nommandriva
chemindeb="$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/mandriva"
find "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")" -maxdepth 1 -path "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/mandriva[0-9]" | while read line
do
echo "mandriva$(($(echo $line | sed "s@${chemindeb}@@g")+1))" >/tmp/multisystem/multisystem-nommandriva
done
osname="$(cat /tmp/multisystem/multisystem-nommandriva)"
osnamemodif="Mandriva 2011"
osicone="multisystem-mandriva"
#Menu live persistent
ligne1="menuentry \"${osnamemodif} Live persistent\" {"
ligne2=""
[ "$checkbox3" == "false" ] && crypter="--unencrypted-home"
#demande overlay et home separé
if [[ "$checkbox" == "true" && "$checkbox2" == "true" ]]; then
ligne3="linux /${osname}/syslinux/vmlinuz0 live_locale=${LANG} live_keytable=${XKBLAYOUT} live_dir=/${osname} overlay=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) root=live:UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) rootfstype=vfat rw liveimg vga=788 desktop nopat rd_NO_LUKS rd_NO_MD noiswmd splash=silent"
#demande overlay separé
elif [[ "$checkbox" == "true" && "$checkbox2" == "false" ]]; then
ligne3="linux /${osname}/syslinux/vmlinuz0 live_locale=${LANG} live_keytable=${XKBLAYOUT} live_dir=/${osname} overlay=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) root=live:UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) rootfstype=vfat rw liveimg vga=788 desktop nopat rd_NO_LUKS rd_NO_MD noiswmd splash=silent"
#demande home separé
elif [[ "$checkbox" == "false" && "$checkbox2" == "true" ]]; then
ligne3="linux /${osname}/syslinux/vmlinuz0 live_locale=${LANG} live_keytable=${XKBLAYOUT} live_dir=/${osname} root=live:UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) rootfstype=vfat ro liveimg  vga=788 desktop nopat rd_NO_LUKS rd_NO_MD noiswmd splash=silent"
fi
ligne4="initrd /${osname}/syslinux/initrd0.img"
ligne5="}"
#Menu install
ligne6="menuentry \"${osnamemodif} Install\" {"
ligne7=""
ligne8="linux /${osname}/syslinux/vmlinuz0 live_locale=${LANG} live_keytable=${XKBLAYOUT} live_dir=/${osname} root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) rootfstype=auto ro liveimg vga=788 desktop nopat rd_NO_LUKS rd_NO_MD noiswmd splash=silent install"
ligne9="initrd /${osname}/syslinux/initrd0.img"
ligne10="}"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD2)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
#demande overlay et home separé
if [[ "$checkbox" == "true" && "$checkbox2" == "true" ]]; then
echo -e "\E[37;44m\033[1m $(eval_gettext 'Veuillez saisir votre mot de passe d\047administrateur') \033[0m"
cp -f /tmp/multisystem/multisystem-mountpoint-iso/Addons/livecd-iso-to-disk /tmp/multisystem/livecd-iso-to-disk
sudo umount $(cat /tmp/multisystem/multisystem-selection-usb)
sudo /tmp/multisystem/livecd-iso-to-disk --noverify --overlay-size-mb ${combobox} --home-size-mb ${combobox2} ${crypter} "${option2}" $(cat /tmp/multisystem/multisystem-selection-usb)
#demande overlay separé
elif [[ "$checkbox" == "true" && "$checkbox2" == "false" ]]; then
echo -e "\E[37;44m\033[1m $(eval_gettext 'Veuillez saisir votre mot de passe d\047administrateur') \033[0m"
cp -f /tmp/multisystem/multisystem-mountpoint-iso/Addons/livecd-iso-to-disk /tmp/multisystem/livecd-iso-to-disk
sudo umount $(cat /tmp/multisystem/multisystem-selection-usb)
sudo /tmp/multisystem/livecd-iso-to-disk --noverify --overlay-size-mb ${combobox} --unencrypted-home "${option2}" $(cat /tmp/multisystem/multisystem-selection-usb)
#demande home separé
elif [[ "$checkbox" == "false" && "$checkbox2" == "true" ]]; then
echo -e "\E[37;44m\033[1m $(eval_gettext 'Veuillez saisir votre mot de passe d\047administrateur') \033[0m"
cp -f /tmp/multisystem/multisystem-mountpoint-iso/Addons/livecd-iso-to-disk /tmp/multisystem/livecd-iso-to-disk
sudo umount $(cat /tmp/multisystem/multisystem-selection-usb)
sudo /tmp/multisystem/livecd-iso-to-disk --noverify --home-size-mb ${combobox2} ${crypter} "${option2}" $(cat /tmp/multisystem/multisystem-selection-usb)
fi
#Mise en forme
echo -e "\E[37;44m\033[1m $(eval_gettext 'Veuillez saisir votre mot de passe d\047administrateur') \033[0m"
sudo rm /tmp/multisystem/livecd-iso-to-disk 2>/dev/null
#remonter dans tmp au cas ou remonte pas dans point de montage precedent
#Renommer dossier LiveOS et deplacer dossier syslinux
sudo mkdir /tmp/multisystem/$(cat /tmp/multisystem/multisystem-selection-uuid-usb)
sudo mount $(cat /tmp/multisystem/multisystem-selection-usb) /tmp/multisystem/$(cat /tmp/multisystem/multisystem-selection-uuid-usb)
sudo rm /tmp/multisystem/$(cat /tmp/multisystem/multisystem-selection-uuid-usb)/syslinux/ldlinux.sys
sudo mv /tmp/multisystem/$(cat /tmp/multisystem/multisystem-selection-uuid-usb)/syslinux /tmp/multisystem/$(cat /tmp/multisystem/multisystem-selection-uuid-usb)/LiveOS/syslinux
sudo mv /tmp/multisystem/$(cat /tmp/multisystem/multisystem-selection-uuid-usb)/LiveOS /tmp/multisystem/$(cat /tmp/multisystem/multisystem-selection-uuid-usb)/${osname}
sudo umount $(cat /tmp/multisystem/multisystem-selection-usb) 2>/dev/null
sudo rmdir /tmp/multisystem/$(cat /tmp/multisystem/multisystem-selection-uuid-usb) 2>/dev/null
#remonter via gvfs-mount
#gvfs-mount -l
gvfs-mount -d $(cat /tmp/multisystem/multisystem-selection-usb) 2>/dev/null
#udisks --unmount $(cat /tmp/multisystem/multisystem-selection-usb)
#udisks --mount $(cat /tmp/multisystem/multisystem-selection-usb)
#verif que la clé usb est toujours bien presente sinon exit!
if [ ! "$(mount -l | grep "$(cat /tmp/multisystem/multisystem-selection-usb) .* $(cat "/tmp/multisystem/multisystem-mountpoint-usb")" | grep vfat | grep rw,)" ]; then
zenity --info --text "$(eval_gettext 'Veuillez remonter la clé usb manuellement')"
FCT_KILL
exit 0
fi
}
function MOD_MANDRIVA_GUI()
{
export INFO='<window title="Mandriva"  window_position="1" icon-name="multisystem-icon" decorated="true">
<vbox homogeneous="true">
<hbox>
<checkbox active="false">
<label>"'$(eval_gettext "Activer persistance overlay")'"</label>
<variable>checkbox</variable>
<action>if true enable:combobox</action>
<action>if false disable:combobox</action>
</checkbox>
<combobox allow-empty="false" value-in-list="true">
<variable>combobox</variable>
<item>512</item>
<item>1024</item>
<item>1536</item>
<item>2047</item>
</combobox>
</hbox>
<hbox>
<checkbox active="false">
<label>"'$(eval_gettext "Activer persistance home séparé")'"</label>
<variable>checkbox2</variable>
<action>if true enable:combobox2</action>
<action>if false disable:combobox2</action>
<action>if true enable:checkbox3</action>
<action>if false disable:checkbox3</action>
</checkbox>
<combobox allow-empty="false" value-in-list="true">
<variable>combobox2</variable>
<item>512</item>
<item>1024</item>
<item>1536</item>
<item>2047</item>
</combobox>
</hbox>
<hbox>
<checkbox active="false">
<label>"'$(eval_gettext "Activer encryption des données de home")'"</label>
<variable>checkbox3</variable>
</checkbox>
</hbox>
<hbox>
<button>
<input file stock="gtk-ok"></input>
<label>"'$(eval_gettext "Valider")'"</label>
<action type="exit">exit</action>
</button>
</hbox>
</vbox>
<action signal="show">disable:checkbox3</action>
<action signal="show">disable:combobox</action>
<action signal="show">disable:combobox2</action>
<action signal="show">disable:combobox3</action>
</window>'
#monter gui
I=$IFS; IFS=""
for MENU_INFO in  $(gtkdialog --program=INFO); do
eval $MENU_INFO
done
IFS=$I
}
#proposer persistent si livecd-iso-to-disk est présent!
#bloquer si livecd-iso-to-disk utilise vol_id car existe plus dans karmic!
if [[ ! "$(grep vol_id /tmp/multisystem/multisystem-mountpoint-iso/Addons/livecd-iso-to-disk 2>/dev/null)" && -f "/tmp/multisystem/multisystem-mountpoint-iso/Addons/livecd-iso-to-disk" ]]; then
unset checkbox combobox2 checkbox checkbox2 checkbox3 combobox combobox2
#lancer gui
MOD_MANDRIVA_GUI
#remonter gui si?
while true
do
if [[ "$checkbox" == "true" || "$checkbox2" == "true" ]]; then
#verifier espace disponible
tiso="$(($(du -sB 1 "${option2}" | awk '{print $1}')/1024/1024))"
tfree="$(($(echo -e "$(df -B 1 $(cat /tmp/multisystem/multisystem-selection-usb))" | grep ^$(cat /tmp/multisystem/multisystem-selection-usb) | awk '{print $4}')/1024/1024))"
echo fichier:${option2}
echo iso:${tiso}Mio
echo libre:${tfree}Mio
#calculer taille necessaire
#demande overlay et home separé
if [[ "$checkbox" == "true" && "$checkbox2" == "true" ]]; then
tdemand="$(($tiso + $combobox + $combobox2))"
#demande overlay separé
elif [[ "$checkbox" == "true" && "$checkbox2" == "false" ]]; then
tdemand="$(($tiso + $combobox))"
#demande home separé
elif [[ "$checkbox" == "false" && "$checkbox2" == "true" ]]; then
tdemand="$(($tiso + $combobox2))"
fi
#verifier si demande espace user est disponible
if [ "$tdemand" -ge "$tfree" ]; then
zenity --error --text "$(eval_gettext "Erreur: pas suffisament d\047espace libre:") ${tdemand}Mio >= ${tfree}Mio"
MOD_MANDRIVA_GUI
#si pas suffisament de place remonter gui
else
MOD_MANDRIVA_PERSIST
break
fi
else
MOD_MANDRIVA
break
fi
done
#si pas de fichier livecd-iso-to-disk
else
MOD_MANDRIVA
fi

#Mageia version dual
#http://www.mageia.org/fr/
#http://mirrors.mageia.org/
elif [[ "$(grep 'Mageia' /tmp/multisystem/multisystem-mountpoint-iso/i586/product.id 2>/dev/null)" \
&& "$(grep 'Mageia' /tmp/multisystem/multisystem-mountpoint-iso/x86_64/product.id 2>/dev/null)" ]]; then
modiso="copycontent"
if [[ ! -d "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/i586" && ! -d "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/x86_64" ]]; then
osname="mageia"
osicone="multisystem-mageia"
#Menu 1
ligne1="menuentry \"Mageia 32Bits\" {"
ligne2=""
ligne3="linux /i586/isolinux/alt0/vmlinuz automatic=method:usb vga=788 splash=silent"
ligne4="initrd /i586/isolinux/alt0/all.rdz"
ligne5="}"
#Menu 2
ligne6="menuentry \"Mageia 64Bits\" {"
ligne7=""
ligne8="linux /x86_64/isolinux/alt0/vmlinuz automatic=method:usb vga=788 splash=silent"
ligne9="initrd /x86_64/isolinux/alt0/all.rdz"
ligne10="}"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD2)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/i586"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/x86_64"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/i586/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/i586/."
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/x86_64/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/x86_64/."
else
zenity --error --text "$(eval_gettext "Erreur: LiveCD déjà présent.")"
fi

#Mageia i586
#http://www.mageia.org/fr/
#http://mirrors.mageia.org/
elif [ "$(grep 'Mageia' /tmp/multisystem/multisystem-mountpoint-iso/i586/product.id 2>/dev/null)" ]; then
modiso="copycontent"
if [ ! -d "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/i586" ]; then
osname="i586"
osnamemodif="mageia"
osicone="multisystem-mageia"
osloopback=""
oskernel="linux /i586/isolinux/alt0/vmlinuz automatic=method:usb vga=788 splash=silent"
osinitrd="initrd /i586/isolinux/alt0/all.rdz"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
#i586
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/i586"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/i586/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/i586/."
else
zenity --error --text "$(eval_gettext "Erreur: LiveCD déjà présent.")"
fi

#Mageiax x86_64
#http://www.mageia.org/fr/
#http://mirrors.mageia.org/
elif [ "$(grep 'Mageia' /tmp/multisystem/multisystem-mountpoint-iso/x86_64/product.id 2>/dev/null)" ]; then
modiso="copycontent"
if [ ! -d "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/x86_64" ]; then
osname="x86_64"
osnamemodif="mageia"
osicone="multisystem-mageia"
osloopback=""
oskernel="linux /x86_64/isolinux/alt0/vmlinuz automatic=method:usb vga=788 splash=silent"
osinitrd="initrd /x86_64/isolinux/alt0/all.rdz"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
#x86_64
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/x86_64"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/x86_64/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/x86_64/."
else
zenity --error --text "$(eval_gettext "Erreur: LiveCD déjà présent.")"
fi

#Mageia-2 version liveCD
#voir script ==> ./divers/mageia.sh
#http://www.mageia.org/fr/downloads/
elif [ "$(grep 'root=mgalive:LABEL=Mageia-2' /tmp/multisystem/multisystem-mountpoint-iso/boot/cdrom/syslinux.cfg 2>/dev/null)" ]; then
modiso="copycontent"
echo "mageia1" >/tmp/multisystem/multisystem-nomdistro
chemindeb="$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/mageia"
find "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")" -maxdepth 1 -path "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/mageia[0-9]" | while read line
do
echo "mageia$(($(echo $line | sed "s@${chemindeb}@@g")+1))" >/tmp/multisystem/multisystem-nomdistro
done
osname="$(cat /tmp/multisystem/multisystem-nomdistro)"
osicone="multisystem-mageia"
#Menu live
ligne1="menuentry \"Mageia-2 live\" {"
ligne2=""
ligne3="linux /boot/bootdistro/${osname}/vmlinuz root=mgalive:LABEL=$(cat /tmp/multisystem/multisystem-selection-label-usb) splash quiet vga=788 "
ligne4="initrd /boot/bootdistro/${osname}/initrd.gz"
ligne5="}"
#Menu install
ligne6="menuentry \"Mageia-2 install\" {"
ligne7=""
ligne8="linux /boot/bootdistro/${osname}/vmlinuz root=mgalive:LABEL=$(cat /tmp/multisystem/multisystem-selection-label-usb) splash quiet vga=788 install"
ligne9="initrd /boot/bootdistro/${osname}/initrd.gz"
ligne10="}"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD2)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${osname}"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/bootdistro/${osname}"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
cp /tmp/multisystem/multisystem-mountpoint-iso/boot/cdrom/initrd.gz "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/bootdistro/${osname}/initrd.gz"
cp /tmp/multisystem/multisystem-mountpoint-iso/boot/vmlinuz "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/bootdistro/${osname}/vmlinuz"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/loopbacks/distrib-lzma.sqfs "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/distrib-lzma.sqfs"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Veuillez saisir votre mot de passe d\047administrateur') \033[0m"
sudo ${dossier}/divers/mageia.sh ${osname}

#Mageia version Netinstall
elif [ "$(grep 'Mageia release' /tmp/multisystem/multisystem-mountpoint-iso/VERSION 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osicone="multisystem-mageia"
#Menu fr
ligne1="menuentry \"Mageia Netinstall desktop\" {"
ligne2="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
ligne3="linux (loop)/isolinux/alt0/vmlinuz"
ligne4="initrd (loop)/isolinux/alt0/all.rdz"
ligne5="}"
#Menu en
ligne6="menuentry \"Mageia Netinstall server\" {"
ligne7="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
ligne8="linux (loop)/isolinux/alt1/vmlinuz"
ligne9="initrd (loop)/isolinux/alt1/all.rdz"
ligne10="}"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD2)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#passe pas à tetester kernel panic...
#blackPanther OS gfxplayload=1280x1024
#http://distrowatch.com/table.php?distribution=blackpanther
elif [ "$(grep 'zzZZzzblackPanther OS' /tmp/multisystem/multisystem-mountpoint-iso/isolinux/isolinux.cfg 2>/dev/null)" ]; then
modiso="copycontent"
echo "mageia1" >/tmp/multisystem/multisystem-nomdistro
chemindeb="$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/mageia"
find "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")" -maxdepth 1 -path "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/mageia[0-9]" | while read line
do
echo "mageia$(($(echo $line | sed "s@${chemindeb}@@g")+1))" >/tmp/multisystem/multisystem-nomdistro
done
osname="$(cat /tmp/multisystem/multisystem-nomdistro)"
osicone="multisystem-blackpanther"
#Menu live
ligne1="menuentry \"Blackpanther OS live\" {"
ligne2=""
ligne3="linux /boot/bootdistro/${osname}/vmlinuz init=linuxrc root=/dev/ram0 acpi=on vga=788 keyb=us splash=silent speedboot=no"
ligne4="initrd /boot/bootdistro/${osname}/initrd.gz"
ligne5="}"
#Menu install
ligne6="menuentry \"Blackpanther OS install\" {"
ligne7=""
ligne8="linux /boot/bootdistro/${osname}/vmlinuz init=linuxrc root=/dev/ram0 acpi=on vga=788 keyb=us splash=silent speedboot=no INSTALL"
ligne9="initrd /boot/bootdistro/${osname}/initrd.gz"
ligne10="}"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD2)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${osname}"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/bootdistro/${osname}"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
cp /tmp/multisystem/multisystem-mountpoint-iso/isolinux/initrd.gz "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/bootdistro/${osname}/initrd.gz"
cp /tmp/multisystem/multisystem-mountpoint-iso/isolinux/vmlinuz "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/bootdistro/${osname}/vmlinuz"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/livecd.sqfs "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/livecd.sqfs"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Veuillez saisir votre mot de passe d\047administrateur') \033[0m"
sudo ${dossier}/divers/blackPanther.sh ${osname}

#CrunchBang => 10 ==> base Debian LIVE/INSTALL Squeeze
#http://www.crunchbanglinux.org/wiki/downloads
elif [ "$(grep 'CrunchBang' /tmp/multisystem/multisystem-mountpoint-iso/isolinux/menu.cfg 2>/dev/null)" ]; then
modiso="copycontent"
echo "crunchbang1" >/tmp/multisystem/multisystem-nomdistro
chemindeb="$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/crunchbang"
find "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")" -maxdepth 1 -path "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/crunchbang[0-9]" | while read line
do
echo "crunchbang$(($(echo $line | sed "s@${chemindeb}@@g")+1))" >/tmp/multisystem/multisystem-nomdistro
done
osname="$(cat /tmp/multisystem/multisystem-nomdistro)"
osnamemodif="CrunchBang"
osicone="multisystem-crunchbang"
#Menu 1
ligne1="menuentry \"CrunchBang live\" {"
ligne2=""
ligne3="linux /${osname}/live/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/live -iname "*vmlinuz*")) root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) rw live-media-path=/${osname}/live quickusbmodules boot=live config quickreboot quiet"
ligne4="initrd /${osname}/live/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/live -iname "*initrd*"))"
ligne5="}"
#Menu 2
ligne6="menuentry \"CrunchBang live (failsafe)\" {"
ligne7=""
ligne8="linux /${osname}/live/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/live -iname "*vmlinuz*")) root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) rw live-media-path=/${osname}/live boot=live config noapic noapm nodma nomce nolapic nomodeset nosmp vga=normal quickreboot"
ligne9="initrd /${osname}/live/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/live -iname "*initrd*"))"
ligne10="}"
#Menu 3
ligne11="menuentry \"CrunchBang Graphical Install\" {"
ligne12=""
ligne13="linux /${osname}/install/gtk/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/install/gtk/ -iname "*vmlinuz*")) root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) video=vesa:ywrap,mtrr vga=788 quiet file=/cdrom/install/crunchbang.cfg"
ligne14="initrd /${osname}/install/gtk/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/install/gtk/ -iname "*initrd*"))"
ligne15="}"
#Menu 4
ligne16="menuentry \"CrunchBang Text Install\" {"
ligne17=""
ligne18="linux /${osname}/install/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/install/ -iname "*vmlinuz*")) root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) vga=normal quiet file=/cdrom/install/crunchbang.cfg"
ligne19="initrd /${osname}/install/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/install/ -iname "*initrd*"))"
ligne20="}"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD4)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${osname}"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/."
#Modifier ramdisk gtk
mkdir /tmp/multisystem/multisystem-modinitrd 2>/dev/null
cd /tmp/multisystem/multisystem-modinitrd
gzip -dc /tmp/multisystem/multisystem-mountpoint-iso/install/gtk/initrd.gz | cpio -i
#if mount -t $type -o ro,exec $device /cdrom; then
sed -i 's@if mount -t $type -o ro,exec $device /cdrom; then@if mount -t vfat -o ro,exec /dev/disk/by-uuid/'$(cat /tmp/multisystem/multisystem-selection-uuid-usb)' /cdrom; then\n\tmount --bind /cdrom/'${osname}' /cdrom 2>/dev/null@' /tmp/multisystem/multisystem-modinitrd/var/lib/dpkg/info/cdrom-detect.postinst
sed -i 's@if mount -t $type -o $OPTIONS $device /cdrom; then@if mount -t vfat -o ro,exec /dev/disk/by-uuid/'$(cat /tmp/multisystem/multisystem-selection-uuid-usb)' /cdrom; then\n\tmount --bind /cdrom/'${osname}' /cdrom 2>/dev/null@' /tmp/multisystem/multisystem-modinitrd/var/lib/dpkg/info/cdrom-detect.postinst
#gedit /tmp/multisystem/multisystem-modinitrd/var/lib/dpkg/info/cdrom-detect.postinst
#echo Attente1
#read
sudo rm "$(cat /tmp/multisystem/multisystem-mountpoint-usb)"/${osname}/install/gtk/initrd.gz
find . | cpio -o -H newc | gzip -9 > "$(cat /tmp/multisystem/multisystem-mountpoint-usb)"/${osname}/install/gtk/initrd.gz
cd -
sudo rm -R /tmp/multisystem/multisystem-modinitrd
#Modifier ramdisk non gtk
mkdir /tmp/multisystem/multisystem-modinitrd 2>/dev/null
cd /tmp/multisystem/multisystem-modinitrd
gzip -dc /tmp/multisystem/multisystem-mountpoint-iso/install/initrd.gz | cpio -i
#if mount -t $type -o ro,exec $device /cdrom; then
sed -i 's@if mount -t $type -o ro,exec $device /cdrom; then@if mount -t vfat -o ro,exec /dev/disk/by-uuid/'$(cat /tmp/multisystem/multisystem-selection-uuid-usb)' /cdrom; then\n\tmount --bind /cdrom/'${osname}' /cdrom 2>/dev/null@' /tmp/multisystem/multisystem-modinitrd/var/lib/dpkg/info/cdrom-detect.postinst
sed -i 's@if mount -t $type -o $OPTIONS $device /cdrom; then@if mount -t vfat -o ro,exec /dev/disk/by-uuid/'$(cat /tmp/multisystem/multisystem-selection-uuid-usb)' /cdrom; then\n\tmount --bind /cdrom/'${osname}' /cdrom 2>/dev/null@' /tmp/multisystem/multisystem-modinitrd/var/lib/dpkg/info/cdrom-detect.postinst
#gedit /tmp/multisystem/multisystem-modinitrd/var/lib/dpkg/info/cdrom-detect.postinst
#echo Attente1
#read
sudo rm "$(cat /tmp/multisystem/multisystem-mountpoint-usb)"/${osname}/install/initrd.gz
find . | cpio -o -H newc | gzip -9 > "$(cat /tmp/multisystem/multisystem-mountpoint-usb)"/${osname}/install/initrd.gz
cd -
sudo rm -R /tmp/multisystem/multisystem-modinitrd

#Zentyal (pas réussit, trouve pas les sources ... a retester...)
#http://www.zentyal.org/downloads/
elif [ "$(grep 'Zentyal' /tmp/multisystem/multisystem-mountpoint-iso/isolinux/isolinux.cfg 2>/dev/null)" ]; then
modiso="copycontent"
echo "zentyal1" >/tmp/multisystem/multisystem-nomdistro
chemindeb="$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/zentyal"
find "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")" -maxdepth 1 -path "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/zentyal[0-9]" | while read line
do
echo "zentyal$(($(echo $line | sed "s@${chemindeb}@@g")+1))" >/tmp/multisystem/multisystem-nomdistro
done
osname="$(cat /tmp/multisystem/multisystem-nomdistro)"
osicone="multisystem-zentyal"
#Menu 1
ligne1="menuentry \"Install Zentyal 2.2-rc2 (delete all disk)\" {"
ligne2=""
ligne3="linux /${osname}/install/vmlinuz file=/cdrom/preseed/ubuntu-server-auto.seed initrd=/install/initrd.gz cdrom-detect/try-usb=true quiet --"
ligne4="initrd /${osname}/install/initrd.gz"
ligne5="}"
#Menu 2
ligne6="menuentry \"Install Zentyal 2.2-rc2 (expert mode)\" {"
ligne7=""
ligne8="linux /${osname}/install/vmlinuz file=/cdrom/preseed/ubuntu-server.seed initrd=/install/initrd.gz cdrom-detect/try-usb=true quiet --"
ligne9="initrd /${osname}/install/initrd.gz"
ligne10="}"
#Menu 3
ligne11="menuentry \"Recover subscribed Zentyal server (delete all disk)\" {"
ligne12=""
ligne13="linux /${osname}/install/vmlinuz file=/cdrom/preseed/disaster-recovery-auto.seed initrd=/install/initrd.gz cdrom-detect/try-usb=true quiet --"
ligne14="initrd /${osname}/install/initrd.gz"
ligne15="}"
#Menu 4
ligne16="menuentry \"Recover subscribed Zentyal server (expert mode)\" {"
ligne17=""
ligne18="linux /${osname}/install/vmlinuz file=/cdrom/preseed/disaster-recovery.seed initrd=/install/initrd.gz cdrom-detect/try-usb=true quiet --"
ligne19="initrd /${osname}/install/initrd.gz"
ligne20="}"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD4)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${osname}"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/."
#Modifier ramdisk
mkdir /tmp/multisystem/multisystem-modinitrd 2>/dev/null
cd /tmp/multisystem/multisystem-modinitrd
gzip -dc /tmp/multisystem/multisystem-mountpoint-iso/install/initrd.gz | cpio -i
#if mount -t vfat -o ro,exec $device /cdrom &&
sed -i 's@if mount -t vfat -o ro,exec $device /cdrom \&\&@if mount -t vfat -o ro,exec /dev/disk/by-uuid/'$(cat /tmp/multisystem/multisystem-selection-uuid-usb)' /cdrom \&\& mount --bind /cdrom/'${osname}' /cdrom 2>/dev/null \&\&@g' /tmp/multisystem/multisystem-modinitrd/var/lib/dpkg/info/cdrom-detect.postinst
#gedit /tmp/multisystem/multisystem-modinitrd/var/lib/dpkg/info/cdrom-detect.postinst
#echo Attente1
#read
sudo rm "$(cat /tmp/multisystem/multisystem-mountpoint-usb)"/${osname}/install/initrd.gz
find . | cpio -o -H newc | gzip -9 > "$(cat /tmp/multisystem/multisystem-mountpoint-usb)"/${osname}/install/initrd.gz
cd -
sudo rm -R /tmp/multisystem/multisystem-modinitrd

#Privatix Live-System
#http://www.mandalka.name/privatix/download.html.en
elif [ "$(grep 'hostname=privatix' /tmp/multisystem/multisystem-mountpoint-iso/isolinux/live.cfg 2>/dev/null)" ]; then
modiso="copycontent"
echo "debian1" >/tmp/multisystem/multisystem-nomdebian
chemindeb="$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/debian"
find "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")" -maxdepth 1 -path "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/debian[0-9]" | while read line
do
echo "debian$(($(echo $line | sed "s@${chemindeb}@@g")+1))" >/tmp/multisystem/multisystem-nomdebian
done
osname="$(cat /tmp/multisystem/multisystem-nomdebian)"
osnamemodif="$(basename "${option2}")"
osicone="multisystem-privatix"
osloopback=""
oskernel="linux /${osname}/vmlinuz root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) live-media-path=/${osname} debian-installer/language=$(echo "${LANG}" |  awk -F"_" '{print $1}') debian-installer/locale=${LANG} kbd-chooser/method=${XKBLAYOUT}  console-setup/layoutcode=${XKBLAYOUT} console-setup/variantcode=${XKBVARIANT} console-setup/modelcode=${XKBMODEL} boot=live config username=privatix hostname=privatix  quiet"
osinitrd="initrd /${osname}/initrd.img"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
#debian
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${osname}"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/live/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/."

#Semplice Linux
#Semplice:http://semplice-linux.sourceforge.net/download/
elif [ "$(grep 'hostname=SempliceInstall' /tmp/multisystem/multisystem-mountpoint-iso/isolinux/other.cfg 2>/dev/null)" ]; then
modiso="copycontent"
echo "debian1" >/tmp/multisystem/multisystem-nomdebian
chemindeb="$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/debian"
find "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")" -maxdepth 1 -path "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/debian[0-9]" | while read line
do
echo "debian$(($(echo $line | sed "s@${chemindeb}@@g")+1))" >/tmp/multisystem/multisystem-nomdebian
done
osname="$(cat /tmp/multisystem/multisystem-nomdebian)"
osnamemodif="$(basename "${option2}")"
osicone="multisystem-semplice"
osloopback=""
oskernel="linux /${osname}/vmlinuz root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) live-media-path=/${osname} debian-installer/language=$(echo "${LANG}" |  awk -F"_" '{print $1}') debian-installer/locale=${LANG} kbd-chooser/method=${XKBLAYOUT}  console-setup/layoutcode=${XKBLAYOUT} console-setup/variantcode=${XKBVARIANT} console-setup/modelcode=${XKBMODEL} boot=live config username=user hostname=SempliceLive user-fullname=Semplice quiet"
osinitrd="initrd /${osname}/initrd.img"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${osname}"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/live/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/."

#Tails Incognito Live System
#https://tails.boum.org/download/
elif [ "$(grep 'label tails-fr' /tmp/multisystem/multisystem-mountpoint-iso/isolinux/live.cfg 2>/dev/null)" ]; then
modiso="copycontent"
echo "debian1" >/tmp/multisystem/multisystem-nomdebian
chemindeb="$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/debian"
find "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")" -maxdepth 1 -path "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/debian[0-9]" | while read line
do
echo "debian$(($(echo $line | sed "s@${chemindeb}@@g")+1))" >/tmp/multisystem/multisystem-nomdebian
done
osname="$(cat /tmp/multisystem/multisystem-nomdebian)"
osnamemodif="$(basename "${option2}")"
osicone="multisystem-incognito"
osloopback=""
#oskernel="linux /${osname}/vmlinuz root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) live-media-path=/${osname} debian-installer/language=$(echo "${LANG}" |  awk -F"_" '{print $1}') debian-installer/locale=${LANG} kbd-chooser/method=${XKBLAYOUT}  console-setup/layoutcode=${XKBLAYOUT} console-setup/variantcode=${XKBVARIANT} console-setup/modelcode=${XKBMODEL} boot=live config splash vga=788  noprompt  quiet"
oskernel="linux /${osname}/vmlinuz root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) live-media-path=/${osname} boot=live config noswap noprompt quiet timezone=Etc/UTC block.events_dfl_poll_msecs=1000 splash  quiet locales=${LANG} keyboard-layouts=${XKBLAYOUT}"
osinitrd="initrd /${osname}/initrd.img"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
#debian
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${osname}"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/live/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/."

#Tails Incognito Live System (tails-i386-0.11.iso)
#https://tails.boum.org/download/
elif [ "$(grep 'tails-greeter' /tmp/multisystem/multisystem-mountpoint-iso/live/filesystem.packages 2>/dev/null)" ]; then
modiso="copycontent"
echo "debian1" >/tmp/multisystem/multisystem-nomdebian
chemindeb="$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/debian"
find "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")" -maxdepth 1 -path "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/debian[0-9]" | while read line
do
echo "debian$(($(echo $line | sed "s@${chemindeb}@@g")+1))" >/tmp/multisystem/multisystem-nomdebian
done
osname="$(cat /tmp/multisystem/multisystem-nomdebian)"
osicone="multisystem-incognito"
#Menu 1
ligne1="menuentry \"Tails live\" {"
ligne2=""
ligne3="linux /${osname}/vmlinuz root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) live-media-path=/${osname} boot=live config noswap live-media=removable nopersistent noprompt quiet timezone=Etc/UTC block.events_dfl_poll_msecs=1000 splash  quiet locales=${LANG} keyboard-layouts=${XKBLAYOUT}"
ligne4="initrd /${osname}/initrd.img"
ligne5="}"
#Menu 2
ligne6="menuentry \"Tails livefailsafe\" {"
ligne7=""
ligne8="linux /${osname}/vmlinuz root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) live-media-path=/${osname} boot=live config noswap live-media=removable nopersistent noprompt quiet timezone=Etc/UTC block.events_dfl_poll_msecs=1000 splash  nox11autologin noapic noapm nodma nomce nolapic nomodeset nosmp vga=normal quiet locales=${LANG} keyboard-layouts=${XKBLAYOUT}"
ligne9="initrd /${osname}/initrd.img"
ligne10="}"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD2)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${osname}"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/live/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/."

#DRBL LIVE
#http://drbl.sourceforge.net/
elif [ "$(grep 'MENU LABEL DRBL Live' /tmp/multisystem/multisystem-mountpoint-iso/syslinux/syslinux.cfg 2>/dev/null)" ]; then
modiso="copycontent"
echo "debian1" >/tmp/multisystem/multisystem-nomdebian
chemindeb="$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/debian"
find "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")" -maxdepth 1 -path "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/debian[0-9]" | while read line
do
echo "debian$(($(echo $line | sed "s@${chemindeb}@@g")+1))" >/tmp/multisystem/multisystem-nomdebian
done
osname="$(cat /tmp/multisystem/multisystem-nomdebian)"
osicone="multisystem-drbl"
#Menu 1
ligne1="menuentry \"DRBL LIVE\" {"
ligne2=""
ligne3="linux /${osname}/live/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/live -iname "*vmlinuz*")) root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) live-media-path=/${osname}/live debian-installer/language=$(echo "${LANG}" |  awk -F"_" '{print $1}') debian-installer/locale=${LANG} kbd-chooser/method=${XKBLAYOUT}  console-setup/layoutcode=${XKBLAYOUT} console-setup/variantcode=${XKBVARIANT} console-setup/modelcode=${XKBMODEL} boot=live config nomodeset vga=785 ip=frommedia  nosplash"
ligne4="initrd /${osname}/live/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/live -iname "*initrd*"))"
ligne5="}"
#Menu 2
ligne6="menuentry \"DRBL LIVE (To RAM)\" {"
ligne7=""
ligne8="linux /${osname}/live/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/live -iname "*vmlinuz*")) root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) live-media-path=/${osname}/live debian-installer/language=$(echo "${LANG}" |  awk -F"_" '{print $1}') debian-installer/locale=${LANG} kbd-chooser/method=${XKBLAYOUT}  console-setup/layoutcode=${XKBLAYOUT} console-setup/variantcode=${XKBVARIANT} console-setup/modelcode=${XKBMODEL} boot=live config nomodeset noprompt vga=785 toram=filesystem.squashfs ip=frommedia  nosplash"
ligne9="initrd /${osname}/live/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/live -iname "*initrd*"))"
ligne10="}"
#Menu 3
ligne11="menuentry \"DRBL LIVE without framebuffer\" {"
ligne12=""
ligne13="linux /${osname}/live/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/live -iname "*vmlinuz*")) root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) live-media-path=/${osname}/live debian-installer/language=$(echo "${LANG}" |  awk -F"_" '{print $1}') debian-installer/locale=${LANG} kbd-chooser/method=${XKBLAYOUT}  console-setup/layoutcode=${XKBLAYOUT} console-setup/variantcode=${XKBVARIANT} console-setup/modelcode=${XKBMODEL} boot=live config nomodeset ip=frommedia vga=normal nosplash"
ligne14="initrd /${osname}/live/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/live -iname "*initrd*"))"
ligne15="}"
#Menu 4
ligne16="menuentry \"DRBL LIVE failsafe mode\" {"
ligne17=""
ligne18="linux /${osname}/live/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/live -iname "*vmlinuz*")) root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) live-media-path=/${osname}/live debian-installer/language=$(echo "${LANG}" |  awk -F"_" '{print $1}') debian-installer/locale=${LANG} kbd-chooser/method=${XKBLAYOUT}  console-setup/layoutcode=${XKBLAYOUT} console-setup/variantcode=${XKBVARIANT} console-setup/modelcode=${XKBMODEL} boot=live config nomodeset acpi=off irqpoll noapic noapm nodma nomce nolapic nosmp ip=frommedia vga=normal nosplash"
ligne19="initrd /${osname}/live/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/live -iname "*initrd*"))"
ligne20="}"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD4)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${osname}"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/."

#openmamba
#http://www.openmamba.org/distribution/download.html
elif [ "$(grep 'zzZZzzopenmamba' /tmp/multisystem/multisystem-mountpoint-iso/boot/isolinux/isolinux.cfg 2>/dev/null)" ]; then
modiso="copycontent"
echo "openmamba1" >/tmp/multisystem/multisystem-nomopenmamba
chemindeb="$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/openmamba"
find "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")" -maxdepth 1 -path "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/openmamba[0-9]" | while read line
do
echo "openmamba$(($(echo $line | sed "s@${chemindeb}@@g")+1))" >/tmp/multisystem/multisystem-nomopenmamba
done
osname="$(cat /tmp/multisystem/multisystem-nomopenmamba)"
osnamemodif="openmamba"
osicone="multisystem-openmamba"
osloopback=""
oskernel="linux /${osname}/boot/vmlinuz live_dir=/${osname}/LiveOS root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) rootfstype=auto ro selinux=0 quiet splash vga=789"
osinitrd="initrd /${osname}/boot/initrmfs.gz"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${osname}"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/."

#Swift Linux
#http://distrowatch.com/table.php?distribution=swift
elif [ "$(grep 'Swift Linux' /tmp/multisystem/multisystem-mountpoint-iso/isolinux/isolinux.cfg 2>/dev/null)" ]; then
modiso="copycontent"
echo "swift1" >/tmp/multisystem/multisystem-nomdistro
chemindeb="$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/swift"
find "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")" -maxdepth 1 -path "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/swift[0-9]" | while read line
do
echo "swift$(($(echo $line | sed "s@${chemindeb}@@g")+1))" >/tmp/multisystem/multisystem-nomdistro
done
osname="$(cat /tmp/multisystem/multisystem-nomdistro)"
osnamemodif="swift"
osicone="multisystem-swift"
#Menu 1
ligne1="menuentry \"Swift Linux\" {"
ligne2=""
ligne3="linux /${osname}/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*vmlinuz*")) root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) live-media-path=/${osname} rw noprompt quickreboot boot=live config quiet splash --"
ligne4="initrd /${osname}/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*initrd*"))"
ligne5="}"
#Menu 2
ligne6="menuentry \"Swift Linux (compatibility mode)\" {"
ligne7=""
ligne8="linux /${osname}/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*vmlinuz*")) live-media-path=/${osname} boot=live config xforcevesa ramdisk_size=1048576 root=/dev/ram rw noprompt quickreboot noapic noapci nosplash irqpoll --"
ligne9="initrd /${osname}/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*initrd*"))"
ligne10="}"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD2)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${osname}"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/casper/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/."

#Liquid Lemur
#http://liquidlemur.org/
elif [ "$(grep 'Liquid Lemur' /tmp/multisystem/multisystem-mountpoint-iso/isolinux/menu.cfg 2>/dev/null)" ]; then
modiso="copycontent"
echo "liquidlemur1" >/tmp/multisystem/multisystem-nomdistro
chemindeb="$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/liquidlemur"
find "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")" -maxdepth 1 -path "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/liquidlemur[0-9]" | while read line
do
echo "liquidlemur$(($(echo $line | sed "s@${chemindeb}@@g")+1))" >/tmp/multisystem/multisystem-nomdistro
done
osname="$(cat /tmp/multisystem/multisystem-nomdistro)"
osnamemodif="liquidlemur"
osicone="multisystem-liquidlemur"
#Menu 1
ligne1="menuentry \"Liquid Lemur live\" {"
ligne2=""
ligne3="linux /${osname}/live/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/live -iname "*vmlinuz*")) root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) rw live-media-path=/${osname}/live boot=live config quiet"
ligne4="initrd /${osname}/live/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/live -iname "*initrd*"))"
ligne5="}"
#Menu 2
ligne6="menuentry \"Liquid Lemur live (failsafe)\" {"
ligne7=""
ligne8="linux /${osname}/live/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/live -iname "*vmlinuz*")) root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) rw live-media-path=/${osname}/live boot=live config noapic noapm nodma nomce nolapic nomodeset nosmp vga=normal"
ligne9="initrd /${osname}/live/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/live -iname "*initrd*"))"
ligne10="}"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD2)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${osname}"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/."

#Matriux
#http://www.matriux.com/index.php?page=download
elif [ "$(grep 'Matriux' /tmp/multisystem/multisystem-mountpoint-iso/isolinux/menu.cfg 2>/dev/null)" ]; then
modiso="copycontent"
echo "matriux1" >/tmp/multisystem/multisystem-nomdistro
chemindeb="$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/matriux"
find "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")" -maxdepth 1 -path "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/matriux[0-9]" | while read line
do
echo "matriux$(($(echo $line | sed "s@${chemindeb}@@g")+1))" >/tmp/multisystem/multisystem-nomdistro
done
osname="$(cat /tmp/multisystem/multisystem-nomdistro)"
osicone="multisystem-matriux"
#Menu 1
ligne1="menuentry \"Matriux live\" {"
ligne2=""
ligne3="linux /${osname}/live/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/live -iname "*vmlinuz*")) root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) rw live-media-path=/${osname}/live boot=live config   quiet splash"
ligne4="initrd /${osname}/live/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/live -iname "*initrd*"))"
ligne5="}"
#Menu 2
ligne6="menuentry \"Matriux live (failsafe)\" {"
ligne7=""
ligne8="linux /${osname}/live/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/live -iname "*vmlinuz*")) root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) rw live-media-path=/${osname}/live boot=live config   noapic noapm nodma nomce nolapic nomodeset radeon.modeset=0 nouveau.modeset=0 nosmp vga=normal"
ligne9="initrd /${osname}/live/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/live -iname "*initrd*"))"
ligne10="}"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD2)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${osname}"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/."

#srvRX live
#https://sourceforge.net/projects/srvrx/files/
elif [ "$(grep -i 'srvrx' <<< "$(basename "${option2}")" 2>/dev/null)" ]; then
modiso="copycontent"
echo "srvrx1" >/tmp/multisystem/multisystem-nomdistro
chemindeb="$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/srvrx"
find "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")" -maxdepth 1 -path "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/srvrx[0-9]" | while read line
do
echo "srvrx$(($(echo $line | sed "s@${chemindeb}@@g")+1))" >/tmp/multisystem/multisystem-nomdistro
done
osname="$(cat /tmp/multisystem/multisystem-nomdistro)"
osicone="multisystem-tux"
#Menu 1
ligne1="menuentry \"srvRX live\" {"
ligne2=""
ligne3="linux /${osname}/live/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/live -iname "*vmlinuz*")) root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) rw live-media-path=/${osname}/live boot=live config   quiet splash"
ligne4="initrd /${osname}/live/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/live -iname "*initrd*"))"
ligne5="}"
#Menu 2
ligne6="menuentry \"srvRX live (failsafe)\" {"
ligne7=""
ligne8="linux /${osname}/live/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/live -iname "*vmlinuz*")) root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) rw live-media-path=/${osname}/live boot=live config   noapic noapm nodma nomce nolapic nomodeset radeon.modeset=0 nouveau.modeset=0 nosmp vga=normal"
ligne9="initrd /${osname}/live/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/live -iname "*initrd*"))"
ligne10="}"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD2)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${osname}"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/."

#Kepler OS (a retester more bugsss...)
#http://kepleros.altervista.org/download/
elif [ "$(grep 'Kepler OS' /tmp/multisystem/multisystem-mountpoint-iso/isolinux/menu.cfg 2>/dev/null)" ]; then
modiso="copycontent"
echo "kepleros1" >/tmp/multisystem/multisystem-nomdistro
chemindeb="$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/kepleros"
find "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")" -maxdepth 1 -path "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/kepleros[0-9]" | while read line
do
echo "kepleros$(($(echo $line | sed "s@${chemindeb}@@g")+1))" >/tmp/multisystem/multisystem-nomdistro
done
osname="$(cat /tmp/multisystem/multisystem-nomdistro)"
osnamemodif="Kepler OS"
osicone="multisystem-kepler"
#Menu 1
ligne1="menuentry \"Kepler OS\" {"
ligne2=""
ligne3="linux /${osname}/live/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/live -iname "*vmlinuz*")) root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) rw live-media-path=/${osname}/live boot=live config   quiet splash"
ligne4="initrd /${osname}/live/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/live -iname "*initrd*"))"
ligne5="}"
#Menu 2
ligne6="menuentry \"Kepler OS (failsafe)\" {"
ligne7=""
ligne8="linux /${osname}/live/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/live -iname "*vmlinuz*")) root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) rw live-media-path=/${osname}/live boot=live config   noapic noapm nodma nomce nolapic nomodeset radeon.modeset=0 nouveau.modeset=0 nosmp vga=normal"
ligne9="initrd /${osname}/live/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/live -iname "*initrd*"))"
ligne10="}"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD2)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${osname}"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/."

#LinuxCoin
#http://www.linuxcoin.co.uk/
elif [ "$(grep 'LinuxCoin' /tmp/multisystem/multisystem-mountpoint-iso/isolinux/live.cfg 2>/dev/null)" ]; then
modiso="copycontent"
echo "linuxcoin1" >/tmp/multisystem/multisystem-nomdistro
chemindeb="$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/linuxcoin"
find "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")" -maxdepth 1 -path "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/linuxcoin[0-9]" | while read line
do
echo "linuxcoin$(($(echo $line | sed "s@${chemindeb}@@g")+1))" >/tmp/multisystem/multisystem-nomdistro
done
osname="$(cat /tmp/multisystem/multisystem-nomdistro)"
osnamemodif="LinuxCoin"
osicone="multisystem-linuxcoin"
#Menu 1
ligne1="menuentry \"LinuxCoin live (64 bits only)\" {"
ligne2=""
ligne3="linux /${osname}/live/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/live -iname "*vmlinuz*")) root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) rw live-media-path=/${osname}/live boot=live config quiet splash rw vga=791 edd=off"
ligne4="initrd /${osname}/live/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/live -iname "*initrd*"))"
ligne5="}"
#Menu 2
ligne6="menuentry \"LinuxCoin (failsafe) (64 bits only)\" {"
ligne7=""
ligne8="linux /${osname}/live/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/live -iname "*vmlinuz*")) root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) rw live-media-path=/${osname}/live  boot=live config noapic noapm nodma nomce nolapic nomodeset radeon.modeset=0 nouveau.modeset=0 nosmp vga=normal"
ligne9="initrd /${osname}/live/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/live -iname "*initrd*"))"
ligne10="}"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD2)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${osname}"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/."

#SparkyLinux
#http://linuxiarze.pl/sparkylinux/
elif [ "$(grep 'SparkyLinux' /tmp/multisystem/multisystem-mountpoint-iso/isolinux/live.cfg 2>/dev/null)" ]; then
modiso="copycontent"
echo "sparkylinux1" >/tmp/multisystem/multisystem-nomdistro
chemindeb="$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/sparkylinux"
find "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")" -maxdepth 1 -path "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/sparkylinux[0-9]" | while read line
do
echo "sparkylinux$(($(echo $line | sed "s@${chemindeb}@@g")+1))" >/tmp/multisystem/multisystem-nomdistro
done
osname="$(cat /tmp/multisystem/multisystem-nomdistro)"
osicone="multisystem-sparkylinux"
#Menu 1
ligne1="menuentry \"SparkyLinux live\" {"
ligne2=""
ligne3="linux /${osname}/live/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/live -iname "*vmlinuz*")) root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) rw live-media-path=/${osname}/live boot=live config quiet"
ligne4="initrd /${osname}/live/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/live -iname "*initrd*"))"
ligne5="}"
#Menu 2
ligne6="menuentry \"SparkyLinux (failsafe)\" {"
ligne7=""
ligne8="linux /${osname}/live/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/live -iname "*vmlinuz*")) root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) rw live-media-path=/${osname}/live boot=live config  noapic noapm nodma nomce nolapic nomodeset radeon.modeset=0 nouveau.modeset=0 nosmp vga=normal"
ligne9="initrd /${osname}/live/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/live -iname "*initrd*"))"
ligne10="}"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD2)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${osname}"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/."

#Snowlinux
#http://www.snowlinux.de/download
elif [ "$(grep 'Snowlinux' /tmp/multisystem/multisystem-mountpoint-iso/isolinux/live.cfg 2>/dev/null)" ]; then
modiso="copycontent"
echo "snowlinux1" >/tmp/multisystem/multisystem-nomdistro
chemindeb="$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/snowlinux"
find "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")" -maxdepth 1 -path "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/sparkylinux[0-9]" | while read line
do
echo "snowlinux$(($(echo $line | sed "s@${chemindeb}@@g")+1))" >/tmp/multisystem/multisystem-nomdistro
done
osname="$(cat /tmp/multisystem/multisystem-nomdistro)"
osicone="multisystem-snowlinux"
#Menu 1
ligne1="menuentry \"Snowlinux live\" {"
ligne2=""
ligne3="linux /${osname}/live/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/live -iname "*vmlinuz*")) root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) rw live-media-path=/${osname}/live boot=live username=snowlinux config quiet"
ligne4="initrd /${osname}/live/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/live -iname "*initrd*"))"
ligne5="}"
#Menu 2
ligne6="menuentry \"Snowlinux (failsafe)\" {"
ligne7=""
ligne8="linux /${osname}/live/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/live -iname "*vmlinuz*")) root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) rw live-media-path=/${osname}/live boot=live username=snowlinux config noapic noapm nodma nomce nolapic nomodeset nosmp vga=normal"
ligne9="initrd /${osname}/live/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/live -iname "*initrd*"))"
ligne10="}"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD2)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${osname}"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/."

#Xen Live CD 32Bits
#livecd-xen-3.2-0.8.2-i386.iso
#http://wiki.xensource.com/xenwiki/LiveCD
elif [ -f "/tmp/multisystem/multisystem-mountpoint-iso/live/initrd.img-2.6.26-1-xen-686" ]; then
modiso="copycontent"
echo "debian1" >/tmp/multisystem/multisystem-nomdebian
chemindeb="$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/debian"
find "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")" -maxdepth 1 -path "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/debian[0-9]" | while read line
do
echo "debian$(($(echo $line | sed "s@${chemindeb}@@g")+1))" >/tmp/multisystem/multisystem-nomdebian
done
osname="$(cat /tmp/multisystem/multisystem-nomdebian)"
osicone="multisystem-xen"
osnamemodif="Xen Live CD 32Bits"
ligne1="title ${osnamemodif}"
ligne2="find --set-root --ignore-floppies --ignore-cd /${osname}/live/xen-3.2-1-i386.gz"
ligne3="kernel /${osname}/live/xen-3.2-1-i386.gz dom0_mem=640M"
ligne4="module /${osname}/live/vmlinuz-2.6.26-1-xen-686 boot=live username=livexen hostname=xenalive union=aufs ro console=tty0 max_loop=256 quickreboot root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) live-media-path=/${osname}/live debian-installer/language=$(echo "${LANG}" |  awk -F"_" '{print $1}') debian-installer/locale=${LANG} kbd-chooser/method=${XKBLAYOUT}  console-setup/layoutcode=${XKBLAYOUT} console-setup/variantcode=${XKBVARIANT} console-setup/modelcode=${XKBMODEL}"
ligne5="module /${osname}/live/initrd.img-2.6.26-1-xen-686"
ligne6="quiet"
ligne7=""
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_GRUB4DOS)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/menu.lst"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${osname}"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/."

#Xen Live CD 64Bits
#livecd-xen-3.2-0.8.2-amd64.iso
#http://wiki.xensource.com/xenwiki/LiveCD
elif [ -f "/tmp/multisystem/multisystem-mountpoint-iso/live/initrd.img-2.6.26-1-xen-amd64" ]; then
modiso="copycontent"
echo "debian1" >/tmp/multisystem/multisystem-nomdebian
chemindeb="$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/debian"
find "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")" -maxdepth 1 -path "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/debian[0-9]" | while read line
do
echo "debian$(($(echo $line | sed "s@${chemindeb}@@g")+1))" >/tmp/multisystem/multisystem-nomdebian
done
osname="$(cat /tmp/multisystem/multisystem-nomdebian)"
osicone="multisystem-xen"
osnamemodif="Xen Live CD 64Bits"
ligne1="title ${osnamemodif}"
ligne2="find --set-root --ignore-floppies --ignore-cd /${osname}/live/xen-3.2-1-amd64.gz"
ligne3="kernel /${osname}/live/xen-3.2-1-amd64.gz dom0_mem=640M"
ligne4="module /${osname}/live/vmlinuz-2.6.26-1-xen-amd64 boot=live username=livexen hostname=xenalive union=aufs ro console=tty0 max_loop=256 quickreboot root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) live-media-path=/${osname}/live debian-installer/language=$(echo "${LANG}" |  awk -F"_" '{print $1}') debian-installer/locale=${LANG} kbd-chooser/method=${XKBLAYOUT}  console-setup/layoutcode=${XKBLAYOUT} console-setup/variantcode=${XKBVARIANT} console-setup/modelcode=${XKBMODEL}"
ligne5="module /${osname}/live/initrd.img-2.6.26-1-xen-amd64"
ligne6="quiet"
ligne7=""
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_GRUB4DOS)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/menu.lst"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${osname}"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/."

#Odebian
#http://www.odebian.org/#telechargement
elif [[ "$(grep 'hostname=odebian' /tmp/multisystem/multisystem-mountpoint-iso/isolinux/live.cfg 2>/dev/null)" || \
"$(grep 'hostname=odebian' /tmp/multisystem/multisystem-mountpoint-iso/isolinux/menu.cfg 2>/dev/null)" ]]; then
modiso="copycontent"
echo "debian1" >/tmp/multisystem/multisystem-nomdebian
chemindeb="$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/debian"
find "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")" -maxdepth 1 -path "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/debian[0-9]" | while read line
do
echo "debian$(($(echo $line | sed "s@${chemindeb}@@g")+1))" >/tmp/multisystem/multisystem-nomdebian
done
osname="$(cat /tmp/multisystem/multisystem-nomdebian)"
osnamemodif="Odebian"
osicone="multisystem-odebian"
osloopback=""
oskernel="linux /${osname}/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/live -iname "*vmlinuz*")) rw quickreboot root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) live-media-path=/${osname} boot=live config locales=${LANG} keyboard-layouts=${XKBLAYOUT} username=anonymous hostname=odebian quiet"
osinitrd="initrd /${osname}/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/live -iname "*initrd*"))"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
#debian
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${osname}"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/live/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/."

#PAIPIX (codé que support du live, manque install)
#http://mirror.sim.ul.pt/paipix/
elif [ "$(grep 'paipix-menu' /tmp/multisystem/multisystem-mountpoint-iso/packages.txt 2>/dev/null)" ]; then
modiso="copycontent"
echo "debian1" >/tmp/multisystem/multisystem-nomdebian
chemindeb="$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/debian"
find "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")" -maxdepth 1 -path "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/debian[0-9]" | while read line
do
echo "debian$(($(echo $line | sed "s@${chemindeb}@@g")+1))" >/tmp/multisystem/multisystem-nomdebian
done
osname="$(cat /tmp/multisystem/multisystem-nomdebian)"
osnamemodif="PAIPIX live"
osicone="multisystem-paipix"
osloopback=""
oskernel="linux /${osname}/live/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/live -iname "*vmlinuz*")) rw quickreboot root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) live-media-path=/${osname}/live/ boot=live debian-installer/language=$(echo "${LANG}" |  awk -F"_" '{print $1}') debian-installer/locale=${LANG} kbd-chooser/method=${XKBLAYOUT}  console-setup/layoutcode=${XKBLAYOUT} console-setup/variantcode=${XKBVARIANT} console-setup/modelcode=${XKBMODEL}"
osinitrd="initrd /${osname}/live/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/live -iname "*initrd*"))"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${osname}"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/."

#Eeebuntu 4.0
#http://eeebuntu.org/
elif [ "$(grep 'define DISKNAME  Eeebuntu 4.0' /tmp/multisystem/multisystem-mountpoint-iso/README.diskdefines 2>/dev/null)" ]; then
modiso="copycontent"
echo "debian1" >/tmp/multisystem/multisystem-nomdebian
chemindeb="$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/debian"
find "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")" -maxdepth 1 -path "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/debian[0-9]" | while read line
do
echo "debian$(($(echo $line | sed "s@${chemindeb}@@g")+1))" >/tmp/multisystem/multisystem-nomdebian
done
osname="$(cat /tmp/multisystem/multisystem-nomdebian)"
osnamemodif="$(basename "${option2}")"
osicone="multisystem-eeebuntu"
osloopback=""
oskernel="linux /${osname}/vmlinuz root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) live-media-path=/${osname} boot=live union=aufs debian-installer/language=$(echo "${LANG}" |  awk -F"_" '{print $1}') debian-installer/locale=${LANG} kbd-chooser/method=${XKBLAYOUT}  console-setup/layoutcode=${XKBLAYOUT} console-setup/variantcode=${XKBVARIANT} console-setup/modelcode=${XKBMODEL} file=/cdrom/preseed/eb4.seed quiet splash --"
osinitrd="initrd /${osname}/initrd.gz"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${osname}"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/live/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/."

#Gibraltar Firewall login:root pass:(rien)
#http://www.gibraltar.at/component/
elif [ "$(grep 'DEFAULT gibraltar' /tmp/multisystem/multisystem-mountpoint-iso/isolinux/isolinux.cfg 2>/dev/null)" ]; then
modiso="copycontent"
echo "debian1" >/tmp/multisystem/multisystem-nomdebian
chemindeb="$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/debian"
find "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")" -maxdepth 1 -path "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/debian[0-9]" | while read line
do
echo "debian$(($(echo $line | sed "s@${chemindeb}@@g")+1))" >/tmp/multisystem/multisystem-nomdebian
done
osname="$(cat /tmp/multisystem/multisystem-nomdebian)"
osnamemodif="$(basename "${option2}")"
osicone="multisystem-gibraltar"
osloopback=""
oskernel="linux /${osname}/linux root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) live-media-path=/${osname} boot=live union=aufs debian-installer/language=$(echo "${LANG}" |  awk -F"_" '{print $1}') debian-installer/locale=${LANG} kbd-chooser/method=${XKBLAYOUT}  console-setup/layoutcode=${XKBLAYOUT} console-setup/variantcode=${XKBVARIANT} console-setup/modelcode=${XKBMODEL} boot=live bootdelay=10 union=aufs exposedroot skipunion nopersistent selinux=1 enforcing=0 quiet"
osinitrd="initrd /${osname}/initrd.img"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
#gibraltar
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${osname}"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/isolinux/linux "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/linux"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/isolinux/initrd.img "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/initrd.img"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/live/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/."

#Puredyne
#http://puredyne.goto10.org/download.html
elif [ "$(grep 'menu label Start Puredyne' /tmp/multisystem/multisystem-mountpoint-iso/isolinux/live.cfg 2>/dev/null)" ]; then
modiso="copycontent"
echo "debian1" >/tmp/multisystem/multisystem-nomdebian
chemindeb="$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/debian"
find "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")" -maxdepth 1 -path "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/debian[0-9]" | while read line
do
echo "debian$(($(echo $line | sed "s@${chemindeb}@@g")+1))" >/tmp/multisystem/multisystem-nomdebian
done
osname="$(cat /tmp/multisystem/multisystem-nomdebian)"
osnamemodif="$(basename "${option2}")"
osicone="multisystem-puredyne"
osloopback=""
oskernel="linux /${osname}/vmlinuz root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) live-media-path=/${osname} debian-installer/language=$(echo "${LANG}" |  awk -F"_" '{print $1}') debian-installer/locale=${LANG} kbd-chooser/method=${XKBLAYOUT}  console-setup/layoutcode=${XKBLAYOUT} console-setup/variantcode=${XKBVARIANT} console-setup/modelcode=${XKBMODEL} boot=live persistent preseed/file=/live/image/${osname}/pure.seed quickreboot username=lintian hostname=puredyne union=aufs"
osinitrd="initrd /${osname}/initrd.img"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${osname}"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/live/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/."
cp /tmp/multisystem/multisystem-mountpoint-iso/pure.seed "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/pure.seed"

#Puredyne 9.10
#methode avec isofrom passe plus sur 9.11...
#http://puredyne.goto10.org/download.html
#http://puredyne.labomedia.net/carrot_and_coriander/
#isofrom=*|fromiso
#multisystem-puredyne|Puredyne|http://puredyne.goto10.org/download.html
elif [ "$(grep 'menu label Start Puredyne' /tmp/multisystem/multisystem-mountpoint-iso/isolinux/live.cfg 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osicone="multisystem-puredyne"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/live/vmlinuz rw rootfstype=vfat root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) isofrom=/dev/sda1/${osname} boot=live automatic-ubiquity preseed/file=/live/image/pure.seed quickreboot username=lintian hostname=puredyne union=aufs"
osinitrd="initrd /boot/bootdistro/puredyne/initrd.img"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
#Modifier ramdisk fait erreur en montant sur vfat
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/bootdistro/puredyne"
mkdir /tmp/multisystem/multisystem-modinitrd 2>/dev/null
cd /tmp/multisystem/multisystem-modinitrd
gzip -dc /tmp/multisystem/multisystem-mountpoint-iso/live/initrd.img | cpio -i
sed -i 's@mount "\$ISO_DEVICE" /isofrom@mount -t vfat "\$ISO_DEVICE" /isofrom@' /tmp/multisystem/multisystem-modinitrd/scripts/live
#gedit /tmp/multisystem/multisystem-modinitrd/scripts/live
#echo Attente
#read
find . | cpio -o -H newc | gzip -9 > "$(cat /tmp/multisystem/multisystem-mountpoint-usb)"/boot/bootdistro/puredyne/initrd.img
cd -
rm -R /tmp/multisystem/multisystem-modinitrd

#PelicanHPC
#http://pareto.uab.es/mcreel/PelicanHPC/
elif [ "$(grep 'hostname=pelican' /tmp/multisystem/multisystem-mountpoint-iso/isolinux/live.cfg 2>/dev/null)" ]; then
modiso="copycontent"
echo "debian1" >/tmp/multisystem/multisystem-nomdebian
chemindeb="$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/debian"
find "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")" -maxdepth 1 -path "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/debian[0-9]" | while read line
do
echo "debian$(($(echo $line | sed "s@${chemindeb}@@g")+1))" >/tmp/multisystem/multisystem-nomdebian
done
osname="$(cat /tmp/multisystem/multisystem-nomdebian)"
osnamemodif="$(basename "${option2}")"
osicone="multisystem-pelican"
osloopback=""
oskernel="linux /${osname}/vmlinuz root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) live-media-path=/${osname} debian-installer/language=$(echo "${LANG}" |  awk -F"_" '{print $1}') debian-installer/locale=${LANG} kbd-chooser/method=${XKBLAYOUT}  console-setup/layoutcode=${XKBLAYOUT} console-setup/variantcode=${XKBVARIANT} console-setup/modelcode=${XKBMODEL} boot=live config noautologin noxautologin quickreboot hostname=pelican quiet"
osinitrd="initrd /${osname}/initrd.img"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
#debian
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${osname}"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/live/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/."

#Kanotix
#http://kanotix.com/Downloads.html
elif [ "$(grep 'menu label Kanotix' /tmp/multisystem/multisystem-mountpoint-iso/isolinux/live.cfg 2>/dev/null)" ]; then
modiso="copycontent"
#
echo "debian1" >/tmp/multisystem/multisystem-nomdebian
chemindeb="$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/debian"
find "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")" -maxdepth 1 -path "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/debian[0-9]" | while read line
do
echo "debian$(($(echo $line | sed "s@${chemindeb}@@g")+1))" >/tmp/multisystem/multisystem-nomdebian
done
#
osname="$(cat /tmp/multisystem/multisystem-nomdebian)"
osnamemodif="$(basename "${option2}")"
osicone="multisystem-kanotix"
osloopback=""
oskernel="linux /${osname}/live/vmlinuz root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) live-media-path=/${osname}/live boot=live config debian-installer/language=$(echo "${LANG}" |  awk -F"_" '{print $1}') debian-installer/locale=${LANG} kbd-chooser/method=${XKBLAYOUT}  console-setup/layoutcode=${XKBLAYOUT} console-setup/variantcode=${XKBVARIANT} console-setup/modelcode=${XKBMODEL}"
osinitrd="initrd /${osname}/live/initrd.img"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
#debian
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${osname}"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/."

#Musix
#http://www.musix.org.ar/download.html
elif [ "$(grep 'Musix GNU/Linux' /tmp/multisystem/multisystem-mountpoint-iso/.disk/info 2>/dev/null)" ]; then
modiso="copycontent"
#
echo "debian1" >/tmp/multisystem/multisystem-nomdebian
chemindeb="$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/debian"
find "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")" -maxdepth 1 -path "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/debian[0-9]" | while read line
do
echo "debian$(($(echo $line | sed "s@${chemindeb}@@g")+1))" >/tmp/multisystem/multisystem-nomdebian
done
#
osname="$(cat /tmp/multisystem/multisystem-nomdebian)"
osnamemodif="$(basename "${option2}")"
osicone="multisystem-musix"
osloopback=""
oskernel="linux /${osname}/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/live -iname "*vmlinuz*")) root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) live-media-path=/${osname} boot=live locale=${LANG} keyb=${XKBLAYOUT} quiet splash username=musixuser hostname=musix union=aufs"
osinitrd="initrd /${osname}/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/live -iname "*initrd*"))"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
#debian
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${osname}"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/live/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/."

#Webconverger
#http://download.webconverger.com/
elif [ "$(grep 'webconverger' /tmp/multisystem/multisystem-mountpoint-iso/isolinux/live.cfg 2>/dev/null)" ]; then
modiso="copycontent"
echo "debian1" >/tmp/multisystem/multisystem-nomdebian
chemindeb="$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/debian"
find "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")" -maxdepth 1 -path "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/debian[0-9]" | while read line
do
echo "debian$(($(echo $line | sed "s@${chemindeb}@@g")+1))" >/tmp/multisystem/multisystem-nomdebian
done
osname="$(cat /tmp/multisystem/multisystem-nomdebian)"
osnamemodif="$(basename "${option2}")"
osicone="multisystem-webconverger"
osloopback=""
search_kernel="$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/live -iname "*vmlinuz*"))"
search_initrd="$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/live -iname "*initrd*"))"
oskernel="linux /${osname}/${search_kernel} root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) live-media-path=/${osname}  boot=live config hostname=webconverger vga=771 video=vesa locale=$(echo "${LANG}" |  awk -F"_" '{print $1}') nomodeset splash quiet quickreboot"
osinitrd="initrd /${osname}/${search_initrd}"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
#debian
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${osname}"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/live/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/."

#kdenlive
#http://www.kdenlive.org/user-manual/downloading-and-installing-kdenlive/live-demonstration-dvd-or-usb-storage
#live-media-path=/zzzzzzzzzzzzzz
elif [ "$(grep 'sername=kdenlive' /tmp/multisystem/multisystem-mountpoint-iso/isolinux/live.cfg 2>/dev/null)" ]; then
modiso="copycontent"
#
echo "debian1" >/tmp/multisystem/multisystem-nomdebian
chemindeb="$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/debian"
find "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")" -maxdepth 1 -path "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/debian[0-9]" | while read line
do
echo "debian$(($(echo $line | sed "s@${chemindeb}@@g")+1))" >/tmp/multisystem/multisystem-nomdebian
done
#kdenlive
osname="$(cat /tmp/multisystem/multisystem-nomdebian)"
osnamemodif="Kdenlive"
osicone="multisystem-kdelive"
osloopback=""
oskernel="linux /${osname}/vmlinuz1 persistent username=kdenlive hostname=kdenlive.org union=aufs  root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) live-media-path=/${osname} boot=live union=aufs debian-installer/language=$(echo "${LANG}" |  awk -F"_" '{print $1}') debian-installer/locale=${LANG} kbd-chooser/method=${XKBLAYOUT}  console-setup/layoutcode=${XKBLAYOUT} console-setup/variantcode=${XKBVARIANT} console-setup/modelcode=${XKBMODEL}"
osinitrd="initrd /${osname}/initrd1.img"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
#debian
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${osname}"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/live/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/."

#Kuki Linux "jaunty" - Release i386 (20090827)
#kuki: http://www.kuki.me/downloads/
#http://pt.kuki.me/iso/Kuki_3.0_Pre_Release/
elif [ "$(grep 'Kuki Linux "jaunty"' /tmp/multisystem/multisystem-mountpoint-iso/.disk/info 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osnamemodif="Kuki"
osicone="multisystem-kuki"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/casper/vmlinuz locale=$(echo "${LANG}" | sed "s/\..*//") bootkbd=${XKBLAYOUT} console-setup/layoutcode=${XKBLAYOUT} console-setup/variantcode=${XKBVARIANT} file=/cdrom/preseed/custom.seed iso-scan/filename=/${osname} boot=casper noprompt quiet splash --"
osinitrd="initrd /boot/bootdistro/kuki/initrd.gz"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/bootdistro/kuki"
mkdir /tmp/multisystem/multisystem-modinitrd 2>/dev/null
cd /tmp/multisystem/multisystem-modinitrd
gzip -dc /tmp/multisystem/multisystem-mountpoint-iso/casper/initrd.gz | cpio -i
cp "${dossier}/divers/lupin-jaunty/05mountpoints_lupin" /tmp/multisystem/multisystem-modinitrd/scripts/casper-bottom/05mountpoints_lupin
cp "${dossier}/divers/lupin-jaunty/10custom_installation" /tmp/multisystem/multisystem-modinitrd/scripts/casper-bottom/10custom_installation
cp "${dossier}/divers/lupin-jaunty/10ntfs_3g" /tmp/multisystem/multisystem-modinitrd/scripts/casper-bottom/10ntfs_3g
cp "${dossier}/divers/lupin-jaunty/20iso_scan" /tmp/multisystem/multisystem-modinitrd/scripts/casper-premount/20iso_scan
cp "${dossier}/divers/lupin-jaunty/30custom_installation" /tmp/multisystem/multisystem-modinitrd/scripts/casper-premount/30custom_installation
cp "${dossier}/divers/lupin-jaunty/lupin-helpers" /tmp/multisystem/multisystem-modinitrd/scripts/lupin-helpers
find . | cpio -o -H newc | gzip -9 > "$(cat /tmp/multisystem/multisystem-mountpoint-usb)"/boot/bootdistro/kuki/initrd.gz
cd -
rm -R /tmp/multisystem/multisystem-modinitrd

#BackTrack (v4)
#http://www.backtrack-linux.org/downloads/
elif [ "$(grep 'zzZZzzStart BackTrack FrameBuffer' /tmp/multisystem/multisystem-mountpoint-iso/boot/grub/menu.lst 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osnamemodif="BackTrack"
osicone="multisystem-backtrack"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/boot/vmlinuz locale=$(echo "${LANG}" | sed "s/\..*//") bootkbd=${XKBLAYOUT} console-setup/layoutcode=${XKBLAYOUT} console-setup/variantcode=${XKBVARIANT} iso-scan/filename=/${osname} boot=casper nopersistent rw quiet"
osinitrd="initrd /boot/bootdistro/backtrack/initrd.gz"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/bootdistro/backtrack"
mkdir /tmp/multisystem/multisystem-modinitrd 2>/dev/null
cd /tmp/multisystem/multisystem-modinitrd
gzip -dc /tmp/multisystem/multisystem-mountpoint-iso/boot/initrd.gz | cpio -i
cp "${dossier}/divers/lupin-jaunty/05mountpoints_lupin" /tmp/multisystem/multisystem-modinitrd/scripts/casper-bottom/05mountpoints_lupin
cp "${dossier}/divers/lupin-jaunty/10custom_installation" /tmp/multisystem/multisystem-modinitrd/scripts/casper-bottom/10custom_installation
cp "${dossier}/divers/lupin-jaunty/10ntfs_3g" /tmp/multisystem/multisystem-modinitrd/scripts/casper-bottom/10ntfs_3g
cp "${dossier}/divers/lupin-jaunty/20iso_scan" /tmp/multisystem/multisystem-modinitrd/scripts/casper-premount/20iso_scan
cp "${dossier}/divers/lupin-jaunty/30custom_installation" /tmp/multisystem/multisystem-modinitrd/scripts/casper-premount/30custom_installation
cp "${dossier}/divers/lupin-jaunty/lupin-helpers" /tmp/multisystem/multisystem-modinitrd/scripts/lupin-helpers
find . | cpio -o -H newc | gzip -9 > "$(cat /tmp/multisystem/multisystem-mountpoint-usb)"/boot/bootdistro/backtrack/initrd.gz
cd -
rm -R /tmp/multisystem/multisystem-modinitrd

#BackTrack (v4)
#http://www.backtrack-linux.org/downloads/
#chexpand=256 load=cubez,nvidiadriver autoexec=xconf;startnvidia.sh;startx
elif [ "$(grep 'Start BackTrack FrameBuffer' /tmp/multisystem/multisystem-mountpoint-iso/boot/grub/menu.lst 2>/dev/null)" ]; then
modiso="copycontent"
if [ ! -d "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/casper" ]; then
osname="casper"
osnamemodif="BackTrack"
osicone="multisystem-backtrack"
osloopback=""
oskernel="linux /casper/vmlinuz ${ubuntu_lang} root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) rootfstype=vfat BOOT=casper boot=casper nopersistent rw quiet"
osinitrd="initrd /casper/initrd.gz"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
#casper
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/casper"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/boot/vmlinuz "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/casper/vmlinuz"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/boot/initrd.gz "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/casper/initrd.gz"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/casper/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/casper/."
else
zenity --error --text "$(eval_gettext "Erreur: LiveCD déjà présent.")"
fi

#BackTrack (v5)
#http://www.backtrack-linux.org/downloads/
elif [ "$(grep 'BackTrack Live CD' /tmp/multisystem/multisystem-mountpoint-iso/README.diskdefines 2>/dev/null)" ]; then
modiso="copycontent"
echo "backtrack1" >/tmp/multisystem/multisystem-nomdistro
chemindeb="$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/backtrack"
find "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")" -maxdepth 1 -path "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/backtrack[0-9]" | while read line
do
echo "backtrack$(($(echo $line | sed "s@${chemindeb}@@g")+1))" >/tmp/multisystem/multisystem-nomdistro
done
osname="$(cat /tmp/multisystem/multisystem-nomdistro)"
osicone="multisystem-backtrack"
#Menu 1
ligne1="menuentry \"BackTrack $(grep "#define ARCH " /tmp/multisystem/multisystem-mountpoint-iso/README.diskdefines | awk '{print $3 }') Text - Default Boot Text Mode\" {"
ligne2=""
ligne3="linux /${osname}/casper/vmlinuz ${ubuntu_lang} live-media-path=/${osname}/casper root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) rootfstype=vfat file=/cdrom/${osname}/preseed/custom.seed boot=casper text splash vga=791--"
ligne4="initrd /${osname}/casper/initrd.gz"
ligne5="}"
#Menu 2
ligne6="menuentry \"BackTrack $(grep "#define ARCH " /tmp/multisystem/multisystem-mountpoint-iso/README.diskdefines | awk '{print $3 }') Stealth - No Networking enabled\" {"
ligne7=""
ligne8="linux /${osname}/casper/vmlinuz ${ubuntu_lang} live-media-path=/${osname}/casper root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) rootfstype=vfat file=/cdrom/${osname}/preseed/custom.seed boot=casper text splash staticip vga=791--"
ligne9="initrd /${osname}/casper/initrds.gz"
ligne10="}"
#Menu 3
ligne11="menuentry \"BackTrack $(grep "#define ARCH " /tmp/multisystem/multisystem-mountpoint-iso/README.diskdefines | awk '{print $3 }') Forensics - No Drive or Swap Mount\" {"
ligne12=""
ligne13="linux /${osname}/casper/vmlinuz ${ubuntu_lang} live-media-path=/${osname}/casper root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) rootfstype=vfat file=/cdrom/${osname}/preseed/custom.seed boot=casper text splash vga=791--"
ligne14="initrd /${osname}/casper/initrdf.gz"
ligne15="}"
#Menu 4
ligne16="menuentry \"BackTrack $(grep "#define ARCH " /tmp/multisystem/multisystem-mountpoint-iso/README.diskdefines | awk '{print $3 }') noDRM - No DRM Drivers\" {"
ligne17=""
ligne18="linux /${osname}/casper/vmlinuz ${ubuntu_lang} live-media-path=/${osname}/casper root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) rootfstype=vfat file=/cdrom/${osname}/preseed/custom.seed boot=casper text splash nomodeset vga=791--"
ligne19="initrd /${osname}/casper/initrd.gz"
ligne20="}"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD4)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${osname}"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/."
#Désactiver 41apt_cdrom car si win7 installé dossier /sources coince...
#.../casper/initrd.gz
#.../casper/initrdf.gz
#.../casper/initrds.gz
rm -R /tmp/multisystem/multisystem-modinitrd 2>/dev/null
mkdir /tmp/multisystem/multisystem-modinitrd 2>/dev/null
cd /tmp/multisystem/multisystem-modinitrd
gzip -dc /tmp/multisystem/multisystem-mountpoint-iso/casper/initrd.gz | cpio -i
sed -i 's%/scripts/casper-bottom/41apt_cdrom%#/scripts/casper-bottom/41apt_cdrom%' /tmp/multisystem/multisystem-modinitrd/scripts/casper-bottom/ORDER
#echo Attente
#read
sudo rm "$(cat /tmp/multisystem/multisystem-mountpoint-usb)"/${osname}/casper/initrd.gz
find . | cpio -o -H newc | gzip -9 > "$(cat /tmp/multisystem/multisystem-mountpoint-usb)"/${osname}/casper/initrd.gz
cd -
rm -R /tmp/multisystem/multisystem-modinitrd
#
rm -R /tmp/multisystem/multisystem-modinitrd 2>/dev/null
mkdir /tmp/multisystem/multisystem-modinitrd 2>/dev/null
cd /tmp/multisystem/multisystem-modinitrd
gzip -dc /tmp/multisystem/multisystem-mountpoint-iso/casper/initrdf.gz | cpio -i
sed -i 's%/scripts/casper-bottom/41apt_cdrom%#/scripts/casper-bottom/41apt_cdrom%' /tmp/multisystem/multisystem-modinitrd/scripts/casper-bottom/ORDER
#echo Attente
#read
sudo rm "$(cat /tmp/multisystem/multisystem-mountpoint-usb)"/${osname}/casper/initrdf.gz
find . | cpio -o -H newc | gzip -9 > "$(cat /tmp/multisystem/multisystem-mountpoint-usb)"/${osname}/casper/initrdf.gz
cd -
rm -R /tmp/multisystem/multisystem-modinitrd
#
rm -R /tmp/multisystem/multisystem-modinitrd 2>/dev/null
mkdir /tmp/multisystem/multisystem-modinitrd 2>/dev/null
cd /tmp/multisystem/multisystem-modinitrd
gzip -dc /tmp/multisystem/multisystem-mountpoint-iso/casper/initrds.gz | cpio -i
sed -i 's%/scripts/casper-bottom/41apt_cdrom%#/scripts/casper-bottom/41apt_cdrom%' /tmp/multisystem/multisystem-modinitrd/scripts/casper-bottom/ORDER
#echo Attente
#read
sudo rm "$(cat /tmp/multisystem/multisystem-mountpoint-usb)"/${osname}/casper/initrds.gz
find . | cpio -o -H newc | gzip -9 > "$(cat /tmp/multisystem/multisystem-mountpoint-usb)"/${osname}/casper/initrds.gz
cd -
rm -R /tmp/multisystem/multisystem-modinitrd

#GnackTrack
#http://www.gnacktrack.co.uk/download.php
#http://manpages.ubuntu.com/manpages/lucid/man7/casper.7.html
elif [ "$(grep 'GnackTrack' /tmp/multisystem/multisystem-mountpoint-iso/isolinux/isolinux.cfg 2>/dev/null)" ]; then
modiso="copycontent"
echo "gnacktrack1" >/tmp/multisystem/multisystem-nomdistro
chemindeb="$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/gnacktrack"
find "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")" -maxdepth 1 -path "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/gnacktrack[0-9]" | while read line
do
echo "gnacktrack$(($(echo $line | sed "s@${chemindeb}@@g")+1))" >/tmp/multisystem/multisystem-nomdistro
done
osname="$(cat /tmp/multisystem/multisystem-nomdistro)"
osnamemodif="GnackTrack"
osicone="multisystem-backtrack"
osloopback=""
oskernel="linux /${osname}/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*vmlinuz*")) ${ubuntu_lang} live-media-path=/${osname}/casper root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) rootfstype=vfat file=/cdrom/${osname}/preseed/custom.seed boot=casper noprompt quiet splash --"
osinitrd="initrd /${osname}/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*initrd*"))"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${osname}"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/."

#Blackbuntu
#http://www.blackbuntu.com/download
elif [ "$(grep '^Blackbuntu' /tmp/multisystem/multisystem-mountpoint-iso/.disk/info 2>/dev/null)" ]; then
modiso="copycontent"
echo "blackbuntu1" >/tmp/multisystem/multisystem-nomdistro
chemindeb="$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/blackbuntu"
find "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")" -maxdepth 1 -path "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/blackbuntu[0-9]" | while read line
do
echo "blackbuntu$(($(echo $line | sed "s@${chemindeb}@@g")+1))" >/tmp/multisystem/multisystem-nomdistro
done
osname="$(cat /tmp/multisystem/multisystem-nomdistro)"
osnamemodif="Blackbuntu"
osicone="multisystem-blackbuntu"
osloopback=""
oskernel="linux /${osname}/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*vmlinuz*")) ${ubuntu_lang} live-media-path=/${osname}/casper root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) rootfstype=vfat file=/cdrom/${osname}/preseed/custom.seed boot=casper noprompt quiet splash --"
osinitrd="initrd /${osname}/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*initrd*"))"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${osname}"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/."

#Guadalinex v6
#http://www.guadalinex.org/donde-conseguirlo
elif [ "$(grep 'Guadalinex V6 "Buho"' /tmp/multisystem/multisystem-mountpoint-iso/.disk/info 2>/dev/null)" ]; then
modiso="copycontent"
if [ ! -d "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/casper" ]; then
osname="casper"
osnamemodif="Guadalinex"
osicone="multisystem-guadalinex"
osloopback=""
oskernel="linux /casper/vmlinuz locale=$(echo "${LANG}" | sed "s/\..*//") bootkbd=${XKBLAYOUT} console-setup/layoutcode=${XKBLAYOUT} console-setup/variantcode=${XKBVARIANT} root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) boot=casper quiet"
osinitrd="initrd /casper/initrd.gz"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
#casper
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/casper"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
cp /tmp/multisystem/multisystem-mountpoint-iso/preseed/custom.seed "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/casper/custom.seed"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/casper/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/casper/."
#Virer /conf/uuid.conf
rm -R /tmp/multisystem/multisystem-modinitrd 2>/dev/null
mkdir /tmp/multisystem/multisystem-modinitrd 2>/dev/null
cd /tmp/multisystem/multisystem-modinitrd
gzip -dc "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/casper/initrd.gz" | cpio -i
rm /tmp/multisystem/multisystem-modinitrd/conf/uuid.conf
find . | sudo cpio -o -H newc | gzip -9 | tee "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/casper/initrd.gz"
cd -
rm -R /tmp/multisystem/multisystem-modinitrd
else
zenity --error --text "$(eval_gettext "Erreur: LiveCD déjà présent.")"
fi

#klikit
#http://www.klikit-linux.com/download.html
elif [ "$(grep 'Start Klikit-Linux' /tmp/multisystem/multisystem-mountpoint-iso/boot/grub/menu.lst 2>/dev/null)" ]; then
modiso="copycontent"
if [ ! -d "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/casper" ]; then
osname="casper"
osnamemodif="Klikit-Linux"
osicone="multisystem-klikit"
osloopback=""
oskernel="linux /casper/vmlinuz locale=$(echo "${LANG}" | sed "s/\..*//") bootkbd=${XKBLAYOUT} console-setup/layoutcode=${XKBLAYOUT} console-setup/variantcode=${XKBVARIANT} root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) quiet"
osinitrd="initrd /casper/initrd.gz"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
#casper
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/casper"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
cp /tmp/multisystem/multisystem-mountpoint-iso/preseed/custom.seed "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/casper/custom.seed"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/casper/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/casper/."
else
zenity --error --text "$(eval_gettext "Erreur: LiveCD déjà présent.")"
fi

#Estrella Roja: http://www.estrellaroja.info/
#Distrowatch: http://distrowatch.com/table.php?distribution=estrellaroja
#mylinux estrellaroja
elif [ "$(grep 'Estrella Roja' /tmp/multisystem/multisystem-mountpoint-iso/boot/er.cfg 2>/dev/null)" ]; then
modiso="copycontent"
if [ ! -d "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/mylinux" ]; then
osname="mylinux"
osnamemodif="Estrella Roja"
osicone="multisystem-estrellaroja"
osloopback=""
oskernel="linux /boot/bootdistro/mylinux/vmlinuz ramdisk_size=6666 root=/dev/ram0 rw vga=791 splash=silent SELINUX_INIT=NO noresume quiet"
osinitrd="initrd /boot/bootdistro/mylinux/initrd"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
#mylinux
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/mylinux"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/bootdistro/mylinux"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/boot/initrd "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/bootdistro/mylinux/initrd"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/boot/vmlinuz "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/bootdistro/mylinux/vmlinuz"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/mylinux/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/mylinux/."
else
zenity --error --text "$(eval_gettext "Erreur: LiveCD déjà présent.")"
fi

#gNewSense i386 deltah
#http://www.gnewsense.org/Mirrors
elif [ "$(grep 'gNewSense i386 deltah' /tmp/multisystem/multisystem-mountpoint-iso/LIVECD_VERSION 2>/dev/null)" ]; then
modiso="copycontent"
if [ ! -d "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/casper" ]; then
osname="casper"
osnamemodif="gNewSense i386 deltah"
osicone="multisystem-gnewsense"
osloopback=""
oskernel="linux /casper/vmlinuz locale=$(echo "${LANG}" | sed "s/\..*//") bootkbd=${XKBLAYOUT} console-setup/layoutcode=${XKBLAYOUT} console-setup/variantcode=${XKBVARIANT} root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) boot=casper quiet splash"
osinitrd="initrd /casper/initrd.gz"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
#casper
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/casper"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/isolinux/initrd.gz "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/casper/initrd.gz"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/isolinux/vmlinuz "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/casper/vmlinuz"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/casper/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/casper/."
else
zenity --error --text "$(eval_gettext "Erreur: LiveCD déjà présent.")"
fi

#Dreamlinux >=v4 (ok mais passe pas dans qemu, ni dans VBox...)
#http://www.dreamlinux.com.br/download.html
elif [ "$(grep 'Start Dreamlinux' /tmp/multisystem/multisystem-mountpoint-iso/boot/isolinux/isolinux.cfg 2>/dev/null)" ]; then
modiso="copycontent"
if [ ! -d "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/distro" ]; then
osname="distro"
osnamemodif="Dreamlinux"
osicone="multisystem-dreamLinux"
osloopback=""
oskernel="linux /boot/bootdistro/distro/vmlinuz boot=distro vga=788 selinux=0 quiet"
osinitrd="initrd /boot/bootdistro/distro/initrd.gz"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/distro"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/bootdistro/distro"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/boot/vmlinuz "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/bootdistro/distro/vmlinuz"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/boot/initrd.gz "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/bootdistro/distro/initrd.gz"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/distro/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/distro/."
else
zenity --error --text "$(eval_gettext "Erreur: LiveCD déjà présent.")"
fi

#BG-Rescue Linux
#http://www.giannone.eu/rescue/
elif [ "$(grep 'BG-Rescue Linux' /tmp/multisystem/multisystem-mountpoint-iso/readme.txt 2>/dev/null)" ]; then
modiso="copycontent"
if [ ! -f "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/rescue.img" ]; then
osname="rescue.img"
osnamemodif="BG-Rescue Linux"
osicone="multisystem-rescue"
osloopback=""
oskernel="linux16 /boot/syslinux/memdisk"
osinitrd="initrd16 /rescue.img"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/rescue.img "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/rescue.img"
else
zenity --error --text "$(eval_gettext "Erreur: LiveCD déjà présent.")"
fi

#Trinity Rescue Kit
#http://trinityhome.org/trk/download.php
elif [ "$(grep 'Trinity Rescue Kit' /tmp/multisystem/multisystem-mountpoint-iso/isolinux.cfg 2>/dev/null)" ]; then
modiso="copycontent"
if [ ! -d "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/trk3" ]; then
osname="trk3"
osnamemodif="Trinity Rescue Kit"
osicone="multisystem-trinity"
osloopback=""
oskernel="linux /trk3/kernel.trk vollabel="$(cat /tmp/multisystem/multisystem-selection-label-usb)" ramdisk_size=65536 root=/dev/ram0 vga=788 splash=verbose pci=conf1 trkmenu"
osinitrd="initrd /trk3/initrd.trk"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
#trk3
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/trk3"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/trk3/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/trk3/."
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/kernel.trk "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/trk3/kernel.trk"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/initrd.trk "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/trk3/initrd.trk"
else
zenity --error --text "$(eval_gettext "Erreur: LiveCD déjà présent.")"
fi

#PLoP Linux/ploplinux
#http://www.plop.at/en/ploplinuxdl.html
#Nouvelle option de boot dispo ==> iso_filename
elif [ -f "/tmp/multisystem/multisystem-mountpoint-iso/ploplinux/ploplinux" ]; then
modiso="copycontent"
if [ ! -d "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/ploplinux" ]; then
osname="ploplinux"
osnamemodif="PLoP Linux"
osicone="multisystem-ploplinux"
osloopback=""
oskernel="linux /boot/bootdistro/ploplinux/kernel/bzImage vga=1 force_usb root=E638-D06F"
osinitrd="initrd /boot/bootdistro/ploplinux/kernel/initramfs.gz"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
#ploplinux
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/ploplinux"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/bootdistro/ploplinux"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/ploplinux/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/ploplinux/."
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/syslinux/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/bootdistro/ploplinux/."
else
zenity --error --text "$(eval_gettext "Erreur: LiveCD déjà présent.")"
fi

#Pardus
#http://www.pardus.org.tr/eng/download/
elif [ "$(grep 'label pardus' /tmp/multisystem/multisystem-mountpoint-iso/boot/isolinux/isolinux.cfg 2>/dev/null)" ]; then
pardusname="$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso -maxdepth 1 -name "pardus.img"))"
modiso="copysqfs"
if [ ! -f "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${pardusname}" ]; then
osname="${pardusname}"
osnamemodif="Pardus"
osicone="multisystem-pardus"
osloopback=""
oskernel="linux /boot/bootdistro/pardus/kernel livedisk splash=silent quiet"
osinitrd="initrd /boot/bootdistro/pardus/initrd"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
#Pardus
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/bootdistro/pardus"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/boot/kernel "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/bootdistro/pardus/kernel"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/${pardusname} "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${pardusname}"
mkdir /tmp/multisystem/multisystem-modinitrd 2>/dev/null
cd /tmp/multisystem/multisystem-modinitrd
gzip -dc /tmp/multisystem/multisystem-mountpoint-iso/boot/initrd | cpio -i
echo -e "root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb)\nliveroot=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb)" | tee /tmp/multisystem/multisystem-modinitrd/etc/initramfs.conf
#gedit /tmp/multisystem/multisystem-modinitrd/etc/initramfs.conf
#echo Attente
#read
find . | cpio -o -H newc | gzip -9 > "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/bootdistro/pardus/initrd"
cd -
rm -R /tmp/multisystem/multisystem-modinitrd
else
zenity --error --text "$(eval_gettext "Erreur: LiveCD déjà présent.")"
fi

#openSUSE
#http://software.opensuse.org/ http://download.opensuse.org/factory/iso/
#/media/SSD/opensuse/config.isoclient
elif [ "$(grep 'openSUSE' /tmp/multisystem/multisystem-mountpoint-iso/config.isoclient 2>/dev/null)" ]; then
modiso="copycontent"
echo "opensuse1" >/tmp/multisystem/multisystem-nomopensuse
chemindeb="$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/opensuse"
find "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")" -maxdepth 1 -path "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/opensuse[0-9]" | while read line
do
echo "opensuse$(($(echo $line | sed "s@${chemindeb}@@g")+1))" >/tmp/multisystem/multisystem-nomopensuse
done
osname="$(cat /tmp/multisystem/multisystem-nomopensuse)"
osnamemodif="$(basename "${option2}")"
osicone="multisystem-opensuse"
osloopback=""
#Detection 32 ou 64bits.
if [ -f "/tmp/multisystem/multisystem-mountpoint-iso/boot/i386/loader/linux" ]; then
oskernel="linux /${osname}/boot/i386/loader/linux livecd_config=/cdrom/${osname}/config.isoclient ramdisk_size=512000 ramdisk_blocksize=4096 splash=silent quiet preloadlog=/dev/null showopts"
osinitrd="initrd /${osname}/boot/i386/loader/initrd"
else
oskernel="linux /${osname}/boot/x86_64/loader/linux livecd_config=/cdrom/${osname}/config.isoclient ramdisk_size=512000 ramdisk_blocksize=4096 splash=silent quiet preloadlog=/dev/null showopts"
osinitrd="initrd /${osname}/boot/x86_64/loader/initrd"
fi
#livecd_config=/cdrom/opensuse/config.isoclient kiwidebug=1
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
#opensuse
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${osname}"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/."
#remplacer chemin dans config.isoclient
sed -i "s/openSUSE-/${osname}\/openSUSE-/" "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/config.isoclient"
#Modifier ramdisk
sudo ${dossier}/divers/opensuse.sh ${osname}

#openSUSE modifié gnome3
#L'utilisateur est tux et son mot de passe et celui de root est linux.
#http://www.korben.info/telecharger-gnome3.html
elif [ "$(grep 'GNOME_3' /tmp/multisystem/multisystem-mountpoint-iso/config.isoclient 2>/dev/null)" ]; then
modiso="copycontent"
echo "opensuse1" >/tmp/multisystem/multisystem-nomopensuse
chemindeb="$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/opensuse"
find "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")" -maxdepth 1 -path "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/opensuse[0-9]" | while read line
do
echo "opensuse$(($(echo $line | sed "s@${chemindeb}@@g")+1))" >/tmp/multisystem/multisystem-nomopensuse
done
osname="$(cat /tmp/multisystem/multisystem-nomopensuse)"
osnamemodif="$(basename "${option2}")"
osicone="multisystem-opensuse"
osloopback=""
#Detection 32 ou 64bits.
if [ -f "/tmp/multisystem/multisystem-mountpoint-iso/boot/i386/loader/linux" ]; then
oskernel="linux /${osname}/boot/i386/loader/linux livecd_config=/cdrom/${osname}/config.isoclient ramdisk_size=512000 ramdisk_blocksize=4096 splash=silent quiet preloadlog=/dev/null showopts"
osinitrd="initrd /${osname}/boot/i386/loader/initrd"
else
oskernel="linux /${osname}/boot/x86_64/loader/linux livecd_config=/cdrom/${osname}/config.isoclient ramdisk_size=512000 ramdisk_blocksize=4096 splash=silent quiet preloadlog=/dev/null showopts"
osinitrd="initrd /${osname}/boot/x86_64/loader/initrd"
fi
#livecd_config=/cdrom/opensuse/config.isoclient kiwidebug=1
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
#opensuse
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${osname}"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/."
#remplacer chemin dans config.isoclient
sed -i "s/GNOME_3/${osname}\/GNOME_3/" "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/config.isoclient"
#Modifier ramdisk
sudo ${dossier}/divers/opensuse.sh ${osname}

#openSUSE ==> Smeegol
#http://software.opensuse.org/ http://download.opensuse.org/factory/iso/
#/media/SSD/opensuse/config.isoclient
elif [ "$(grep 'Smeegol' /tmp/multisystem/multisystem-mountpoint-iso/config.isoclient 2>/dev/null)" ]; then
modiso="copycontent"
echo "opensuse1" >/tmp/multisystem/multisystem-nomopensuse
chemindeb="$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/opensuse"
find "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")" -maxdepth 1 -path "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/opensuse[0-9]" | while read line
do
echo "opensuse$(($(echo $line | sed "s@${chemindeb}@@g")+1))" >/tmp/multisystem/multisystem-nomopensuse
done
osname="$(cat /tmp/multisystem/multisystem-nomopensuse)"
osnamemodif="$(basename "${option2}")"
osicone="multisystem-opensuse"
osloopback=""
#Detection 32 ou 64bits.
if [ -f "/tmp/multisystem/multisystem-mountpoint-iso/boot/i386/loader/linux" ]; then
oskernel="linux /${osname}/boot/i386/loader/linux livecd_config=/cdrom/${osname}/config.isoclient ramdisk_size=512000 ramdisk_blocksize=4096 splash=silent quiet preloadlog=/dev/null showopts"
osinitrd="initrd /${osname}/boot/i386/loader/initrd"
else
oskernel="linux /${osname}/boot/x86_64/loader/linux livecd_config=/cdrom/${osname}/config.isoclient ramdisk_size=512000 ramdisk_blocksize=4096 splash=silent quiet preloadlog=/dev/null showopts"
osinitrd="initrd /${osname}/boot/x86_64/loader/initrd"
fi
#livecd_config=/cdrom/opensuse/config.isoclient kiwidebug=1
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
#opensuse
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${osname}"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/."
#remplacer chemin dans config.isoclient
sed -i "s/Smeegol/${osname}\/Smeegol/" "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/config.isoclient"
#Modifier ramdisk
sudo ${dossier}/divers/opensuse.sh ${osname}

#NetSecL The password for both admin and root user on the DVD is linux.
#http://software.opensuse.org/ http://download.opensuse.org/factory/iso/
#/media/SSD/opensuse/config.isoclient
elif [ "$(grep 'NetSecL' /tmp/multisystem/multisystem-mountpoint-iso/config.isoclient 2>/dev/null)" ]; then
modiso="copycontent"
echo "opensuse1" >/tmp/multisystem/multisystem-nomopensuse
chemindeb="$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/opensuse"
find "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")" -maxdepth 1 -path "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/opensuse[0-9]" | while read line
do
echo "opensuse$(($(echo $line | sed "s@${chemindeb}@@g")+1))" >/tmp/multisystem/multisystem-nomopensuse
done
osname="$(cat /tmp/multisystem/multisystem-nomopensuse)"
osnamemodif="NetSecL"
osicone="multisystem-netsecl"
osloopback=""
#Detection 32 ou 64bits.
if [ -f "/tmp/multisystem/multisystem-mountpoint-iso/boot/i386/loader/linux" ]; then
oskernel="linux /${osname}/boot/i386/loader/linux livecd_config=/cdrom/${osname}/config.isoclient ramdisk_size=512000 ramdisk_blocksize=4096 splash=silent quiet preloadlog=/dev/null showopts"
osinitrd="initrd /${osname}/boot/i386/loader/initrd"
else
oskernel="linux /${osname}/boot/x86_64/loader/linux livecd_config=/cdrom/${osname}/config.isoclient ramdisk_size=512000 ramdisk_blocksize=4096 splash=silent quiet preloadlog=/dev/null showopts"
osinitrd="initrd /${osname}/boot/x86_64/loader/initrd"
fi
#livecd_config=/cdrom/opensuse/config.isoclient kiwidebug=1
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
#opensuse
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${osname}"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/."
#remplacer chemin dans config.isoclient
sed -i "s/NetSecL/${osname}\/NetSecL/" "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/config.isoclient"
#Modifier ramdisk
sudo ${dossier}/divers/opensuse.sh ${osname}

#ChromiumOS
#http://chromeos.hexxeh.net/

#getchrome User password: user Root password: root (pas reussit)
#http://getchrome.eu/download.php
elif [ "$(grep 'Chrome_OS' /tmp/multisystem/multisystem-mountpoint-iso/config.isoclient 2>/dev/null)" ]; then
modiso="copycontent"
echo "chromeos1" >/tmp/multisystem/multisystem-nomchromeos
chemindeb="$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/chromeos"
find "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")" -maxdepth 1 -path "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/chromeos[0-9]" | while read line
do
echo "chromeos$(($(echo $line | sed "s@${chemindeb}@@g")+1))" >/tmp/multisystem/multisystem-nomchromeos
done
osname="$(cat /tmp/multisystem/multisystem-nomchromeos)"
osnamemodif="Chrome OS"
osicone="multisystem-chrome"
osloopback=""
oskernel="linux /${osname}/boot/i386/loader/linux livecd_config=/cdrom/${osname}/config.isoclient ramdisk_size=512000 ramdisk_blocksize=4096 splash=silent showopts"
osinitrd="initrd /${osname}/boot/i386/loader/initrd"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
#chromeos
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${osname}"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/."
#remplacer chemin dans config.isoclient
sed -i "s/Chrome_OS./${osname}\/Chrome_OS./" "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/config.isoclient"
#Modifier ramdisk
sudo ${dossier}/divers/opensuse.sh ${osname}

#Stresslinux login/pass ==> stress/stress
#http://www.stresslinux.org/sl/downloads
elif [ "$(grep 'stresslinux' /tmp/multisystem/multisystem-mountpoint-iso/config.isoclient 2>/dev/null)" ]; then
modiso="copycontent"
echo "stresslinux1" >/tmp/multisystem/multisystem-nomstresslinux
chemindeb="$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/stresslinux"
find "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")" -maxdepth 1 -path "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/stresslinux[0-9]" | while read line
do
echo "stresslinux$(($(echo $line | sed "s@${chemindeb}@@g")+1))" >/tmp/multisystem/multisystem-nomstresslinux
done
osname="$(cat /tmp/multisystem/multisystem-nomstresslinux)"
osnamemodif="$(basename "${option2}")"
osicone="multisystem-stresslinux"
osloopback=""
oskernel="linux /${osname}/boot/i386/loader/linux livecd_config=/cdrom/${osname}/config.isoclient ramdisk_size=512000 ramdisk_blocksize=4096 splash=silent showopts "
osinitrd="initrd /${osname}/boot/i386/loader/initrd"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
#stresslinux
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${osname}"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/."
#remplacer chemin dans config.isoclient
sed -i "s/stresslinux/${osname}\/stresslinux/" "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/config.isoclient"
#Modifier ramdisk
sudo ${dossier}/divers/opensuse.sh ${osname}

#Upstream l/p upstream/upstream root/toor 
##http://upstreamos.tk/
elif [ "$(grep 'Upstream_OS' /tmp/multisystem/multisystem-mountpoint-iso/config.isoclient 2>/dev/null)" ]; then
modiso="copycontent"
echo "upstream1" >/tmp/multisystem/multisystem-nomupstream
chemindeb="$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/upstream"
find "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")" -maxdepth 1 -path "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/upstream[0-9]" | while read line
do
echo "upstream$(($(echo $line | sed "s@${chemindeb}@@g")+1))" >/tmp/multisystem/multisystem-nomupstream
done
osname="$(cat /tmp/multisystem/multisystem-nomupstream)"
osnamemodif="$(basename "${option2}")"
osicone="multisystem-upstream"
osloopback=""
oskernel="linux /${osname}/boot/i386/loader/linux livecd_config=/cdrom/${osname}/config.isoclient ramdisk_size=512000 ramdisk_blocksize=4096 splash=silent showopts "
osinitrd="initrd /${osname}/boot/i386/loader/initrd"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
#Upstream_OS
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${osname}"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/."
#remplacer chemin dans config.isoclient
sed -i "s/Upstream_OS/${osname}\/Upstream_OS/" "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/config.isoclient"
#Modifier ramdisk
sudo ${dossier}/divers/opensuse.sh ${osname}

#KDE Partition Manager
#http://sourceforge.net/projects/partitionman/
elif [ "$(grep 'KDE_Partition_Manager' /tmp/multisystem/multisystem-mountpoint-iso/config.isoclient 2>/dev/null)" ]; then
modiso="copycontent"
echo "partitionman1" >/tmp/multisystem/multisystem-nompartitionman
chemindeb="$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/partitionman"
find "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")" -maxdepth 1 -path "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/partitionman[0-9]" | while read line
do
echo "partitionman$(($(echo $line | sed "s@${chemindeb}@@g")+1))" >/tmp/multisystem/multisystem-nompartitionman
done
osname="$(cat /tmp/multisystem/multisystem-nompartitionman)"
osnamemodif="$(basename "${option2}")"
osicone="multisystem-opensuse"
osloopback=""
oskernel="linux /${osname}/boot/i386/loader/linux livecd_config=/cdrom/${osname}/config.isoclient ramdisk_size=512000 ramdisk_blocksize=4096 splash=silent showopts "
osinitrd="initrd /${osname}/boot/i386/loader/initrd"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${osname}"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/."
#remplacer chemin dans config.isoclient
sed -i "s/KDE_Partition_Manager/${osname}\/KDE_Partition_Manager/" "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/config.isoclient"
#Modifier ramdisk
sudo ${dossier}/divers/opensuse.sh ${osname}

#passe pas ecran noir, retester ...
#Elephant OS
#http://elephant-os.com/
elif [ "$(grep 'Elephant' /tmp/multisystem/multisystem-mountpoint-iso/config.isoclient 2>/dev/null)" ]; then
modiso="copycontent"
echo "elephant1" >/tmp/multisystem/multisystem-nomelephant
chemindeb="$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/elephant"
find "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")" -maxdepth 1 -path "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/elephant[0-9]" | while read line
do
echo "elephant$(($(echo $line | sed "s@${chemindeb}@@g")+1))" >/tmp/multisystem/multisystem-nomelephant
done
osname="$(cat /tmp/multisystem/multisystem-nomelephant)"
osnamemodif="$(basename "${option2}")"
osicone="multisystem-elephant"
osloopback=""
oskernel="linux /${osname}/boot/linux livecd_config=/cdrom/${osname}/config.isoclient vga=0x314 splash=silent ramdisk_size=512000 ramdisk_blocksize=4096 cdinst=1 loader=grub showopts"
osinitrd="initrd /${osname}/boot/initrd"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
#Elephant
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${osname}"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/."
#remplacer chemin dans config.isoclient
sed -i "s/Elephant/${osname}\/Elephant/" "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/config.isoclient"
#Modifier ramdisk
sudo ${dossier}/divers/elephant-os.sh ${osname}

#d4e desktop4education
#http://d4e.at/downloads/
#Login: root
#Passwort: open23
elif [ "$(grep 'd4e' /tmp/multisystem/multisystem-mountpoint-iso/config.isoclient 2>/dev/null)" ]; then
modiso="copycontent"
echo "d4e1" >/tmp/multisystem/multisystem-nomd4e
chemindeb="$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/d4e"
find "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")" -maxdepth 1 -path "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/d4e[0-9]" | while read line
do
echo "d4e$(($(echo $line | sed "s@${chemindeb}@@g")+1))" >/tmp/multisystem/multisystem-nomd4e
done
osname="$(cat /tmp/multisystem/multisystem-nomd4e)"
osnamemodif="Desktop4Education"
osicone="multisystem-opensuse"
osloopback=""
oskernel="linux /${osname}/boot/i386/loader/linux livecd_config=/cdrom/${osname}/config.isoclient ramdisk_size=512000 ramdisk_blocksize=4096 splash=silent showopts"
osinitrd="initrd /${osname}/boot/i386/loader/initrd"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
#d4e
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${osname}"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/."
#remplacer chemin dans config.isoclient
sed -i "s/d4e/${osname}\/d4e/" "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/config.isoclient"
#Modifier ramdisk
sudo ${dossier}/divers/d4e.sh ${osname}

#susestudio SUSE Studio Team
#User 	Password
#root 	linux
#tux 	linux
#http://susestudio.com/a/TadMax/owncloud-in-a-box?a=download&f=iso
elif [ "$(grep 'theme=studio' /tmp/multisystem/multisystem-mountpoint-iso/boot/i386/loader/gfxboot.cfg 2>/dev/null)" ]; then
modiso="copycontent"
echo "opensuse1" >/tmp/multisystem/multisystem-nomopensuse
chemindeb="$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/opensuse"
find "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")" -maxdepth 1 -path "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/opensuse[0-9]" | while read line
do
echo "opensuse$(($(echo $line | sed "s@${chemindeb}@@g")+1))" >/tmp/multisystem/multisystem-nomopensuse
done
osname="$(cat /tmp/multisystem/multisystem-nomopensuse)"
osnamemodif="SUSE Studio Team"
osicone="multisystem-opensuse"
osloopback=""
#Detection 32 ou 64bits.
if [ -f "/tmp/multisystem/multisystem-mountpoint-iso/boot/i386/loader/linux" ]; then
oskernel="linux /${osname}/boot/i386/loader/linux livecd_config=/cdrom/${osname}/config.isoclient ramdisk_size=512000 ramdisk_blocksize=4096 splash=silent quiet preloadlog=/dev/null showopts lang=$(echo "${LANG}" | sed "s/\..*//")"
osinitrd="initrd /${osname}/boot/i386/loader/initrd"
else
oskernel="linux /${osname}/boot/x86_64/loader/linux livecd_config=/cdrom/${osname}/config.isoclient ramdisk_size=512000 ramdisk_blocksize=4096 splash=silent quiet preloadlog=/dev/null showopts lang=$(echo "${LANG}" | sed "s/\..*//")"
osinitrd="initrd /${osname}/boot/x86_64/loader/initrd"
fi
#livecd_config=/cdrom/opensuse/config.isoclient kiwidebug=1
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
#opensuse
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${osname}"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/."
#remplacer chemin dans config.isoclient
sed -i 's%/dev/ram1;%/dev/ram1;/'${osname}'/%' "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/config.isoclient"
#Modifier ramdisk
sudo ${dossier}/divers/susestudio.sh ${osname}

#openRescue
#https://github.com/cernoch/openRescue/wiki
#http://susestudio.com/a/8RMG1v/openrescue
elif [ "$(grep 'openRescue' /tmp/multisystem/multisystem-mountpoint-iso/config.isoclient 2>/dev/null)" ]; then
modiso="copycontent"
echo "opensuse1" >/tmp/multisystem/multisystem-nomopensuse
chemindeb="$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/opensuse"
find "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")" -maxdepth 1 -path "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/opensuse[0-9]" | while read line
do
echo "opensuse$(($(echo $line | sed "s@${chemindeb}@@g")+1))" >/tmp/multisystem/multisystem-nomopensuse
done
osname="$(cat /tmp/multisystem/multisystem-nomopensuse)"
osnamemodif="openRescue"
osicone="multisystem-opensuse"
osloopback=""
#Detection 32 ou 64bits.
if [ -f "/tmp/multisystem/multisystem-mountpoint-iso/boot/i386/loader/linux" ]; then
oskernel="linux /${osname}/boot/i386/loader/linux livecd_config=/cdrom/${osname}/config.isoclient ramdisk_size=512000 ramdisk_blocksize=4096 splash=silent quiet preloadlog=/dev/null showopts lang=$(echo "${LANG}" | sed "s/\..*//")"
osinitrd="initrd /${osname}/boot/i386/loader/initrd"
else
oskernel="linux /${osname}/boot/x86_64/loader/linux livecd_config=/cdrom/${osname}/config.isoclient ramdisk_size=512000 ramdisk_blocksize=4096 splash=silent quiet preloadlog=/dev/null showopts lang=$(echo "${LANG}" | sed "s/\..*//")"
osinitrd="initrd /${osname}/boot/x86_64/loader/initrd"
fi
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
#openrescue
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${osname}"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/."
#remplacer chemin dans config.isoclient
sed -i 's%/dev/ram1;%/dev/ram1;/'${osname}'/%' "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/config.isoclient"
#Modifier ramdisk
sudo ${dossier}/divers/openrescue.sh ${osname}

#Saline OS
#http://www.salineos.com/downloads.php
elif [ "$(grep -i 'Saline' /tmp/multisystem/multisystem-mountpoint-iso/isolinux/menu.cfg 2>/dev/null)" ]; then
modiso="copycontent"
echo "debian1" >/tmp/multisystem/multisystem-nomdebian
chemindeb="$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/debian"
find "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")" -maxdepth 1 -path "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/debian[0-9]" | while read line
do
echo "debian$(($(echo $line | sed "s@${chemindeb}@@g")+1))" >/tmp/multisystem/multisystem-nomdebian
done
osname="$(cat /tmp/multisystem/multisystem-nomdebian)"
osicone="multisystem-saline"
#Menu 1
ligne1="menuentry \"$(basename "${option2}") live\" {"
ligne2=""
ligne3="linux /${osname}/live/vmlinuz root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) live-media-path=/${osname}/live boot=live config quiet"
ligne4="initrd /${osname}/live/initrd.img"
ligne5="}"
#Menu 2
ligne6="menuentry \"$(basename "${option2}") livefailsafe\" {"
ligne7=""
ligne8="linux /${osname}/live/vmlinuz root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) live-media-path=/${osname}/live boot=live config noapic noapm nodma nomce nolapic nomodeset nosmp vga=normal"
ligne9="initrd /${osname}/live/initrd.img"
ligne10="}"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD2)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${osname}"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/."

#XBMC 10.0 et xbmcfreak 1000 login/pass xbmc/xbmc
#http://xbmc.org/download/
#http://xbmcfreak.binkey.nl/xbmcfreak-1000-maverick-v3.zip
elif [ "$(grep 'XBMCLive' /tmp/multisystem/multisystem-mountpoint-iso/install/preseed.cfg 2>/dev/null)" ]; then
modiso="copycontent"
echo "debian1" >/tmp/multisystem/multisystem-nomdebian
chemindeb="$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/debian"
find "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")" -maxdepth 1 -path "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/debian[0-9]" | while read line
do
echo "debian$(($(echo $line | sed "s@${chemindeb}@@g")+1))" >/tmp/multisystem/multisystem-nomdebian
done
osname="$(cat /tmp/multisystem/multisystem-nomdebian)"
osicone="multisystem-xbmc"
#Menu 1
ligne1="menuentry \"$(basename "${option2}") 800x600\" {"
ligne2="set quiet=1\nset gfxpayload="800x600""
ligne3="linux /${osname}/live/vmlinuz root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) live-media-path=/${osname}/live video=vesafb boot=live xbmc=autostart,nodiskmount splash quiet loglevel=0 quickreboot quickusbmodules notimezone noaccessibility noapparmor noaptcdrom noautologin noxautologin noconsolekeyboard nofastboot nognomepanel nohosts nokpersonalizer nolanguageselector nolocales nonetworking nopowermanagement noprogramcrashes nojockey nosudo noupdatenotifier nouser nopolkitconf noxautoconfig noxscreensaver nopreseed union=aufs"
ligne4="initrd /${osname}/live/initrd.img"
ligne5="}"
#Menu 2
ligne6="menuentry \"$(basename "${option2}") SAFE MODE\" {"
ligne7="set quiet=1\nset gfxpayload=text"
ligne8="linux /${osname}/live/vmlinuz root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) live-media-path=/${osname}/live boot=live xbmc=nodiskmount quiet loglevel=0 quickreboot quickusbmodules notimezone noaccessibility noapparmor noaptcdrom noautologin noxautologin noconsolekeyboard nofastboot nognomepanel nohosts nokpersonalizer nolanguageselector nolocales nonetworking nopowermanagement noprogramcrashes nojockey nosudo noupdatenotifier nouser nopolkitconf noxautoconfig noxscreensaver nopreseed union=aufs"
ligne9="initrd /${osname}/live/initrd.img"
ligne10="}"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD2)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${osname}"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/."

#XBMC
#http://xbmc.org/download/
elif [ -f "/tmp/multisystem/multisystem-mountpoint-iso/boot/xbmc.xpm.gz" ]; then
modiso="copycontent"
if [ ! -d "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/xbmc" ]; then
osname="xbmc"
osnamemodif="XBMC_Live-9.04.1 Media Center NVIDIA GPU"
osicone="multisystem-xbmc"
dater="$(date +%d-%m-%Y-%T-%N)"
tailleiso="$(($(du -sB 1 "${option2}" | awk '{print $1}')/1024/1024))Mio"
menuxbmc1="menuentry \"XBMCLive boottoram autogpu\" {\n\nlinux /xbmc/vmlinuz boottoram autogpu boot=usb root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) quiet splash\ninitrd /xbmc/initrd0.img\n}"
menuxbmc2="#MULTISYSTEM_MENU_DEBUT|${dater}|${osname}|${osicone}|${tailleiso}|\n$menuxbmc1\n#MULTISYSTEM_MENU_FIN|${dater}|${osname}|${osicone}|${tailleiso}|"
sed -i "s@^#MULTISYSTEM_STOP@$menuxbmc2\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
#xbmc
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/xbmc"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/vmlinuz "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/xbmc/vmlinuz"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/initrd0.img "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/xbmc/initrd0.img"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/restrictedDrivers.nvidia.img "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/restrictedDrivers.nvidia.img"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/restrictedDrivers.amd.img "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/restrictedDrivers.amd.img"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/rootfs.img "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/rootfs.img"
else
zenity --error --text "$(eval_gettext "Erreur: LiveCD déjà présent.")"
fi

#xbmc-live-9.11 (base debian/ubuntu)
#http://xbmc.org/download/
elif [ "$(grep 'Ubuntu GNU/Linux 9.10 "Karmic" - Build i386 LIVE/INSTALL Binary' /tmp/multisystem/multisystem-mountpoint-iso/.disk/info 2>/dev/null)" ]; then
modiso="copycontent"
echo "debian1" >/tmp/multisystem/multisystem-nomdebian
chemindeb="$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/debian"
find "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")" -maxdepth 1 -path "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/debian[0-9]" | while read line
do
echo "debian$(($(echo $line | sed "s@${chemindeb}@@g")+1))" >/tmp/multisystem/multisystem-nomdebian
done
osname="$(cat /tmp/multisystem/multisystem-nomdebian)"
osnamemodif="$(basename "${option2}")"
osicone="multisystem-xbmc"
osloopback=""
oskernel="linux /${osname}/live/vmlinuz root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) live-media-path=/${osname}/live boot=live union=aufs cdrom-detect/try-usb=true xbmc=autostart,tempfs,nodiskmount,setvolume splash quiet"
osinitrd="initrd /${osname}/live/initrd.img"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${osname}"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/."

#MyXBMC Passion
#http://passion-xbmc.org/downloads
elif [ "$(grep '^MyXBMC' /tmp/multisystem/multisystem-mountpoint-iso/.disk/info 2>/dev/null)" ]; then
modiso="copycontent"
echo "ubuntu1" >/tmp/multisystem/multisystem-nomdistro
chemindeb="$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/ubuntu"
find "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")" -maxdepth 1 -path "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/ubuntu[0-9]" | while read line
do
echo "ubuntu$(($(echo $line | sed "s@${chemindeb}@@g")+1))" >/tmp/multisystem/multisystem-nomdistro
done
osname="$(cat /tmp/multisystem/multisystem-nomdistro)"
osicone="multisystem-xbmc"
#Menu 1
ligne1="menuentry \"Tester le LiveCD MyXBMC\" {"
ligne2=""
ligne3="linux /${osname}/casper/vmlinuz live-media-path=/${osname}/casper root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) file=/cdrom/${osname}/preseed/custom.seed boot=casper quiet splash --"
ligne4="initrd /${osname}/casper/initrd.gz "
ligne5="}"
#Menu 2
ligne6="menuentry \"Installer MyXBMC sur votre disque dur\" {"
ligne7=""
ligne8="linux /${osname}/casper/vmlinuz live-media-path=/${osname}/casper root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) file=/cdrom/${osname}/preseed/custom.seed boot=casper only-ubiquity quiet splash --"
ligne9="initrd /${osname}/casper/initrd.gz"
ligne10="}"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD2)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${osname}"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/."

#Tuquito
#http://www.tuquito.org.ar/descargas.html
#http://manpages.ubuntu.com/manpages/lucid/man7/casper.7.html
elif [ "$(grep 'Tuquito' /tmp/multisystem/multisystem-mountpoint-iso/.disk/info 2>/dev/null)" ]; then
modiso="copycontent"
echo "tuquito1" >/tmp/multisystem/multisystem-nomdistro
chemindeb="$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/tuquito"
find "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")" -maxdepth 1 -path "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/tuquito[0-9]" | while read line
do
echo "tuquito$(($(echo $line | sed "s@${chemindeb}@@g")+1))" >/tmp/multisystem/multisystem-nomdistro
done
osname="$(cat /tmp/multisystem/multisystem-nomdistro)"
osnamemodif="Tuquito 4.0"
osicone="multisystem-tuquito"
osloopback=""
oskernel="linux /${osname}/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*vmlinuz*")) live-media-path=/${osname}/casper root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) file=/cdrom/${osname}/preseed/tuquito.seed locale=$(echo "${LANG}" | sed "s/\..*//") bootkbd=${XKBLAYOUT} console-setup/layoutcode=${XKBLAYOUT} console-setup/variantcode=${XKBVARIANT} boot=casper noprompt quiet splash --"
osinitrd="initrd /${osname}/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*initrd*"))"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${osname}"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/."

#IPCop Firewall pas réussit ...
#http://sourceforge.net/projects/ipcop/files/
#http://distrowatch.com/table.php?distribution=IPCop
elif [ "$(grep 'IPCopzzZZzz' /tmp/multisystem/multisystem-mountpoint-iso/README.txt 2>/dev/null)" ]; then
modiso="copycontent"
if [ ! -d "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/ipcop" ]; then
osname="ipcop"
osicone="multisystem-ipcop"
osloopback=""
oskernel="linux16 /boot/syslinux/memdisk"
osinitrd="initrd16 /${osname}/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/images -iname "*boot-*.img*"))"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
mkdir "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/ipcop"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/images/boot-*.img "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/."
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/ipcop-*.tgz "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/."
else
zenity --error --text "$(eval_gettext "Erreur: LiveCD déjà présent.")"
fi

#gag
#http://gag.sourceforge.net/pics.html
elif [ "$(grep 'GAG Version' /tmp/multisystem/multisystem-mountpoint-iso/version.txt 2>/dev/null)" ]; then
modiso="copycontent"
if [ ! -f "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/disk.dsk" ]; then
osname="disk.dsk"
osnamemodif="GAG"
osicone="multisystem-gag"
osloopback=""
oskernel="linux16 /boot/syslinux/memdisk"
osinitrd="initrd16 /disk.dsk"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/disk.dsk "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/disk.dsk"
else
zenity --error --text "$(eval_gettext "Erreur: LiveCD déjà présent.")"
fi

#LliureX 
#http://lliurex.net/home/descargas/
elif [ "$(grep -i '^LliureX' /tmp/multisystem/multisystem-mountpoint-iso/.disk/info 2>/dev/null)" ]; then
modiso="copycontent"
echo "ubuntu1" >/tmp/multisystem/multisystem-nomdistro
chemindeb="$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/ubuntu"
find "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")" -maxdepth 1 -path "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/ubuntu[0-9]" | while read line
do
echo "ubuntu$(($(echo $line | sed "s@${chemindeb}@@g")+1))" >/tmp/multisystem/multisystem-nomdistro
done
osname="$(cat /tmp/multisystem/multisystem-nomdistro)"
osnamemodif="$(basename "${option2}")"
osicone="multisystem-lliurex"
gen_champ="$(grep -m1 'file=.*\.seed' -o /tmp/multisystem/multisystem-mountpoint-iso/isolinux/*.cfg 2>/dev/null)"
oskernel="linux /${osname}/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*vmlinuz*")) live-media-path=/${osname}/casper root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) $(sed 's%/cdrom/preseed/%/cdrom/'${osname}'/preseed/%' <<<"${gen_champ}") ${ubuntu_lang} boot=casper showmounts ignore_uuid noprompt quiet splash --"
osinitrd="initrd /${osname}/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*initrd*"))"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${osname}"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/."

#PC/OS (manque lupin-casper)
#http://distro.ibiblio.org/pub/linux/distributions/pcos/
elif [ "$(grep 'define DISKNAME  PC/OS OpenWorkstation 10' /tmp/multisystem/multisystem-mountpoint-iso/README.diskdefines 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osnamemodif="PC-OS"
osicone="multisystem-pcos"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/casper/vmlinuz locale=$(echo "${LANG}" | sed "s/\..*//") bootkbd=${XKBLAYOUT} console-setup/layoutcode=${XKBLAYOUT} console-setup/variantcode=${XKBVARIANT} iso-scan/filename=/${osname} file=/cdrom/preseed/custom.seed boot=casper noprompt quiet splash --"
osinitrd="initrd /boot/bootdistro/PC-OS/initrd.gz"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
#Modifier ramdisk pour ajouter support option de boot ==> iso-scan/filename=/${osname}
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/bootdistro/PC-OS"
mkdir /tmp/multisystem/multisystem-modinitrd 2>/dev/null
cd /tmp/multisystem/multisystem-modinitrd
gzip -dc /tmp/multisystem/multisystem-mountpoint-iso/casper/initrd.gz | cpio -i
cp "${dossier}/divers/lupin-karmic/05mountpoints_lupin" /tmp/multisystem/multisystem-modinitrd/scripts/casper-bottom/05mountpoints_lupin
cp "${dossier}/divers/lupin-karmic/10custom_installation" /tmp/multisystem/multisystem-modinitrd/scripts/casper-bottom/10custom_installation
cp "${dossier}/divers/lupin-karmic/10ntfs_3g" /tmp/multisystem/multisystem-modinitrd/scripts/casper-bottom/10ntfs_3g
cp "${dossier}/divers/lupin-karmic/20iso_scan" /tmp/multisystem/multisystem-modinitrd/scripts/casper-premount/20iso_scan
cp "${dossier}/divers/lupin-karmic/30custom_installation" /tmp/multisystem/multisystem-modinitrd/scripts/casper-premount/30custom_installation
cp "${dossier}/divers/lupin-karmic/lupin-helpers" /tmp/multisystem/multisystem-modinitrd/scripts/lupin-helpers
find . | cpio -o -H newc | gzip -9 > "$(cat /tmp/multisystem/multisystem-mountpoint-usb)"/boot/bootdistro/PC-OS/initrd.gz
cd -
rm -R /tmp/multisystem/multisystem-modinitrd

#Skolelinux http://www.skolelinux.org i386/amd64 (ok sur v5)
#http://www.slx.no/en/downloads
elif [ "$(grep 'Skolelinux' /tmp/multisystem/multisystem-mountpoint-iso/dists/*/local/binary-i386/Release 2>/dev/null)" ]; then
modiso="copycontent"
#relever Codename
CODENAME="$(awk '{print $4}' /tmp/multisystem/multisystem-mountpoint-iso/.disk/info | sed 's/\"//g' | tr '[:upper:]' '[:lower:]')"
#relever Version
VUBSERV="$(grep 'Codename: ' /tmp/multisystem/multisystem-mountpoint-iso/dists/${CODENAME}/Release | awk '{print $2}')"
DOSSIERINSTALL="skolelinux_inst_${CODENAME}"
if [[ ! "${CODENAME}" || ! "${VUBSERV}" ]]; then
zenity --error --text "CODENAME:$CODENAME\nARCHITECTURE:$ARCHITECTURE\nVUBSERV:$VUBSERV"
FCT_RELOAD
exit 0
fi
if [ ! -d "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${DOSSIERINSTALL}" ]; then
#Créer
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${DOSSIERINSTALL}/i386/gtk/"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${DOSSIERINSTALL}/amd64/gtk"
#i386
cd "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${DOSSIERINSTALL}/i386"
hd_media="ftp.debian.org/debian/dists/${VUBSERV}/main/installer-i386/current/images/hd-media/initrd.gz"
wget -nd ${hd_media} 2>&1 \
| sed -u 's/\([ 0-9]\+K\)[ \.]*\([0-9]\+%\) \(.*\)/\2\n#Transfert : \1 (\2) à \3/' \
| zenity --progress --auto-close --width 400 --title "$(eval_gettext 'Téléchargement en cours...')"
cd -
#i386/gtk
cd "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${DOSSIERINSTALL}/i386/gtk"
hd_media="ftp.debian.org/debian/dists/${VUBSERV}/main/installer-i386/current/images/hd-media/gtk/initrd.gz"
wget -nd ${hd_media} 2>&1 \
| sed -u 's/\([ 0-9]\+K\)[ \.]*\([0-9]\+%\) \(.*\)/\2\n#Transfert : \1 (\2) à \3/' \
| zenity --progress --auto-close --width 400 --title "$(eval_gettext 'Téléchargement en cours...')"
cd -
#amd64
cd "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${DOSSIERINSTALL}/amd64"
hd_media="ftp.debian.org/debian/dists/${VUBSERV}/main/installer-amd64/current/images/hd-media/initrd.gz"
wget -nd ${hd_media} 2>&1 \
| sed -u 's/\([ 0-9]\+K\)[ \.]*\([0-9]\+%\) \(.*\)/\2\n#Transfert : \1 (\2) à \3/' \
| zenity --progress --auto-close --width 400 --title "$(eval_gettext 'Téléchargement en cours...')"
cd -
#amd64/gtk
cd "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${DOSSIERINSTALL}/amd64/gtk"
hd_media="ftp.debian.org/debian/dists/${VUBSERV}/main/installer-amd64/current/images/hd-media/gtk/initrd.gz"
wget -nd ${hd_media} 2>&1 \
| sed -u 's/\([ 0-9]\+K\)[ \.]*\([0-9]\+%\) \(.*\)/\2\n#Transfert : \1 (\2) à \3/' \
| zenity --progress --auto-close --width 400 --title "$(eval_gettext 'Téléchargement en cours...')"
cd -
#si echoue exit!
if [ "$(du -h "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${DOSSIERINSTALL}/i386/initrd.gz" | awk '{print $1}')" == "0" ]; then
zenity --error --text "$(eval_gettext 'Erreur de téléchargement')"
rm -R "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${DOSSIERINSTALL}"
FCT_RELOAD
exit 0
fi
#si echoue exit!
if [ "$(du -h "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${DOSSIERINSTALL}/i386/gtk/initrd.gz" | awk '{print $1}')" == "0" ]; then
zenity --error --text "$(eval_gettext 'Erreur de téléchargement')"
rm -R "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${DOSSIERINSTALL}"
FCT_RELOAD
exit 0
fi
#si echoue exit!
if [ "$(du -h "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${DOSSIERINSTALL}/amd64/initrd.gz" | awk '{print $1}')" == "0" ]; then
zenity --error --text "$(eval_gettext 'Erreur de téléchargement')"
rm -R "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${DOSSIERINSTALL}"
FCT_RELOAD
exit 0
fi
#si echoue exit!
if [ "$(du -h "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${DOSSIERINSTALL}/amd64/gtk/initrd.gz" | awk '{print $1}')" == "0" ]; then
zenity --error --text "$(eval_gettext 'Erreur de téléchargement')"
rm -R "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${DOSSIERINSTALL}"
FCT_RELOAD
exit 0
fi
osname="${DOSSIERINSTALL}"
osicone="multisystem-skolelinux"
#auto=true priority=critical
#Menu i386
ligne1="menuentry \"Skolelinux install ${CODENAME} i386\" {"
ligne2="loopback loop \"/${DOSSIERINSTALL}/$(basename "${option2}")\""
ligne3="linux (loop)/install.386/vmlinuz quiet desktop=kde vga=784 -- quiet"
ligne4="initrd /${DOSSIERINSTALL}/i386/initrd.gz"
ligne5="}"
#Menu i386/gtk
ligne6="menuentry \"Skolelinux install ${CODENAME} i386/gtk\" {"
ligne7="loopback loop \"/${DOSSIERINSTALL}/$(basename "${option2}")\""
ligne8="linux (loop)/install.386/vmlinuz quiet  desktop=kde video=vesa:ywrap,mtrr vga=784 -- quiet"
ligne9="initrd /${DOSSIERINSTALL}/i386/gtk/initrd.gz"
ligne10="}"
#Menu amd64
ligne11="menuentry \"Skolelinux install ${CODENAME} amd64\" {"
ligne12="loopback loop \"/${DOSSIERINSTALL}/$(basename "${option2}")\""
ligne13="linux (loop)/install.amd/vmlinuz quiet desktop=kde vga=784 -- quiet"
ligne14="initrd /${DOSSIERINSTALL}/amd64/initrd.gz"
ligne15="}"
#Menu amd64/gtk
ligne16="menuentry \"Skolelinux install ${CODENAME} amd64/gtk\" {"
ligne17="loopback loop \"/${DOSSIERINSTALL}/$(basename "${option2}")\""
ligne18="linux (loop)/install.amd/vmlinuz quiet  desktop=kde video=vesa:ywrap,mtrr vga=784 -- quiet"
ligne19="initrd /${DOSSIERINSTALL}/amd64/gtk/initrd.gz"
ligne20="}"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD4)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
#Modifier initrd pour que monte la bonne iso!
#i386
rm -R /tmp/multisystem/multisystem-modinitrd 2>/dev/null
mkdir /tmp/multisystem/multisystem-modinitrd 2>/dev/null
cd /tmp/multisystem/multisystem-modinitrd
gzip -dc "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${DOSSIERINSTALL}/i386/initrd.gz" | cpio -i
sed -i "s@iso_to_try=\$1@iso_to_try=/hd-media/${DOSSIERINSTALL}/$( basename "${option2}" )@" /tmp/multisystem/multisystem-modinitrd/var/lib/dpkg/info/iso-scan.postinst
#gedit /tmp/multisystem/multisystem-modinitrd/var/lib/dpkg/info/iso-scan.postinst
find . | cpio -o -H newc | gzip -9 > "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${DOSSIERINSTALL}/i386/initrd.gz"
cd -
rm -R /tmp/multisystem/multisystem-modinitrd
#i386/gtk
rm -R /tmp/multisystem/multisystem-modinitrd 2>/dev/null
mkdir /tmp/multisystem/multisystem-modinitrd 2>/dev/null
cd /tmp/multisystem/multisystem-modinitrd
gzip -dc "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${DOSSIERINSTALL}/i386/gtk/initrd.gz" | cpio -i
sed -i "s@iso_to_try=\$1@iso_to_try=/hd-media/${DOSSIERINSTALL}/$( basename "${option2}" )@" /tmp/multisystem/multisystem-modinitrd/var/lib/dpkg/info/iso-scan.postinst
#gedit /tmp/multisystem/multisystem-modinitrd/var/lib/dpkg/info/iso-scan.postinst
find . | cpio -o -H newc | gzip -9 > "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${DOSSIERINSTALL}/i386/gtk/initrd.gz"
cd -
rm -R /tmp/multisystem/multisystem-modinitrd
#amd64
rm -R /tmp/multisystem/multisystem-modinitrd 2>/dev/null
mkdir /tmp/multisystem/multisystem-modinitrd 2>/dev/null
cd /tmp/multisystem/multisystem-modinitrd
gzip -dc "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${DOSSIERINSTALL}/amd64/initrd.gz" | cpio -i
sed -i "s@iso_to_try=\$1@iso_to_try=/hd-media/${DOSSIERINSTALL}/$( basename "${option2}" )@" /tmp/multisystem/multisystem-modinitrd/var/lib/dpkg/info/iso-scan.postinst
#gedit /tmp/multisystem/multisystem-modinitrd/var/lib/dpkg/info/iso-scan.postinst
find . | cpio -o -H newc | gzip -9 > "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${DOSSIERINSTALL}/amd64/initrd.gz"
cd -
rm -R /tmp/multisystem/multisystem-modinitrd
#amd64/gtk
rm -R /tmp/multisystem/multisystem-modinitrd 2>/dev/null
mkdir /tmp/multisystem/multisystem-modinitrd 2>/dev/null
cd /tmp/multisystem/multisystem-modinitrd
gzip -dc "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${DOSSIERINSTALL}/amd64/gtk/initrd.gz" | cpio -i
sed -i "s@iso_to_try=\$1@iso_to_try=/hd-media/${DOSSIERINSTALL}/$( basename "${option2}" )@" /tmp/multisystem/multisystem-modinitrd/var/lib/dpkg/info/iso-scan.postinst
#gedit /tmp/multisystem/multisystem-modinitrd/var/lib/dpkg/info/iso-scan.postinst
find . | cpio -o -H newc | gzip -9 > "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${DOSSIERINSTALL}/amd64/gtk/initrd.gz"
cd -
rm -R /tmp/multisystem/multisystem-modinitrd
#Copie iso
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress "${option2}" "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${DOSSIERINSTALL}/$(basename "${option2}")"
else
zenity --error --text "$(eval_gettext "Erreur: LiveCD déjà présent.")"
fi

#AV Linux New version >= 5.0
#http://www.bandshed.net/DownloadInstall.html
elif [ "$(grep 'AV Linux' /tmp/multisystem/multisystem-mountpoint-iso//isolinux/menu.cfg 2>/dev/null)" ]; then
modiso="copycontent"
echo "debian1" >/tmp/multisystem/multisystem-nomdebian
chemindeb="$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/debian"
find "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")" -maxdepth 1 -path "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/debian[0-9]" | while read line
do
echo "debian$(($(echo $line | sed "s@${chemindeb}@@g")+1))" >/tmp/multisystem/multisystem-nomdebian
done
osname="$(cat /tmp/multisystem/multisystem-nomdebian)"
osnamemodif="AV Linux"
osicone="multisystem-avlinux"
#Menu 1
ligne1="menuentry \"AV Linux Live\" {"
ligne2="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
ligne3="linux /${osname}/live/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/live -iname "*vmlinuz*")) quickreboot root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) live-media-path=/${osname}/live debian-installer/language=$(echo "${LANG}" |  awk -F"_" '{print $1}') debian-installer/locale=${LANG} kbd-chooser/method=${XKBLAYOUT}  console-setup/layoutcode=${XKBLAYOUT} console-setup/variantcode=${XKBVARIANT} console-setup/modelcode=${XKBMODEL} boot=live config threadirqs quiet splash"
ligne4="initrd /${osname}/live/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/live -iname "*initrd*"))"
ligne5="}"
#Menu 2
ligne6="menuentry \"AV Linux Live (failsafe)\" {"
ligne7="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
ligne8="linux /${osname}/live/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/live -iname "*vmlinuz*")) quickreboot root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) live-media-path=/${osname}/live debian-installer/language=$(echo "${LANG}" |  awk -F"_" '{print $1}') debian-installer/locale=${LANG} kbd-chooser/method=${XKBLAYOUT}  console-setup/layoutcode=${XKBLAYOUT} console-setup/variantcode=${XKBVARIANT} console-setup/modelcode=${XKBMODEL} boot=live config threadirqs noapic noapm nodma nomce nolapic nomodeset radeon.modeset=0 nouveau.modeset=0 nosmp vga=normal"
ligne9="initrd /${osname}/live/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/live -iname "*initrd*"))"
ligne10="}"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD2)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${osname}"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/."

#AV Linux
#http://www.bandshed.net/DownloadInstall.html
elif [ "$(grep 'AV Linux' /tmp/multisystem/multisystem-mountpoint-iso/isolinux/isolinux.txt 2>/dev/null)" ]; then
modiso="copycontent"
echo "debian1" >/tmp/multisystem/multisystem-nomdebian
chemindeb="$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/debian"
find "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")" -maxdepth 1 -path "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/debian[0-9]" | while read line
do
echo "debian$(($(echo $line | sed "s@${chemindeb}@@g")+1))" >/tmp/multisystem/multisystem-nomdebian
done
osname="$(cat /tmp/multisystem/multisystem-nomdebian)"
osnamemodif="AV Linux"
osicone="multisystem-avlinux"
#Menu 1
ligne1="menuentry \"AV Linux\" {"
ligne2="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
ligne3="linux /${osname}/live/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/live -iname "*vmlinuz*")) quickreboot root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) live-media-path=/${osname}/live boot=live union=aufs debian-installer/language=$(echo "${LANG}" |  awk -F"_" '{print $1}') debian-installer/locale=${LANG} kbd-chooser/method=${XKBLAYOUT}  console-setup/layoutcode=${XKBLAYOUT} console-setup/variantcode=${XKBVARIANT} console-setup/modelcode=${XKBMODEL} file=/cdrom/${osname}/preseed/custom.seed"
ligne4="initrd /${osname}/live/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/live -iname "*initrd*"))"
ligne5="}"
#Menu 2
ligne6="menuentry \"AV Linux xforcevesa\" {"
ligne7="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
ligne8="linux /${osname}/live/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/live -iname "*vmlinuz*")) quickreboot root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) xforcevesa live-media-path=/${osname}/live boot=live union=aufs debian-installer/language=$(echo "${LANG}" |  awk -F"_" '{print $1}') debian-installer/locale=${LANG} kbd-chooser/method=${XKBLAYOUT}  console-setup/layoutcode=${XKBLAYOUT} console-setup/variantcode=${XKBVARIANT} console-setup/modelcode=${XKBMODEL} file=/cdrom/${osname}/preseed/custom.seed"
ligne9="initrd /${osname}/live/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/live -iname "*initrd*"))"
ligne10="}"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD2)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${osname}"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/."

#AV Linux 5.0.2
#http://www.bandshed.net/DownloadInstall.html
elif [ "$(grep 'AV_Linux' /tmp/multisystem/multisystem-mountpoint-iso/isolinux/menu.cfg 2>/dev/null)" ]; then
modiso="copycontent"
echo "debian1" >/tmp/multisystem/multisystem-nomdebian
chemindeb="$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/debian"
find "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")" -maxdepth 1 -path "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/debian[0-9]" | while read line
do
echo "debian$(($(echo $line | sed "s@${chemindeb}@@g")+1))" >/tmp/multisystem/multisystem-nomdebian
done
osname="$(cat /tmp/multisystem/multisystem-nomdebian)"
osnamemodif="AV Linux"
osicone="multisystem-avlinux"
#Menu 1
ligne1="menuentry \"AV Linux\" {"
ligne2="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
ligne3="linux /${osname}/live/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/live -iname "*vmlinuz*")) quickreboot root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) live-media-path=/${osname}/live boot=live union=aufs debian-installer/language=$(echo "${LANG}" |  awk -F"_" '{print $1}') debian-installer/locale=${LANG} kbd-chooser/method=${XKBLAYOUT}  console-setup/layoutcode=${XKBLAYOUT} console-setup/variantcode=${XKBVARIANT} console-setup/modelcode=${XKBMODEL} boot=live config   threadirqs transparent_hugepage=never quiet"
ligne4="initrd /${osname}/live/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/live -iname "*initrd*"))"
ligne5="}"
#Menu 2
ligne6="menuentry \"AV Linux failsafe\" {"
ligne7="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
ligne8="linux /${osname}/live/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/live -iname "*vmlinuz*")) quickreboot root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) xforcevesa live-media-path=/${osname}/live boot=live union=aufs debian-installer/language=$(echo "${LANG}" |  awk -F"_" '{print $1}') debian-installer/locale=${LANG} kbd-chooser/method=${XKBLAYOUT}  console-setup/layoutcode=${XKBLAYOUT} console-setup/variantcode=${XKBVARIANT} console-setup/modelcode=${XKBMODEL} boot=live config   threadirqs transparent_hugepage=never noapic noapm nodma nomce nolapic pci=nomsi nomodeset radeon.modeset=0 nouveau.modeset=0 nosmp vga=normal"
ligne9="initrd /${osname}/live/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/live -iname "*initrd*"))"
ligne10="}"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD2)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${osname}"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/."

#KDuXP: http://www.linuxkduxp.com/downloads/
#linuxmao: http://www.linuxmao.org/tikiwiki/tiki-index.php?page=tangostudio&highlight=livecd
elif [ "$(grep -E '(KDuXP)|(KDu-Small)' /tmp/multisystem/multisystem-mountpoint-iso/.disk/info 2>/dev/null)" ]; then
modiso="copycontent"
echo "kduxp1" >/tmp/multisystem/multisystem-nomdistro
chemindeb="$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/kduxp"
find "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")" -maxdepth 1 -path "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/kduxp[0-9]" | while read line
do
echo "kduxp$(($(echo $line | sed "s@${chemindeb}@@g")+1))" >/tmp/multisystem/multisystem-nomdistro
done
osname="$(cat /tmp/multisystem/multisystem-nomdistro)"
osnamemodif="KDuXP"
osicone="multisystem-kduxp"
osloopback=""
gen_champ="$(grep -m1 'file=.*\.seed' -o /tmp/multisystem/multisystem-mountpoint-iso/isolinux/isolinux.cfg)"
oskernel="linux /${osname}/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*vmlinuz*")) rw live-media-path=/${osname}/casper root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) ${gen_champ} ${ubuntu_lang} boot=casper noprompt quiet splash --"
osinitrd="initrd /${osname}/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*initrd*"))"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${osname}"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/."

#Tango Studio 1.1 "Karmasutra" - i386 (20101011)
#http://tangostudio.tuxfamily.org/en/tangostudio
elif [ "$(grep 'Tango Studio' /tmp/multisystem/multisystem-mountpoint-iso/.disk/info 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osnamemodif="Tango Studio"
osicone="multisystem-tangostudio"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*vmlinuz*")) root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) file=/cdrom/preseed/tangostudio.seed locale=$(echo "${LANG}" | sed "s/\..*//") bootkbd=${XKBLAYOUT} console-setup/layoutcode=${XKBLAYOUT} console-setup/variantcode=${XKBVARIANT} iso-scan/filename=/${osname} boot=casper noprompt quiet splash --"
osinitrd="initrd (loop)/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*initrd*"))"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#rescatux Login password is: live
#http://www.supergrubdisk.org/rescatux/
elif [ "$(grep -i rescatux <<<"$(basename "${option2}")")" ]; then
modiso="copycontent"
echo "rescatux1" >/tmp/multisystem/multisystem-nomdistro
chemindeb="$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/rescatux"
find "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")" -maxdepth 1 -path "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/rescatux[0-9]" | while read line
do
echo "rescatux$(($(echo $line | sed "s@${chemindeb}@@g")+1))" >/tmp/multisystem/multisystem-nomdistro
done
osname="$(cat /tmp/multisystem/multisystem-nomdistro)"
osicone="multisystem-debian"
osloopback=""
#Menu i386
ligne1="menuentry \"Rescatux i386\" {"
ligne2="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
ligne3="linux /${osname}/live/vmlinuz live-media-path=/${osname}/live boot=live config quiet"
ligne4="initrd /${osname}/live/initrd.img"
ligne5="}"
#Menu amd64
ligne6="menuentry \"Rescatux amd64\" {"
ligne7="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
ligne8="linux /${osname}/live/vmlinuz2 live-media-path=/${osname}/live boot=live config quiet"
ligne9="initrd /${osname}/live/initrd2.img"
ligne10="}"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD2)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${osname}"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/."

#MultiSystem 12.04 LTS "Precise Pangolin"
#MultiSystem iso fr/en boot toram http://liveusb.info/multisystem/iso_ms_ubuntu/
elif [ "$(grep '^MultiSystem 12.04 LTS' /tmp/multisystem/multisystem-mountpoint-iso/.disk/info 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osicone="multisystem-icon"
#Menu fr
ligne1="menuentry \"MultiSystem live French (toram)\" {"
ligne2="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
ligne3="linux (loop)/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*vmlinuz*")) toram root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) iso-scan/filename=/${osname} debian-installer/language=fr keyboard-configuration/layoutcode=fr keyboard-configuration/variantcode=oss ignore_uuid boot=casper noprompt quiet splash --"
ligne4="initrd (loop)/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*initrd*"))"
ligne5="}"
#Menu en
ligne6="menuentry \"MultiSystem live English (toram)\" {"
ligne7="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
ligne8="linux (loop)/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*vmlinuz*")) toram root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) iso-scan/filename=/${osname} debian-installer/language=en keyboard-configuration/layoutcode=us ignore_uuid boot=casper noprompt quiet splash --"
ligne9="initrd (loop)/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*initrd*"))"
ligne10="}"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD2)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#MultiSystem iso fr/en boot toram http://liveusb.info/multisystem/iso_ms_ubuntu/
elif [ "$(grep '^MultiSystem' /tmp/multisystem/multisystem-mountpoint-iso/.disk/info 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osicone="multisystem-icon"
#Menu fr
ligne1="menuentry \"MultiSystem live French (toram)\" {"
ligne2="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
ligne3="linux (loop)/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*vmlinuz*")) toram root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) iso-scan/filename=/${osname} debian-installer/locale=fr_FR.UTF-8 debian-installer/language=fr kbd-chooser/method=fr console-setup/layoutcode=fr console-setup/variantcode=oss console-setup/modelcode=pc105 ignore_uuid boot=casper noprompt quiet splash --"
ligne4="initrd (loop)/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*initrd*"))"
ligne5="}"
#Menu en
ligne6="menuentry \"MultiSystem live English (toram)\" {"
ligne7="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
ligne8="linux (loop)/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*vmlinuz*")) toram root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) iso-scan/filename=/${osname} debian-installer/locale=en_US.UTF-8 debian-installer/language=us kbd-chooser/method=us console-setup/layoutcode=us console-setup/modelcode=pc105 ignore_uuid boot=casper noprompt quiet splash --"
ligne9="initrd (loop)/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*initrd*"))"
ligne10="}"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD2)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#Greenie Linux 8 ok vu comme Ubuntu 10.10 
#http://www.greenie.sk/stiahnutie.html

#Pcubuntoo (version >= lucid) ok vu comme Ubuntu
#http://www.pcubuntoo.fr/
#http://www.freetorrent.fr/details.php?id=af8d514fa90ad37a85412e1d693606bb4b1e4519

#Doudoulinux
#http://download.doudoulinux.org/
elif [ "$(grep -E '(DoudouLinux)' /tmp/multisystem/multisystem-mountpoint-iso/isolinux/live.cfg 2>/dev/null)" ]; then
modiso="copycontent"
echo "debian1" >/tmp/multisystem/multisystem-nomdebian
chemindeb="$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/debian"
find "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")" -maxdepth 1 -path "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/debian[0-9]" | while read line
do
echo "debian$(($(echo $line | sed "s@${chemindeb}@@g")+1))" >/tmp/multisystem/multisystem-nomdebian
done
osname="$(cat /tmp/multisystem/multisystem-nomdebian)"
osnamemodif="DoudouLinux"
osicone="multisystem-doudoulinux"
osloopback=""
oskernel="linux /${osname}/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/live -iname "*vmlinuz*")) quickreboot root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) live-media-path=/${osname} boot=live debian-installer/language=$(echo "${LANG}" |  awk -F"_" '{print $1}') debian-installer/locale=${LANG} kbd-chooser/method=${XKBLAYOUT}  console-setup/layoutcode=${XKBLAYOUT} console-setup/variantcode=${XKBVARIANT} console-setup/modelcode=${XKBMODEL} notimezone noxautologin quiet splash vga=785 username=tux hostname=doudoulinux union=aufs"
osinitrd="initrd /${osname}/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/live -iname "*initrd*"))"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${osname}"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/live/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/."

#Boot-Repair-Disk (YannUbuntu)
#http://doc.ubuntu-fr.org/boot-repair
elif [ "$(grep 'boot-repair' /tmp/multisystem/multisystem-mountpoint-iso/live/filesystem.manifest 2>/dev/null)" ]; then
modiso="copycontent"
echo "debian1" >/tmp/multisystem/multisystem-nomdebian
chemindeb="$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/debian"
find "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")" -maxdepth 1 -path "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/debian[0-9]" | while read line
do
echo "debian$(($(echo $line | sed "s@${chemindeb}@@g")+1))" >/tmp/multisystem/multisystem-nomdebian
done
osname="$(cat /tmp/multisystem/multisystem-nomdebian)"
osicone="multisystem-boot-repair-disk"
#Menu 1
ligne1="menuentry \"Boot-Repair-Disk 32bits session\" {"
ligne2=""
ligne3="linux /${osname}/live/vmlinuz live-media-path=/${osname}/live  boot=live config quiet"
ligne4="initrd /${osname}/live/initrd.img"
ligne5="}"
#Menu 2
ligne6="menuentry \"Boot-Repair-Disk 64bits session\" {"
ligne7=""
ligne8="linux /${osname}/live/vmlinuz2 live-media-path=/${osname}/live boot=live config quiet"
ligne9="initrd /${osname}/live/initrd2.img"
ligne10="}"
#Menu 3
ligne11="menuentry \"Boot-Repair-Disk 32bits session (failsafe)\" {"
ligne12=""
ligne13="linux /${osname}/live/vmlinuz live-media-path=/${osname}/live boot=live config noapic noapm nodma nomce nolapic nomodeset nosmp vga=normal"
ligne14="initrd /${osname}/live/initrd.img"
ligne15="}"
#Menu 4
ligne16="menuentry \"Boot-Repair-Disk 64bits session (failsafe)\" {"
ligne17=""
ligne18="linux /${osname}/live/vmlinuz2 live-media-path=/${osname}/live boot=live config noapic noapm nodma nomce nolapic nomodeset nosmp vga=normal"
ligne19="initrd /${osname}/live/initrd2.img"
ligne20="}"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD4)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${osname}"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/."

#JonDo Live-CD
#http://www.anonym-surfen.de/jondo-live-cd.html
elif [ "$(grep 'username=jondo' /tmp/multisystem/multisystem-mountpoint-iso/isolinux/live.cfg 2>/dev/null)" ]; then
modiso="copycontent"
echo "debian1" >/tmp/multisystem/multisystem-nomdebian
chemindeb="$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/debian"
find "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")" -maxdepth 1 -path "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/debian[0-9]" | while read line
do
echo "debian$(($(echo $line | sed "s@${chemindeb}@@g")+1))" >/tmp/multisystem/multisystem-nomdebian
done
osname="$(cat /tmp/multisystem/multisystem-nomdebian)"
osicone="multisystem-jondo"
#Menu 1
ligne1="menuentry \"JonDo Live\" {"
ligne2=""
ligne3="linux /${osname}/live/vmlinuz live-media-path=/${osname}/live boot=live config  username=jondo  quiet"
ligne4="initrd /${osname}/live/initrd.img"
ligne5="}"
#Menu 2
ligne6="menuentry \"JonDo Live (failsafe)\" {"
ligne7=""
ligne8="linux /${osname}/live/vmlinuz live-media-path=/${osname}/live boot=live config username=jondo  noapic noapm nodma nomce nolapic nomodeset nosmp vga=normal"
ligne9="initrd /${osname}/live/initrd.img"
ligne10="}"
#Menu 3
ligne11="menuentry \"JonDo Live 686\" {"
ligne12=""
ligne13="linux /${osname}/live/vmlinuz2 live-media-path=/${osname}/live boot=live config username=jondo  quiet"
ligne14="initrd /${osname}/live/initrd2.img"
ligne15="}"
#Menu 4
ligne16="menuentry \"JonDo Live 686 (failsafe)\" {"
ligne17=""
ligne18="linux /${osname}/live/vmlinuz2 live-media-path=/${osname}/live boot=live config username=jondo  noapic noapm nodma nomce nolapic nomodeset nosmp vga=normal"
ligne19="initrd /${osname}/live/initrd2.img"
ligne20="}"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD4)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${osname}"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/."

#Ubuntu Secured Remix (YannUbuntu)
#http://doc.ubuntu-fr.org/ubuntu_secured_remix
elif [ "$(grep 'cleanubiquitybefore' /tmp/multisystem/multisystem-mountpoint-iso/preseed/ubuntu.seed 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osicone="multisystem-ubuntu_secured_remix"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/casper/vmlinuz root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) ${ubuntu_lang} iso-scan/filename=/${osname} boot=casper file=/cdrom/preseed/ubuntu.seed noprompt quiet splash --"
osinitrd="initrd (loop)/casper/initrd.lz"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#ZevenOS Maverick Meerkat
#http://www.zevenos.com/download
elif [ "$(grep 'ZevenOS.*"Maverick Meerkat"' /tmp/multisystem/multisystem-mountpoint-iso/.disk/info 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osicone="multisystem-zevenos"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/casper/vmlinuz root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) ${ubuntu_lang} iso-scan/filename=/${osname} boot=casper file=/cdrom/preseed/zevenos.seed noprompt quiet splash --"
osinitrd="initrd (loop)/casper/initrd.lz"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#ZEVENOS-Neptune (Debian based)
#http://www.zevenos.com/download
elif [ "$(grep 'MENU LABEL Neptune Live' /tmp/multisystem/multisystem-mountpoint-iso/isolinux/live.cfg 2>/dev/null)" ]; then
modiso="copycontent"
echo "debian1" >/tmp/multisystem/multisystem-nomdebian
chemindeb="$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/debian"
find "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")" -maxdepth 1 -path "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/debian[0-9]" | while read line
do
echo "debian$(($(echo $line | sed "s@${chemindeb}@@g")+1))" >/tmp/multisystem/multisystem-nomdebian
done
osname="$(cat /tmp/multisystem/multisystem-nomdebian)"
osicone="multisystem-zevenos"
#Menu 1
ligne1="menuentry \"Neptune Live\" {"
ligne2=""
ligne3="linux /${osname}/live/vmlinuz2 root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) live-media-path=/${osname}/live boot=live union=aufs locale=${LANG} keyb=${XKBLAYOUT} swapon splash noprompt quiet"
ligne4="initrd /${osname}/live/initrd2.img"
ligne5="}"
#Menu 2
ligne6="menuentry \"Neptune Live failsafe\" {"
ligne7=""
ligne8="linux /${osname}/live/vmlinuz2 root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) live-media-path=/${osname}/live boot=live union=aufs noapic noapm nodma nomce nolapic nosmp vga=normal locale=${LANG} keyb=${XKBLAYOUT}"
ligne9="initrd /${osname}/live/initrd2.img"
ligne10="}"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD2)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
mkdir "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${osname}"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/."

#siduction (Debian based)
#http://siduction.org/index.php?module=inhalt&func=view&pid=2
elif [ "$(grep 'siduction' /tmp/multisystem/multisystem-mountpoint-iso/boot/isolinux/isolinux.cfg 2>/dev/null)" ]; then
modiso="copycontent"
echo "debian1" >/tmp/multisystem/multisystem-nomdebian
chemindeb="$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/debian"
find "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")" -maxdepth 1 -path "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/debian[0-9]" | while read line
do
echo "debian$(($(echo $line | sed "s@${chemindeb}@@g")+1))" >/tmp/multisystem/multisystem-nomdebian
done
osname="$(cat /tmp/multisystem/multisystem-nomdebian)"
osicone="multisystem-siduction"
#Menu 1
ligne1="menuentry \"siduction\" {"
ligne2=""
ligne3="linux /${osname}/boot/vmlinuz0.686 root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) image_dir=/${osname}/siduction boot=fll lang=$(echo "${LANG}" | sed "s/\..*//")"
ligne4="initrd /${osname}/boot/initrd0.686"
ligne5="}"
#Menu 2
ligne6="menuentry \"siduction (Safe Graphics Settings)\" {"
ligne7=""
ligne8="linux /${osname}/boot/vmlinuz0.686 root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) image_dir=/${osname}/siduction boot=fll radeon.modeset=0 nouveau.modeset=0 i915.modeset=0 xmodule=vesa lang=$(echo "${LANG}" | sed "s/\..*//")"
ligne9="initrd /${osname}/boot/initrd0.686"
ligne10="}"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD2)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
mkdir "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${osname}"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/."

#ZevenOS 4.0
#http://www.zevenos.com/download
elif [ "$(grep '^ZevenOS 4' /tmp/multisystem/multisystem-mountpoint-iso/.disk/info 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osnamemodif="ZevenOS 4.0 "Oneiric Ocelot""
osicone="multisystem-zevenos"
gen_champ="$(grep -m1 'file=.*\.seed' -o /tmp/multisystem/multisystem-mountpoint-iso/isolinux/txt.cfg)"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*vmlinuz*")) root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) ${gen_champ} ${ubuntu_lang} iso-scan/filename=/${osname} boot=casper noprompt quiet splash --"
osinitrd="initrd (loop)/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*initrd*"))"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#Commodore OS
#http://www.commodoreusa.net/CUSA_OS_Vision_Download.aspx
elif [ "$(grep '^Commodore OS' /tmp/multisystem/multisystem-mountpoint-iso/.disk/info 2>/dev/null)" ]; then
modiso="copycontent"
echo "ubuntu1" >/tmp/multisystem/multisystem-nomdistro
chemindeb="$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/ubuntu"
find "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")" -maxdepth 1 -path "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/ubuntu[0-9]" | while read line
do
echo "ubuntu$(($(echo $line | sed "s@${chemindeb}@@g")+1))" >/tmp/multisystem/multisystem-nomdistro
done
osname="$(cat /tmp/multisystem/multisystem-nomdistro)"
osnamemodif="Commodore OS"
osicone="multisystem-commodore"
gen_champ="$(grep -m1 'file=.*\.seed' -o /tmp/multisystem/multisystem-mountpoint-iso/isolinux/*.cfg 2>/dev/null)"
oskernel="linux /${osname}/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*vmlinuz*")) live-media-path=/${osname}/casper root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) $(sed 's%/cdrom/preseed/%/cdrom/'${osname}'/preseed/%' <<<"${gen_champ}") ${ubuntu_lang} boot=casper showmounts ignore_uuid noprompt quiet splash --"
osinitrd="initrd /${osname}/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*initrd*"))"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${osname}"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/."

#Ultimate-Edition
#http://ultimateedition.info/
elif [ "$(grep 'UE.3.0' /tmp/multisystem/multisystem-mountpoint-iso/.disk/info 2>/dev/null)" ]; then
modiso="copycontent"
echo "ubuntu1" >/tmp/multisystem/multisystem-nomdistro
chemindeb="$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/ubuntu"
find "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")" -maxdepth 1 -path "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/ubuntu[0-9]" | while read line
do
echo "ubuntu$(($(echo $line | sed "s@${chemindeb}@@g")+1))" >/tmp/multisystem/multisystem-nomdistro
done
osname="$(cat /tmp/multisystem/multisystem-nomdistro)"
osnamemodif="$(basename "${option2}")"
osicone="multisystem-ultimate-edition"
gen_champ="$(grep -m1 'file=.*\.seed' -o /tmp/multisystem/multisystem-mountpoint-iso/isolinux/*.cfg 2>/dev/null)"
oskernel="linux /${osname}/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*vmlinuz*")) live-media-path=/${osname}/casper root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) $(sed 's%/cdrom/preseed/%/cdrom/'${osname}'/preseed/%' <<<"${gen_champ}") ${ubuntu_lang} boot=casper showmounts ignore_uuid noprompt quiet splash --"
osinitrd="initrd /${osname}/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*initrd*"))"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${osname}"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/."

#Live CD/DVD VOYAGER 11.10
#http://voyager.legtux.org/
elif [ "$(grep 'Live Voyager' /tmp/multisystem/multisystem-mountpoint-iso/isolinux/txt.cfg 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osicone="multisystem-voyager"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/casper/vmlinuz root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) ${ubuntu_lang} iso-scan/filename=/${osname} boot=casper file=/cdrom/preseed/xubuntu.seed noprompt quiet splash --"
osinitrd="initrd (loop)/casper/initrd.lz"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#Pear OS
#http://www.pear-os-linux.fr/index.php?option=com_content
elif [ "$(grep 'Pear OS' /tmp/multisystem/multisystem-mountpoint-iso/.disk/info 2>/dev/null)" ]; then
modiso="copycontent"
echo "ubuntu1" >/tmp/multisystem/multisystem-nomdistro
chemindeb="$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/ubuntu"
find "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")" -maxdepth 1 -path "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/ubuntu[0-9]" | while read line
do
echo "ubuntu$(($(echo $line | sed "s@${chemindeb}@@g")+1))" >/tmp/multisystem/multisystem-nomdistro
done
osname="$(cat /tmp/multisystem/multisystem-nomdistro)"
osnamemodif="$(basename "${option2}")"
osicone="multisystem-pear"
gen_champ="$(grep -m1 'file=.*\.seed' -o /tmp/multisystem/multisystem-mountpoint-iso/isolinux/*.cfg 2>/dev/null)"
oskernel="linux /${osname}/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*vmlinuz*")) live-media-path=/${osname}/casper root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) $(sed 's%/cdrom/preseed/%/cdrom/'${osname}'/preseed/%' <<<"${gen_champ}") ${ubuntu_lang} boot=casper showmounts ignore_uuid noprompt quiet splash --"
osinitrd="initrd /${osname}/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*initrd*"))"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${osname}"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/."

#Pear OS - Pear Linux Comice OS 4.0
#http://www.pear-os-linux.fr/index.php?option=com_content
elif [ "$(grep 'Pear Linux Comice OS' /tmp/multisystem/multisystem-mountpoint-iso/.disk/info 2>/dev/null)" ]; then
modiso="copycontent"
echo "ubuntu1" >/tmp/multisystem/multisystem-nomdistro
chemindeb="$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/ubuntu"
find "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")" -maxdepth 1 -path "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/ubuntu[0-9]" | while read line
do
echo "ubuntu$(($(echo $line | sed "s@${chemindeb}@@g")+1))" >/tmp/multisystem/multisystem-nomdistro
done
osname="$(cat /tmp/multisystem/multisystem-nomdistro)"
osnamemodif="$(basename "${option2}")"
osicone="multisystem-pear"
gen_champ="$(grep -m1 'file=.*\.seed' -o /tmp/multisystem/multisystem-mountpoint-iso/isolinux/*.cfg 2>/dev/null)"
#Menu 1
ligne1="menuentry \"Comice OS 4 livecd\" {"
ligne2=""
ligne3="linux /${osname}/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*vmlinuz*")) live-media-path=/${osname}/casper root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) $(sed 's%/cdrom/preseed/%/cdrom/'${osname}'/preseed/%' <<<"${gen_champ}") boot=casper noprompt quiet splash --"
ligne4="initrd /${osname}/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*initrd*"))"
ligne5="}"
#Menu 2
ligne6="menuentry \"Comice OS 4 install\" {"
ligne7=""
ligne8="linux /${osname}/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*vmlinuz*")) live-media-path=/${osname}/casper root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) $(sed 's%/cdrom/preseed/%/cdrom/'${osname}'/preseed/%' <<<"${gen_champ}") boot=casper only-ubiquity noprompt quiet splash --"
ligne9="initrd /${osname}/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*initrd*"))"
ligne10="}"
#Menu 3
ligne11="menuentry \"Comice OS 4 xforcevesa\" {"
ligne12=""
ligne13="linux /${osname}/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*vmlinuz*")) live-media-path=/${osname}/casper root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) $(sed 's%/cdrom/preseed/%/cdrom/'${osname}'/preseed/%' <<<"${gen_champ}") boot=casper xforcevesa noprompt quiet splash --"
ligne14="initrd /${osname}/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*initrd*"))"
ligne15="}"
#Menu 4
ligne16="menuentry \"Comice OS 4 Live textonly\" {"
ligne17=""
ligne18="linux /${osname}/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*vmlinuz*")) live-media-path=/${osname}/casper root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) $(sed 's%/cdrom/preseed/%/cdrom/'${osname}'/preseed/%' <<<"${gen_champ}") boot=casper textonly noprompt quiet splash --"
ligne19="initrd /${osname}/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*initrd*"))"
ligne20="}"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD4)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${osname}"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/."

#Sabily
#http://www.sabily.org/website/index.php/fr/sabily/downloads
elif [ "$(grep '^Sabily' /tmp/multisystem/multisystem-mountpoint-iso/.disk/info 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osnamemodif="$(basename "${option2}")"
osicone="multisystem-sabily"
gen_champ="$(grep -m1 'file=.*\.seed' -o /tmp/multisystem/multisystem-mountpoint-iso/isolinux/txt.cfg)"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*vmlinuz*")) root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) ${gen_champ} ${ubuntu_lang} iso-scan/filename=/${osname} boot=casper noprompt quiet splash --"
osinitrd="initrd (loop)/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*initrd*"))"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#ExTiX
#http://sourceforge.net/projects/extix/files/
elif [ "$(grep 'ExTiX' /tmp/multisystem/multisystem-mountpoint-iso/README.diskdefines 2>/dev/null)" ]; then
modiso="copycontent"
echo "ubuntu1" >/tmp/multisystem/multisystem-nomdistro
chemindeb="$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/ubuntu"
find "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")" -maxdepth 1 -path "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/ubuntu[0-9]" | while read line
do
echo "ubuntu$(($(echo $line | sed "s@${chemindeb}@@g")+1))" >/tmp/multisystem/multisystem-nomdistro
done
osname="$(cat /tmp/multisystem/multisystem-nomdistro)"
osnamemodif="$(basename "${option2}")"
osicone="multisystem-extix"
gen_champ="$(grep -m1 'file=.*\.seed' -o /tmp/multisystem/multisystem-mountpoint-iso/isolinux/*.cfg 2>/dev/null)"
oskernel="linux /${osname}/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*vmlinuz*")) live-media-path=/${osname}/casper root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) $(sed 's%/cdrom/preseed/%/cdrom/'${osname}'/preseed/%' <<<"${gen_champ}") ${ubuntu_lang} boot=casper showmounts ignore_uuid noprompt quiet splash --"
osinitrd="initrd /${osname}/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*initrd*"))"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${osname}"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/."

#Leeenux
#http://www.leeenux-linux.com/index.php/get-leeenux
elif [ "$(grep 'Leeenux' /tmp/multisystem/multisystem-mountpoint-iso/isolinux/isolinux.cfg 2>/dev/null)" ]; then
modiso="copycontent"
echo "ubuntu1" >/tmp/multisystem/multisystem-nomdistro
chemindeb="$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/ubuntu"
find "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")" -maxdepth 1 -path "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/ubuntu[0-9]" | while read line
do
echo "ubuntu$(($(echo $line | sed "s@${chemindeb}@@g")+1))" >/tmp/multisystem/multisystem-nomdistro
done
osname="$(cat /tmp/multisystem/multisystem-nomdistro)"
osnamemodif="$(basename "${option2}")"
osicone="multisystem-leeenux"
gen_champ="$(grep -m1 'file=.*\.seed' -o /tmp/multisystem/multisystem-mountpoint-iso/isolinux/*.cfg 2>/dev/null)"
oskernel="linux /${osname}/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*vmlinuz*")) live-media-path=/${osname}/casper root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) $(sed 's%/cdrom/preseed/%/cdrom/'${osname}'/preseed/%' <<<"${gen_champ}") ${ubuntu_lang} boot=casper showmounts ignore_uuid noprompt quiet splash --"
osinitrd="initrd /${osname}/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*initrd*"))"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${osname}"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/."

#Linutop
#http://www.linutop.com/download.en.html
#root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb)
elif [ "$(grep 'Linutop' /tmp/multisystem/multisystem-mountpoint-iso/isolinux/isolinux.cfg 2>/dev/null)" ]; then
modiso="copycontent"
osname="linutop"
if [ ! -d "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/linutop" ]; then
osnamemodif="Linutop"
osicone="multisystem-linutop"
oskernel="linux /linutop/isolinux/vmlinuz boot=lrd root=/dev/ram rootdevice=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) rootfstype=vfat rw quiet splash nohwclock"
osinitrd="initrd /linutop/isolinux/initrd.gz"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/linutop"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/linutop/."
mkdir /tmp/multisystem/multisystem-modinitrd 2>/dev/null
cd /tmp/multisystem/multisystem-modinitrd
gzip -dc /tmp/multisystem/multisystem-mountpoint-iso/isolinux/initrd.gz | cpio -i
sed -i 's@mount -o noatime,ro \$1 /cdrom >/dev/null 2>\&1@mount -o noatime,ro \$1 /cdrom >/dev/null 2>\&1\n\tmount --bind /cdrom/linutop /cdrom@' /tmp/multisystem/multisystem-modinitrd/scripts/lrd
sed -i 's@mount -o \$RWOPT,noatime \$ROOT_DEVICE /cdrom@mount -o \$RWOPT,noatime \$ROOT_DEVICE /cdrom\n\tmount --bind /cdrom/linutop /cdrom@' /tmp/multisystem/multisystem-modinitrd/scripts/lrd
#gedit /tmp/multisystem/multisystem-modinitrd/scripts/lrd
#echo Attente
#read
sudo rm "$(cat /tmp/multisystem/multisystem-mountpoint-usb)"/linutop/isolinux/initrd.gz
find . | cpio -o -H newc | gzip -9 > "$(cat /tmp/multisystem/multisystem-mountpoint-usb)"/linutop/isolinux/initrd.gz
cd -
rm -R /tmp/multisystem/multisystem-modinitrd
else
zenity --error --text "$(eval_gettext "Erreur: LiveCD déjà présent.")"
fi

#Anonymous-OS
#http://sourceforge.net/projects/anonymous-os/
elif [ "$(grep 'Anonymous-OS' /tmp/multisystem/multisystem-mountpoint-iso/.disk/info 2>/dev/null)" ]; then
modiso="copycontent"
echo "ubuntu1" >/tmp/multisystem/multisystem-nomdistro
chemindeb="$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/ubuntu"
find "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")" -maxdepth 1 -path "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/ubuntu[0-9]" | while read line
do
echo "ubuntu$(($(echo $line | sed "s@${chemindeb}@@g")+1))" >/tmp/multisystem/multisystem-nomdistro
done
osname="$(cat /tmp/multisystem/multisystem-nomdistro)"
osnamemodif="Anonymous-OS"
osicone="multisystem-anonymous-os"
gen_champ="$(grep -m1 'file=.*\.seed' -o /tmp/multisystem/multisystem-mountpoint-iso/isolinux/*.cfg 2>/dev/null)"
oskernel="linux /${osname}/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*vmlinuz*")) live-media-path=/${osname}/casper root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) $(sed 's%/cdrom/preseed/%/cdrom/'${osname}'/preseed/%' <<<"${gen_champ}") ${ubuntu_lang} boot=casper showmounts ignore_uuid noprompt quiet splash --"
osinitrd="initrd /${osname}/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*initrd*"))"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${osname}"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/."

#Ubuntu Business Remix
#http://www.ubuntu.com/business/desktop/remix
elif [ "$(grep 'Ubuntu Business Remix' /tmp/multisystem/multisystem-mountpoint-iso/isolinux/live.cfg 2>/dev/null)" ]; then
modiso="copycontent"
echo "ubuntu1" >/tmp/multisystem/multisystem-nomdistro
chemindeb="$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/ubuntu"
find "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")" -maxdepth 1 -path "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/ubuntu[0-9]" | while read line
do
echo "ubuntu$(($(echo $line | sed "s@${chemindeb}@@g")+1))" >/tmp/multisystem/multisystem-nomdistro
done
osname="$(cat /tmp/multisystem/multisystem-nomdistro)"
osicone="multisystem-ubuntu"
#Menu 1
ligne1="menuentry \"Ubuntu Business Remix Live (no install)\" {"
ligne2=""
ligne3="linux /${osname}/casper/vmlinuz live-media-path=/${osname}/casper root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) ${ubuntu_lang} boot=casper showmounts ignore_uuid noprompt quiet splash --"
ligne4="initrd /${osname}/casper/initrd.lz"
ligne5="}"
#Menu 2
ligne6="menuentry \"Ubuntu Business Remix, by Canonical (install only)\" {"
ligne7=""
ligne8="linux /${osname}/casper/vmlinuz live-media-path=/${osname}/casper root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) ${ubuntu_lang} boot=casper showmounts ignore_uuid noprompt quiet splash only-ubiquity file=/cdrom/${osname}/install/preseed.cfg"
ligne9="initrd /${osname}/casper/initrd.lz"
ligne10="}"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD2)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${osname}"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/."

#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒/divers#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒



#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒Debian-Live#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
#Squeeze ==> 6.0
#Lenny ==> 5.0
#etch ==> 4.0
#Woody ==> 3.0

#Debian-Live-Squeeze 6.0
#http://live.debian.net/
elif [ "$(grep 'Debian GNU/Linux 6.*"Squeeze" - Official Snapshot.*LIVE/INSTALL' /tmp/multisystem/multisystem-mountpoint-iso/.disk/info 2>/dev/null)" ]; then
modiso="copycontent"
echo "debian1" >/tmp/multisystem/multisystem-nomdebian
chemindeb="$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/debian"
find "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")" -maxdepth 1 -path "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/debian[0-9]" | while read line
do
echo "debian$(($(echo $line | sed "s@${chemindeb}@@g")+1))" >/tmp/multisystem/multisystem-nomdebian
done
osname="$(cat /tmp/multisystem/multisystem-nomdebian)"
osnamemodif=""
osicone="multisystem-debian"
if [ "$(grep -i kde <<<$(basename "${option2}"))" ]; then
debiandesktop="kde"
elif [ "$(grep -i lxde <<<$(basename "${option2}"))" ]; then
debiandesktop="lxde"
elif [ "$(grep -i xfce <<<$(basename "${option2}"))" ]; then
debiandesktop="xfce"
elif [ "$(grep -i gnome <<<$(basename "${option2}"))" ]; then
debiandesktop="gnome"
elif [ "$(grep -i canaima <<<$(basename "${option2}"))" ]; then
debiandesktop="canaima"
else
debiandesktop=""
fi
debianarch="$(cat /tmp/multisystem/multisystem-mountpoint-iso/dists/squeeze/Release | grep 'Architectures: ' | cut -d " " -f2)"
if [ ! -f "/tmp/multisystem/multisystem-mountpoint-iso/live/initrd2.img" ]; then
#Menu live
ligne1="menuentry \"Debian Squeeze ${debiandesktop} ${debianarch} Live\" {"
ligne2=""
ligne3="linux /${osname}/live/vmlinuz rw quickusbmodules live-media-path=/${osname}/live boot=live config live-config live-config.locales=${LANG} live-config.keyboard-layouts=${XKBLAYOUT} live-config.timezone=$(cat /etc/timezone 2>/dev/null) quiet quickreboot"
ligne4="initrd /${osname}/live/initrd.img"
ligne5="}"
#Menu install
ligne6="menuentry \"Debian Squeeze ${debiandesktop} ${debianarch} install\" {"
ligne7=""
ligne8="linux /${osname}/install/vmlinuz root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) cdrom-detect/try-usb=true quiet"
ligne9="initrd /${osname}/install/initrd.gz"
ligne10="}"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD2)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
else
#Menu 1
ligne1="menuentry \"Debian Squeeze ${debiandesktop} ${debianarch} Live\" {"
ligne2=""
ligne3="linux /${osname}/live/vmlinuz rw quickusbmodules live-media-path=/${osname}/live boot=live config live-config live-config.locales=${LANG} live-config.keyboard-layouts=${XKBLAYOUT} live-config.timezone=$(cat /etc/timezone 2>/dev/null) quiet quickreboot"
ligne4="initrd /${osname}/live/initrd.img"
ligne5="}"
#Menu 2
ligne6="menuentry \"Debian Squeeze ${debiandesktop} ${debianarch} Live 686\" {"
ligne7=""
ligne8="linux /${osname}/live/vmlinuz2 rw quickusbmodules live-media-path=/${osname}/live boot=live config live-config live-config.locales=${LANG} live-config.keyboard-layouts=${XKBLAYOUT} live-config.timezone=$(cat /etc/timezone 2>/dev/null) quiet quickreboot"
ligne9="initrd /${osname}/live/initrd2.img"
ligne10="}"
#Menu 3
ligne11="menuentry \"Debian Squeeze ${debiandesktop} ${debianarch} install\" {"
ligne12=""
ligne13="linux /${osname}/install/vmlinuz root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) cdrom-detect/try-usb=true quiet"
ligne14="initrd /${osname}/install/initrd.gz"
ligne15="}"
#Menu 4
ligne16="menuentry \"Debian Squeeze ${debiandesktop} ${debianarch} install gtk\" {"
ligne17=""
ligne18="linux /${osname}/install/gtk/vmlinuz root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) cdrom-detect/try-usb=true quiet"
ligne19="initrd /${osname}/install/gtk/initrd.gz"
ligne20="}"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD4)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
fi
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${osname}"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/."
#Modifier initrd du live
mkdir /tmp/multisystem/multisystem-modinitrd 2>/dev/null
cd /tmp/multisystem/multisystem-modinitrd
gzip -dc /tmp/multisystem/multisystem-mountpoint-iso/live/initrd.img | cpio -i
sed -i 's@mount \"\$ISO_DEVICE\" /isofrom@modprobe -q vfat\n\t\t\tmount \"\$ISO_DEVICE\" /isofrom   @' /tmp/multisystem/multisystem-modinitrd/scripts/live
#pour nouvelle version...
sed -i 's@mount -t auto \"\$ISO_DEVICE\" /isofrom@modprobe -q vfat\n\t\t\tmount -t vfat \"\$ISO_DEVICE\" /isofrom   @' /tmp/multisystem/multisystem-modinitrd/scripts/live
#gedit /tmp/multisystem/multisystem-modinitrd/scripts/live
#echo Attente
#read
sudo rm "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/live/initrd.img"
find . | cpio -o -H newc | gzip -9 > "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/live/initrd.img"
cd -
rm -R /tmp/multisystem/multisystem-modinitrd
#Modifier initrd de install
mkdir /tmp/multisystem/multisystem-modinitrd 2>/dev/null
cd /tmp/multisystem/multisystem-modinitrd
gzip -dc /tmp/multisystem/multisystem-mountpoint-iso/install/initrd.gz | cpio -i
#if mount -t $type -o ro,exec $device /cdrom; then
sed -i 's@if mount -t $type -o ro,exec $device /cdrom; then@if mount -t vfat -o ro,exec /dev/disk/by-uuid/'$(cat /tmp/multisystem/multisystem-selection-uuid-usb)' /cdrom; then\n\tmount --bind /cdrom/'${osname}' /cdrom 2>/dev/null@' /tmp/multisystem/multisystem-modinitrd/var/lib/dpkg/info/cdrom-detect.postinst
sed -i 's@if mount -t $type -o $OPTIONS $device /cdrom; then@if mount -t vfat -o ro,exec /dev/disk/by-uuid/'$(cat /tmp/multisystem/multisystem-selection-uuid-usb)' /cdrom; then\n\tmount --bind /cdrom/'${osname}' /cdrom 2>/dev/null@' /tmp/multisystem/multisystem-modinitrd/var/lib/dpkg/info/cdrom-detect.postinst
#gedit /tmp/multisystem/multisystem-modinitrd/var/lib/dpkg/info/cdrom-detect.postinst
#echo Attente
#read
sudo rm "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/install/initrd.gz"
find . | cpio -o -H newc | gzip -9 > "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/install/initrd.gz"
cd -
rm -R /tmp/multisystem/multisystem-modinitrd
#Modifier initrd 2 du live
mkdir /tmp/multisystem/multisystem-modinitrd 2>/dev/null
cd /tmp/multisystem/multisystem-modinitrd
gzip -dc /tmp/multisystem/multisystem-mountpoint-iso/live/initrd2.img | cpio -i
sed -i 's@mount \"\$ISO_DEVICE\" /isofrom@modprobe -q vfat\n\t\t\tmount \"\$ISO_DEVICE\" /isofrom   @' /tmp/multisystem/multisystem-modinitrd/scripts/live
#pour nouvelle version...
sed -i 's@mount -t auto \"\$ISO_DEVICE\" /isofrom@modprobe -q vfat\n\t\t\tmount -t vfat \"\$ISO_DEVICE\" /isofrom   @' /tmp/multisystem/multisystem-modinitrd/scripts/live
#gedit /tmp/multisystem/multisystem-modinitrd/scripts/live
#echo Attente
#read
sudo rm "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/live/initrd2.img"
find . | cpio -o -H newc | gzip -9 > "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/live/initrd2.img"
cd -
rm -R /tmp/multisystem/multisystem-modinitrd
#Modifier initrd gtk de install
mkdir /tmp/multisystem/multisystem-modinitrd 2>/dev/null
cd /tmp/multisystem/multisystem-modinitrd
gzip -dc /tmp/multisystem/multisystem-mountpoint-iso/install/gtk/initrd.gz | cpio -i
#if mount -t $type -o ro,exec $device /cdrom; then
sed -i 's@if mount -t $type -o ro,exec $device /cdrom; then@if mount -t vfat -o ro,exec /dev/disk/by-uuid/'$(cat /tmp/multisystem/multisystem-selection-uuid-usb)' /cdrom; then\n\tmount --bind /cdrom/'${osname}' /cdrom 2>/dev/null@' /tmp/multisystem/multisystem-modinitrd/var/lib/dpkg/info/cdrom-detect.postinst
sed -i 's@if mount -t $type -o $OPTIONS $device /cdrom; then@if mount -t vfat -o ro,exec /dev/disk/by-uuid/'$(cat /tmp/multisystem/multisystem-selection-uuid-usb)' /cdrom; then\n\tmount --bind /cdrom/'${osname}' /cdrom 2>/dev/null@' /tmp/multisystem/multisystem-modinitrd/var/lib/dpkg/info/cdrom-detect.postinst
#gedit /tmp/multisystem/multisystem-modinitrd/var/lib/dpkg/info/cdrom-detect.postinst
#echo Attente
#read
sudo rm "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/install/gtk/initrd.gz"
find . | cpio -o -H newc | gzip -9 > "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/install/gtk/initrd.gz"
cd -
rm -R /tmp/multisystem/multisystem-modinitrd


#Debian-live Lenny 5.0
#http://debian-live.alioth.debian.org/
elif [ "$(grep -E '(Debian GNU/Linux 5.*"Lenny".*LIVE)' /tmp/multisystem/multisystem-mountpoint-iso/.disk/info 2>/dev/null)" ]; then
modiso="copycontent"
echo "debian1" >/tmp/multisystem/multisystem-nomdebian
chemindeb="$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/debian"
find "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")" -maxdepth 1 -path "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/debian[0-9]" | while read line
do
echo "debian$(($(echo $line | sed "s@${chemindeb}@@g")+1))" >/tmp/multisystem/multisystem-nomdebian
done
osname="$(cat /tmp/multisystem/multisystem-nomdebian)"
osnamemodif="$(sed "s/.iso//"  <<< "$(basename "${option2}")")"
osicone="multisystem-debian"
osloopback=""
oskernel="linux /${osname}/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/live -iname "*vmlinuz*")) quickreboot root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) live-media-path=/${osname} boot=live union=aufs debian-installer/language=$(echo "${LANG}" |  awk -F"_" '{print $1}') debian-installer/locale=${LANG} kbd-chooser/method=${XKBLAYOUT}  console-setup/layoutcode=${XKBLAYOUT} console-setup/variantcode=${XKBVARIANT} console-setup/modelcode=${XKBMODEL}"
osinitrd="initrd /${osname}/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/live -iname "*initrd*"))"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${osname}"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/live/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/."

#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒/Debian-Live#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒



#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒Debian-mini.iso▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
#debian Amorçage par le réseau ==> mini.iso
#http://ftp.nl.debian.org/debian/dists/lenny/main/installer-i386/current/images/netboot/mini.iso
elif [ "$(grep 'append vga=normal initrd=initrd.gz -- quiet ' /tmp/multisystem/multisystem-mountpoint-iso/txt.cfg 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osnamemodif="Debian Network boot mini.iso"
osicone="multisystem-debian"
FCT_DOS1
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_GRUB4DOS)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/menu.lst"
#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒Debian-mini.iso#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒



#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒Debian-Multi-architecture#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
#Squeeze ==> 6.0
#Lenny ==> 5.0
#etch ==> 4.0
#Woody ==> 3.0

#ftp://ftp.debian.org/debian/dists/testing/main/installer-i386/current/images/hd-media/
#voir fichier initrd ==> .../var/lib/dpkg/info/iso-scan.postinst
#http://wiki.debian.org/DebianEeePC/HowTo/InstallUsingStandardInstaller
#http://http.us.debian.org/debian/dists/stable/main/installer-i386/current/images/hd-media/
#http://laotzu.acc.umu.se/debian-cd/5.0.4/i386/iso-cd/debian-504-i386-netinst.iso
#http://linuxfr.org/forums/15/26411.html

#unofficial cd-including-firmware
#http://cdimage.debian.org/cdimage/unofficial/non-free/cd-including-firmware/6.0.2.1/multi-arch/iso-cd/
#http://cdimage.debian.org/cdimage/unofficial/non-free/cd-including-firmware/current/
#http://cdimage.debian.org/cdimage/unofficial/non-free

#debian Amorçage par le réseau ==> mini.iso
#http://ftp.nl.debian.org/debian/dists/lenny/main/installer-i386/current/images/netboot/mini.iso


#Debian NetInstall et install sourse Multi-architecture amd64/i386 CD et DVD
#Debian GNU/Linux 6.0.3 "Squeeze" - Official Multi-architecture amd64/i386 NETINST #1 20111008-20:04
#Debian GNU/Linux 6.0.3 "Squeeze" - Official Multi-architecture i386/amd64/source DVD #1 20111008-15:09
#http://www.debian.org/CD/netinst/
#http://cdimage.debian.org/cdimage/unofficial/non-free
elif [[ -f "/tmp/multisystem/multisystem-mountpoint-iso/.disk/multi_arch" && "$(grep 'Debian GNU/Linux.* Multi-architecture amd64/i386 NETINST' /tmp/multisystem/multisystem-mountpoint-iso/.disk/info 2>/dev/null)" \
|| "$(grep 'Debian GNU/Linux .* - Official .* Multi-architecture i386/amd64/source DVD' /tmp/multisystem/multisystem-mountpoint-iso/.disk/info 2>/dev/null)" ]]; then
modiso="copycontent"
echo "debian1" >/tmp/multisystem/multisystem-nomdebian
chemindeb="$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/debian"
find "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")" -maxdepth 1 -path "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/debian[0-9]" | while read line
do
echo "debian$(($(echo $line | sed "s@${chemindeb}@@g")+1))" >/tmp/multisystem/multisystem-nomdebian
done
osname="$(cat /tmp/multisystem/multisystem-nomdebian)"
osnamemodif=""
osicone="multisystem-debian"
unset debiancodename
#Codename: lenny
[ "$(grep 'Codename: lenny' /tmp/multisystem/multisystem-mountpoint-iso/dists/lenny/Release 2>/dev/null)" ] && debiancodename="lenny"
#Codename: squeeze
[ "$(grep 'Codename: squeeze' /tmp/multisystem/multisystem-mountpoint-iso/dists/squeeze/Release 2>/dev/null)" ] && debiancodename="squeeze"
#Codename: wheezy
[ "$(grep 'Codename: wheezy' /tmp/multisystem/multisystem-mountpoint-iso/dists/wheezy/Release 2>/dev/null)" ] && debiancodename="wheezy"
if [ ! "${debiancodename}" ]; then
zenity --error --text "Erreur: Codename: ?"
FCT_RELOAD
exit 0
fi
#Menu 1
ligne1="menuentry \"Debian Multi-architecture ${debiancodename} install 32 bit i386 text\" {"
ligne2=""
ligne3="linux /${osname}/install.386/vmlinuz root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) cdrom-detect/try-usb=true quiet"
ligne4="initrd /${osname}/install.386/initrd.gz"
ligne5="}"
#Menu 2
ligne6="menuentry \"Debian Multi-architecture ${debiancodename} install 32 bit i386 gtk\" {"
ligne7=""
ligne8="linux /${osname}/install.386/gtk/vmlinuz video=vesa:ywrap,mtrr root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) cdrom-detect/try-usb=true quiet"
ligne9="initrd /${osname}/install.386/gtk/initrd.gz"
ligne10="}"
#Menu 3
ligne11="menuentry \"Debian Multi-architecture ${debiancodename} install 64 bit amd text\" {"
ligne12=""
ligne13="linux /${osname}/install.amd/vmlinuz root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) cdrom-detect/try-usb=true quiet"
ligne14="initrd /${osname}/install.amd/initrd.gz"
ligne15="}"
#Menu 4
ligne16="menuentry \"Debian Multi-architecture ${debiancodename} install 64 bit amd gtk\" {"
ligne17=""
ligne18="linux /${osname}/install.amd/gtk/vmlinuz video=vesa:ywrap,mtrr root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) cdrom-detect/try-usb=true quiet"
ligne19="initrd /${osname}/install.amd/gtk/initrd.gz"
ligne20="}"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD4)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${osname}"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/."
#Modifier initrd 386 text
mkdir /tmp/multisystem/multisystem-modinitrd 2>/dev/null
cd /tmp/multisystem/multisystem-modinitrd
gzip -dc /tmp/multisystem/multisystem-mountpoint-iso/install.386/initrd.gz | cpio -i
#if mount -t $type -o ro,exec $device /cdrom; then
sed -i 's@if mount -t $type -o ro,exec $device /cdrom; then@if mount -t vfat -o ro,exec /dev/disk/by-uuid/'$(cat /tmp/multisystem/multisystem-selection-uuid-usb)' /cdrom; then\n\tmount --bind /cdrom/'${osname}' /cdrom 2>/dev/null@' /tmp/multisystem/multisystem-modinitrd/var/lib/dpkg/info/cdrom-detect.postinst
sed -i 's@if mount -t $type -o $OPTIONS $device /cdrom; then@if mount -t vfat -o ro,exec /dev/disk/by-uuid/'$(cat /tmp/multisystem/multisystem-selection-uuid-usb)' /cdrom; then\n\tmount --bind /cdrom/'${osname}' /cdrom 2>/dev/null@' /tmp/multisystem/multisystem-modinitrd/var/lib/dpkg/info/cdrom-detect.postinst
#gedit /tmp/multisystem/multisystem-modinitrd/var/lib/dpkg/info/cdrom-detect.postinst
#echo Attente
#read
sudo rm "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/install.386/initrd.gz"
find . | cpio -o -H newc | gzip -9 > "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/install.386/initrd.gz"
cd -
rm -R /tmp/multisystem/multisystem-modinitrd
#Modifier initrd 386 gtk
mkdir /tmp/multisystem/multisystem-modinitrd 2>/dev/null
cd /tmp/multisystem/multisystem-modinitrd
gzip -dc /tmp/multisystem/multisystem-mountpoint-iso/install.386/gtk/initrd.gz | cpio -i
#if mount -t $type -o ro,exec $device /cdrom; then
sed -i 's@if mount -t $type -o ro,exec $device /cdrom; then@if mount -t vfat -o ro,exec /dev/disk/by-uuid/'$(cat /tmp/multisystem/multisystem-selection-uuid-usb)' /cdrom; then\n\tmount --bind /cdrom/'${osname}' /cdrom 2>/dev/null@' /tmp/multisystem/multisystem-modinitrd/var/lib/dpkg/info/cdrom-detect.postinst
sed -i 's@if mount -t $type -o $OPTIONS $device /cdrom; then@if mount -t vfat -o ro,exec /dev/disk/by-uuid/'$(cat /tmp/multisystem/multisystem-selection-uuid-usb)' /cdrom; then\n\tmount --bind /cdrom/'${osname}' /cdrom 2>/dev/null@' /tmp/multisystem/multisystem-modinitrd/var/lib/dpkg/info/cdrom-detect.postinst
#gedit /tmp/multisystem/multisystem-modinitrd/var/lib/dpkg/info/cdrom-detect.postinst
#echo Attente
#read
sudo rm "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/install.386/gtk/initrd.gz"
find . | cpio -o -H newc | gzip -9 > "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/install.386/gtk/initrd.gz"
cd -
rm -R /tmp/multisystem/multisystem-modinitrd
#Modifier initrd  amd text
mkdir /tmp/multisystem/multisystem-modinitrd 2>/dev/null
cd /tmp/multisystem/multisystem-modinitrd
gzip -dc /tmp/multisystem/multisystem-mountpoint-iso/install.amd/initrd.gz | cpio -i
#if mount -t $type -o ro,exec $device /cdrom; then
sed -i 's@if mount -t $type -o ro,exec $device /cdrom; then@if mount -t vfat -o ro,exec /dev/disk/by-uuid/'$(cat /tmp/multisystem/multisystem-selection-uuid-usb)' /cdrom; then\n\tmount --bind /cdrom/'${osname}' /cdrom 2>/dev/null@' /tmp/multisystem/multisystem-modinitrd/var/lib/dpkg/info/cdrom-detect.postinst
sed -i 's@if mount -t $type -o $OPTIONS $device /cdrom; then@if mount -t vfat -o ro,exec /dev/disk/by-uuid/'$(cat /tmp/multisystem/multisystem-selection-uuid-usb)' /cdrom; then\n\tmount --bind /cdrom/'${osname}' /cdrom 2>/dev/null@' /tmp/multisystem/multisystem-modinitrd/var/lib/dpkg/info/cdrom-detect.postinst
#gedit /tmp/multisystem/multisystem-modinitrd/var/lib/dpkg/info/cdrom-detect.postinst
#echo Attente
#read
sudo rm "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/install.amd/initrd.gz"
find . | cpio -o -H newc | gzip -9 > "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/install.amd/initrd.gz"
cd -
rm -R /tmp/multisystem/multisystem-modinitrd
#Modifier initrd amd gtk
mkdir /tmp/multisystem/multisystem-modinitrd 2>/dev/null
cd /tmp/multisystem/multisystem-modinitrd
gzip -dc /tmp/multisystem/multisystem-mountpoint-iso/install.amd/gtk/initrd.gz | cpio -i
#if mount -t $type -o ro,exec $device /cdrom; then
sed -i 's@if mount -t $type -o ro,exec $device /cdrom; then@if mount -t vfat -o ro,exec /dev/disk/by-uuid/'$(cat /tmp/multisystem/multisystem-selection-uuid-usb)' /cdrom; then\n\tmount --bind /cdrom/'${osname}' /cdrom 2>/dev/null@' /tmp/multisystem/multisystem-modinitrd/var/lib/dpkg/info/cdrom-detect.postinst
sed -i 's@if mount -t $type -o $OPTIONS $device /cdrom; then@if mount -t vfat -o ro,exec /dev/disk/by-uuid/'$(cat /tmp/multisystem/multisystem-selection-uuid-usb)' /cdrom; then\n\tmount --bind /cdrom/'${osname}' /cdrom 2>/dev/null@' /tmp/multisystem/multisystem-modinitrd/var/lib/dpkg/info/cdrom-detect.postinst
#gedit /tmp/multisystem/multisystem-modinitrd/var/lib/dpkg/info/cdrom-detect.postinst
#echo Attente
#read
sudo rm "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/install.amd/gtk/initrd.gz"
find . | cpio -o -H newc | gzip -9 > "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/install.amd/gtk/initrd.gz"
cd -
rm -R /tmp/multisystem/multisystem-modinitrd
#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒/Debian-Multi-architecture#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒



#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒Debian-NetInstall#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒

#Debian NetInstall Mono-architecture
#http://www.debian.org/CD/netinst/
elif [ "$(grep 'Debian GNU/Linux.* - Official.*NETINST' /tmp/multisystem/multisystem-mountpoint-iso/.disk/info 2>/dev/null)" ]; then
modiso="copycontent"
echo "debian1" >/tmp/multisystem/multisystem-nomdebian
chemindeb="$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/debian"
find "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")" -maxdepth 1 -path "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/debian[0-9]" | while read line
do
echo "debian$(($(echo $line | sed "s@${chemindeb}@@g")+1))" >/tmp/multisystem/multisystem-nomdebian
done
osname="$(cat /tmp/multisystem/multisystem-nomdebian)"
osnamemodif=""
osicone="multisystem-debian"
unset debiancodename
#Codename: lenny
[ "$(grep 'Codename: lenny' /tmp/multisystem/multisystem-mountpoint-iso/dists/lenny/Release 2>/dev/null)" ] && debiancodename="lenny"
#Codename: squeeze
[ "$(grep 'Codename: squeeze' /tmp/multisystem/multisystem-mountpoint-iso/dists/squeeze/Release 2>/dev/null)" ] && debiancodename="squeeze"
#Codename: wheezy
[ "$(grep 'Codename: wheezy' /tmp/multisystem/multisystem-mountpoint-iso/dists/wheezy/Release 2>/dev/null)" ] && debiancodename="wheezy"
if [ ! "${debiancodename}" ]; then
zenity --error --text "Erreur: Codename: ?"
FCT_RELOAD
exit 0
fi
debianarch="$(cat /tmp/multisystem/multisystem-mountpoint-iso/dists/${debiancodename}/Release 2>/dev/null | grep 'Architectures: ' | cut -d " " -f2)"
if [ ! "${debianarch}" ]; then
zenity --error --text "Erreur: Architectures: ?"
FCT_RELOAD
exit 0
fi
debianinit="$(grep ' initrd=/install.*initrd.gz ' -h -o -R /tmp/multisystem/multisystem-mountpoint-iso/isolinux 2>/dev/null | head -1 | cut -d"/" -f2)"
if [ ! "${debianinit}" ]; then
zenity --error --text "Erreur: debianinit: ?"
FCT_RELOAD
exit 0
fi
#Menu Gnome
ligne1="menuentry \"Debian ${debiancodename} gnome NetInstall ${debianarch}\" {"
ligne2=""
ligne3="linux /${osname}/${debianinit}/vmlinuz root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) cdrom-detect/try-usb=true quiet"
ligne4="initrd /${osname}/${debianinit}/initrd.gz"
ligne5="}"
#Menu kde
ligne6="menuentry \"Debian ${debiancodename} kde NetInstall ${debianarch}\" {"
ligne7=""
ligne8="linux /${osname}/${debianinit}/vmlinuz desktop=kde root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) cdrom-detect/try-usb=true quiet"
ligne9="initrd /${osname}/${debianinit}/initrd.gz"
ligne10="}"
#Menu lxde
ligne11="menuentry \"Debian ${debiancodename} lxde NetInstall ${debianarch}\" {"
ligne12=""
ligne13="linux /${osname}/${debianinit}/vmlinuz desktop=lxde root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) cdrom-detect/try-usb=true quiet"
ligne14="initrd /${osname}/${debianinit}/initrd.gz"
ligne15="}"
#Menu xfce
ligne16="menuentry \"Debian ${debiancodename} xfce NetInstall ${debianarch}\" {"
ligne17=""
ligne18="linux /${osname}/${debianinit}/vmlinuz desktop=xfce root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) cdrom-detect/try-usb=true quiet"
ligne19="initrd /${osname}/${debianinit}/initrd.gz"
ligne20="}"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD4)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${osname}"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/."
#Modifier initrd de install
mkdir /tmp/multisystem/multisystem-modinitrd 2>/dev/null
cd /tmp/multisystem/multisystem-modinitrd
gzip -dc /tmp/multisystem/multisystem-mountpoint-iso/${debianinit}/initrd.gz | cpio -i
#if mount -t $type -o ro,exec $device /cdrom; then
sed -i 's@if mount -t $type -o ro,exec $device /cdrom; then@if mount -t vfat -o ro,exec /dev/disk/by-uuid/'$(cat /tmp/multisystem/multisystem-selection-uuid-usb)' /cdrom; then\n\tmount --bind /cdrom/'${osname}' /cdrom 2>/dev/null@' /tmp/multisystem/multisystem-modinitrd/var/lib/dpkg/info/cdrom-detect.postinst
sed -i 's@if mount -t $type -o $OPTIONS $device /cdrom; then@if mount -t vfat -o ro,exec /dev/disk/by-uuid/'$(cat /tmp/multisystem/multisystem-selection-uuid-usb)' /cdrom; then\n\tmount --bind /cdrom/'${osname}' /cdrom 2>/dev/null@' /tmp/multisystem/multisystem-modinitrd/var/lib/dpkg/info/cdrom-detect.postinst
#gedit /tmp/multisystem/multisystem-modinitrd/var/lib/dpkg/info/cdrom-detect.postinst
#echo Attente
#read
sudo rm "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/${debianinit}/initrd.gz"
find . | cpio -o -H newc | gzip -9 > "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/${debianinit}/initrd.gz"
cd -
rm -R /tmp/multisystem/multisystem-modinitrd

#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒/Debian-NetInstall#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒



#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒/Debian-Businesscard#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
#Debian Businesscard
elif [ "$(grep 'Debian GNU/Linux.* - Official.*BC Binary-1' /tmp/multisystem/multisystem-mountpoint-iso/.disk/info 2>/dev/null)" ]; then
modiso="copycontent"
echo "debian1" >/tmp/multisystem/multisystem-nomdebian
chemindeb="$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/debian"
find "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")" -maxdepth 1 -path "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/debian[0-9]" | while read line
do
echo "debian$(($(echo $line | sed "s@${chemindeb}@@g")+1))" >/tmp/multisystem/multisystem-nomdebian
done
osname="$(cat /tmp/multisystem/multisystem-nomdebian)"
osnamemodif=""
osicone="multisystem-debian"
unset debiancodename
#Codename: lenny
[ "$(grep 'Codename: lenny' /tmp/multisystem/multisystem-mountpoint-iso/dists/lenny/Release 2>/dev/null)" ] && debiancodename="lenny"
#Codename: squeeze
[ "$(grep 'Codename: squeeze' /tmp/multisystem/multisystem-mountpoint-iso/dists/squeeze/Release 2>/dev/null)" ] && debiancodename="squeeze"
#Codename: wheezy
[ "$(grep 'Codename: wheezy' /tmp/multisystem/multisystem-mountpoint-iso/dists/wheezy/Release 2>/dev/null)" ] && debiancodename="wheezy"
if [ ! "${debiancodename}" ]; then
zenity --error --text "Erreur: Codename: ?"
FCT_RELOAD
exit 0
fi
debianarch="$(cat /tmp/multisystem/multisystem-mountpoint-iso/dists/${debiancodename}/Release 2>/dev/null | grep 'Architectures: ' | cut -d " " -f2)"
if [ ! "${debianarch}" ]; then
zenity --error --text "Erreur: Architectures: ?"
FCT_RELOAD
exit 0
fi
debianinit="$(grep ' initrd=/install.*initrd.gz ' -h -o -R /tmp/multisystem/multisystem-mountpoint-iso/isolinux 2>/dev/null | head -1 | cut -d"/" -f2)"
if [ ! "${debianinit}" ]; then
zenity --error --text "Erreur: debianinit: ?"
FCT_RELOAD
exit 0
fi
#Menu Gnome
ligne1="menuentry \"Debian ${debiancodename} gnome Businesscard ${debianarch}\" {"
ligne2=""
ligne3="linux /${osname}/${debianinit}/vmlinuz root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) cdrom-detect/try-usb=true quiet"
ligne4="initrd /${osname}/${debianinit}/initrd.gz"
ligne5="}"
#Menu kde
ligne6="menuentry \"Debian ${debiancodename} kde Businesscard ${debianarch}\" {"
ligne7=""
ligne8="linux /${osname}/${debianinit}/vmlinuz desktop=kde root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) cdrom-detect/try-usb=true quiet"
ligne9="initrd /${osname}/${debianinit}/initrd.gz"
ligne10="}"
#Menu lxde
ligne11="menuentry \"Debian ${debiancodename} lxde Businesscard ${debianarch}\" {"
ligne12=""
ligne13="linux /${osname}/${debianinit}/vmlinuz desktop=lxde root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) cdrom-detect/try-usb=true quiet"
ligne14="initrd /${osname}/${debianinit}/initrd.gz"
ligne15="}"
#Menu xfce
ligne16="menuentry \"Debian ${debiancodename} xfce Businesscard ${debianarch}\" {"
ligne17=""
ligne18="linux /${osname}/${debianinit}/vmlinuz desktop=xfce root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) cdrom-detect/try-usb=true quiet"
ligne19="initrd /${osname}/${debianinit}/initrd.gz"
ligne20="}"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD4)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${osname}"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/."
#Modifier initrd de install
mkdir /tmp/multisystem/multisystem-modinitrd 2>/dev/null
cd /tmp/multisystem/multisystem-modinitrd
gzip -dc /tmp/multisystem/multisystem-mountpoint-iso/${debianinit}/initrd.gz | cpio -i
#if mount -t $type -o ro,exec $device /cdrom; then
sed -i 's@if mount -t $type -o ro,exec $device /cdrom; then@if mount -t vfat -o ro,exec /dev/disk/by-uuid/'$(cat /tmp/multisystem/multisystem-selection-uuid-usb)' /cdrom; then\n\tmount --bind /cdrom/'${osname}' /cdrom 2>/dev/null@' /tmp/multisystem/multisystem-modinitrd/var/lib/dpkg/info/cdrom-detect.postinst
sed -i 's@if mount -t $type -o $OPTIONS $device /cdrom; then@if mount -t vfat -o ro,exec /dev/disk/by-uuid/'$(cat /tmp/multisystem/multisystem-selection-uuid-usb)' /cdrom; then\n\tmount --bind /cdrom/'${osname}' /cdrom 2>/dev/null@' /tmp/multisystem/multisystem-modinitrd/var/lib/dpkg/info/cdrom-detect.postinst
#gedit /tmp/multisystem/multisystem-modinitrd/var/lib/dpkg/info/cdrom-detect.postinst
#echo Attente
#read
sudo rm "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/${debianinit}/initrd.gz"
find . | cpio -o -H newc | gzip -9 > "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/${debianinit}/initrd.gz"
cd -
rm -R /tmp/multisystem/multisystem-modinitrd
#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒/Debian-Businesscard#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒



#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒Debian-Install#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒

#hurd ...
#http://www.debian.org/ports/hurd/hurd-cd

#Wheezy ==> 7.0
#Squeeze ==> 6.0
#Lenny ==> 5.0
#etch ==> 4.0
#Woody ==> 3.0

#Untangle (eventuelement coder support avec methode Debian)
#http://www.untangle.com/Downloads/Download-ISO
#Debian GNU/Linux 5.0.4 "Lenny" - Unofficial i386 CD Binary-1 20100521-21:37

#Debian squeeze/wheezy install Official CD Binary-1
#http://www.debian.org/CD/http-ftp/#stable
elif [ "$(grep '^Debian GNU/Linux .* - Official .* Binary-1' /tmp/multisystem/multisystem-mountpoint-iso/.disk/info 2>/dev/null)" ]; then
modiso="copycontent"
echo "debian1" >/tmp/multisystem/multisystem-nomdebian
chemindeb="$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/debian"
find "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")" -maxdepth 1 -path "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/debian[0-9]" | while read line
do
echo "debian$(($(echo $line | sed "s@${chemindeb}@@g")+1))" >/tmp/multisystem/multisystem-nomdebian
done
osname="$(cat /tmp/multisystem/multisystem-nomdebian)"
osnamemodif=""
osicone="multisystem-debian"
unset debiancodename
#Codename: squeeze
[ "$(grep 'Codename: squeeze' /tmp/multisystem/multisystem-mountpoint-iso/dists/squeeze/Release 2>/dev/null)" ] && debiancodename="squeeze"
#Codename: wheezy
[ "$(grep 'Codename: wheezy' /tmp/multisystem/multisystem-mountpoint-iso/dists/wheezy/Release 2>/dev/null)" ] && debiancodename="wheezy"
if [ ! "${debiancodename}" ]; then
zenity --error --text "Erreur: Codename: ?"
FCT_RELOAD
exit 0
fi
debianarch="$(cat /tmp/multisystem/multisystem-mountpoint-iso/dists/${debiancodename}/Release 2>/dev/null | grep 'Architectures: ' | cut -d " " -f2)"
if [ ! "${debianarch}" ]; then
zenity --error --text "Erreur: Architectures: ?"
FCT_RELOAD
exit 0
fi
debianinit="$(grep ' initrd=/install.*initrd.gz ' -h -o -R /tmp/multisystem/multisystem-mountpoint-iso/isolinux 2>/dev/null | head -1 | cut -d"/" -f2)"
if [ ! "${debianinit}" ]; then
zenity --error --text "Erreur: debianinit: ?"
FCT_RELOAD
exit 0
fi
#gnome kde lxde xfce
if [[ -d "/tmp/multisystem/multisystem-mountpoint-iso/isolinux/kde" \
&& -d "/tmp/multisystem/multisystem-mountpoint-iso/isolinux/lxde" \
&& -d "/tmp/multisystem/multisystem-mountpoint-iso/isolinux/xfce" ]]; then
#Menu Gnome
ligne1="menuentry \"Debian ${debiancodename} gnome install ${debianarch}\" {"
ligne2=""
ligne3="linux /${osname}/${debianinit}/vmlinuz root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) cdrom-detect/try-usb=true quiet"
ligne4="initrd /${osname}/${debianinit}/initrd.gz"
ligne5="}"
#Menu kde
ligne6="menuentry \"Debian ${debiancodename} kde install ${debianarch}\" {"
ligne7=""
ligne8="linux /${osname}/${debianinit}/vmlinuz desktop=kde root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) cdrom-detect/try-usb=true quiet"
ligne9="initrd /${osname}/${debianinit}/initrd.gz"
ligne10="}"
#Menu lxde
ligne11="menuentry \"Debian ${debiancodename} lxde install ${debianarch}\" {"
ligne12=""
ligne13="linux /${osname}/${debianinit}/vmlinuz desktop=lxde root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) cdrom-detect/try-usb=true quiet"
ligne14="initrd /${osname}/${debianinit}/initrd.gz"
ligne15="}"
#Menu xfce
ligne16="menuentry \"Debian ${debiancodename} xfce install ${debianarch}\" {"
ligne17=""
ligne18="linux /${osname}/${debianinit}/vmlinuz desktop=xfce root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) cdrom-detect/try-usb=true quiet"
ligne19="initrd /${osname}/${debianinit}/initrd.gz"
ligne20="}"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD4)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
#lxde xfce
elif [[ -d "/tmp/multisystem/multisystem-mountpoint-iso/isolinux/lxde" \
&& -d "/tmp/multisystem/multisystem-mountpoint-iso/isolinux/xfce" ]]; then
#Menu 1
ligne1="menuentry \"Debian ${debiancodename} lxde install ${debianarch}\" {"
ligne2=""
ligne3="linux /${osname}/${debianinit}/vmlinuz desktop=lxde root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) cdrom-detect/try-usb=true quiet"
ligne4="initrd /${osname}/${debianinit}/initrd.gz"
ligne5="}"
#Menu 2
ligne6="menuentry \"Debian ${debiancodename} xfce install ${debianarch}\" {"
ligne7=""
ligne8="linux /${osname}/${debianinit}/vmlinuz desktop=xfce root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) cdrom-detect/try-usb=true quiet"
ligne9="initrd /${osname}/${debianinit}/initrd.gz"
ligne10="}"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD2)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
#kde
elif [ "$(grep 'desktop=kde' /tmp/multisystem/multisystem-mountpoint-iso/isolinux/adtxt.cfg 2>/dev/null)" ]; then
osnamemodif="Debian ${debiancodename} kde install ${debianarch}"
osloopback=""
oskernel="linux /${osname}/${debianinit}/vmlinuz desktop=kde root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) cdrom-detect/try-usb=true quiet"
osinitrd="initrd /${osname}/${debianinit}/initrd.gz"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
#gnome
else
osnamemodif="Debian ${debiancodename} install ${debianarch}"
osloopback=""
oskernel="linux /${osname}/${debianinit}/vmlinuz root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) cdrom-detect/try-usb=true quiet"
osinitrd="initrd /${osname}/${debianinit}/initrd.gz"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
fi
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${osname}"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/."
#Modifier initrd de install
mkdir /tmp/multisystem/multisystem-modinitrd 2>/dev/null
cd /tmp/multisystem/multisystem-modinitrd
gzip -dc /tmp/multisystem/multisystem-mountpoint-iso/${debianinit}/initrd.gz | cpio -i
#if mount -t $type -o ro,exec $device /cdrom; then
sed -i 's@if mount -t $type -o ro,exec $device /cdrom; then@if mount -t vfat -o ro,exec /dev/disk/by-uuid/'$(cat /tmp/multisystem/multisystem-selection-uuid-usb)' /cdrom; then\n\tmount --bind /cdrom/'${osname}' /cdrom 2>/dev/null@' /tmp/multisystem/multisystem-modinitrd/var/lib/dpkg/info/cdrom-detect.postinst
sed -i 's@if mount -t $type -o $OPTIONS $device /cdrom; then@if mount -t vfat -o ro,exec /dev/disk/by-uuid/'$(cat /tmp/multisystem/multisystem-selection-uuid-usb)' /cdrom; then\n\tmount --bind /cdrom/'${osname}' /cdrom 2>/dev/null@' /tmp/multisystem/multisystem-modinitrd/var/lib/dpkg/info/cdrom-detect.postinst
#gedit /tmp/multisystem/multisystem-modinitrd/var/lib/dpkg/info/cdrom-detect.postinst
#echo Attente
#read
sudo rm "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/${debianinit}/initrd.gz"
find . | cpio -o -H newc | gzip -9 > "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/${debianinit}/initrd.gz"
cd -
rm -R /tmp/multisystem/multisystem-modinitrd

#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒/Debian-Install#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒



#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒Netboot#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
#Netboot ==> mini.iso
#http://cdimage.ubuntu.com/netboot/
elif [[ -f "/tmp/multisystem/multisystem-mountpoint-iso/linux" && -f "/tmp/multisystem/multisystem-mountpoint-iso/initrd.gz" ]]; then
osname="$(basename "${option2}")"
osicone="multisystem-ubuntu"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/linux  -- quiet"
osinitrd="initrd (loop)/initrd.gz"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒/Netboot#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒



#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒Alternate#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒

#Alternate Ubuntu et dérivés
elif [[ ! -d "/tmp/multisystem/multisystem-mountpoint-iso/casper" && "$(grep 'Origin: Ubuntu' -R /tmp/multisystem/multisystem-mountpoint-iso/dists/*/Release 2>/dev/null)" ]]; then
modiso="copycontent"
echo "ubuntu1" >/tmp/multisystem/multisystem-nomdistro
chemindeb="$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/ubuntu"
find "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")" -maxdepth 1 -path "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/ubuntu[0-9]" | while read line
do
echo "ubuntu$(($(echo $line | sed "s@${chemindeb}@@g")+1))" >/tmp/multisystem/multisystem-nomdistro
done
osname="$(cat /tmp/multisystem/multisystem-nomdistro)"
if [ "$(grep -i i386 /tmp/multisystem/multisystem-mountpoint-iso/.disk/info 2>/dev/null)" ]; then
checkarch="i386"
elif [ "$(grep -i amd64 /tmp/multisystem/multisystem-mountpoint-iso/.disk/info 2>/dev/null)" ]; then
checkarch="amd64"
else
zenity --error --text "Erreur: arch ?"
FCT_RELOAD
exit 0
fi
if [ "$(grep '/kubuntu.seed ' /tmp/multisystem/multisystem-mountpoint-iso/isolinux/t*xt.cfg 2>/dev/null)" ]; then
osicone="multisystem-kubuntu"
osnamemodif="INSTALL $(cut -d " " -f1 /tmp/multisystem/multisystem-mountpoint-iso/.disk/info) $(cut -d " " -f2 /tmp/multisystem/multisystem-mountpoint-iso/.disk/info) ${checkarch}"
elif [ "$(grep '/xubuntu.seed ' /tmp/multisystem/multisystem-mountpoint-iso/isolinux/t*xt.cfg 2>/dev/null)" ]; then
osicone="multisystem-xubuntu"
osnamemodif="INSTALL $(cut -d " " -f1 /tmp/multisystem/multisystem-mountpoint-iso/.disk/info) $(cut -d " " -f2 /tmp/multisystem/multisystem-mountpoint-iso/.disk/info) ${checkarch}"
elif [ "$(grep '/ubuntu.seed ' /tmp/multisystem/multisystem-mountpoint-iso/isolinux/t*xt.cfg 2>/dev/null)" ]; then
osicone="multisystem-ubuntu"
osnamemodif="INSTALL $(cut -d " " -f1 /tmp/multisystem/multisystem-mountpoint-iso/.disk/info) $(cut -d " " -f2 /tmp/multisystem/multisystem-mountpoint-iso/.disk/info) ${checkarch}"
#Zentyal
elif [ "$(grep 'Zentyal' /tmp/multisystem/multisystem-mountpoint-iso/isolinux/t*xt.cfg 2>/dev/null)" ]; then
osicone="multisystem-zentyal"
osnamemodif="INSTALL Zentyal ${checkarch}"
#ubuntu-server
elif [ "$(grep '/ubuntu-server.seed ' /tmp/multisystem/multisystem-mountpoint-iso/isolinux/t*xt.cfg 2>/dev/null)" ]; then
osicone="multisystem-ubuntu-server"
osnamemodif="INSTALL $(cut -d " " -f1 /tmp/multisystem/multisystem-mountpoint-iso/.disk/info) $(cut -d " " -f2 /tmp/multisystem/multisystem-mountpoint-iso/.disk/info) ${checkarch}"
elif [ "$(grep '/ubuntustudio.seed ' /tmp/multisystem/multisystem-mountpoint-iso/isolinux/t*xt.cfg 2>/dev/null)" ]; then
osicone="multisystem-ubuntu-studio"
osnamemodif="INSTALL $(cut -d " " -f1 /tmp/multisystem/multisystem-mountpoint-iso/.disk/info) $(cut -d " " -f2 /tmp/multisystem/multisystem-mountpoint-iso/.disk/info) ${checkarch}"
elif [ "$(grep '/lubuntu.seed ' /tmp/multisystem/multisystem-mountpoint-iso/isolinux/t*xt.cfg 2>/dev/null)" ]; then
osicone="multisystem-lubuntu"
osnamemodif="INSTALL $(cut -d " " -f1 /tmp/multisystem/multisystem-mountpoint-iso/.disk/info) $(cut -d " " -f2 /tmp/multisystem/multisystem-mountpoint-iso/.disk/info) ${checkarch}"
else
osicone="multisystem-ubuntu"
osnamemodif="INSTALL (generique) $(cut -d " " -f1 /tmp/multisystem/multisystem-mountpoint-iso/.disk/info) $(cut -d " " -f2 /tmp/multisystem/multisystem-mountpoint-iso/.disk/info) ${checkarch}"
fi
gen_champ="$(grep -m1 'file=.*\.seed' -o /tmp/multisystem/multisystem-mountpoint-iso/isolinux/t*xt.cfg 2>/dev/null)"
if [ ! "${gen_champ}" ]; then
zenity --error --text "Erreur: gen_champ"
FCT_RELOAD
exit 0
fi
if [ ! -f "/tmp/multisystem/multisystem-mountpoint-iso/install/initrd.gz" ]; then
zenity --error --text "Erreur: initrd"
FCT_RELOAD
exit 0
fi
if [ ! -f "/tmp/multisystem/multisystem-mountpoint-iso/install/vmlinuz" ]; then
zenity --error --text "Erreur: vmlinuz"
FCT_RELOAD
exit 0
fi
oskernel="linux /${osname}/install/vmlinuz root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) ${gen_champ} cdrom-detect/try-usb=true quiet --"
osinitrd="initrd /${osname}/install/initrd.gz"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${osname}"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/."
#Modifier ramdisk
mkdir /tmp/multisystem/multisystem-modinitrd 2>/dev/null
cd /tmp/multisystem/multisystem-modinitrd
gzip -dc /tmp/multisystem/multisystem-mountpoint-iso/install/initrd.gz | cpio -i
#Oneiric
#if mount -t $type -o $OPTIONS $device /cdrom; then
sed -i 's@if mount -t $type -o $OPTIONS $device /cdrom; then@if mount -t vfat -o ro,exec /dev/disk/by-uuid/'$(cat /tmp/multisystem/multisystem-selection-uuid-usb)' /cdrom; then\n\tmount --bind /cdrom/'${osname}' /cdrom 2>/dev/null@' /tmp/multisystem/multisystem-modinitrd/var/lib/dpkg/info/cdrom-detect.postinst
#Lucid
#if mount -t vfat -o ro,exec $device /cdrom &&
sed -i 's@if mount -t vfat -o ro,exec $device /cdrom \&\&@if mount -t vfat -o ro,exec /dev/disk/by-uuid/'$(cat /tmp/multisystem/multisystem-selection-uuid-usb)' /cdrom \&\& mount --bind /cdrom/'${osname}' /cdrom 2>/dev/null \&\&@' /tmp/multisystem/multisystem-modinitrd/var/lib/dpkg/info/cdrom-detect.postinst
#gedit /tmp/multisystem/multisystem-modinitrd/var/lib/dpkg/info/cdrom-detect.postinst
#echo Attente1
##read
sudo rm "$(cat /tmp/multisystem/multisystem-mountpoint-usb)"/${osname}/install/initrd.gz
find . | cpio -o -H newc | gzip -9 > "$(cat /tmp/multisystem/multisystem-mountpoint-usb)"/${osname}/install/initrd.gz
cd -
sudo rm -R /tmp/multisystem/multisystem-modinitrd

#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒/Alternate#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒



#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒hardy#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
#Ubuntu 8.* "Hardy Heron"
#http://releases.ubuntu.com/hardy/
elif [ "$(grep 'Ubuntu 8.* "Hardy Heron"' /tmp/multisystem/multisystem-mountpoint-iso/.disk/info 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osicone="multisystem-ubuntu"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/casper/vmlinuz locale=$(echo "${LANG}" | sed "s/\..*//") bootkbd=${XKBLAYOUT} console-setup/layoutcode=${XKBLAYOUT} console-setup/variantcode=${XKBVARIANT} iso-scan/filename=/${osname} boot=casper file=/cdrom/preseed/ubuntu.seed noprompt quiet splash --"
osinitrd="initrd (loop)/casper/initrd.gz"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#Kubuntu 8.* "Hardy Heron"
#http://releases.ubuntu.com/kubuntu/hardy/
elif [ "$(grep 'Kubuntu 8.* "Hardy Heron"' /tmp/multisystem/multisystem-mountpoint-iso/.disk/info 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osicone="multisystem-kubuntu"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/casper/vmlinuz locale=$(echo "${LANG}" | sed "s/\..*//") bootkbd=${XKBLAYOUT} console-setup/layoutcode=${XKBLAYOUT} console-setup/variantcode=${XKBVARIANT} iso-scan/filename=/${osname} boot=casper file=/cdrom/preseed/kubuntu.seed noprompt quiet splash --"
osinitrd="initrd (loop)/casper/initrd.gz"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#Xubuntu 8.* "Hardy Heron"
#http://cdimage.ubuntu.com/xubuntu/releases/hardy/
elif [ "$(grep 'Xubuntu 8.* "Hardy Heron"' /tmp/multisystem/multisystem-mountpoint-iso/.disk/info 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osicone="multisystem-xubuntu"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/casper/vmlinuz locale=$(echo "${LANG}" | sed "s/\..*//") bootkbd=${XKBLAYOUT} console-setup/layoutcode=${XKBLAYOUT} console-setup/variantcode=${XKBVARIANT} iso-scan/filename=/${osname} boot=casper file=/cdrom/preseed/xubuntu.seed noprompt quiet splash --"
osinitrd="initrd (loop)/casper/initrd.gz"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒/hardy#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒



#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒intrepid#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
#Ubuntu 8.10 "Intrepid Ibex"
#http://releases.ubuntu.com/intrepid/
elif [ "$(grep 'Ubuntu 8.10 "Intrepid Ibex"' /tmp/multisystem/multisystem-mountpoint-iso/.disk/info 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osicone="multisystem-ubuntu"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/casper/vmlinuz locale=$(echo "${LANG}" | sed "s/\..*//") bootkbd=${XKBLAYOUT} console-setup/layoutcode=${XKBLAYOUT} console-setup/variantcode=${XKBVARIANT} iso-scan/filename=/${osname} boot=casper file=/cdrom/preseed/ubuntu.seed noprompt quiet splash --"
osinitrd="initrd (loop)/casper/initrd.gz"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#Kubuntu 8.10 "Intrepid Ibex"
#http://releases.ubuntu.com/kubuntu/intrepid/
elif [ "$(grep 'Kubuntu 8.10 "Intrepid Ibex"' /tmp/multisystem/multisystem-mountpoint-iso/.disk/info 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osicone="multisystem-kubuntu"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/casper/vmlinuz locale=$(echo "${LANG}" | sed "s/\..*//") bootkbd=${XKBLAYOUT} console-setup/layoutcode=${XKBLAYOUT} console-setup/variantcode=${XKBVARIANT} iso-scan/filename=/${osname} boot=casper file=/cdrom/preseed/kubuntu.seed noprompt quiet splash --"
osinitrd="initrd (loop)/casper/initrd.gz"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#Xubuntu 8.10 "Intrepid Ibex"
#http://cdimage.ubuntu.com/xubuntu/releases/intrepid/
elif [ "$(grep 'Xubuntu 8.10 "Intrepid Ibex"' /tmp/multisystem/multisystem-mountpoint-iso/.disk/info 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osicone="multisystem-xubuntu"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/casper/vmlinuz locale=$(echo "${LANG}" | sed "s/\..*//") bootkbd=${XKBLAYOUT} console-setup/layoutcode=${XKBLAYOUT} console-setup/variantcode=${XKBVARIANT} iso-scan/filename=/${osname} boot=casper file=/cdrom/preseed/xubuntu.seed noprompt quiet splash --"
osinitrd="initrd (loop)/casper/initrd.gz"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒/intrepid#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒



#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒Jaunty#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
#Ubuntu 9.04 "Jaunty Jackalope"
#http://releases.ubuntu.com/jaunty/
elif [ "$(grep 'Ubuntu 9.04 "Jaunty Jackalope"' /tmp/multisystem/multisystem-mountpoint-iso/.disk/info 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osicone="multisystem-ubuntu"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/casper/vmlinuz locale=$(echo "${LANG}" | sed "s/\..*//") bootkbd=${XKBLAYOUT} console-setup/layoutcode=${XKBLAYOUT} console-setup/variantcode=${XKBVARIANT} iso-scan/filename=/${osname} boot=casper file=/cdrom/preseed/ubuntu.seed noprompt quiet splash --"
osinitrd="initrd (loop)/casper/initrd.gz"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#Kubuntu 9.04 "Jaunty Jackalope"
#http://releases.ubuntu.com/kubuntu/jaunty/
elif [ "$(grep 'Kubuntu 9.04 "Jaunty Jackalope"' /tmp/multisystem/multisystem-mountpoint-iso/.disk/info 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osicone="multisystem-kubuntu"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/casper/vmlinuz locale=$(echo "${LANG}" | sed "s/\..*//") bootkbd=${XKBLAYOUT} console-setup/layoutcode=${XKBLAYOUT} console-setup/variantcode=${XKBVARIANT} iso-scan/filename=/${osname} boot=casper file=/cdrom/preseed/kubuntu.seed noprompt quiet splash --"
osinitrd="initrd (loop)/casper/initrd.gz"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#Xubuntu 9.04 "Jaunty Jackalope"
#http://cdimage.ubuntu.com/xubuntu/releases/jaunty/
elif [ "$(grep 'Xubuntu 9.04 "Jaunty Jackalope"' /tmp/multisystem/multisystem-mountpoint-iso/.disk/info 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osicone="multisystem-xubuntu"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/casper/vmlinuz locale=$(echo "${LANG}" | sed "s/\..*//") bootkbd=${XKBLAYOUT} console-setup/layoutcode=${XKBLAYOUT} console-setup/variantcode=${XKBVARIANT} iso-scan/filename=/${osname} boot=casper file=/cdrom/preseed/xubuntu.seed noprompt quiet splash --"
osinitrd="initrd (loop)/casper/initrd.gz"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#Ubuntu-Netbook-Remix 9.04 "Jaunty Jackalope"
#http://ftp.oleane.net/ubuntu-cd/jaunty/ubuntu-9.04-netbook-remix-i386.img
#http://cdimage.ubuntu.com/ubuntu-netbook-remix/
elif [ "$(grep 'Ubuntu-Netbook-Remix 9.04 "Jaunty Jackalope"' /tmp/multisystem/multisystem-mountpoint-iso/.disk/info 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osicone="multisystem-ubuntu"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/casper/vmlinuz locale=$(echo "${LANG}" | sed "s/\..*//") bootkbd=${XKBLAYOUT} console-setup/layoutcode=${XKBLAYOUT} console-setup/variantcode=${XKBVARIANT} iso-scan/filename=/${osname} boot=casper file=/cdrom/preseed/netbook-remix.seed noprompt quiet splash --"
osinitrd="initrd /boot/bootdistro/unr/initrd.gz"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/bootdistro/unr"
mkdir /tmp/multisystem/multisystem-modinitrd 2>/dev/null
cd /tmp/multisystem/multisystem-modinitrd
gzip -dc /tmp/multisystem/multisystem-mountpoint-iso/casper/initrd.gz | cpio -i
cp "${dossier}/divers/lupin-jaunty/05mountpoints_lupin" /tmp/multisystem/multisystem-modinitrd/scripts/casper-bottom/05mountpoints_lupin
cp "${dossier}/divers/lupin-jaunty/10custom_installation" /tmp/multisystem/multisystem-modinitrd/scripts/casper-bottom/10custom_installation
cp "${dossier}/divers/lupin-jaunty/10ntfs_3g" /tmp/multisystem/multisystem-modinitrd/scripts/casper-bottom/10ntfs_3g
cp "${dossier}/divers/lupin-jaunty/20iso_scan" /tmp/multisystem/multisystem-modinitrd/scripts/casper-premount/20iso_scan
cp "${dossier}/divers/lupin-jaunty/30custom_installation" /tmp/multisystem/multisystem-modinitrd/scripts/casper-premount/30custom_installation
cp "${dossier}/divers/lupin-jaunty/lupin-helpers" /tmp/multisystem/multisystem-modinitrd/scripts/lupin-helpers
find . | cpio -o -H newc | gzip -9 > "$(cat /tmp/multisystem/multisystem-mountpoint-usb)"/boot/bootdistro/unr/initrd.gz
cd -
rm -R /tmp/multisystem/multisystem-modinitrd

#Ubuntu 9.04 "Jaunty Jackalope Rescue Remix"
##http://ubuntu-rescue-remix.org/Download
elif [ "$(grep 'Ubuntu 9.04 "Jaunty Jackalope Rescue Remix"' /tmp/multisystem/multisystem-mountpoint-iso/.disk/info 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osicone="multisystem-ubuntu-rescue-remix"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/casper/vmlinuz locale=$(echo "${LANG}" | sed "s/\..*//") bootkbd=${XKBLAYOUT} console-setup/layoutcode=${XKBLAYOUT} console-setup/variantcode=${XKBVARIANT} iso-scan/filename=/${osname} boot=casper file=/cdrom/preseed/ubuntu.seed noprompt quiet splash --"
osinitrd="initrd (loop)/casper/initrd.gz"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒/Jaunty#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒


#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒Karmic#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
#Ubuntu 9.10 "Karmic Koala"
#http://cdimage.ubuntu.com/daily-live/current/
elif [ "$(grep 'Ubuntu 9.10 "Karmic Koala"' /tmp/multisystem/multisystem-mountpoint-iso/.disk/info 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osicone="multisystem-ubuntu"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/casper/vmlinuz locale=$(echo "${LANG}" | sed "s/\..*//") bootkbd=${XKBLAYOUT} console-setup/layoutcode=${XKBLAYOUT} console-setup/variantcode=${XKBVARIANT} iso-scan/filename=/${osname} boot=casper file=/cdrom/preseed/ubuntu.seed noprompt quiet splash --"
osinitrd="initrd (loop)/casper/initrd.lz"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#Kubuntu 9.10 "Karmic Koala"
#http://cdimage.ubuntu.com/kubuntu/
elif [ "$(grep 'Kubuntu 9.10 "Karmic Koala"' /tmp/multisystem/multisystem-mountpoint-iso/.disk/info 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osicone="multisystem-kubuntu"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/casper/vmlinuz locale=$(echo "${LANG}" | sed "s/\..*//") bootkbd=${XKBLAYOUT} console-setup/layoutcode=${XKBLAYOUT} console-setup/variantcode=${XKBVARIANT} iso-scan/filename=/${osname} boot=casper file=/cdrom/preseed/kubuntu.seed noprompt quiet splash --"
osinitrd="initrd (loop)/casper/initrd.lz"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#Xubuntu 9.10 "Karmic Koala"
#http://cdimage.ubuntu.com/xubuntu/
elif [ "$(grep 'Xubuntu 9.10 "Karmic Koala"' /tmp/multisystem/multisystem-mountpoint-iso/.disk/info 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osicone="multisystem-xubuntu"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/casper/vmlinuz locale=$(echo "${LANG}" | sed "s/\..*//") bootkbd=${XKBLAYOUT} console-setup/layoutcode=${XKBLAYOUT} console-setup/variantcode=${XKBVARIANT} iso-scan/filename=/${osname} boot=casper file=/cdrom/preseed/xubuntu.seed noprompt quiet splash --"
osinitrd="initrd (loop)/casper/initrd.lz"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#Ubuntu-Moblin-Remix 9.10 "Karmic Koala"
#http://cdimage.ubuntu.com/ubuntu-moblin-remix/
elif [ "$(grep 'Ubuntu-Moblin-Remix 9.10 "Karmic Koala"' /tmp/multisystem/multisystem-mountpoint-iso/.disk/info 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osicone="multisystem-moblin"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/casper/vmlinuz locale=$(echo "${LANG}" | sed "s/\..*//") bootkbd=${XKBLAYOUT} console-setup/layoutcode=${XKBLAYOUT} console-setup/variantcode=${XKBVARIANT} iso-scan/filename=/${osname} boot=casper file=/cdrom/preseed/moblin-remix.seed noprompt quiet splash --"
osinitrd="initrd (loop)/casper/initrd.lz"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#Ubuntu-Netbook-Remix 9.10 "Karmic Koala"
#http://cdimage.ubuntu.com/ubuntu-netbook-remix/
elif [ "$(grep 'Ubuntu-Netbook-Remix 9.10 "Karmic Koala"' /tmp/multisystem/multisystem-mountpoint-iso/.disk/info 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osicone="multisystem-ubuntu"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/casper/vmlinuz locale=$(echo "${LANG}" | sed "s/\..*//") bootkbd=${XKBLAYOUT} console-setup/layoutcode=${XKBLAYOUT} console-setup/variantcode=${XKBVARIANT} iso-scan/filename=/${osname} boot=casper file=/cdrom/preseed/netbook-remix.seed noprompt quiet splash --"
osinitrd="initrd (loop)/casper/initrd.lz"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#Kubuntu-Netbook 9.10 "Karmic Koala"
#http://cdimage.ubuntu.com/kubuntu-netbook/daily-live/current/
elif [ "$(grep 'Kubuntu-Netbook 9.10 "Karmic Koala"' /tmp/multisystem/multisystem-mountpoint-iso/.disk/info 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osicone="multisystem-kubuntu"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/casper/vmlinuz locale=$(echo "${LANG}" | sed "s/\..*//") bootkbd=${XKBLAYOUT} console-setup/layoutcode=${XKBLAYOUT} console-setup/variantcode=${XKBVARIANT} iso-scan/filename=/${osname} boot=casper file=/cdrom/preseed/kubuntu-netbook.seed noprompt quiet splash --"
osinitrd="initrd (loop)/casper/initrd.lz"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒/Karmic#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒


#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒Lucid#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
#Ultimate-Edition
#http://ultimateedition.info/
elif [ "$(grep 'Start or install Ultimate Edition' /tmp/multisystem/multisystem-mountpoint-iso/isolinux/isolinux.cfg 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osicone="multisystem-ultimate-edition"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/casper/vmlinuz root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) ${ubuntu_lang} iso-scan/filename=/${osname} boot=casper file=/cdrom/preseed/ubuntu.seed noprompt quiet splash --"
osinitrd="initrd (loop)/casper/initrd.lz"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#ubuntu-rescue-remix  Ubuntu 10.04 "Lucid Lynx Remix"
##http://ubuntu-rescue-remix.org/Download
elif [ "$(grep 'http://ubuntu-rescue-remix.org' /tmp/multisystem/multisystem-mountpoint-iso/.disk/release_notes_url 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osicone="multisystem-ubunturescue"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/casper/vmlinuz root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) ${ubuntu_lang} iso-scan/filename=/${osname} boot=casper file=/cdrom/preseed/ubuntu.seed noprompt quiet splash --"
osinitrd="initrd (loop)/casper/initrd.lz"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#Ubuntu 10.04 "Lucid Lynx"
#http://cdimage.ubuntu.com/daily-live/current/
elif [ "$(grep 'Ubuntu 10.04.*"Lucid Lynx"' /tmp/multisystem/multisystem-mountpoint-iso/.disk/info 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osicone="multisystem-ubuntu"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/casper/vmlinuz root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) ${ubuntu_lang} iso-scan/filename=/${osname} boot=casper file=/cdrom/preseed/ubuntu.seed noprompt quiet splash --"
osinitrd="initrd (loop)/casper/initrd.lz"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#Kubuntu 10.04 "Lucid Lynx"
#http://cdimage.ubuntu.com/kubuntu/
elif [ "$(grep 'Kubuntu 10.04.*"Lucid Lynx"' /tmp/multisystem/multisystem-mountpoint-iso/.disk/info 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osicone="multisystem-kubuntu"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/casper/vmlinuz root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) ${ubuntu_lang} iso-scan/filename=/${osname} boot=casper file=/cdrom/preseed/kubuntu.seed noprompt quiet splash --"
osinitrd="initrd (loop)/casper/initrd.lz"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#Xubuntu 10.04 "Lucid Lynx"
#http://cdimage.ubuntu.com/xubuntu/
elif [ "$(grep 'Xubuntu 10.04.*"Lucid Lynx"' /tmp/multisystem/multisystem-mountpoint-iso/.disk/info 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osicone="multisystem-xubuntu"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/casper/vmlinuz root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) ${ubuntu_lang} iso-scan/filename=/${osname} boot=casper file=/cdrom/preseed/xubuntu.seed noprompt quiet splash --"
osinitrd="initrd (loop)/casper/initrd.lz"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#Ubuntu-Moblin-Remix 10.04 "Lucid Lynx"
#http://cdimage.ubuntu.com/ubuntu-moblin-remix/
elif [ "$(grep 'Ubuntu-Moblin-Remix 10.04.*"Lucid Lynx"' /tmp/multisystem/multisystem-mountpoint-iso/.disk/info 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osicone="multisystem-moblin"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/casper/vmlinuz root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) ${ubuntu_lang} iso-scan/filename=/${osname} boot=casper file=/cdrom/preseed/moblin-remix.seed noprompt quiet splash --"
osinitrd="initrd (loop)/casper/initrd.lz"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#Ubuntu-Netbook-Remix 10.04 "Lucid Lynx"
#http://cdimage.ubuntu.com/ubuntu-netbook-remix/
elif [ "$(grep 'Ubuntu-Netbook 10.04.*"Lucid Lynx"' /tmp/multisystem/multisystem-mountpoint-iso/.disk/info 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osicone="multisystem-ubuntu"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/casper/vmlinuz root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) ${ubuntu_lang} iso-scan/filename=/${osname} boot=casper file=/cdrom/preseed/$(sed -n 's/.*cdrom\/preseed\/\(.*\)\.seed.*/\1/p' /tmp/multisystem/multisystem-mountpoint-iso/isolinux/text.cfg | tail -n1).seed noprompt quiet splash --"
osinitrd="initrd (loop)/casper/initrd.lz"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#Kubuntu-Netbook 10.04 "Lucid Lynx""
#http://cdimage.ubuntu.com/kubuntu-netbook/daily-live/current/
elif [ "$(grep 'Kubuntu-Netbook 10.04.*"Lucid Lynx"' /tmp/multisystem/multisystem-mountpoint-iso/.disk/info 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osicone="multisystem-kubuntu"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/casper/vmlinuz root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) ${ubuntu_lang} iso-scan/filename=/${osname} boot=casper file=/cdrom/preseed/kubuntu-netbook.seed noprompt quiet splash --"
osinitrd="initrd (loop)/casper/initrd.lz"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#Lubuntu 10.04 "Lucid Lynx"
#http://lubuntu.net/
elif [ "$(grep 'Lubuntu 10.04.*"Lucid Lynx"' /tmp/multisystem/multisystem-mountpoint-iso/.disk/info 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osicone="multisystem-lubuntu"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/casper/vmlinuz root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) ${ubuntu_lang} iso-scan/filename=/${osname} boot=casper file=/cdrom/preseed/ubuntu.seed noprompt quiet splash --"
osinitrd="initrd (loop)/casper/initrd.lz"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#Edubuntu 10.04 "Lucid Lynx"
#http://cdimage.ubuntu.com/edubuntu/releases/lucid/release/
elif [ "$(grep 'Edubuntu 10.04.*"Lucid Lynx"' /tmp/multisystem/multisystem-mountpoint-iso/.disk/info 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osicone="multisystem-edubuntu"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/casper/vmlinuz root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) ${ubuntu_lang} iso-scan/filename=/${osname} boot=casper file=/cdrom/preseed/edubuntu.seed noprompt quiet splash --"
osinitrd="initrd (loop)/casper/initrd.lz"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#Mythbuntu 10.04 LTS "Lucid Lynx"
#http://cdimage.ubuntu.com/mythbuntu/releases/
elif [ "$(grep 'Mythbuntu 10.04 LTS "Lucid Lynx"' /tmp/multisystem/multisystem-mountpoint-iso/.disk/info 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osicone="multisystem-mythbuntu"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/casper/vmlinuz root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) ${ubuntu_lang} iso-scan/filename=/${osname} boot=casper file=/cdrom/preseed/mythbuntu.seed noprompt quiet splash --"
osinitrd="initrd (loop)/casper/initrd.lz"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒/Lucid#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒


#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒Maverick#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒

#Ultimate-Edition
#http://ultimateedition.info/
elif [ "$(grep 'Ultimate Edition' /tmp/multisystem/multisystem-mountpoint-iso/isolinux/txt.cfg 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osicone="multisystem-ultimate-edition"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/casper/vmlinuz root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) ${ubuntu_lang} iso-scan/filename=/${osname} boot=casper file=/cdrom/preseed/ubuntu.seed noprompt quiet splash --"
osinitrd="initrd (loop)/casper/initrd.lz"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#Ubuntu 10.10 "Maverick Meerkat"
elif [ "$(grep '^Ubuntu 10.10 "Maverick Meerkat"' /tmp/multisystem/multisystem-mountpoint-iso/.disk/info 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osicone="multisystem-ubuntu"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/casper/vmlinuz root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) ${ubuntu_lang} iso-scan/filename=/${osname} boot=casper file=/cdrom/preseed/ubuntu.seed noprompt quiet splash --"
osinitrd="initrd (loop)/casper/initrd.lz"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#Kubuntu 10.10 "Maverick Meerkat"
elif [ "$(grep 'Kubuntu 10.10 "Maverick Meerkat"' /tmp/multisystem/multisystem-mountpoint-iso/.disk/info 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osicone="multisystem-kubuntu"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/casper/vmlinuz root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) ${ubuntu_lang} iso-scan/filename=/${osname} boot=casper file=/cdrom/preseed/kubuntu.seed noprompt quiet splash --"
osinitrd="initrd (loop)/casper/initrd.lz"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#Xubuntu 10.10 "Maverick Meerkat"
#http://cdimage.ubuntu.com/xubuntu/
elif [ "$(grep 'Xubuntu 10.10 "Maverick Meerkat"' /tmp/multisystem/multisystem-mountpoint-iso/.disk/info 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osicone="multisystem-xubuntu"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/casper/vmlinuz root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) ${ubuntu_lang} iso-scan/filename=/${osname} boot=casper file=/cdrom/preseed/xubuntu.seed noprompt quiet splash --"
osinitrd="initrd (loop)/casper/initrd.lz"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#Ubuntu-Netbook 10.10 "Maverick Meerkat"
elif [ "$(grep 'Ubuntu-Netbook 10.10 "Maverick Meerkat"' /tmp/multisystem/multisystem-mountpoint-iso/.disk/info 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osicone="multisystem-ubuntu"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/casper/vmlinuz root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) ${ubuntu_lang} iso-scan/filename=/${osname} boot=casper file=/cdrom/preseed/$(sed -n 's/.*cdrom\/preseed\/\(.*\)\.seed.*/\1/p' /tmp/multisystem/multisystem-mountpoint-iso/isolinux/text.cfg | tail -n1).seed noprompt quiet splash --"
osinitrd="initrd (loop)/casper/initrd.lz"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#Kubuntu-Netbook 10.10 "Maverick Meerkat"
elif [ "$(grep 'Kubuntu-Netbook 10.10 "Maverick Meerkat"' /tmp/multisystem/multisystem-mountpoint-iso/.disk/info 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osicone="multisystem-kubuntu"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/casper/vmlinuz root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) ${ubuntu_lang} iso-scan/filename=/${osname} boot=casper file=/cdrom/preseed/kubuntu-netbook.seed noprompt quiet splash --"
osinitrd="initrd (loop)/casper/initrd.lz"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#Kubuntu-Mobile 10.10 "Maverick Meerkat"
elif [ "$(grep 'Kubuntu-Mobile 10.10 "Maverick Meerkat"' /tmp/multisystem/multisystem-mountpoint-iso/.disk/info 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osicone="multisystem-kubuntu"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/casper/vmlinuz root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) ${ubuntu_lang} iso-scan/filename=/${osname} boot=casper noprompt quiet splash --"
osinitrd="initrd (loop)/casper/initrd.lz"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#Edubuntu 10.10 "Maverick Meerkat"
elif [ "$(grep 'Edubuntu 10.10 "Maverick Meerkat"' /tmp/multisystem/multisystem-mountpoint-iso/.disk/info 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osicone="multisystem-edubuntu"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/casper/vmlinuz root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) ${ubuntu_lang} iso-scan/filename=/${osname} boot=casper file=/cdrom/preseed/edubuntu.seed noprompt quiet splash --"
osinitrd="initrd (loop)/casper/initrd.lz"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#Mythbuntu 10.10 "Maverick Meerkat"
#http://cdimage.ubuntu.com/mythbuntu/releases/
elif [ "$(grep 'Mythbuntu 10.10 "Maverick Meerkat"' /tmp/multisystem/multisystem-mountpoint-iso/.disk/info 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osicone="multisystem-mythbuntu"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/casper/vmlinuz root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) ${ubuntu_lang} iso-scan/filename=/${osname} boot=casper file=/cdrom/preseed/mythbuntu.seed noprompt quiet splash --"
osinitrd="initrd (loop)/casper/initrd.lz"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#Lubuntu 10.10 "Maverick Meerkat"
elif [ "$(grep 'Lubuntu 10.10 "Maverick Meerkat"' /tmp/multisystem/multisystem-mountpoint-iso/.disk/info 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osicone="multisystem-lubuntu"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/casper/vmlinuz root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) ${ubuntu_lang} iso-scan/filename=/${osname} boot=casper file=/cdrom/preseed/ubuntu.seed noprompt quiet splash --"
osinitrd="initrd (loop)/casper/initrd.lz"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒/Maverick#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒


#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒Natty_Narwhal#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒

#UbuntuRescueRemix (kernel panic?)
#http://ubuntu-rescue-remix.org/Download
elif [ "$(grep '^Ubuntu 11.04 "Natty Remix"' /tmp/multisystem/multisystem-mountpoint-iso/.disk/info 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osicone="multisystem-ubuntu-rescue-remix"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/casper/vmlinuz root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) ${ubuntu_lang} iso-scan/filename=/${osname} boot=casper file=/cdrom/preseed/ubuntu.seed noprompt quiet splash --"
osinitrd="initrd (loop)/casper/initrd.lz"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#Ubuntu 11.04 "Natty Narwhal"
elif [ "$(grep '^Ubuntu 11.04 "Natty Narwhal"' /tmp/multisystem/multisystem-mountpoint-iso/.disk/info 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osicone="multisystem-ubuntu"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/casper/vmlinuz root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) ${ubuntu_lang} iso-scan/filename=/${osname} boot=casper file=/cdrom/preseed/ubuntu.seed noprompt quiet splash --"
osinitrd="initrd (loop)/casper/initrd.lz"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#Kubuntu 11.04 "Natty Narwhal"
elif [ "$(grep 'Kubuntu 11.04 "Natty Narwhal"' /tmp/multisystem/multisystem-mountpoint-iso/.disk/info 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osicone="multisystem-kubuntu"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/casper/vmlinuz root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) ${ubuntu_lang} iso-scan/filename=/${osname} boot=casper file=/cdrom/preseed/kubuntu.seed noprompt quiet splash --"
osinitrd="initrd (loop)/casper/initrd.lz"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#Xubuntu 11.04 "Natty Narwhal"
#http://cdimage.ubuntu.com/xubuntu/
elif [ "$(grep 'Xubuntu 11.04 "Natty Narwhal"' /tmp/multisystem/multisystem-mountpoint-iso/.disk/info 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osicone="multisystem-xubuntu"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/casper/vmlinuz root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) ${ubuntu_lang} iso-scan/filename=/${osname} boot=casper file=/cdrom/preseed/xubuntu.seed noprompt quiet splash --"
osinitrd="initrd (loop)/casper/initrd.lz"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#Ubuntu-Netbook 11.04 "Natty Narwhal"
elif [ "$(grep 'Ubuntu-Netbook 11.04 "Natty Narwhal"' /tmp/multisystem/multisystem-mountpoint-iso/.disk/info 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osicone="multisystem-ubuntu"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/casper/vmlinuz root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) ${ubuntu_lang} iso-scan/filename=/${osname} boot=casper file=/cdrom/preseed/$(sed -n 's/.*cdrom\/preseed\/\(.*\)\.seed.*/\1/p' /tmp/multisystem/multisystem-mountpoint-iso/isolinux/text.cfg | tail -n1).seed noprompt quiet splash --"
osinitrd="initrd (loop)/casper/initrd.lz"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#Kubuntu-Netbook 11.04 "Natty Narwhal"
elif [ "$(grep 'Kubuntu-Netbook 11.04 "Natty Narwhal"' /tmp/multisystem/multisystem-mountpoint-iso/.disk/info 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osicone="multisystem-kubuntu"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/casper/vmlinuz root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) ${ubuntu_lang} iso-scan/filename=/${osname} boot=casper file=/cdrom/preseed/kubuntu-netbook.seed noprompt quiet splash --"
osinitrd="initrd (loop)/casper/initrd.lz"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#Kubuntu-Mobile 11.04 "Natty Narwhal"
elif [ "$(grep 'Kubuntu-Mobile 11.04 "Natty Narwhal"' /tmp/multisystem/multisystem-mountpoint-iso/.disk/info 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osicone="multisystem-kubuntu"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/casper/vmlinuz root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) ${ubuntu_lang} iso-scan/filename=/${osname} boot=casper noprompt quiet splash --"
osinitrd="initrd (loop)/casper/initrd.lz"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#Edubuntu 11.04 "Natty Narwhal"
elif [ "$(grep 'Edubuntu 11.04 "Natty Narwhal"' /tmp/multisystem/multisystem-mountpoint-iso/.disk/info 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osicone="multisystem-edubuntu"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/casper/vmlinuz root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) ${ubuntu_lang} iso-scan/filename=/${osname} boot=casper file=/cdrom/preseed/edubuntu.seed noprompt quiet splash --"
osinitrd="initrd (loop)/casper/initrd.lz"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#Mythbuntu 11.04 "Natty Narwhal"
#http://cdimage.ubuntu.com/mythbuntu/releases/
elif [ "$(grep 'Mythbuntu 11.04 "Natty Narwhal"' /tmp/multisystem/multisystem-mountpoint-iso/.disk/info 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osicone="multisystem-mythbuntu"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/casper/vmlinuz root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) ${ubuntu_lang} iso-scan/filename=/${osname} boot=casper file=/cdrom/preseed/mythbuntu.seed noprompt quiet splash --"
osinitrd="initrd (loop)/casper/initrd.lz"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#Lubuntu 11.04 "Natty Narwhal"
elif [ "$(grep 'Lubuntu 11.04 "Natty Narwhal"' /tmp/multisystem/multisystem-mountpoint-iso/.disk/info 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osicone="multisystem-lubuntu"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/casper/vmlinuz root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) ${ubuntu_lang} iso-scan/filename=/${osname} boot=casper file=/cdrom/preseed/ubuntu.seed noprompt quiet splash --"
osinitrd="initrd (loop)/casper/initrd.lz"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒/Natty_Narwhal#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒


#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒Oneiric Ocelot▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒

#http://ubuntu-rescue-remix.org/Download
elif [ "$(grep 'Ubuntu Remix Live CD' /tmp/multisystem/multisystem-mountpoint-iso/isolinux/isolinux.txt 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osicone="multisystem-ubuntu-rescue-remix"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/casper/vmlinuz root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) ${ubuntu_lang} iso-scan/filename=/${osname} boot=casper file=/cdrom/preseed/ubuntu.seed noprompt quiet splash --"
osinitrd="initrd (loop)/casper/initrd.gz"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#Ubuntu 11.10 "Oneiric Ocelot"
elif [ "$(grep '^Ubuntu 11.10 "Oneiric Ocelot"' /tmp/multisystem/multisystem-mountpoint-iso/.disk/info 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osicone="multisystem-ubuntu"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/casper/vmlinuz root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) ${ubuntu_lang} iso-scan/filename=/${osname} boot=casper file=/cdrom/preseed/ubuntu.seed noprompt quiet splash --"
osinitrd="initrd (loop)/casper/initrd.lz"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#Kubuntu 11.10 "Oneiric Ocelot"
elif [ "$(grep 'Kubuntu 11.10 "Oneiric Ocelot"' /tmp/multisystem/multisystem-mountpoint-iso/.disk/info 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osicone="multisystem-kubuntu"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/casper/vmlinuz root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) ${ubuntu_lang} iso-scan/filename=/${osname} boot=casper file=/cdrom/preseed/kubuntu.seed noprompt quiet splash --"
osinitrd="initrd (loop)/casper/initrd.lz"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#Xubuntu 11.10 "Oneiric Ocelot"
#http://cdimage.ubuntu.com/xubuntu/
elif [ "$(grep 'Xubuntu 11.10 "Oneiric Ocelot"' /tmp/multisystem/multisystem-mountpoint-iso/.disk/info 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osicone="multisystem-xubuntu"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/casper/vmlinuz root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) ${ubuntu_lang} iso-scan/filename=/${osname} boot=casper file=/cdrom/preseed/xubuntu.seed noprompt quiet splash --"
osinitrd="initrd (loop)/casper/initrd.lz"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#Kubuntu-Mobile 11.10 "Oneiric Ocelot"
elif [ "$(grep 'Kubuntu-Mobile 11.10 "Oneiric Ocelot"' /tmp/multisystem/multisystem-mountpoint-iso/.disk/info 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osicone="multisystem-kubuntu"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/casper/vmlinuz root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) ${ubuntu_lang} iso-scan/filename=/${osname} boot=casper noprompt quiet splash --"
osinitrd="initrd (loop)/casper/initrd.lz"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#Edubuntu 11.10 "Oneiric Ocelot"
elif [ "$(grep 'Edubuntu 11.10 "Oneiric Ocelot"' /tmp/multisystem/multisystem-mountpoint-iso/.disk/info 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osicone="multisystem-edubuntu"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/casper/vmlinuz root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) ${ubuntu_lang} iso-scan/filename=/${osname} boot=casper file=/cdrom/preseed/edubuntu.seed noprompt quiet splash --"
osinitrd="initrd (loop)/casper/initrd.lz"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#Mythbuntu 11.10 "Oneiric Ocelot"
#http://cdimage.ubuntu.com/mythbuntu/releases/
elif [ "$(grep 'Mythbuntu 11.10 "Oneiric Ocelot"' /tmp/multisystem/multisystem-mountpoint-iso/.disk/info 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osicone="multisystem-mythbuntu"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/casper/vmlinuz root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) ${ubuntu_lang} iso-scan/filename=/${osname} boot=casper file=/cdrom/preseed/mythbuntu.seed noprompt quiet splash --"
osinitrd="initrd (loop)/casper/initrd.lz"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#Lubuntu 11.10 "Oneiric Ocelot"
elif [ "$(grep 'Lubuntu 11.10 "Oneiric Ocelot"' /tmp/multisystem/multisystem-mountpoint-iso/.disk/info 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osicone="multisystem-lubuntu"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/casper/vmlinuz root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) ${ubuntu_lang} iso-scan/filename=/${osname} boot=casper file=/cdrom/preseed/ubuntu.seed noprompt quiet splash --"
osinitrd="initrd (loop)/casper/initrd.lz"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#ubuntu-fr
#http://miroirs.ubuntu-fr.org/11.10/
elif [ "$(grep '^Ubuntu 11.10 "Oneiric"' /tmp/multisystem/multisystem-mountpoint-iso/.disk/info 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osicone="multisystem-ubuntu"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/casper/vmlinuz root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) ${ubuntu_lang} iso-scan/filename=/${osname} boot=casper file=/cdrom/preseed/ubuntu.seed noprompt quiet splash --"
osinitrd="initrd (loop)/casper/initrd.lz"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒/Oneiric Ocelot▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒



#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒Precise Pangolin▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒

#Ubuntu 12.04 LTS "Precise Pangolin" 
elif [ "$(grep '^Ubuntu 12.04.*"Precise Pangolin"' /tmp/multisystem/multisystem-mountpoint-iso/.disk/info 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osicone="multisystem-ubuntu"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/casper/vmlinuz root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) ${ubuntu_lang} iso-scan/filename=/${osname} boot=casper file=/cdrom/preseed/ubuntu.seed noprompt quiet splash --"
osinitrd="initrd (loop)/casper/initrd.lz"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#Kubuntu 12.04 "Precise Pangolin"
elif [ "$(grep 'Kubuntu 12.04.*"Precise Pangolin"' /tmp/multisystem/multisystem-mountpoint-iso/.disk/info 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osicone="multisystem-kubuntu"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/casper/vmlinuz root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) ${ubuntu_lang} iso-scan/filename=/${osname} boot=casper file=/cdrom/preseed/kubuntu.seed noprompt quiet splash --"
osinitrd="initrd (loop)/casper/initrd.lz"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#Xubuntu 12.04 "Precise Pangolin"
#http://cdimage.ubuntu.com/xubuntu/
elif [ "$(grep 'Xubuntu 12.04.*"Precise Pangolin"' /tmp/multisystem/multisystem-mountpoint-iso/.disk/info 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osicone="multisystem-xubuntu"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/casper/vmlinuz root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) ${ubuntu_lang} iso-scan/filename=/${osname} boot=casper file=/cdrom/preseed/xubuntu.seed noprompt quiet splash --"
osinitrd="initrd (loop)/casper/initrd.lz"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#Kubuntu-Mobile 12.04 "Precise Pangolin"
elif [ "$(grep 'Kubuntu-Mobile.*12.04 "Precise Pangolin"' /tmp/multisystem/multisystem-mountpoint-iso/.disk/info 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osicone="multisystem-kubuntu"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/casper/vmlinuz root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) ${ubuntu_lang} iso-scan/filename=/${osname} boot=casper noprompt quiet splash --"
osinitrd="initrd (loop)/casper/initrd.lz"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#Edubuntu 12.04 "Precise Pangolin"
elif [ "$(grep 'Edubuntu 12.04.*"Precise Pangolin"' /tmp/multisystem/multisystem-mountpoint-iso/.disk/info 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osicone="multisystem-edubuntu"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/casper/vmlinuz root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) ${ubuntu_lang} iso-scan/filename=/${osname} boot=casper file=/cdrom/preseed/edubuntu.seed noprompt quiet splash --"
osinitrd="initrd (loop)/casper/initrd.lz"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#Mythbuntu 12.04 "Precise Pangolin"
#http://cdimage.ubuntu.com/mythbuntu/releases/
elif [ "$(grep 'Mythbuntu 12.04.*"Precise Pangolin"' /tmp/multisystem/multisystem-mountpoint-iso/.disk/info 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osicone="multisystem-mythbuntu"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/casper/vmlinuz root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) ${ubuntu_lang} iso-scan/filename=/${osname} boot=casper file=/cdrom/preseed/mythbuntu.seed noprompt quiet splash --"
osinitrd="initrd (loop)/casper/initrd.lz"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#Lubuntu 12.04 "Precise Pangolin"
elif [ "$(grep 'Lubuntu 12.04.*"Precise Pangolin"' /tmp/multisystem/multisystem-mountpoint-iso/.disk/info 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osicone="multisystem-lubuntu"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/casper/vmlinuz root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) ${ubuntu_lang} iso-scan/filename=/${osname} boot=casper file=/cdrom/preseed/ubuntu.seed noprompt quiet splash --"
osinitrd="initrd (loop)/casper/initrd.lz"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#ubuntu-fr
#http://miroirs.ubuntu-fr.org/11.10/
elif [ "$(grep '^Ubuntu 12.04.*"Precise"' /tmp/multisystem/multisystem-mountpoint-iso/.disk/info 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osicone="multisystem-ubuntu"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/casper/vmlinuz root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) ${ubuntu_lang} iso-scan/filename=/${osname} boot=casper file=/cdrom/preseed/ubuntu.seed noprompt quiet splash --"
osinitrd="initrd (loop)/casper/initrd.lz"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#Ubuntu Studio live dvd !
#http://ubuntustudio.org/downloads
elif [ "$(grep '^Ubuntu-Studio 12.04 "Precise Pangolin"' /tmp/multisystem/multisystem-mountpoint-iso/.disk/info 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osicone="multisystem-ubuntu-studio"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/casper/vmlinuz root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) ${ubuntu_lang} iso-scan/filename=/${osname} boot=casper file=/cdrom/preseed/ubuntustudio.seed noprompt quiet splash --"
osinitrd="initrd (loop)/casper/initrd.lz"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒/Precise Pangolin▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒



#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒Quantal Quetzal▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒

#Ubuntu 12.10 "Quantal Quetzal" 
#elif [ "$(grep '^Ubuntu 12.10.*"Quantal Quetzal"' /tmp/multisystem/multisystem-mountpoint-iso/.disk/info 2>/dev/null)" ]; then

#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒/Quantal Quetzal▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒



#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒Mythbuntu#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
#NE PAS DÉPLACER!!!
#Mythbuntu
#http://cdimage.ubuntu.com/mythbuntu/releases/jaunty/
elif [ "$(grep 'Mythbuntu' /tmp/multisystem/multisystem-mountpoint-iso/.disk/info 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osicone="multisystem-mythbuntu"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/casper/vmlinuz ${ubuntu_lang} iso-scan/filename=/${osname} boot=casper file=/cdrom/preseed/mythbuntu.seed noprompt quiet splash --"
osinitrd="initrd (loop)/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*initrd*"))"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒/Mythbuntu#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒



#Base Ubuntu générique sans lupin-casper dans le ramdisk...
elif [[ ! "$(grep 'lupin-casper' /tmp/multisystem/multisystem-mountpoint-iso/casper/filesystem.manifest 2>/dev/null)" && "$(grep 'boot=casper' -R /tmp/multisystem/multisystem-mountpoint-iso/isolinux 2>/dev/null)" ]]; then
modiso="copycontent"
echo "ubuntu1" >/tmp/multisystem/multisystem-nomdistro
chemindeb="$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/ubuntu"
find "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")" -maxdepth 1 -path "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/ubuntu[0-9]" | while read line
do
echo "ubuntu$(($(echo $line | sed "s@${chemindeb}@@g")+1))" >/tmp/multisystem/multisystem-nomdistro
done
osname="$(cat /tmp/multisystem/multisystem-nomdistro)"
osnamemodif="(generic) $(basename "${option2}")"
osicone="multisystem-ubuntu"
gen_champ="$(grep -m1 'file=.*\.seed' -o /tmp/multisystem/multisystem-mountpoint-iso/isolinux/*.cfg 2>/dev/null)"
oskernel="linux /${osname}/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*vmlinuz*")) live-media-path=/${osname}/casper root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) $(sed 's%/cdrom/preseed/%/cdrom/'${osname}'/preseed/%' <<<"${gen_champ}") ${ubuntu_lang} boot=casper showmounts ignore_uuid noprompt quiet splash --"
osinitrd="initrd /${osname}/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*initrd*"))"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
mkdir -p "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${osname}"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie en cours...') \033[0m"
rsync -avS --progress /tmp/multisystem/multisystem-mountpoint-iso/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${osname}/."

#Base Ubuntu générique1
elif [ "$(grep 'boot=casper' /tmp/multisystem/multisystem-mountpoint-iso/isolinux/isolinux.cfg 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osnamemodif="(generic) $(basename "${option2}")"
osicone="multisystem-ubuntu"
gen_champ="$(grep -m1 'file=.*\.seed' -o /tmp/multisystem/multisystem-mountpoint-iso/isolinux/isolinux.cfg)"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*vmlinuz*")) root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) ${gen_champ} ${ubuntu_lang} iso-scan/filename=/${osname} boot=casper noprompt quiet splash --"
osinitrd="initrd (loop)/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*initrd*"))"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#Base Ubuntu générique2
elif [ "$(grep 'boot=casper' /tmp/multisystem/multisystem-mountpoint-iso/isolinux/text.cfg 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osnamemodif="(generic) $(basename "${option2}")"
osicone="multisystem-ubuntu"
gen_champ="$(grep -m1 'file=.*\.seed' -o /tmp/multisystem/multisystem-mountpoint-iso/isolinux/text.cfg)"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*vmlinuz*")) root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) ${gen_champ} ${ubuntu_lang} iso-scan/filename=/${osname} boot=casper noprompt quiet splash --"
osinitrd="initrd (loop)/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*initrd*"))"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#Base Ubuntu générique3 (a partir de Maverick)
elif [ "$(grep 'boot=casper' /tmp/multisystem/multisystem-mountpoint-iso/isolinux/txt.cfg 2>/dev/null)" ]; then
osname="$(basename "${option2}")"
osnamemodif="(generic) $(basename "${option2}")"
osicone="multisystem-ubuntu"
gen_champ="$(grep -m1 'file=.*\.seed' -o /tmp/multisystem/multisystem-mountpoint-iso/isolinux/txt.cfg)"
osloopback="search --set -f \"/${osname}\"\nloopback loop \"/${osname}\""
oskernel="linux (loop)/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*vmlinuz*")) root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) ${gen_champ} ${ubuntu_lang} iso-scan/filename=/${osname} boot=casper noprompt quiet splash --"
osinitrd="initrd (loop)/casper/$(basename $(find /tmp/multisystem/multisystem-mountpoint-iso/casper -iname "*initrd*"))"
sed -i "s@^#MULTISYSTEM_STOP@$(FCT_ADD)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"

#N/A pour le moment!...
else
zenity --error --text "$(eval_gettext "Erreur:iso non supporté actuellement.")"
FCT_RELOAD
exit 0
fi
