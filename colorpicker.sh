#!/bin/bash
chemin="$(cd "$(dirname "$0")";pwd)/$(basename "$0")";
dossier="$(dirname "$chemin")"
option="$1"

if [ ! "${option}" ]; then
exit 0
fi

#charger couleurs par defaut menu Grub
. "${dossier}"/colorpicker.txt
mkdir "$HOME"/.multisystem 2>/dev/null
[ ! "$(cat "$HOME"/.multisystem/color1.txt 2>/dev/null)" ] && echo "${color1}" >"$HOME/.multisystem/color1.txt"
[ ! "$(cat "$HOME"/.multisystem/color2.txt 2>/dev/null)" ] && echo "${color2}" >"$HOME/.multisystem/color2.txt"
[ ! "$(cat "$HOME"/.multisystem/color3.txt 2>/dev/null)" ] && echo "${color3}" >"$HOME/.multisystem/color3.txt"
[ ! "$(cat "$HOME"/.multisystem/color4.txt 2>/dev/null)" ] && echo "${color4}" >"$HOME/.multisystem/color4.txt"
[ ! "$(cat "$HOME"/.multisystem/color5.txt 2>/dev/null)" ] && echo "${color5}" >"$HOME/.multisystem/color5.txt"

#fichier couleur demandée?
color="$HOME/.multisystem/${option}.txt"
#exit si fichier pas present!
if [ ! -f "${color}" ]; then
exit 0
fi

cd "$(dirname "$chemin")/img"
export TREE='<window title="ColorPicKer" icon-name="gtk-select-color" decorated="true">
<vbox spacing="0">
<tree  hover_selection="true" headers_visible="false" exported_column="0">
<label>Code hexa</label>
<input icon_column="0">ls -A | grep ".*.png$" | sed "s/.png//" | awk '\''{print ""$0 "|" $0}'\''</input>
<height>250</height><width>150</width>
<variable>TREE</variable>
<action signal="button-press-event">echo "$TREE" >'$color'</action>
<action signal="button-press-event">exit:rgb</action>
</tree>
</vbox>
</window>'
gtkdialog --program=TREE &>/dev/null
exit 0












