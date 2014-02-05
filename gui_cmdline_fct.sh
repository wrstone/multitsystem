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

options="$*"
option1="$(echo "$options" | awk -F"|" '{print $1}')"
option2="$(echo "$options" | awk -F"|" '{print $2}')"
option3="$(echo "$options" | awk -F"|" '{print $3}')"
date="${option2}"

rm /tmp/multisystem/multisystem-confboot-* 2>/dev/null

if [ ! "${date}" ]; then
exit 0
fi

#Rechercher le fichier de conf
cmdline_config="$(grep -m1 "${date}" $(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/grub/grub.cfg $(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/grub/menu.lst $(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/syslinux/syslinux.cfg | awk -F":" '{print $1}')"

if [ ! "${cmdline_config}" ]; then
exit 0
fi

#Extraire les menu
#Numéroter le fichier de conf
awk '{print NR " " $0}' "$cmdline_config" >/tmp/multisystem/multisystem-confboot-temp

#Extraire menu
cmdline_menu="$(sed -n "/ #MULTISYSTEM_MENU_DEBUT|${date}.*$/,/ #MULTISYSTEM_MENU_FIN|${date}.*$/p" /tmp/multisystem/multisystem-confboot-temp)"

#Extraire le titre des menus ==> /tmp/multisystem/multisystem-confboot-title
#Grub2
if [ "$(basename "${cmdline_config}")" = "grub.cfg" ]; then
#Bootloader ?
cmdline_namebootloader=Grub2
cmdline_pathbootloader="$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/grub/grub.cfg"
#Extraire le titre
grep -iE  "([0-9] menuentry)" <<<"${cmdline_menu}" | sed "s/menuentry //" | sed "s/ {//" | sed "s/\"//g" | awk '{print $0}' >/tmp/multisystem/multisystem-confboot-title

#Grub4dos
elif [ "$(basename "${cmdline_config}")" = "menu.lst" ]; then
cmdline_namebootloader=grub4dos
cmdline_pathbootloader="$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/grub/menu.lst"
grep -iE  "([0-9] title)" <<<"${cmdline_menu}" | sed "s/title //" | sed "s/\"//g" | awk '{print $0}'  >/tmp/multisystem/multisystem-confboot-title

#Syslinux
elif [ "$(basename "${cmdline_config}")" = "syslinux.cfg" ]; then
cmdline_namebootloader=Syslinux
cmdline_pathbootloader="$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/syslinux/syslinux.cfg"
grep -iE  "([0-9] MENU LABEL)" <<<"${cmdline_menu}" | sed "s/MENU LABEL //" | sed "s/\"//g" | awk '{print $0}' >/tmp/multisystem/multisystem-confboot-title
else
exit 0
fi

#Extraire les lignes
cmdline_lines="$(grep -iE  "([0-9] kernel|[0-9] linux)" <<<"${cmdline_menu}")"
echo -e "$cmdline_lines" | awk '{print $1}' >/tmp/multisystem/multisystem-confboot-lines

#exit si pas trouvé $cmdline_lines !
if [ ! "$cmdline_lines" ]; then
echo exit >/tmp/multisystem/multisystem-confboot-exit
exit 0
fi

#Concaténer pour tree
>/tmp/multisystem/multisystem-confboot-tree
i=1
while read line
do
echo "$line|$(cat /tmp/multisystem/multisystem-confboot-title | awk 'NR=='$i'' | awk '{print $1}')|$(cat /tmp/multisystem/multisystem-confboot-title | awk 'NR=='$i'' | sed "s/[0-9]* //")" >>/tmp/multisystem/multisystem-confboot-tree
let i++
done </tmp/multisystem/multisystem-confboot-lines

#Ecrire le nom du bootloader dans fichier pour gui
echo "${cmdline_namebootloader}" >/tmp/multisystem/multisystem-confboot-namebootloader

#Ecrire la ligne kernel dans fichier pour gui
awk 'NR=='${option3}'' "$cmdline_pathbootloader" >/tmp/multisystem/multisystem-confboot-kernel

#Ecrire le chemin du fichier de conf à modifier
echo "$cmdline_pathbootloader" >/tmp/multisystem/multisystem-confboot-pathbootloader

#Vérifier que meme nombre de titres et de lignes !
if [ "$(cat /tmp/multisystem/multisystem-confboot-lines | wc -l)" != "$(cat /tmp/multisystem/multisystem-confboot-title | wc -l)" ]; then
exit 0
fi

#lire la sélection
readsel="$(cat "${cmdline_pathbootloader}" | awk 'NR=='${option3}'')"

#acpi=off checkbox1
if [ "$(grep -i "acpi=off" <<<"${readsel}")" ]; then
echo yes >/tmp/multisystem/multisystem-confboot-checkbox1
else
echo no >/tmp/multisystem/multisystem-confboot-checkbox1
fi

#edd=on checkbox2
if [ "$(grep -i "edd=on" <<<"${readsel}")" ]; then
echo yes >/tmp/multisystem/multisystem-confboot-checkbox2
else
echo no >/tmp/multisystem/multisystem-confboot-checkbox2
fi

#all_generic_ide checkbox3
if [ "$(grep -i "all_generic_ide" <<<"${readsel}")" ]; then
echo yes >/tmp/multisystem/multisystem-confboot-checkbox3
else
echo no >/tmp/multisystem/multisystem-confboot-checkbox3
fi

#irqpoll checkbox4
if [ "$(grep -i "irqpoll" <<<"${readsel}")" ]; then
echo yes >/tmp/multisystem/multisystem-confboot-checkbox4
else
echo no >/tmp/multisystem/multisystem-confboot-checkbox4
fi

#nomodeset checkbox5
if [ "$(grep -i "nomodeset" <<<"${readsel}")" ]; then
echo yes >/tmp/multisystem/multisystem-confboot-checkbox5
else
echo no >/tmp/multisystem/multisystem-confboot-checkbox5
fi

#noacpi checkbox6
if [ "$(grep -i "noacpi" <<<"${readsel}")" ]; then
echo yes >/tmp/multisystem/multisystem-confboot-checkbox6
else
echo no >/tmp/multisystem/multisystem-confboot-checkbox6
fi

#noapic checkbox7
if [ "$(grep -i "noapic" <<<"${readsel}")" ]; then
echo yes >/tmp/multisystem/multisystem-confboot-checkbox7
else
echo no >/tmp/multisystem/multisystem-confboot-checkbox7
fi

#xforcevesa checkbox8
if [ "$(grep -i "xforcevesa" <<<"${readsel}")" ]; then
echo yes >/tmp/multisystem/multisystem-confboot-checkbox8
else
echo no >/tmp/multisystem/multisystem-confboot-checkbox8
fi

exit 0
