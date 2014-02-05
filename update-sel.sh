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

#Installé via depôt
if [[ "$(dpkg -l 2>/dev/null | grep '^ii  multisystem')" && "$(grep '^deb http://liveusb.info/multisystem' /etc/apt/sources.list 2>/dev/null)" ]]; then

#update
xterm -title 'apt-get update' -e "\
echo -e \"\E[37;44m\033[1m $(eval_gettext 'Veuillez saisir votre mot de passe d\047administrateur') \033[0m\"
if [ ! \"$(sudo apt-key list 2>/dev/null | grep multiboot)\" ]; then
wget -q http://liveusb.info/multisystem/depot/multisystem.asc -O- | sudo apt-key add -
fi
sudo apt-get -q update
sleep .5
"

#verifier si il y a une mise à jour
if [ "$(apt-get upgrade -s | grep ^Inst | grep multisystem | awk '{print $2}')" ]; then
#mise à jour
nohup xterm -title 'apt-get upgrade multisystem' -e "./update_deb.sh" &
sleep .5
exit 0

else
zenity --info --title MultiSystem_Information --text="$(eval_gettext "Pas de mise à jour disponible,\nVous utilisez bien la dernière version du script.")"
#Relancer gui
nohup "${dossier}/gui_multisystem.sh" &
fi

#mise à jour disponible
elif [ "$(dpkg -l | grep '^Inst  multisystem')" ]; then
nohup xterm -title 'apt-get upgrade multisystem' -e "./update_deb.sh" &
sleep .5
exit 0

#erreur depôt non present mais paquet installé
elif [ "$(dpkg -l | grep '^ii  multisystem')" ]; then
zenity --error --text="$(eval_gettext "Erreur: Impossible de détecter le depôt liveusb.info")"


#Installé via les sources
else
nohup ./update-src.sh &
fi

exit 0
