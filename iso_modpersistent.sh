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


#exit si pas sufisament de place...
#num1 -lt num2 inférieur (<) [ $nombre -lt 27 ]
tdispo="$(($(df | grep ^$(cat /tmp/multisystem/multisystem-selection-usb) | awk '{print $4}')/1024))"
if [ "${tdispo}" -lt "300" ]; then
zenity --error --text "<b>$(eval_gettext "Erreur:") ${tdispo} lower 300</b>"
else
if [ "${tdispo}" -lt "4096" ]; then
max_value="${tdispo}"
value="${tdispo}"
else
max_value="4096"
value="1024"
fi
fi


#stop si pas de selection
if [ ! "$option2" ]; then
zenity --error --text "<b>$(eval_gettext "Erreur: Veuillez sélectionner la distribution\nà laquelle il faut ajouter le mode persistent!")</b>"
else


#si sel user ok extraire le paragrapphe de grub.cfg
#chercher selection dens cette liste
export liste="$(sed -n '/^#MULTISYSTEM_MENU_DEBUT/p' "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg" | awk -F"|" '{print "|" $2 "|" $3 "|" $4 "|" $5 "|" $6}')"
export ligne="$(echo -e "${liste}" | grep "${option2}")"
export paragraphe="$(sed -n "/^#MULTISYSTEM_MENU_DEBUT${ligne}$/,/^#MULTISYSTEM_MENU_FIN${ligne}$/p" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg" | grep -v ^#)"
#au cas ou plusieures entrées dans fichier de conf on ne prend que la première!
>/tmp/multisystem/multisystem-menu-persistent
while read line
do
echo "$line" >>/tmp/multisystem/multisystem-menu-persistent
var=(${var[@]} $line)
[ "$line" == "}" ] && break
done <<<"$(echo -e "${paragraphe}")"
export paragraphe="$(cat /tmp/multisystem/multisystem-menu-persistent)"



#Ubuntu
function MOD_CASPER()
{
#test si persistent déjà present
if [ -f "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/casper-rw" ]; then
zenity --error --text "<b>$(eval_gettext 'Erreur: 1 mode persistent est déjà présent,\n1 seul est possible.')</b>"
else
while true
do
tpersistent="$(zenity --scale --text "$(eval_gettext "Taille du mode persistent en Mio")" --min-value=256 --max-value=${max_value} --value=${value} --step 128)"
stop="$?"
if [ "$stop" -ne "0" ]; then
echo stop
break
elif [ "$(($(df | grep ^$(cat /tmp/multisystem/multisystem-selection-usb) | awk '{print $4}')/1024))" -lt "${tpersistent}" ]; then
zenity --error --text "<b>$(eval_gettext "Erreur pas suffisament d\047espace libre dans $(cat /tmp/multisystem/multisystem-selection-usb)\n\nSouhaité:${tpersistent}\nDisponible:$(($(df | grep ^$(cat /tmp/multisystem/multisystem-selection-usb) | awk '{print $4}')/1024))")</b>"
else
echo tpersistent:"${tpersistent}"
function FCT_CREERMP()
{
#Ajouter une entrée à grub.cfg
dater="$(date +%d-%m-%Y-%T-%N)"
echo -e "$(echo -e "${ligne}" | awk -F"|" '{print "#MULTISYSTEM_MENU_DEBUT|'${dater}'" "|" $3 "|" $4 "|" $5 "|persistent '${tpersistent}'Mio"}')
$(echo -e "${paragraphe}" | sed "s/menuentry \"/menuentry \"Mode persistent /" | sed "s/boot=casper/boot=casper showmounts persistent/")
$(echo -e "${ligne}" | awk -F"|" '{print "#MULTISYSTEM_MENU_FIN|'${dater}'" "|" $3 "|" $4 "|" $5 "|persistent '${tpersistent}'Mio"}')" >/tmp/multisystem/multisystem-persistent
#virer les saut de ligne
sed -i ':a;N;$!ba;s/\n/\\n/g' /tmp/multisystem/multisystem-persistent
#Ajouter entree à grub.cfg
sed -i "s@^#MULTISYSTEM_STOP@$(cat /tmp/multisystem/multisystem-persistent)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
#Créer fichier image vide persistent
dd if=/dev/zero of="$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/casper-rw"  bs=1M count=${tpersistent}
#Formater le fichier image persistent
#mkfs.ext3 -L casper-rw -F "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/casper-rw"
mkfs.ext2 -L casper-rw -F "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/casper-rw"
}
(echo 1;FCT_CREERMP ;echo 100) | zenity --progress --pulsate --auto-close --width 400 --title "$(eval_gettext 'Création du mode persistent')"
#Mettre grub2 à jour
xterm -title 'Update_Bootloaders' -e './update_grub.sh'
break
fi
done
fi
}



#Debian-live
#http://www.mjc-athena.org/mediawiki/index.php/Live_Helper
#http://live.debian.net/manual/html/live-environment.html
#http://live.debian.net/manual/html/persistence.html
function MOD_LIVE()
{
#test si persistent déjà present
if [ -f "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/live-rw" ]; then
zenity --error --text "<b>$(eval_gettext 'Erreur: 1 mode persistent est déjà présent,\n1 seul est possible.')</b>"
else
while true
do
tpersistent="$(zenity --scale --text "$(eval_gettext "Taille du mode persistent en Mio")" --min-value=256 --max-value=${max_value} --value=${value} --step 128)"
stop="$?"
if [ "$stop" -ne "0" ]; then
echo stop
break
elif [ "$(($(df | grep ^$(cat /tmp/multisystem/multisystem-selection-usb) | awk '{print $4}')/1024))" -lt "${tpersistent}" ]; then
zenity --error --text "<b>$(eval_gettext "Erreur pas suffisament d\047espace libre dans $(cat /tmp/multisystem/multisystem-selection-usb)\n\nSouhaité:${tpersistent}\nDisponible:$(($(df | grep ^$(cat /tmp/multisystem/multisystem-selection-usb) | awk '{print $4}')/1024))")</b>"
else
echo tpersistent:"${tpersistent}"
function FCT_CREERMP()
{
#Ajouter une entrée à grub.cfg
dater="$(date +%d-%m-%Y-%T-%N)"
#persistent-path=/live/image
#debug=whatyouwant
echo -e "$(echo -e "${ligne}" | awk -F"|" '{print "#MULTISYSTEM_MENU_DEBUT|'${dater}'" "|" $3 "|" $4 "|" $5 "|persistent '${tpersistent}'Mio"}')
$(echo -e "${paragraphe}" | sed "s/menuentry \"/menuentry \"Mode persistent /" | sed "s/boot=live/boot=live debug=whatyouwant persistent-path=\/ persistent/")
$(echo -e "${ligne}" | awk -F"|" '{print "#MULTISYSTEM_MENU_FIN|'${dater}'" "|" $3 "|" $4 "|" $5 "|persistent '${tpersistent}'Mio"}')" >/tmp/multisystem/multisystem-persistent
#virer les saut de ligne
sed -i ':a;N;$!ba;s/\n/\\n/g' /tmp/multisystem/multisystem-persistent
#Ajouter entree à grub.cfg
sed -i "s@^#MULTISYSTEM_STOP@$(cat /tmp/multisystem/multisystem-persistent)\n#MULTISYSTEM_STOP@" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
#Créer fichier image vide persistent
dd if=/dev/zero of="$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/live-rw" bs=1M count=${tpersistent}
#Formater en ext2/3 ? le fichier image persistent
mkfs.ext2 -L live-rw -F "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/live-rw"
#mkfs.ext3 -L live-rw -F "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/live-rw"
#sudo e2label "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/live-rw" live-rw
}
(echo 1;FCT_CREERMP ;echo 100) | zenity --progress --pulsate --auto-close --width 400 --title "$(eval_gettext 'Création du mode persistent')"
#modifier initrd pour corriger bug 502
xterm -title 'Debian-live' -e "sudo ${dossier}/divers/debian-live.sh $(echo $ligne |  awk -F"|" '{print $3}')"
#Mettre grub2 à jour
xterm -title 'Update_Bootloaders' -e './update_grub.sh'
break
fi
done
fi
}


#Déterminer quelle distro, et si supporte persistent
distro=""
#laisser espace devant persistent pour ne pas confondre avec nopersistent!
if [ "$(echo -e "${paragraphe}" | grep -i " persistent")" ]; then
zenity --error --text "<b>$(eval_gettext 'Erreur: 1 mode persistent est déjà présent,\n1 seul est possible.')</b>"
#Détection casper
elif [ "$(echo -e "${paragraphe}" | grep -i "boot=casper")" ]; then
MOD_CASPER
#Détection live
elif [ "$(echo -e "${paragraphe}" | grep -i "live-media-path" | grep -i "boot=live")" ]; then
MOD_LIVE
#special Crunchbang
elif [ "$(grep "fromiso=/.*boot=live" <<<"$(echo "${paragraphe}")")" ]; then
MOD_LIVE
else
zenity --error --text "<b>$(eval_gettext "Erreur:pas de mode persistent pour cette distribution")</b>"
fi

fi


exit 0
