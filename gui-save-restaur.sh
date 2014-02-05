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

# dd if=/dev/sdx of=/mbr_sdx.bak bs=512 count=1       # Backup the full MBR
# dd if=/dev/zero of=/dev/sdx bs=512 count=1          # Delete MBR and partition table
# dd if=/mbr_sdx.bak of=/dev/sdx bs=512 count=1       # Restore the full MBR
# dd if=/mbr_sdx.bak of=/dev/sdx bs=446 count=1       # Restore only the boot loader
# dd if=/mbr_sdx.bak of=/dev/sdx bs=1 count=64 skip=446 seek=446 # Restore partition table

function ddgraph()
{
options="$*"
source="$(echo "$options" | awk -F"|" '{print $1}')"
destination="$(echo "$options" | awk -F"|" '{print $2}')"
optiondd="$(echo "$options" | awk -F"|" '{print $3}')"
if [ "$(grep '^/dev/' <<<$source)" ]; then
destination="$destination"
taille="$(fdisk -l "$source" | sed -n 2p | awk '{print $5}')"
message="$(eval_gettext "Sauvegarder")"
else
taille="$(du -sb "$source" | awk '{print $1}')"
message="$(eval_gettext "Restaurer")"
fi
dd if="$source" of="$destination" $optiondd 2>/tmp/multisystem/tampondd &
sleep 1
pid=$!
echo $pid >/tmp/multisystem/multisystem-pid-save
echo ${destination} >/tmp/multisystem/multisystem-path-save
while kill -USR1 $pid
do
#ne pas régler trop féquement car cela ralenti la copie!
sleep 1
copie="$(sed -n 3p /tmp/multisystem/tampondd | awk '{print $1}')"
taillemio="$(echo $copie/1024/1024|bc 2>/dev/null)"
if [ "$taillemio" ]; then
echo "# ${message} ${taillemio}Mio $(eval_gettext "de") $(($taille/1024/1024))Mio $(echo "scale=2; $copie/$taille*100;"|bc)%"
echo "$(echo "scale=2; $copie/$taille*100;"|bc)"
fi
>/tmp/multisystem/tampondd
done | zenity --progress --auto-close --width=400 --auto-kill
rm /tmp/multisystem/multisystem-pid-save 2>/dev/null
rm /tmp/multisystem/multisystem-path-save 2>/dev/null
}


function MENUS()
{
MENUS=$(zenity \
--window-icon="${dossier}/pixmaps/multisystem-icon.png" \
--title="$(eval_gettext "Sauvegarde/Restauration")" \
--text="<span foreground=\"#F33D00\" font-family=\"impact\" size=\"x-large\">MultiSystem $(eval_gettext "Sauvegarde/Restauration")</span>
<b>$(eval_gettext "ATTENTION!\nla restauration effacera définitivement\ntout le contenu de:")</b> ${vol_usb_sel}

<b>$(eval_gettext "Clé USB:")</b> ${vol_usb_sel}
<b>$(eval_gettext "UUID clé USB:")</b> ${vol_usb_uuid}
<b>$(eval_gettext "Taille de la clé USB")</b> $(echo ${vol_usb_taille}/1024/1024|bc 2>/dev/null) Mio
" \
--width=400 \
--height=400 \
--list \
--print-column="2" \
--radiolist \
--separator=" " \
--column="*" \
--column="Val" \
--column="$(eval_gettext "Fonction à exécuter")" \
--hide-column="2" \
FALSE "A" "$(eval_gettext "Sauvegarder")" \
FALSE "B" "$(eval_gettext "Restaurer")" \
TRUE "C" "$(eval_gettext "Fermer cette fenêtre")" \
)
test $? -ne 0 && exit 0 # Bouton Annuler
}


while true; do
if [ ! -f "/tmp/multisystem/multisystem-selection-usb" ]; then
zenity --error --text "$(eval_gettext "Erreur:Veuillez démarrer multisystem")"
break
exit 0
fi
#Définir les var
vol_usb_sel="$(cat /tmp/multisystem/multisystem-selection-usb | sed 's/[0-9]//')"
vol_usb_uuid="$(cat /tmp/multisystem/multisystem-selection-uuid-usb)"
vol_usb_taille="$(fdisk -l ${vol_usb_sel} | sed -n 2p | awk '{print $5}')"
file_save_name="MultiSystem-${vol_usb_uuid}.img"
#demarrer menu
MENUS


#Save
if [ "$(echo "${MENUS}" | awk '{print $1}')" == "A" ]; then
#Choix dossier de destination
cd "$HOME"
save_path="$(zenity --file-selection --directory \
--window-icon=${dossier}/pixmaps/multisystem-icon.png \
--width=400 \
--height=400)"
cd -
if [ "${save_path}" ]; then
echo
if [ -f "${save_path}/${file_save_name}" ]; then
zenity --error --text "$(eval_gettext "Erreur: fichier de sauvegarde déjà présent.")"
else
ddgraph ${vol_usb_sel}\|${save_path}/${file_save_name}
zenity --info --text "$(eval_gettext "Sauvegarde effectuée dans le fichier:") ${save_path}/${file_save_name}"
fi
fi


#Restauration
elif [ "$(echo "${MENUS}" | awk '{print $1}')" == "B" ]; then
#faire test avec retour erreur si fichier plus grand que clé usb!
cd "$HOME"
restaur_file_name=$(zenity --file-selection \
--width=400 \
--height=400 \
--title="$(eval_gettext "Sélection du fichier de restauration.")")
test $? -ne 0 && exit 0 # Bouton Annuler
cd -
if [[ ! -f "${restaur_file_name}" || ! "$(fdisk -l "${restaur_file_name}" 2>/dev/null | grep FAT32)" ]]; then
zenity --error --text "$(eval_gettext "Erreur: détection impossible du fichier de sauvegarde")"
else
restaur_file_size="$(($(du -sb "${restaur_file_name}" | awk '{print $1}')/1024/1024))"
if [ "${restaur_file_size}" -gt "$(echo ${vol_usb_taille}/1024/1024|bc 2>/dev/null)" ]; then
zenity --error --text "$(eval_gettext "Erreur: clé USB trop petite") ${restaur_file_size} > $(echo ${vol_usb_taille}/1024/1024|bc 2>/dev/null)"
else
#ok on lance restauration
xterm -title 'umount' -e "\
#! /bin/bash
###Pour exporter la librairie de gettext.
set -a
source gettext.sh
set +a
export TEXTDOMAIN=multisystem
export TEXTDOMAINDIR=${dossier}/locale
. gettext.sh
multisystem=$0
echo -e \"\E[37;44m\033[1m $(eval_gettext 'Veuillez saisir votre mot de passe d\047administrateur') \033[0m\"
sudo umount ${vol_usb_sel}1 2>/dev/null
"
cd "$HOME"
ddgraph ${restaur_file_name}\|${vol_usb_sel}\|bs=1024
cd -
#Redimmensionner si besoin!
if [ "$(du -sb "${restaur_file_name}" | awk '{print $1}')" !=  "$(fatresize -i ${vol_usb_sel}1 | grep '^Max size' | awk '{print $3}')" ]; then
xterm -title 'fatresize' -e "\
#! /bin/bash
###Pour exporter la librairie de gettext.
set -a
source gettext.sh
set +a
export TEXTDOMAIN=multisystem
export TEXTDOMAINDIR=${dossier}/locale
. gettext.sh
multisystem=$0
echo -e \"\E[37;44m\033[1m $(eval_gettext 'Veuillez saisir votre mot de passe d\047administrateur') \033[0m\"
sudo umount ${vol_usb_sel}1 2>/dev/null
#redimensionner
sudo fatresize -p -s $(sudo fatresize -i ${vol_usb_sel}1 | grep '^Max size' | awk '{print $3}') ${vol_usb_sel}1
#echo Attente
#read
"
fi
#tuer process multisystem!
zenity --info --text "$(eval_gettext "Restauration effectuée,\nveuillez débrancher/rebrancher votre clé USB\navant de relancer multisystem.")"
break
fi
fi

#Quitter
else
break
fi
done

#Tuer multisystem
if [ ! "$(mount | grep "^${vol_usb_sel}1")" ]; then
nohup "$dossier"/kill.sh&
fi
exit 0

