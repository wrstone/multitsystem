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

function FCT_GUIDETECT()
{
#relever idfenetre attente pour livecd
while true
do
#wid="$(wmctrl -l | grep ' MultiSystem$' | awk '{print $1}')"
wid="$(wmctrl -p -G -l | grep '400.*420' | grep ' MultiSystem$' | awk '{print $1}')"
echo Attente idfenetre
if [ "${wid}" ]; then
echo $wid >/tmp/multisystem/multisystem-idgui
#activer fenetre
xdotool windowactivate $(cat /tmp/multisystem/multisystem-idgui)
#masquer
xdotool windowunmap $(cat /tmp/multisystem/multisystem-idgui)
break
fi
sleep .1
done
}
FCT_GUIDETECT&

#monter gui
I=$IFS; IFS=""
for MENU_INFO in  $(./gui_multi_sel.sh); do
eval $MENU_INFO
done
IFS=$I

if [ "$EXIT" != "ok" ]; then
>/tmp/multisystem/multisystem-sel-multi
fi

i=0
cat /tmp/multisystem/multisystem-sel-multi | awk -F '|' '{print $2}' | while read line
do
let i++
#afficher
xdotool windowmap $(cat /tmp/multisystem/multisystem-idgui)
#activer fenetre
xdotool windowactivate $(cat /tmp/multisystem/multisystem-idgui)
./fonctions.sh add\|$line\|${i}
done


#afficher
xdotool windowmap $(cat /tmp/multisystem/multisystem-idgui)
#activer fenetre
xdotool windowactivate $(cat /tmp/multisystem/multisystem-idgui)
exit 0
