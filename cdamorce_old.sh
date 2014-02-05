#! /bin/bash
chemin="$(cd "$(dirname "$0")";pwd)/$(basename "$0")";
dossier="$(dirname "$chemin")"
export chemin dossier
cd "${dossier}"

###Pour exporter la librairie de gettext.
set -a
source gettext.sh
set +a
export TEXTDOMAIN=multisystem
export TEXTDOMAINDIR=${dossier}/locale
. gettext.sh
multisystem=$0

#par securité...
if [ -d "${dossier}/locale" ]; then

FISOLINUX="default vesamenu.c32
prompt 0
timeout 300

#pour options de syslinux voir:/usr/share/doc/syslinux/menu.txt.gz
menu color screen 37;40      #80ffffff #00000000 std
menu color border 30;44      #40000000 #00000000 std
menu color title 1;36;44    #c00090f0 #00000000 std
menu color unsel 37;44      #90ffffff #00000000 std
menu color hotkey 1;37;44    #ffffffff #00000000 std
menu color sel 7;37;40    #e0000000 #20ff8000 all
menu color hotsel 1;7;37;40  #e0400000 #20ff8000 all
menu color disabled 1;30;44    #60cccccc #00000000 std
menu color scrollbar 30;44      #40000000 #00000000 std
menu color tabmsg 31;40      #90ffff00 #00000000 std
menu color cmdmark 1;36;40    #c000ffff #00000000 std
menu color cmdline 37;40      #c0ffffff #00000000 std
menu color pwdborder 30;47      #80ffffff #20ffffff std
menu color pwdheader 31;47      #80ff8080 #20ffffff std
menu color pwdentry 30;47      #80ffffff #20ffffff std
menu color timeout_msg 37;40      #80ffffff #00000000 std
menu color timeout 1;37;40    #c0ffffff #00000000 std
menu color help 37;40      #c0ffffff #00000000 std
menu color msg07 37;40      #90ffffff #00000000 std

MENU WIDTH 80
MENU MARGIN 5
MENU PASSWORDMARGIN 3
MENU ROWS 16
MENU TABMSGROW 22
MENU CMDLINEROW 22
MENU ENDROW -1
MENU PASSWORDROW 11
MENU TIMEOUTROW 24
MENU HELPMSGROW 27
MENU HELPMSGENDROW -1
MENU HIDDENROW -2
MENU HSHIFT 0
MENU VSHIFT 0

MENU BACKGROUND /splash.png

MENU TITLE MultiSystem LiveUSB
MENU DEFAULT plp

label plp
MENU LABEL PLoP Boot Manager
linux /plpbt.bin

#LABEL kexec
#MENU LABEL kexec-loader
#KERNEL /memdisk
#APPEND initrd=/kexec.img

LABEL reboot
MENU LABEL $(eval_gettext 'Redemarrer')
TEXT HELP
$(eval_gettext 'Redemarrer votre PC')
ENDTEXT
KERNEL /reboot.c32

MENU TABMSG $(eval_gettext 'Pressez [Tab] pour afficher les options de boot')"

rm -R "/tmp/multisystem/isolinux" 2>/dev/null
mkdir "/tmp/multisystem/isolinux" 2>/dev/null
echo -e "${FISOLINUX}" >"/tmp/multisystem/isolinux/isolinux.cfg"

#Copie fichiers isolinux
if [ -f "/usr/lib/syslinux/isolinux.bin" ]; then
cp -f /usr/lib/syslinux/isolinux.bin "/tmp/multisystem/isolinux/isolinux.bin"
cp -f /usr/lib/syslinux/vesamenu.c32 "/tmp/multisystem/isolinux/vesamenu.c32"
cp -f /usr/lib/syslinux/memdisk "/tmp/multisystem/isolinux/memdisk"
cp -f /usr/lib/syslinux/reboot.c32 "/tmp/multisystem/isolinux/reboot.c32"
#pour Slitaz
else
cp -f /boot/isolinux/isolinux.bin "/tmp/multisystem/isolinux/isolinux.bin"
cp -f /boot/isolinux/reboot.c32 "/tmp/multisystem/isolinux/reboot.c32"
cp -f "${dossier}/boot/syslinux/vesamenu.c32" "/tmp/multisystem/isolinux/vesamenu.c32"
cp -f "${dossier}/boot/syslinux/memdisk" "/tmp/multisystem/isolinux/memdisk"
fi

#sur dires de didgant, ajout d'un fichier image vide dans iso,
#car certains vieux PC ont du mal si iso trop legere...
dd if=/dev/zero of="/tmp/multisystem/isolinux/vide.img" bs=1M count=64

#Image de splash
cp -f "${dossier}/boot/splash/splash.png" "/tmp/multisystem/isolinux/splash.png"

#Télécharger PloP
#####verion="plpbt-5.0.8"
#####wget http://download.plop.at/files/bootmngr/plpbt-5.0.8.zip -O /tmp/multisystem/${verion}.zip
#####cd /tmp/multisystem
#####unzip /tmp/multisystem/${verion}.zip
#####rm /tmp/multisystem/${verion}.zip
#####cp -f /tmp/multisystem/${verion}/plpbt.img "/tmp/multisystem/isolinux/plpbt.img"
#####rm -R /tmp/multisystem/${verion}
#####cd -


#Attention! PloP n'est pas libre, c'est un freeware
cp -f "$HOME"/.multisystem/nonfree/plpbt.bin "/tmp/multisystem/isolinux/plpbt.bin"

#Kexec
#http://www.solemnwarning.net/kexec-loader/download.cgi
#wget http://www.solemnwarning.net/kexec-loader/downloads/kexec-loader-2.2-floppy.img.gz -O "/tmp/multisystem/isolinux/kexec.img.gz"
#gzip -d "/tmp/multisystem/isolinux/kexec.img.gz"
#rm "/tmp/multisystem/isolinux/kexec.img.gz"

cd "/tmp/multisystem/isolinux"
genisoimage -o "$HOME/cd-boot-liveusb.iso" \
	-r -l -J -V "CD Amorce USB" -cache-inodes \
	-b isolinux.bin -c boot.cat \
	-no-emul-boot -boot-load-size 4 -boot-info-table \
	"/tmp/multisystem/isolinux"
cd -

echo -e '\E[37;44m'"\033[1m $(eval_gettext "Veuillez graver image du cd\nChemin: \$HOME/cd-boot-liveusb.iso\n(clic droit, graver sur le disque...)") \033[0m"
zenity --info --text "<b>$(eval_gettext "l\047image du cd d\047amorce est disponible,")
$(eval_gettext "Chemin"): \"$HOME/cd-boot-liveusb.iso\"
$(eval_gettext "(clic droit, graver sur le disque...)")

$(eval_gettext "Avant démarrer votre PC si besoin est,")
$(eval_gettext "insérez le CD ainsi que votre clé USB")</b>"
#xterm -title 'Qemu' -e "sudo ./qemu.sh cdamorce"
fi
exit 0
