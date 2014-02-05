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
sudo umount "/tmp/multisystem/multisystem-mountpoint-iso" 2>/dev/null
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


#verifier si nom fichier ne pose pas problemes
#Générer erreur si nom contient &
option2="$(echo -e "${option2}" | sed 's%&%_%')"
if [ ! -f "${option2}" ]; then
zenity --error --text "$(eval_gettext "Erreur:Le fichier iso sélectionné contiens un caractère non supporté dans son nom:") (1 $(stat  -c %a" "%U ${option2})) ${option2}"
FCT_RELOAD
exit 0
fi
#interdire @ dans nom de fichier
if [ "$(grep '@' <<<"${option2}")" ]; then
zenity --error --text "$(eval_gettext "Erreur:Le fichier iso sélectionné contiens un caractère non supporté dans son nom:") (2@ $(stat  -c %a" "%U ${option2})) ${option2}"
FCT_RELOAD
exit 0
fi

#verifier espace disponible
if [ "$(($(du -sB 1 "${option2}" | awk '{print $1}')/1024/1024))" -ge "$(($(df | grep ^$(cat /tmp/multisystem/multisystem-selection-usb) | awk '{print $4}')/1024))" ]; then
zenity --error --text "$(eval_gettext "Erreur: pas suffisament d\047espace libre:") \
$(($(du -sB 1 "${option2}" | awk '{print $1}')/1024/1024)) >= \
$(($(df | grep ^$(cat /tmp/multisystem/multisystem-selection-usb) | awk '{print $4}')/1024))"
FCT_RELOAD
exit 0
fi
echo fichier:${option2}
echo iso:$(($(du -sB 1 "${option2}" | awk '{print $1}')/1024/1024))Mio
echo libre:$(($(df | grep ^$(cat /tmp/multisystem/multisystem-selection-usb) | awk '{print $4}')/1024))Mio

#verifier presence fichier iso (loop)
if [ "${option2}" == "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/$(basename "${option2}")" ]; then
zenity --info --text "lol"
FCT_RELOAD
exit 0
fi
#verifier presence fichier iso
if [ -e "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/$(basename "${option2}")" ]; then
zenity --error --text "$(eval_gettext "Erreur:Un fichier portant le même nom est déjà présent.")"
FCT_RELOAD
exit 0
fi
#Test droits sur fichier iso
if [ "$(stat -c %a "${option2}")" -lt "600" ]; then
zenity --error --text "$(eval_gettext "Problème de droits sur le fichier,") $(stat -c %a "${option2}")"
FCT_RELOAD
exit 0
fi
#test si marqueurs présent dans grub.cfg et menu.lst
if [ ! "$(grep '^#MULTISYSTEM_START' "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg")" ]; then
zenity --error --text "$(eval_gettext "Erreur:Impossible de détecter le marqueur:")MULTISYSTEM_START"
FCT_RELOAD
exit 0
elif [ ! "$(grep '^#MULTISYSTEM_STOP' "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg")" ]; then
zenity --error --text "$(eval_gettext "Erreur:Impossible de détecter le marqueur:")MULTISYSTEM_STOP"
FCT_RELOAD
exit 0
fi
if [ ! "$(grep '^#MULTISYSTEM_START' "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/menu.lst")" ]; then
zenity --error --text "$(eval_gettext "Erreur:Impossible de détecter le marqueur:")MULTISYSTEM_START"
FCT_RELOAD
exit 0
elif [ ! "$(grep '^#MULTISYSTEM_STOP' "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/menu.lst")" ]; then
zenity --error --text "$(eval_gettext "Erreur:Impossible de détecter le marqueur:")MULTISYSTEM_STOP"
FCT_RELOAD
exit 0
fi

#Monter
mkdir "/tmp/multisystem/multisystem-mountpoint-iso" 2>/dev/null
echo -e "\E[37;44m\033[1m $(eval_gettext 'Demande de votre mot de passe d\047administrateur pour monter le fichier') \033[0m"
#si pas uid fait erreur sur pas mal de distro....
sudo umount "/tmp/multisystem/multisystem-mountpoint-iso" 2>/dev/null
sudo mount -o loop,uid=$(id -u) "${option2}" "/tmp/multisystem/multisystem-mountpoint-iso"

#ISO-13346 "UDF"
if [ "$(grep 'ISO-13346 "UDF"' /tmp/multisystem/multisystem-mountpoint-iso/readme.txt 2>/dev/null)" ]; then
mkdir "/tmp/multisystem/multisystem-mountpoint-iso" 2>/dev/null
echo -e "\E[37;44m\033[1m $(eval_gettext 'Demande de votre mot de passe d\047administrateur pour monter le fichier') \033[0m"
sudo umount "/tmp/multisystem/multisystem-mountpoint-iso" 2>/dev/null
sudo mount -o loop "${option2}" "/tmp/multisystem/multisystem-mountpoint-iso"
fi

#verifier iso et exit si pas monté
if [ "$(echo "${option2}" | grep -i "konboot.*.img")" ]; then
echo
elif [ "$(echo "${option2}" | grep "M32.*.IMG")" ]; then
echo
elif [ "$(echo "${option2}" | grep "pci_.*emaxx.iso")" ]; then
echo
elif [[ "$(echo "${option2}" | grep -i ".*.img")" && $(($(du -sB 1 "${option2}" | awk '{print $1}')/1024)) -le "1445" ]]; then
echo
elif [ ! "$(ls -A "/tmp/multisystem/multisystem-mountpoint-iso" 2>/dev/null)" ]; then
zenity --error --text "$(eval_gettext "Erreur:de montage du fichier iso.")"
FCT_RELOAD
exit 0
fi

#fonction ajoute menu à grub.cfg
function FCT_ADD()
{
dater="$(date +%d-%m-%Y-%T-%N)"
tailleiso="$(($(du -sB 1 "${option2}" | awk '{print $1}')/1024/1024))Mio"
if [ ! "$osnamemodif" ]; then
osnamemodif="$osname"
fi
cat <<EOF
#MULTISYSTEM_MENU_DEBUT|${dater}|${osname}|${osicone}|${tailleiso}|\nmenuentry "${osnamemodif}" {\n${osloopback}\n${oskernel}\n${osinitrd}\n}\n#MULTISYSTEM_MENU_FIN|${dater}|${osname}|${osicone}|${tailleiso}|
EOF
}
function FCT_ADD2()
{
dater="$(date +%d-%m-%Y-%T-%N)"
tailleiso="$(($(du -sB 1 "${option2}" | awk '{print $1}')/1024/1024))Mio"
if [ ! "$osnamemodif" ]; then
osnamemodif="$osname"
fi
cat <<EOF
#MULTISYSTEM_MENU_DEBUT|${dater}|${osname}|${osicone}|${tailleiso}|\n${ligne1}\n${ligne2}\n${ligne3}\n${ligne4}\n${ligne5}\n${ligne6}\n${ligne7}\n${ligne8}\n${ligne9}\n${ligne10}\n#MULTISYSTEM_MENU_FIN|${dater}|${osname}|${osicone}|${tailleiso}|
EOF
}
function FCT_ADD4()
{
dater="$(date +%d-%m-%Y-%T-%N)"
tailleiso="$(($(du -sB 1 "${option2}" | awk '{print $1}')/1024/1024))Mio"
if [ ! "$osnamemodif" ]; then
osnamemodif="$osname"
fi
cat <<EOF
#MULTISYSTEM_MENU_DEBUT|${dater}|${osname}|${osicone}|${tailleiso}|\n${ligne1}\n${ligne2}\n${ligne3}\n${ligne4}\n${ligne5}\n${ligne6}\n${ligne7}\n${ligne8}\n${ligne9}\n${ligne10}\n${ligne11}\n${ligne12}\n${ligne13}\n${ligne14}\n${ligne15}\n${ligne16}\n${ligne17}\n${ligne18}\n${ligne19}\n${ligne20}\n#MULTISYSTEM_MENU_FIN|${dater}|${osname}|${osicone}|${tailleiso}|
EOF
}
function FCT_GRUB4DOS()
{
dater="$(date +%d-%m-%Y-%T-%N)"
tailleiso="$(($(du -sB 1 "${option2}" | awk '{print $1}')/1024/1024))Mio"
if [ ! "$osnamemodif" ]; then
osnamemodif="$osname"
fi
cat <<EOF
#MULTISYSTEM_MENU_DEBUT|${dater}|${osname}|${osicone}|${tailleiso}|\n${ligne1}\n${ligne2}\n${ligne3}\n${ligne4}\n${ligne5}\n${ligne6}\n${ligne7}\n#MULTISYSTEM_MENU_FIN|${dater}|${osname}|${osicone}|${tailleiso}|
EOF
}
function FCT_SYSLINUX()
{
dater="$(date +%d-%m-%Y-%T-%N)"
tailleiso="$(($(du -sB 1 "${option2}" | awk '{print $1}')/1024/1024))Mio"
if [ ! "$osnamemodif" ]; then
osnamemodif="$osname"
fi
cat <<EOF
#MULTISYSTEM_MENU_DEBUT|${dater}|${osname}|${osicone}|${tailleiso}|\n${ligne1}\n${ligne2}\n${ligne3}\n${ligne4}\n${ligne5}\n${ligne6}\n${ligne7}\n#MULTISYSTEM_MENU_FIN|${dater}|${osname}|${osicone}|${tailleiso}|
EOF
}
function FCT_DOS1()
{
if [ ! "$osnamemodif" ]; then
osnamemodif="$osname"
fi
ligne1="title ${osnamemodif}"
ligne2="find --set-root --ignore-floppies --ignore-cd /${osname}"
ligne3="map (hd0,0)/${osname} (hd32)"
ligne4="map --hook"
ligne5="chainloader (hd32)"
ligne6="boot"
ligne7=""
}
function FCT_DOS2()
{
if [ ! "$osnamemodif" ]; then
osnamemodif="$osname"
fi
ligne1="title ${osnamemodif}"
ligne2="find --set-root /${osname}"
ligne3="map /${osname} (0xff) || map --mem /${osname} (0xff)"
ligne4="map --hook"
ligne5="chainloader (0xff)"
ligne6="boot"
ligne7=""
}
#Emuler disquette
function FCT_DOS3()
{
if [ ! "$osnamemodif" ]; then
osnamemodif="$osname"
fi
ligne1="title ${osnamemodif}"
ligne2="find --set-root /${osname}"
ligne3="map --mem /${osname} (fd0)"
ligne4="map --hook"
ligne5="rootnoverify (fd0)"
ligne6="chainloader (fd0)+1"
ligne7="boot"
}
#Boot memdisk
function FCT_DOS4()
{
if [ ! "$osnamemodif" ]; then
osnamemodif="$osname"
fi
ligne1="title ${osnamemodif}"
ligne2="find --set-root /${osname}"
ligne3="kernel /boot/syslinux/memdisk"
ligne4="initrd /${osname}"
ligne5=""
ligne6=""
ligne7=""
}
#
function FCT_DOS5()
{
if [ ! "$osnamemodif" ]; then
osnamemodif="$osname"
fi
ligne1="title ${osnamemodif}"
ligne2="find --set-root --ignore-floppies /${osname}"
ligne3="map /${osname} (0xff)"
ligne4="map --hook"
ligne5="root (0xff)"
ligne6="chainloader (0xff)"
ligne7="boot"
}
function FCT_DOS6()
{
if [ ! "$osnamemodif" ]; then
osnamemodif="$osname"
fi
ligne1="title ${osnamemodif}"
ligne2="find --set-root --ignore-floppies /${osname}"
ligne3="map /${osname} (hd32)"
ligne4="map --hook"
ligne5="root (hd32)"
ligne6="chainloader (hd32)"
ligne7="boot"
}
function FCT_DOS7()
{
if [ ! "$osnamemodif" ]; then
osnamemodif="$osname"
fi
ligne1="title ${osnamemodif}"
ligne2="find --set-root --ignore-floppies /${osname}"
ligne3="map --heads=0 --sectors-per-track=0 /${osname} (hd32)"
ligne4="map --hook"
ligne5="root (hd32)"
ligne6="chainloader (hd32)"
ligne7="boot"
}
function FCT_DOS8()
{
if [ ! "$osnamemodif" ]; then
osnamemodif="$osname"
fi
ligne1="title ${osnamemodif}"
ligne2="find --set-root /${osname}"
ligne3="map --heads=0 --sectors-per-track=0 /${osname} (0xff) || map --heads=0 --sectors-per-track=0 --mem /${osname} (0xff)"
ligne4="map --hook"
ligne5="chainloader (0xff)"
ligne6="boot"
ligne7=""
}

#pour caler les fichiers de conf
. /etc/default/locale
. /etc/default/console-setup
XKBLAYOUT="$(echo $XKBLAYOUT | awk -F"," '{print $1}')"
XKBVARIANT="$(echo "$XKBVARIANT" | awk -F"," '{print $1}')"
if [ ! "$XKBVARIANT" ]; then
. /etc/default/locale
. /etc/default/console-setup
XKBVARIANT="$(echo "$XKBVARIANT" | awk -F"," '{print $2}')"
XKBLAYOUT="$(echo $XKBLAYOUT | awk -F"," '{print $1}')"
fi

#
if [ ! "$XKBVARIANT" ]; then
XKBVARIANT="$(gconftool-2 --get /desktop/gnome/peripherals/keyboard/kbd/layouts 2>/dev/null | sed "s%\[%%g" | sed "s%\]%%g" | awk -F"," '{print $1}' | awk '{print $2}')"
fi

#11.10 "Oneiric Ocelot"
#if [ ! "$XKBVARIANT" ]; then
#XKBVARIANT="$(gsettings get org.gnome.libgnomekbd.keyboard layouts 2>/dev/null | sed "s%\[%%g" | sed "s%\]%%g" | awk -F"," '{print $1}' | awk '{print $2}')"
#fi

#
if [ "$XKBVARIANT" ]; then
ms_variant="keyboard-configuration/variantcode=${XKBVARIANT}"
fi

echo XKBLAYOUT:${XKBLAYOUT} 
echo XKBVARIANT:${XKBVARIANT}
echo XKBMODEL:${XKBMODEL}

#var lang ubuntu
ubuntu_lang="debian-installer/language=$(echo "${LANG}" | sed "s/\_.*//") keyboard-configuration/layoutcode=${XKBLAYOUT} ${ms_variant}"
#ubuntu_lang="debian-installer/locale=${LANG} debian-installer/language=$(echo "${LANG}" | sed "s/\_.*//") kbd-chooser/method=$(echo "${LANG}" | sed "s/\_.*//") console-setup/layoutcode=${XKBLAYOUT} console-setup/variantcode=${XKBVARIANT} console-setup/modelcode=${XKBMODEL}"

#OS supportés.
. ${dossier}/os_support.sh

#Démonter
sudo umount "/tmp/multisystem/multisystem-mountpoint-iso" 2>/dev/null

#Copie iso
if [ ! "$modiso" ]; then
echo -e "\E[37;44m\033[1m $(eval_gettext 'Copie du fichier iso en cours...') \033[0m"
rsync -avS --progress -h "${option2}" "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/$(basename "${source}")"
fi

#Mettre à jour les bootloader
if [ "$(cat /tmp/multisystem/multisystem-update-bootloader)" = "true" ]; then
echo
if [ ! "${option3}" ]; then
./update_grub.sh
elif [ "${option3}" == "$(cat /tmp/multisystem/multisystem-sel-multi 2>/dev/null | wc -l)" ]; then
./update_grub.sh
fi
fi

exit 0
