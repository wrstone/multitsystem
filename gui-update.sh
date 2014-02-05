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

options="$*"
option1="$(echo "$options" | awk -F"|" '{print $1}')"
option2="$(echo "$options" | awk -F"|" '{print $2}')"

varupdate="$(cat "$HOME/.multisystem/checkupdate")"

#Exit si option demandée!
if [ "${options}" ]; then
exit 0
fi

#Thème
. ${dossier}/theme.sh

export INFO='<window width_request="400" height_request="400" resizable="false" title="MultiSystem_PoPuP"  window_position="1" icon-name="multisystem-icon" decorated="true">
<vbox>

<frame>
<vbox>
<text use-markup="true" wrap="true" width-chars="70">
<input>echo "\<b>\<span color=\"blue\">'$(eval_gettext "A ce jour MultiSystem est gratuit\nmais son développement n\\047est pas sans frais!\nSi vous l\\047utilisez régulièrement\net que vous souhaitez qu\\047il continue à évoluer,\nmerci de faire un geste de soutien via paypal.\n\npar avance MERCI!\nFrançois Fabre @frafa")'\</span>\</b>" | sed "s%\\\%%g" | sed "s%\\\\n\\\\n\\\\n%%g"</input>
</text>
</vbox>
</frame>

<hbox>
<pixmap>
<input file>'${theme_bdo}'</input>
</pixmap>
</hbox>

<vbox>
<checkbox active="'${varupdate}'">
<label>"'$(eval_gettext 'Vérifier les mise à jour à chaque lancement')'"</label>
<variable>checkupdate</variable>
<action>if true echo true >"'$HOME'/.multisystem/checkupdate"</action>
<action>if false echo false >"'$HOME'/.multisystem/checkupdate"</action>
</checkbox>
</vbox>

<hbox>
<pixmap>
<input file>'${theme_bdo}'</input>
</pixmap>
</hbox>

<vbox>
<radiobutton active="true">
<label>"'$(eval_gettext "Faire une donation")'"</label>
<variable>RADIOBUTTON1</variable>
</radiobutton>
<radiobutton>
<label>"'$(eval_gettext "Ne pas faire de donation")'"</label>
<variable>RADIOBUTTON2</variable>
</radiobutton>
</vbox>

<hbox>
<pixmap>
<input file>'${theme_bdo}'</input>
</pixmap>
</hbox>

<vbox>
<radiobutton active="true">
<label>"'$(eval_gettext "Mise à jour")'"</label>
<variable>RADIOBUTTON3</variable>
</radiobutton>
<radiobutton>
<label>"'$(eval_gettext "Mise à jour partielle")'"</label>
<variable>RADIOBUTTON4</variable>
</radiobutton>
</vbox>

<hbox>
<pixmap>
<input file>'${theme_bdo}'</input>
</pixmap>
</hbox>

<hbox>
<button>
<input file icon="gtk-cancel"></input>
<label>'$(eval_gettext 'Annuler')'</label>
<action type="exit">null</action>
</button>
<button>
<input file icon="gtk-apply"></input>
<label>'$(eval_gettext 'Mise à jour')'</label>
<action type="exit">paypal</action>
</button>
</hbox>

</vbox>
</window>'

#monter gui
I=$IFS; IFS=""
for MENU_INFO in  $(gtkdialog --program=INFO); do
eval $MENU_INFO
done
IFS=$I
$RADIOBUTTON1 && xdg-open 'http://liveusb.info/dotclear/index.php?pages/Soutien'&
if [ "$EXIT" == "paypal" ]; then
echo
if [ "$RADIOBUTTON3" == "true" ]; then
./update-sel.sh
elif [ "$RADIOBUTTON4" == "true" ]; then
wget -nd http://liveusb.info/multisystem/os_support.sh -O /tmp/multisystem/os_support.sh 2>&1 \
| sed -u 's/\([ 0-9]\+K\)[ \.]*\([0-9]\+%\) \(.*\)/\2\n#Transfert : \1 (\2) à \3/' \
| zenity --progress --auto-kill --auto-close --width 400 --title "$(eval_gettext 'Téléchargement en cours...')"
if [ "$(diff /tmp/multisystem/os_support.sh ${dossier}/os_support.sh 2>/dev/null)" ]; then
#Remplacer...
echo
if [ "$(du -h "/tmp/multisystem/os_support.sh" 2>/dev/null | awk '{print $1}')" == "0" ]; then
zenity --error --text "$(eval_gettext 'Erreur de téléchargement')"
elif [ "$(grep FCT_RELOAD /tmp/multisystem/os_support.sh 2>/dev/null)" ]; then
cp -f /tmp/multisystem/os_support.sh ${dossier}/os_support.sh
fi
else
zenity --info --title MultiSystem_Information --text="$(eval_gettext "Pas de mise à jour disponible,\nVous utilisez bien la dernière version du script.")"
fi
fi
fi
exit 0
