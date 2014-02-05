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

#Exit si options vide exit
if [ ! "${options}" ]; then
exit 0
fi

#Grub2
if [ "${option2}" == "1" ]; then
awk 'NR=='${option1}' {print $0}' "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/grub/grub.cfg" \
| sed "s/menuentry //" | sed "s/ {//" | sed "s/\"//g" >/tmp/multisystem/multisystem-modif-menu
#Grub4dos
elif [ "${option2}" == "2" ]; then
awk 'NR=='${option1}' {print $0}' "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/grub/menu.lst" \
| sed "s/title //" | sed "s/\"//g" >/tmp/multisystem/multisystem-modif-menu
#Syslinux
elif [ "${option2}" == "3" ]; then
awk 'NR=='${option1}' {print $0}' "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/syslinux/syslinux.cfg" \
| sed "s/MENU LABEL //" | sed "s/\"//g" >/tmp/multisystem/multisystem-modif-menu
fi

export MAIN_EDIT='<window width_request="600" resizable="true" title="MultiSystem_PoPuP" window_position="1" icon-name="multisystem-icon" decorated="true">
<vbox>
<entry>
<input>cat /tmp/multisystem/multisystem-modif-menu</input>
<variable>ENTRY</variable>
</entry>
<hbox>
<button cancel></button>
<button ok></button>
</hbox>
</vbox>
</window>'
#monter gui
I=$IFS; IFS=""
for MENU_INFO in  $(gtkdialog -c --program=MAIN_EDIT); do
eval $MENU_INFO
done
IFS=$I
#on modifie entrée de Grub2
if [[ "${EXIT}" == "OK" && "${ENTRY}" && "${option2}" == "1" ]]; then
sed -i "${option1}cmenuentry \"${ENTRY}\" {" "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/grub/grub.cfg"
#on modifie entrée de Grub4dos
elif [[ "${EXIT}" == "OK" && "${ENTRY}" && "${option2}" == "2" ]]; then
sed -i "${option1}ctitle ${ENTRY}" "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/grub/menu.lst"
#on modifie entrée de Syslinux
elif [[ "${EXIT}" == "OK" && "${ENTRY}" && "${option2}" == "3" ]]; then
sed -i "${option1}cMENU LABEL ${ENTRY}" "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/syslinux/syslinux.cfg"
fi
#mettre a jour les entrées pour le tree du gui
>/tmp/multisystem/multisystem-edit-menu1
>/tmp/multisystem/multisystem-edit-menu2
>/tmp/multisystem/multisystem-edit-menu3
cat "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/grub/grub.cfg" | awk '{print "gtk-edit|" $0 "|" NR}' | grep 'gtk-edit|menuentry' >>"/tmp/multisystem/multisystem-edit-menu1"
cat "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/grub/menu.lst" | awk '{print "gtk-edit|" $0 "|" NR}' | grep -i 'gtk-edit|title' >>"/tmp/multisystem/multisystem-edit-menu2"
cat "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/syslinux/syslinux.cfg" | awk '{print "gtk-edit|" $0 "|" NR}' | grep -i 'gtk-edit|MENU LABEL' >>"/tmp/multisystem/multisystem-edit-menu3"
>/tmp/multisystem/multisystem-edit-menu-all-after
cat "/tmp/multisystem/multisystem-edit-menu1" >>/tmp/multisystem/multisystem-edit-menu-all-after
cat "/tmp/multisystem/multisystem-edit-menu2" >>/tmp/multisystem/multisystem-edit-menu-all-after
cat "/tmp/multisystem/multisystem-edit-menu3" >>/tmp/multisystem/multisystem-edit-menu-all-after
exit 0
