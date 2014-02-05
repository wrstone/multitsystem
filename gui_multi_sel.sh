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


#reset
>/tmp/multisystem/multisystem-sel-multi
>/tmp/multisystem/multisystem-sel-distro
echo $(($(df -B 1 | grep ^$(cat /tmp/multisystem/multisystem-selection-usb) | awk '{print $4}')/1024/1024)) >/tmp/multisystem/multisystem-sel-calcsize


#Supprimer sélection user
function FCT_multi_sel_delsel()
{
sed -i "s@gtk-cdrom|${*}.*@@g" /tmp/multisystem/multisystem-sel-multi
sed -i "/^$/d" /tmp/multisystem/multisystem-sel-multi
}


#Ajouter sélection user
function FCT_multi_sel_addsel()
{
if [ "$(cat /tmp/multisystem/multisystem-sel-multi | grep "${*}" )" ]; then
wmctrl -c "$(eval_gettext 'Erreur: LiveCD déjà présent.')"
zenity --title="$(eval_gettext 'Erreur: LiveCD déjà présent.')" --error --text "$(eval_gettext 'Erreur: LiveCD déjà présent.')"&
sleep 1
wmctrl -a "$(eval_gettext 'Erreur: LiveCD déjà présent.')"
else
#verifier si nom fichier ne pose pas problemes
if [ ! -f "${*}" ]; then
zenity --error --text "$(eval_gettext "Erreur:Le fichier iso sélectionné contiens un caractère non supporté dans son nom:")"
fi
if [ "$(echo "$(basename "${*}")" | grep -iE "(\.iso$)|(\.img$)")" ]; then
echo "gtk-cdrom|${*}|$(($(du -sB 1 "${*}" | awk '{print $1}')/1024/1024))" >>/tmp/multisystem/multisystem-sel-multi
fi
fi
}


#Calcul taille restante
function FCT_multi_sel_calcsize()
{
echo $(($(df -B 1 | grep ^$(cat /tmp/multisystem/multisystem-selection-usb) | awk '{print $4}')/1024/1024)) >/tmp/multisystem/multisystem-sel-calcsize
total="0"
cat /tmp/multisystem/multisystem-sel-multi | awk -F '|' '{print $2}' | while read line
do
tiso="$(($(du -sB 1 "$line" | awk '{print $1}')/1024/1024))"
total="$(($total + $tiso))"
echo $total
echo $(($(($(df -B 1 | grep ^$(cat /tmp/multisystem/multisystem-selection-usb) | awk '{print $4}')/1024/1024))-$total)) >/tmp/multisystem/multisystem-sel-calcsize
done
#verifier espace disponible #>=
if [ "10" -ge "$(cat /tmp/multisystem/multisystem-sel-calcsize)" ]; then
zenity --error --text "$(eval_gettext "Erreur: pas suffisament d\047espace libre:")"&
delsel="$(awk 'END {print}' /tmp/multisystem/multisystem-sel-multi)"
sed -i "s@${delsel}@@" /tmp/multisystem/multisystem-sel-multi
sed -i "/^$/d" /tmp/multisystem/multisystem-sel-multi
#recalculer la taille
./gui_multi_sel.sh calcsize
fi
}

export -f FCT_multi_sel_delsel FCT_multi_sel_addsel FCT_multi_sel_calcsize


#Thème
. ./theme.sh

export MAIN_DIALOG='<window width_request="700" height_request="400" window_position="1" title="Multi-select" icon-name="multisystem-icon" decorated="true" resizable="false">
<vbox>

<vbox height_request="60">
<frame>
<vbox height_request="40">
<text sensitive="false">
<variable>msg</variable>
<input>echo "$(cat /tmp/multisystem/multisystem-sel-distro)\n'$(eval_gettext 'Libre:')'$(cat /tmp/multisystem/multisystem-sel-calcsize)Mio '$(eval_gettext 'Nombre de LiveCD:')'$(wc -l /tmp/multisystem/multisystem-sel-multi | awk '\''{print $1}'\'')"</input>
</text>
</vbox>
</frame>
</vbox>

<hbox height_request="270">

<vbox>
<button height_request="270">
<input file stock="gtk-delete"></input>
<variable>btclear</variable>
<action>test "$tree" && bash -c "FCT_multi_sel_delsel ${tree}"</action>
<action>test "$tree" && bash -c "FCT_multi_sel_calcsize"</action>
<action>refresh:msg</action>
<action>refresh:tree</action>
</button>
</vbox>

<tree rules_hint="true" headers_visible="false" hover_expand="false" hover_selection="false" exported_column="0">
<label>1|2|3</label>
<variable>tree</variable>
<input icon_column="0">cat /tmp/multisystem/multisystem-sel-multi</input>
<action signal="button-release-event">test "$tree" && echo "$(basename "$(grep "$tree" /tmp/multisystem/multisystem-sel-multi | awk -F '\''|'\'' '\''{print $2}'\'')") $(grep "$tree" /tmp/multisystem/multisystem-sel-multi | awk -F '\''|'\'' '\''{print $3}'\'')Mio" >/tmp/multisystem/multisystem-sel-distro</action>
<action signal="button-release-event">refresh:msg</action>
</tree>


<vbox>
<chooser accept="newdirectory" show-hidden="false">
<height>270</height><width>480</width>
<variable>CHOOSER</variable>
<action>bash -c "FCT_multi_sel_addsel $CHOOSER"</action>
<action>bash -c "FCT_multi_sel_calcsize"</action>
<action>echo "$(basename "$(grep "$CHOOSER" /tmp/multisystem/multisystem-sel-multi | awk -F '\''|'\'' '\''{print $2}'\'')") $(grep "$CHOOSER" /tmp/multisystem/multisystem-sel-multi | awk -F '\''|'\'' '\''{print $3}'\'')Mio" >/tmp/multisystem/multisystem-sel-distro</action>
<action>refresh:tree</action>
<action>refresh:msg</action>
</chooser>
</vbox>

</hbox>

<vbox>
<pixmap>
<input file>'${theme_bdo}'</input>
</pixmap>
</vbox>

<hbox>
<button>
<input file stock="gtk-cancel"></input>
<variable>btnul</variable>
<label>"'$(eval_gettext 'Annuler')'"</label>
<action>rm /tmp/multisystem/multisystem-sel-multi</action>
<action type="exit">cancel</action>
</button>
<button>
<input file stock="gtk-ok"></input>
<variable>btok</variable>
<label>"'$(eval_gettext 'Créer')'"</label>
<action type="exit">ok</action>
</button>
</hbox>

</vbox>
</window>'
gtkdialog --program=MAIN_DIALOG
exit 0
