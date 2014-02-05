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

echo -e "\E[37;44m\033[1m $(eval_gettext 'Veuillez saisir votre mot de passe d\047administrateur') \033[0m"

#tuer process en cours
PID_SCRIPT=$(pidof -x $(basename $0))
rm "$dossier"/nohup.out 2>/dev/null
rm -R /tmp/multisystem 2>/dev/null
wmctrl -c MultiSystem-logo 2>/dev/null
wmctrl -c VBox 2>/dev/null
#wmctrl -c MULTISYSTEM 2>/dev/null
kill $(ps ax | grep '/bin/bash' | grep 'gui_multisystem.sh' | grep -v grep | awk '{print $1}' | xargs)
kill $(ps ax | grep 'gtkdialog --program=MULTISYSTEM' | grep -v grep | awk '{print $1}' | xargs)
#kill -9  $(lsof -at "$dossier" | grep -v $PID_SCRIPT | xargs) 2>/dev/null

#mettre à jour multisystem
sudo apt-get --yes --force-yes -q install --reinstall multisystem

#lancer gui
nohup /usr/local/share/multisystem/gui_multisystem.sh&
sleep 1
exit 0



