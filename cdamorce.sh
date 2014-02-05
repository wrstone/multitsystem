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
echo "idgui:$(cat /tmp/multisystem/multisystem-idgui)"
if [ "$(cat /tmp/multisystem/multisystem-idgui)" ]; then
xdotool windowmap $(cat /tmp/multisystem/multisystem-idgui)
#activer fenetre
xdotool windowactivate $(cat /tmp/multisystem/multisystem-idgui)
wmctrl -c MultiSystem-logo
fi
}



#Faire test présence de PloP et message si pas présent
if [ ! -f "$HOME"/.multisystem/nonfree/bootcd/boot/plpbt.img ]; then
./fonctions-nonfree.sh alert-plop
else

echo -e "\E[37;44m\033[1m $(eval_gettext 'Veuillez saisir votre mot de passe d\047administrateur') \033[0m"
mkdir /tmp/multisystem/multisystem-mountpoint-plop 2>/dev/null
sudo mount -o loop,rw "$HOME"/.multisystem/nonfree/bootcd/boot/plpbt.img /tmp/multisystem/multisystem-mountpoint-plop
#Activer usb par defaut!
sudo "$HOME"/.multisystem/nonfree/plpcfgbt cnt=on cntval=3 dbt=usb /tmp/multisystem/multisystem-mountpoint-plop/plpbt.bin
#echo Attente
#read
sudo umount /tmp/multisystem/multisystem-mountpoint-plop
rmdir /tmp/multisystem/multisystem-mountpoint-plop
cd "$HOME"/.multisystem/nonfree
genisoimage -r -b boot/plpbt.img -c boot/boot.catalog -o "$HOME"/cd-boot-liveusb.iso -V plop_bootmanager bootcd
#echo Attente
#read

echo -e '\E[37;44m'"\033[1m $(eval_gettext "Veuillez graver image du cd\nChemin: \$HOME/cd-boot-liveusb.iso\n(clic droit, graver sur le disque...)") \033[0m"
zenity --info --text "<b>$(eval_gettext "l\047image du cd d\047amorce est disponible,")
$(eval_gettext "Chemin"): \"$HOME/cd-boot-liveusb.iso\"
$(eval_gettext "(clic droit, graver sur le disque...)")

$(eval_gettext "Avant démarrer votre PC si besoin est,")
$(eval_gettext "insérez le CD ainsi que votre clé USB")</b>"
fi


exit 0
