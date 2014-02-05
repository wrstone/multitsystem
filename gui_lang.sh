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

#Caler lang
#pour slitaz
if [ "$USER" == "tux" ]; then
export LANG="$(cat "$HOME/.multisystem/lang_sel.txt" | awk -F'|' '{print $3}')"
else
declare -x LANGUAGE="$(cat "$HOME/.multisystem/lang_sel.txt" | awk -F'|' '{print $3}')"
fi

function lister_lang()
{
echo "<combobox allow-empty=\"false\" value-in-list=\"true\" width_request=\"140\"><variable>modlang</variable>"
while read line
do
echo "<item>$(echo ${line} | awk -F'|' '{print $1}')</item>"
done <<<"$(cat "${dossier}/lang_list.txt" | sed "/^$/d")"
echo "</combobox>"
}


texte_annonce="MultiSystem recherche des traducteurs,\nMerci de nous contacter\nsi vous souhaitez participer\nContact:liveusb@gmail.com\n\nMultiSystem looking for translators,\nThank you contact us\nif you want to participate\nContact:liveusb@gmail.com"

export INFO='<window title="MultiSystem_PoPuP" icon-name="multisystem-icon" decorated="true" width_request="400" height_request="400">
<vbox>

<hbox>
'$(lister_lang)'
<button>
<input file icon="config-language"></input>
<label>"'$(eval_gettext "Changer de language")'"</label>
<action type="exit">selang</action>
</button>
</hbox>


<frame>
<text use-markup="true" wrap="true" width-chars="70" sensitive="false">
<input>echo "\<b>\<big>'$texte_annonce'\</big>\</b>" | sed "s%\\\%%g"</input>
</text>
</frame>

<hbox>
<button width_request="160">
<input file icon="gtk-close"></input>
<label>"'$(eval_gettext "Fermer")'"</label>
<action type="exit">exit</action>
</button>
</hbox>
</vbox>
</window>'

#monter gui
I=$IFS; IFS=""
for MENU_INFO in  $(gtkdialog -c --program=INFO); do
eval $MENU_INFO
done
IFS=$I

#Changer lang par defaut dans le fichier "$HOME/.multisystem/lang_sel.txt"
if [ "$EXIT" == "selang" ]; then
while read line
do
if [ "$(echo ${line} | awk -F'|' '{print $1}')" = "${modlang}" ]; then
echo ${line} | awk -F'|' '{print $1}'
echo "${line}" >"$HOME/.multisystem/lang_sel.txt"
break
fi
done <<<"$(cat "${dossier}/lang_list.txt" | sed "/^$/d")"
rm -R /tmp/multisystem 2>/dev/null
killall gui-detect.sh 2>/dev/null
killall gui_multisystem.sh 2>/dev/null
killall "${dossier}/fonctions.sh"
kill $(ps ax | grep '/bin/bash ./fonctions.sh lang' | awk '{print $1}' | xargs)
#xterm -e "read"
rm "${dossier}/nohup.out" 2>/dev/null
#wmctrl -c MULTISYSTEM
nohup "${dossier}/gui_multisystem.sh" &
sleep 1
fi
exit 0
