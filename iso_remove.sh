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

#Récupérer les options
option1="$(cat /tmp/multisystem/multisystem-option1 2>/dev/null)"
option2="$(cat /tmp/multisystem/multisystem-option2 2>/dev/null)"
option3="$(cat /tmp/multisystem/multisystem-option3 2>/dev/null)"

function FCT_KILL()
{
nohup ./kill.sh&
exit 0
}

function FCT_RELOAD()
{
sync
echo "idgui:$(cat /tmp/multisystem/multisystem-idgui)"
if [ "$(cat /tmp/multisystem/multisystem-idgui)" ]; then
xdotool windowmap $(cat /tmp/multisystem/multisystem-idgui)
#activer fenetre
xdotool windowactivate $(cat /tmp/multisystem/multisystem-idgui)
wmctrl -c MultiSystem-logo
fi
}
echo -e "\E[37;44m\033[1m $(eval_gettext 'Veuillez saisir votre mot de passe d\047administrateur') \033[0m"
sudo echo


if [ "${option2}" ]; then
#chercher selection dans grub.cfg
liste="$(sed -n '/^#MULTISYSTEM_MENU_DEBUT/p' "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg" | awk -F"|" '{print "|" $2 "|" $3 "|" $4 "|" $5 "|" $6}')"
ligne="$(echo -e "${liste}" | grep "${option2}")"
paragraphe="$(sed -n "/^#MULTISYSTEM_MENU_DEBUT${ligne}$/,/^#MULTISYSTEM_MENU_FIN${ligne}$/p" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg" | grep ^#)"
paragraphe2="$(sed -n "/^#MULTISYSTEM_MENU_DEBUT${ligne}$/,/^#MULTISYSTEM_MENU_FIN${ligne}$/p" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg" | grep -v ^#)"
if [ ! "${ligne}" ]; then
#chercher selection dans menu.lst
liste="$(sed -n '/^#MULTISYSTEM_MENU_DEBUT/p' "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/menu.lst" | awk -F"|" '{print "|" $2 "|" $3 "|" $4 "|" $5 "|" $6}')"
ligne="$(echo -e "${liste}" | grep "${option2}")"
paragraphe="$(sed -n "/^#MULTISYSTEM_MENU_DEBUT${ligne}$/,/^#MULTISYSTEM_MENU_FIN${ligne}$/p" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/menu.lst" | grep ^#)"
paragraphe2="$(sed -n "/^#MULTISYSTEM_MENU_DEBUT${ligne}$/,/^#MULTISYSTEM_MENU_FIN${ligne}$/p" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/menu.lst" | grep -v ^#)"
fi
if [ ! "${ligne}" ]; then
#chercher selection dans syslinux.cfg
liste="$(sed -n '/^#MULTISYSTEM_MENU_DEBUT/p' "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/syslinux/syslinux.cfg" | awk -F"|" '{print "|" $2 "|" $3 "|" $4 "|" $5 "|" $6}')"
ligne="$(echo -e "${liste}" | grep "${option2}")"
paragraphe="$(sed -n "/^#MULTISYSTEM_MENU_DEBUT${ligne}$/,/^#MULTISYSTEM_MENU_FIN${ligne}$/p" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/syslinux/syslinux.cfg" | grep ^#)"
paragraphe2="$(sed -n "/^#MULTISYSTEM_MENU_DEBUT${ligne}$/,/^#MULTISYSTEM_MENU_FIN${ligne}$/p" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/syslinux/syslinux.cfg" | grep -v ^#)"
fi
if [ "${ligne}" ]; then
fichier="$(echo -e "${ligne}" | awk -F"|" '{print $3}')"
#zenity --info --text "nb:$(echo -e "${paragraphe}" | grep "${option2}" | wc -l)"
#zenity --info --text "liste:${liste}\n\nligne:${ligne}\n\nChamp1:$(echo "${ligne}" | awk -F"|" '{print $1 }')\nChamp2:$(echo "${ligne}" | awk -F"|" '{print $2 }')\nChamp3:$(echo "${ligne}" | awk -F"|" '{print $3 }')\nChamp4:$(echo "${ligne}" | awk -F"|" '{print $4 }')\nChamp5:$(echo "${ligne}" | awk -F"|" '{print $5 }')\nChamp6:$(echo "${ligne}" | awk -F"|" '{print $6 }')"
if [ "$(echo -e "${paragraphe}" | grep "${option2}" | wc -l)" == "2" ]; then
#Supprimer menu de grub.cfg
sed -i "/^#MULTISYSTEM_MENU_DEBUT${ligne}$/,/^#MULTISYSTEM_MENU_FIN${ligne}$/d" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
#Supprimer menu de menu.lst
sed -i "/^#MULTISYSTEM_MENU_DEBUT${ligne}$/,/^#MULTISYSTEM_MENU_FIN${ligne}$/d" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/menu.lst"
#Supprimer menu de syslinux.cfg
sed -i "/^#MULTISYSTEM_MENU_DEBUT${ligne}$/,/^#MULTISYSTEM_MENU_FIN${ligne}$/d" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/syslinux/syslinux.cfg"
#Supprimer mode persistent casper-rw
if [[ "$(echo -e "${paragraphe2}" | grep -i 'boot=casper' | grep ' persistent ')" && "$(echo "${ligne}" | awk -F"|" '{print $6 }' | grep 'persistent')" ]]; then
rm "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/casper-rw" 2>/dev/null
#Supprimer mode persistent live-rw
elif [[  "$(echo -e "${paragraphe2}" | grep -i 'live-media-path' | grep -i 'boot=live' | grep ' persistent ')" && "$(echo "${ligne}" | awk -F"|" '{print $6 }' | grep 'persistent')" ]]; then
rm "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/live-rw" 2>/dev/null
#pas persistent
else
#Effacer iso
#distro en dossier
echo


#Si est dans un sous-dossier Ophcrack LiveCD version XP et Vista
if [[ "${fichier}" && -d "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/tables/${fichier}" ]]; then
echo -e "\E[37;44m\033[1m $(eval_gettext 'Suppression du LiveCD.') \033[0m"
#Ophcrack LiveCD version XP
if [ "${fichier}" == "xp_free_small" ]; then
sudo rm -R "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/tables/xp_free_small" 2>/dev/null
fi
#Ophcrack LiveCD version Vista
if [ "${fichier}" == "vista_free" ]; then
sudo rm -R "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/tables/vista_free" 2>/dev/null
fi
#si dossier .../tables est vide le virer
if [ ! "$(ls $(cat /tmp/multisystem/multisystem-mountpoint-usb)/tables)" ]; then
sudo rm -R "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/tables" 2>/dev/null
fi


#
elif [[ "${fichier}" && -d "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${fichier}" ]]; then
echo -e "\E[37;44m\033[1m $(eval_gettext 'Suppression du LiveCD.') \033[0m"

#special UBCD4Win
if [[ "${fichier}" == "minint" && -d "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${fichier}" ]]; then
echo
if [ -f "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/PROGRAMS/XPSetupLauncher/XPSetupLauncher.exe" ]; then
#virer dossier PROGRAMS et fichiers de boot
sudo rm -R "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/PROGRAMS" 2>/dev/null
sudo rm "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/ntdetect.com" 2>/dev/null
sudo rm "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/ntldr" 2>/dev/null
fi
fi

#special ReactOS
if [[ "${fichier}" = "reactos" && -d "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${fichier}" ]]; then
#virer dossiers et fichier
sudo rm -R "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/reactos" 2>/dev/null
sudo rm -R "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/Profiles" 2>/dev/null
sudo rm -R "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/loader" 2>/dev/null
sudo rm "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/freeldr.ini" 2>/dev/null
fi

#special GDATA
if [[ "${fichier}" == "GDATA" && -d "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${fichier}" ]]; then
echo
if [ -d "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/dbase" ]; then
#virer dossier dbase
sudo rm -R "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/dbase" 2>/dev/null
fi
fi

#Win7/Vista
if [ "${fichier}" == "sources" ]; then
sudo rm -R "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/fonts" 2>/dev/null
sudo rm "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/bcd" 2>/dev/null
sudo rm "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/boot.sdi" 2>/dev/null
sudo rm "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/bootfix.bin" 2>/dev/null
sudo rm "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/bootsect.exe" 2>/dev/null
sudo rm "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/etfsboot.com" 2>/dev/null
sudo rm "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/memtest.exe" 2>/dev/null
sudo rm -R "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/efi" 2>/dev/null
sudo rm -R "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/sources" 2>/dev/null
sudo rm -R "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/support" 2>/dev/null
sudo rm -R "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/upgrade" 2>/dev/null
sudo rm "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/autorun.inf" 2>/dev/null
sudo rm "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/bootmgr" 2>/dev/null
sudo rm "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/setup.exe" 2>/dev/null
sudo rm -R "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/fr-fr" 2>/dev/null
sudo rm -R "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/cs-cz" 2>/dev/null
sudo rm -R "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/da-dk" 2>/dev/null
sudo rm -R "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/de-de" 2>/dev/null
sudo rm -R "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/el-gr" 2>/dev/null
sudo rm -R "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/en-us" 2>/dev/null
sudo rm -R "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/es-es" 2>/dev/null
sudo rm -R "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/fi-fi" 2>/dev/null
sudo rm -R "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/hu-hu" 2>/dev/null
sudo rm -R "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/it-it" 2>/dev/null
sudo rm -R "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/ja-jp" 2>/dev/null
sudo rm -R "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/ko-kr" 2>/dev/null
sudo rm -R "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/nb-no" 2>/dev/null
sudo rm -R "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/nl-nl" 2>/dev/null
sudo rm -R "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/pl-pl" 2>/dev/null
sudo rm -R "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/pt-br" 2>/dev/null
sudo rm -R "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/pt-pt" 2>/dev/null
sudo rm -R "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/ru-ru" 2>/dev/null
sudo rm -R "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/sv-se" 2>/dev/null
sudo rm -R "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/tr-tr" 2>/dev/null
sudo rm -R "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/zh-cn" 2>/dev/null
sudo rm -R "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/zh-hk" 2>/dev/null
sudo rm -R "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/zh-tw" 2>/dev/null
fi
#xbmc
if [ "${fichier}" == "xbmc" ]; then
sudo rm  "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/restrictedDrivers.nvidia.img" 2>/dev/null
sudo rm  "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/restrictedDrivers.amd.img" 2>/dev/null
sudo rm  "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/rootfs.img" 2>/dev/null
fi
sudo rm -R "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/bootdistro/$(echo "${fichier}" | tr [:upper:] [:lower:])" 2>/dev/null
sudo rm -R "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${fichier}" 2>/dev/null


#distro en fichier
else
sudo rm "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/${fichier}" 2>/dev/null
#pour distro en copy sqfs supprimer aussi kernel et ramdisk
if [ "$(echo -e "${ligne}" | awk -F"|" '{print $4}' | sed "s/multisystem-//g")" ]; then
sudo rm -R "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/bootdistro/$(echo -e "${ligne}" | awk -F"|" '{print $4}' | sed "s/multisystem-//g")/" 2>/dev/null
fi
fi
fi
#Special archlinux supprimer fichiers associés
if [ "${fichier}" == "archlinux.iso" ]; then
echo -e "\E[37;44m\033[1m $(eval_gettext 'Suppression du LiveCD.') \033[0m"
sudo rm "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/core-pkgs.sqfs" 2>/dev/null
sudo rm "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/isomounts" 2>/dev/null
sudo rm "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/overlay.sqfs" 2>/dev/null
sudo rm "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/root-image.sqfs" 2>/dev/null
fi
#Special linuxgamers
if [ "${fichier}" == "linuxgamers" ]; then
echo -e "\E[37;44m\033[1m $(eval_gettext 'Suppression du LiveCD.') \033[0m"
sudo rm -R "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/linuxgamers" 2>/dev/null
sudo rm "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/isomounts" 2>/dev/null
fi
#Special Mageia version dual
if [ "${fichier}" == "mageia" ]; then
echo -e "\E[37;44m\033[1m $(eval_gettext 'Suppression du LiveCD.') \033[0m"
sudo rm -R "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/i586" 2>/dev/null
sudo rm -R "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/x86_64" 2>/dev/null
fi
#Special Avira AntiVir Rescue System
if [ "${fichier}" == "antivir" ]; then
echo -e "\E[37;44m\033[1m $(eval_gettext 'Suppression du LiveCD.') \033[0m"
sudo rm -R "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/avupdate" 2>/dev/null
fi
#Special archlinux
if [ "${fichier}" == "archlinux" ]; then
echo -e "\E[37;44m\033[1m $(eval_gettext 'Suppression du LiveCD.') \033[0m"
sudo rm -R "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/archlinux" 2>/dev/null
sudo rm "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/isomounts" 2>/dev/null
fi
#Special chakra supprimer fichiers associés
if [ "${fichier}" == "chakra" ]; then
echo -e "\E[37;44m\033[1m $(eval_gettext 'Suppression du LiveCD.') \033[0m"
sudo rm -R "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/larch" 2>/dev/null
sudo rm "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/mods.sqf" 2>/dev/null
sudo rm "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/overlay.ovl" 2>/dev/null
sudo rm "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/system.sqf" 2>/dev/null
fi
#UHU-linux uhulinux.img
if [ "${fichier}" == "uhulinux.img" ]; then
echo -e "\E[37;44m\033[1m $(eval_gettext 'Suppression du LiveCD.') \033[0m"
sudo rm  -R "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/bootdistro/uhulinux.img" 2>/dev/null
sudo rm  "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/uhulinux.img" 2>/dev/null
fi
#special GeeXboX i386
if [ "${fichier}" = "rootfs-i386" ]; then
sudo rm -R "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/bootdistro/rootfs-i386" 2>/dev/null
sudo rm "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/geexbox-i386-rw" 2>/dev/null
fi
#special GeeXboX 
if [ "${fichier}" = "rootfs-x86_64" ]; then
sudo rm -R "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/bootdistro/rootfs-x86_64" 2>/dev/null
sudo rm "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/geexbox-x86_64-rw" 2>/dev/null
fi
fi
fi
fi

#Mettre à jour les bootloader
if [ "$(cat /tmp/multisystem/multisystem-update-bootloader)" = "true" ]; then
./update_grub.sh
fi

exit 0

