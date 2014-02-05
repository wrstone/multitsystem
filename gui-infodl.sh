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



#Télécharger des LiveCD
echo All | tee /tmp/multisystem/multisystem-output-list
function FCT_download_livecd()
{
#Audio Utility Antivirus Gamer
if [ "$(grep -E "(Audio)|(Utility)|(Antivirus)|(Gamer)" <<<"$1")" ]; then
#Lancer logo
gtkdialog --program=MOD_WAIT&
#while read line
#do
#test  "$(echo "$line" | sed "/^#/d" | sed "/^$/d" | awk -F "|" '{print $4}' | grep -E "${1}")" && echo $line
#done <"${dossier}/list.txt"
cat "${dossier}/list.txt" | sed "/^#/d" | sed "/^$/d"  | grep -E "\|${1}\|"
sleep .2
wmctrl -c MultiSystem-logo

elif [ "$1" = "All" ]; then
cat "${dossier}/list.txt" | grep -v "^#" | sed "/^$/d"

elif [ "$1" = "clear" ]; then
echo "||||"

elif [ "$1" ]; then
#Lancer logo
gtkdialog --program=MOD_WAIT&
cat "${dossier}/list.txt" | sed "/^#/d" | sed "/^$/d" | grep -iE "\|.*${1}.*\|.*\|.*\|"
sleep .2
wmctrl -c MultiSystem-logo

else
cat "${dossier}/list.txt" | grep -v "^#" | sed "/^$/d"
fi

}
export -f FCT_download_livecd



export INFO='<window window_position="1" title="MultiSystem_PoPuP" icon-name="multisystem-icon" decorated="true" width_request="400" height_request="400">
<vbox>

<hbox>
<entry activates_default="true">
<variable>QUOI</variable>
</entry>
<button>
<input file stock="gtk-find"></input>
<variable>RECHERCHER</variable>
<action signal="button-press-event">echo clear | tee /tmp/multisystem/multisystem-output-list</action>
<action signal="button-press-event">refresh:tree_list</action>
<action>echo "$QUOI" >/tmp/multisystem/multisystem-output-list</action>
<action>refresh:tree_list</action>
<action>echo | tee /tmp/multisystem/multisystem-output-list</action>
</button>
</hbox>

<hbox>
<button>
<label>All</label>
<input file stock="gtk-find"></input>
<action signal="button-press-event">clear:QUOI</action>
<action signal="button-press-event">echo clear | tee /tmp/multisystem/multisystem-output-list</action>
<action signal="button-press-event">refresh:tree_list</action>
<action>echo All | tee /tmp/multisystem/multisystem-output-list</action>
<action>refresh:tree_list</action>
</button>

<button>
<label>Audio</label>
<input file stock="gtk-find"></input>
<action signal="button-press-event">clear:QUOI</action>
<action signal="button-press-event">echo clear | tee /tmp/multisystem/multisystem-output-list</action>
<action signal="button-press-event">refresh:tree_list</action>
<action>echo Audio | tee /tmp/multisystem/multisystem-output-list</action>
<action>refresh:tree_list</action>
</button>

<button>
<label>Utility</label>
<input file stock="gtk-find"></input>
<action signal="button-press-event">clear:QUOI</action>
<action signal="button-press-event">echo clear | tee /tmp/multisystem/multisystem-output-list</action>
<action signal="button-press-event">refresh:tree_list</action>
<action>echo Utility | tee /tmp/multisystem/multisystem-output-list</action>
<action>refresh:tree_list</action>
</button>

<button>
<label>Antivirus</label>
<input file stock="gtk-find"></input>
<action signal="button-press-event">clear:QUOI</action>
<action signal="button-press-event">echo clear | tee /tmp/multisystem/multisystem-output-list</action>
<action signal="button-press-event">refresh:tree_list</action>
<action>echo Antivirus | tee /tmp/multisystem/multisystem-output-list</action>
<action>refresh:tree_list</action>
</button>

<button>
<label>Gamer</label>
<input file stock="gtk-find"></input>
<action signal="button-press-event">clear:QUOI</action>
<action signal="button-press-event">echo clear | tee /tmp/multisystem/multisystem-output-list</action>
<action signal="button-press-event">refresh:tree_list</action>
<action>echo Gamer | tee /tmp/multisystem/multisystem-output-list</action>
<action>refresh:tree_list</action>
</button>
</hbox>

<tree  headers_visible="true" exported_column="3" rules_hint="true">
<label>Name|Bootloader|Category|URL Download</label>
<variable>tree_list</variable>
<input icon_column="0">bash -c "FCT_download_livecd $(cat /tmp/multisystem/multisystem-output-list 2>/dev/null)"</input>
<action>test ${tree_list} && xdg-open ${tree_list}&</action>
</tree>

<hbox>
<button width_request="160">
<input file icon="gtk-close"></input>
<label>"'$(eval_gettext "Fermer")'"</label>
<action type="exit">exit</action>
</button>
</hbox>
</vbox>
</window>'
gtkdialog --program=INFO &>/dev/null
exit 0
