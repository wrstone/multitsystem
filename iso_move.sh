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


date="${option2}"

#Rechercher le fichier de conf
mov_config="$(grep -m1 "${date}" $(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/grub/grub.cfg $(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/grub/menu.lst $(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/syslinux/syslinux.cfg | awk -F":" '{print $1}')"
echo mov_config:$mov_config

#Nombre total de menus dans le fichier de conf
move_totalnumber="$(grep '^#MULTISYSTEM_MENU_DEBUT|' "${mov_config}" | wc -l)"
echo move_totalnumber:${move_totalnumber}

#Vérifier que bien 1 seul menu avec la même date sinon exit
if [  "$(grep "^#MULTISYSTEM_MENU_DEBUT|${date}" "${mov_config}" | wc -l)" != "1" ]; then
zenity --error --text "Erreur: move 1"
FCT_RELOAD
exit 0
fi

#Vérifier que pas de @ sinon exit
if [ "$(grep "@" "${mov_config}")" ]; then
zenity --error --text "Erreur: move 2"
FCT_RELOAD
exit 0
fi

#Extraire le menu à déplacer dans un fichier temporaire
echo "$(sed -n "/^#MULTISYSTEM_MENU_DEBUT|${date}.*$/,/^#MULTISYSTEM_MENU_FIN|${date}.*$/p" "${mov_config}")" >/tmp/multisystem/multisystem-move-menu

#Détecter Numéro de la sélection
move_selnumber="$(cat "${mov_config}" | grep '^#MULTISYSTEM_MENU_DEBUT|' | awk -F"|" '{print NR " " $2}' | grep "${date}" | awk  '{print $1}')"
echo move_selnumber:${move_selnumber}

#Nom du bootloader à afficher
test $(basename ${mov_config}) = grub.cfg && move_namebootloader=Grub2
test $(basename ${mov_config}) = menu.lst && move_namebootloader=grub4dos
test $(basename ${mov_config}) = syslinux.cfg && move_namebootloader=Syslinux

move_number="$(zenity --scale \
--text "$(eval_gettext "Position actuelle:") ${move_selnumber}\n${move_namebootloader} ==> $(basename ${mov_config})" \
--min-value=1 \
--max-value=${move_totalnumber} \
--value=${move_selnumber} \
--step 1)"

#
if [[ "${date}" && "${move_number}" && ${move_selnumber} && "${mov_config}" && "${move_totalnumber}" ]]; then
#Extraire la date du menu à remplacer
move_date="$(cat "${mov_config}" | grep '^#MULTISYSTEM_MENU_DEBUT|' | awk -F"|" '{print NR " " $2}' | grep "^${move_number} " | awk  '{print $2}')"
echo move_date:${move_date}

##############################################
function MOD_DEBUBMOVE()
{
zenity --info --text "${move_date}"
#afficher gui
FCT_RELOAD
exit 0
}
#DEBUBMOVE
##############################################

#Pas de changements
if [ "${move_number}" = "${move_selnumber}" ]; then
FCT_RELOAD
exit 0

#Si deplacer vers le bas vers le dernier menu
elif [[ "${move_selnumber}" -lt "${move_number}" && "${move_number}" = "${move_totalnumber}" ]]; then
#zenity --info --text "baisser vers dernier\nmove_selnumber:${move_selnumber}\nmove_number:${move_number}\nmove_totalnumber:${move_totalnumber}"
sed -i "s@^#MULTISYSTEM_STOP@zzZZzzZZzzZZzzZZzz#MULTISYSTEM_STOP@" "${mov_config}"

#Si est < descente
elif [ "${move_selnumber}" -lt "${move_number}" ]; then
#zenity --info --text "descendre\nmove_selnumber:${move_selnumber}\nmove_number:${move_number}\nmove_totalnumber:${move_totalnumber}"
move_date="$(cat "${mov_config}" | grep '^#MULTISYSTEM_MENU_DEBUT|' | awk -F"|" '{print NR " " $2}' | grep ^$((${move_number}+1)) | awk  '{print $2}')"
sed -i "s@^#MULTISYSTEM_MENU_DEBUT|${move_date}@zzZZzzZZzzZZzzZZzz#MULTISYSTEM_MENU_DEBUT|${move_date}@" "${mov_config}"
#FCT_RELOAD
#exit 0

#Si est > montée
elif [ "${move_selnumber}" -gt "${move_number}" ]; then
sed -i "s@^#MULTISYSTEM_MENU_DEBUT|${move_date}@zzZZzzZZzzZZzzZZzz#MULTISYSTEM_MENU_DEBUT|${move_date}@" "${mov_config}"
#zenity --info --text "monter\nmove_selnumber:${move_selnumber}\nmove_number:${move_number}\nmove_totalnumber:${move_totalnumber}"
#FCT_RELOAD
#exit 0

#???
else
#zenity --info --text "???\nmove_selnumber:${move_selnumber}\nmove_number:${move_number}\nmove_totalnumber:${move_totalnumber}"
FCT_RELOAD
exit 0
fi

#Erreur pas de marqueur trouvé !
if [ ! "$(grep "zzZZzzZZzzZZzzZZzz" "${mov_config}")" ]; then
zenity --error --text "Erreur: move 3"
FCT_RELOAD
exit 0
fi

#Effacer le menu à déplacer
sed -i "/^#MULTISYSTEM_MENU_DEBUT|${date}.*$/,/^#MULTISYSTEM_MENU_FIN|${date}.*$/d" "${mov_config}"

#Poser des marqueurs en fin de ligne
sed -i 's@$@z88z@' /tmp/multisystem/multisystem-move-menu
#supprimer \n
move_content="$(echo $(cat /tmp/multisystem/multisystem-move-menu))"

#Placer le nouveau menu déplacé
sed -i "s@zzZZzzZZzzZZzzZZzz@${move_content}@" "${mov_config}"

#Remettre les mise à la ligne
sed -i "s@z88z @\n@g" "${mov_config}"
sed -i "s@z88z@\n@g" "${mov_config}"

#Supprimer
rm /tmp/multisystem/multisystem-move-menu

#Virer lignes vides
sed -i "/^$/d" "${mov_config}"

#Mettre à jour les bootloader
if [ "$(cat /tmp/multisystem/multisystem-update-bootloader)" = "true" ]; then
xterm -title 'update_grub' -e './update_grub.sh'
fi

fi

exit 0
