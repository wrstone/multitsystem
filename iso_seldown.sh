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
if [ "${date}" ]; then
#Numéro de la ligne suivante
after="$(($(cat /tmp/multisystem/multisystem-mise-en-forme  | awk -F"|" '{print NR " " $3}' | grep ${date} | awk  '{print $1}')+1))"
echo ${after}
#Extraire date suivante
after_date="$(sed -n "${after} p" /tmp/multisystem/multisystem-mise-en-forme | awk -F"|" '{print $3}')"
echo ${after_date}
#Rechercher dans grub.cfg/menu.lst/syslinux.cfg si dates sont présentes !
for i in $(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/grub/grub.cfg $(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/grub/menu.lst $(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/syslinux/syslinux.cfg
do
#verifier que contiens au moins 2 menus, sinon exit
if [ "$(grep "^#MULTISYSTEM_MENU_DEBUT" $i | wc -l)" -ge "2" ]; then
echo
#Vérifier que n'est pas la dernière ligne
if [ "${after_date}" ]; then
echo
if [[ "$(grep "^#MULTISYSTEM_MENU_DEBUT|${date}" $i)" && "$(grep "^#MULTISYSTEM_MENU_DEBUT|${after_date}" $i)" ]]; then
#Extraire sur date le menu à déplacer 
echo "$(sed -n "/^#MULTISYSTEM_MENU_DEBUT|${date}.*$/,/^#MULTISYSTEM_MENU_FIN|${date}.*$/p" "$i")" >/tmp/multisystem/multisystem-down-menu
#Effacer le menu
sed -i "/^#MULTISYSTEM_MENU_DEBUT|${date}.*$/,/^#MULTISYSTEM_MENU_FIN|${date}.*$/d" "$i"
#Reinsérer le menu à la bonne position
#Relever le numéro ou il fau insérer
line_after="$(grep "^#MULTISYSTEM_MENU_FIN|${after_date}" $i)"
number_line_after="$(cat $i  | awk -F"|" '{print NR " " $0}' | grep "${line_after}" | awk  '{print $1}')"
#insérer zzZZzzZZzzZZzzZZzz sur la ligne ou insérer le bloc
sed -i "${number_line_after}s/.*/&\nzzZZzzZZzzZZzzZZzz/" "$i"
#Remplacer zzZZzzZZzzZZzzZZzz par le bloc contenu dans /tmp/multisystem/multisystem-down-menu
#insérer z88z en fin de ligne
sed -i 's@$@z88z@' /tmp/multisystem/multisystem-down-menu
#supprimer \n
formcontent="$(echo $(cat /tmp/multisystem/multisystem-down-menu))"
sed -i "s@zzZZzzZZzzZZzzZZzz@${formcontent}@" "$i"
#Remettre les mise à la ligne
sed -i "s@z88z @\n@g" "$i"
sed -i "s@z88z@\n@g" "$i"
#Supprimer
rm /tmp/multisystem/multisystem-down-menu
#Virer lignes vides
sed -i "/^$/d" "$i"
seldown_test=ok
#stop boucle
break
fi
fi
fi
done
fi

if [ "$seldown_test" = "ok" ]; then
echo
#Mettre à jour les bootloader
if [ "$(cat /tmp/multisystem/multisystem-update-bootloader)" = "true" ]; then
./update_grub.sh
fi
fi

exit 0
