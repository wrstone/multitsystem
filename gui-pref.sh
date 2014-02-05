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


#texteditor
function FCT_texteditor()
{
texteditor="gedit"
if which gedit >/dev/null 2>&1; then
texteditor="gedit"
elif which kwrite >/dev/null 2>&1; then
texteditor="kwrite"
elif which kate >/dev/null 2>&1; then
texteditor="kate"
elif which mousepad >/dev/null 2>&1; then
texteditor="mousepad"
elif which geany >/dev/null 2>&1; then
texteditor="geany"
elif which leafpad >/dev/null 2>&1; then
texteditor="leafpad"
fi
}
FCT_texteditor

#changer splash
function FCT_splash_change()
{
if [ "$1" = "splash_change" ]; then
#Convertir
convert "$2" /tmp/multisystem/multisystem-splash-convert.png
if [ "$(identify "/tmp/multisystem/multisystem-splash-convert.png" | awk '{print $2}')" != "PNG" ]; then
zenity --error --text "$(eval_gettext "Erreur: impossible de détecter Type:PNG dans votre sélection.")"
exit 0
fi
convert "/tmp/multisystem/multisystem-splash-convert.png" \
-strip -density 72x72 \
-resize 323x242 \
"/tmp/multisystem/multisystem-splash-prevue.png"
convert "/tmp/multisystem/multisystem-splash-convert.png" \
-strip -density 72x72 \
-resize 640x480 \
"/tmp/multisystem/multisystem-splash.png"
if [ "$(identify "/tmp/multisystem/multisystem-splash.png" | awk '{print $3}')" != "640x480" ]; then
zenity --error --text "$(eval_gettext "Erreur: impossible de convertir en 640x480.")"
exit 0
fi
#copier splash
mv -f "/tmp/multisystem/multisystem-splash-prevue.png" "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/splash/splash-prevue.png"
mv -f "/tmp/multisystem/multisystem-splash.png"  "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/splash/splash.png"
cp -f "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/splash/splash-prevue.png" "$HOME"/.local/share/icons/hicolor/48x48/apps/multisystem-splash-prevue.png
#splash pour grub4dos
convert -resize 640x480 -colors 14 \
"$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/splash/splash.png" \
"$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/splash/splash.xpm.gz"
exit 0
fi
}

#splash_reset
function FCT_splash_reset()
{
if [ "$1" == "splash_reset" ]; then
rm "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/splash/splash.png"
rm "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/splash/splash-prevue.png"
rm "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/splash/splash.xpm.gz"
cp "${dossier}/boot/splash/not_available.png" "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/splash/splash-prevue.png"
cp -f "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/splash/not_available.png" "$HOME"/.local/share/icons/hicolor/48x48/apps/multisystem-splash-prevue.png
exit 0
fi
}

#splash_revert
function FCT_splash_revert()
{
if [ "$1" == "splash_revert" ]; then
cp -f "${dossier}/boot/splash/splash.png" "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/splash/splash.png"
cp -f "${dossier}/boot/splash/splash-prevue.png" "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/splash/splash-prevue.png"
cp -f "${dossier}/boot/splash/splash-prevue.png" "$HOME"/.local/share/icons/hicolor/48x48/apps/multisystem-splash-prevue.png
cp -f "${dossier}/boot/splash/splash.xpm.gz" "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/splash/splash.xpm.gz"
exit 0
fi
}

#splash_flip
function FCT_splash_flip()
{
if [[ "$1" == "splash_flip" && -e "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/splash/splash.png" ]]; then
mogrify -flip "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/splash/splash.png"
mogrify -flip "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/splash/splash-prevue.png"
mogrify -flip "$HOME"/.local/share/icons/hicolor/48x48/apps/multisystem-splash-prevue.png
#splash pour grub4dos
convert -resize 640x480 -colors 14 \
"$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/splash/splash.png" \
"$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/splash/splash.xpm.gz"
exit 0
fi
}

#splash flop
function FCT_splash_flop()
{
if [[ "$1" == "splash_flop" && -e "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/splash/splash.png" ]]; then
mogrify -flop "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/splash/splash.png"
mogrify -flop "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/splash/splash-prevue.png"
mogrify -flop "$HOME"/.local/share/icons/hicolor/48x48/apps/multisystem-splash-prevue.png
#splash pour grub4dos
convert -resize 640x480 -colors 14 \
"$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/splash/splash.png" \
"$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/splash/splash.xpm.gz"
exit 0
fi
}

#exporter les fonftions
export -f FCT_splash_flop FCT_splash_flip FCT_splash_revert FCT_splash_reset FCT_splash_change

#charger couleurs par defaut menu Grub
echo "multisystem-splash-prevue" >/tmp/multisystem/multisystem-splash-prevue
. "${dossier}"/colorpicker.txt
mkdir "$HOME"/.multisystem 2>/dev/null
[ ! "$(cat "$HOME"/.multisystem/color1.txt 2>/dev/null)" ] && echo "${color1}" >"$HOME/.multisystem/color1.txt"
[ ! "$(cat "$HOME"/.multisystem/color2.txt 2>/dev/null)" ] && echo "${color2}" >"$HOME/.multisystem/color2.txt"
[ ! "$(cat "$HOME"/.multisystem/color3.txt 2>/dev/null)" ] && echo "${color3}" >"$HOME/.multisystem/color3.txt"
[ ! "$(cat "$HOME"/.multisystem/color4.txt 2>/dev/null)" ] && echo "${color4}" >"$HOME/.multisystem/color4.txt"
[ ! "$(cat "$HOME"/.multisystem/color5.txt 2>/dev/null)" ] && echo "${color5}" >"$HOME/.multisystem/color5.txt"

#copier splash dans icon hicolor perso
if [ ! -e "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/splash/splash-prevue.png" ]; then
cp -f "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/splash/not_available.png" "$HOME"/.local/share/icons/hicolor/48x48/apps/multisystem-splash-prevue.png
else
cp -f "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/splash/splash-prevue.png" "$HOME"/.local/share/icons/hicolor/48x48/apps/multisystem-splash-prevue.png
fi


export MOD_WAIT='<window title="MultiSystem-logo" decorated="false" window_position="1">
<vbox spacing="0">
<pixmap>
<input file>./logo.png</input>
</pixmap>
</vbox>
</window>'

export INFO='<window width_request="400" height_request="400" resizable="false" title="MultiSystem_PoPuP" window_position="1" icon-name="multisystem-icon" decorated="true">
<vbox spacing="0">

<hbox>
<frame>
<vbox homogeneous="true">
<button tooltip-text="'$(eval_gettext 'Éditer le fichier de configuration de grub2 .../grub.cfg')'">
<input file stock="gtk-preferences"></input>
<label>"grub.cfg"</label>
<action>exec '${texteditor}' &</action>
<action>exec '${texteditor}' "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/grub/grub.cfg" &</action>
</button>
<button tooltip-text="'$(eval_gettext 'Éditer le fichier de configuration de grub4dos .../menu.lst')'">
<input file stock="gtk-preferences"></input>
<label>"menu.lst"</label>
<action>exec '${texteditor}' "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/grub/menu.lst" &</action>
</button>
<button tooltip-text="'$(eval_gettext 'Éditer le fichier de configuration de syslinux .../syslinux.cfg')'">
<input file stock="gtk-preferences"></input>
<label>"syslinux.cfg"</label>
<action>exec '${texteditor}' "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/syslinux/syslinux.cfg" &</action>
</button>
</vbox>
</frame>

<vbox>
<text use-markup="true">
<label>"'$(eval_gettext 'Choix image de boot Grub2')'"</label>
</text>
<entry editable="false">
<height>1</height><width>1</width>
<variable>SPLASH</variable>
<action>bash -c "FCT_splash_change splash_change $SPLASH"</action>
<action>refresh:choiximg</action>
<action>clear:SPLASH</action>
</entry>

<hbox>

<hbox>
<vbox homogeneous="true">
<button height_request="50" tooltip-text="'$(eval_gettext 'Spalsh defaut')'">
<input file stock="gtk-revert-to-saved"></input>
<variable>btclear</variable>
<action>bash -c "FCT_splash_revert splash_revert"</action>
<action>refresh:choiximg</action>
</button>
<button height_request="50" tooltip-text="'$(eval_gettext 'Renversement vertical')'">
<input file icon="multisystem-flip-vertical"></input>
<variable>bt2</variable>
<action>bash -c "FCT_splash_flip splash_flip"</action>
<action>refresh:choiximg</action>
</button>
</vbox>
</hbox>
<hbox>
<vbox homogeneous="true">
<button height_request="50" tooltip-text="'$(eval_gettext 'Effacer splash')'">
<input file stock="gtk-clear"></input>
<variable>btclear</variable>
<action>bash -c "FCT_splash_reset splash_reset"</action>
<action>refresh:choiximg</action>
</button>
<button height_request="50" tooltip-text="'$(eval_gettext 'Renversement horizontal')'">
<input file icon="multisystem-flip-horizontal"></input>
<variable>bt4</variable>
<action>bash -c "FCT_splash_flop splash_flop"</action>
<action>refresh:choiximg</action>
</button>
</vbox>
</hbox>

<vbox width_request="140">
<tree hover_selection="true" headers_visible="false" exported_column="0">
<variable>choiximg</variable>
<label>1</label>
<action signal="button-press-event" type="fileselect">SPLASH</action>
<input icon_column="0">cat /tmp/multisystem/multisystem-splash-prevue</input>
</tree>
</vbox>
</hbox>

</vbox>
</hbox>

<frame '$(eval_gettext 'Couleur fond écran')'>
<hbox  height_request="32">
<tree hover_selection="true" headers_visible="false" exported_column="0">
<label>"'$(eval_gettext 'hexa|Titre')'"</label>
<input icon_column="0">echo "$(cat "'$HOME'"/.multisystem/color5.txt) | $(cat "'$HOME'"/.multisystem/color5.txt) | "'$(eval_gettext 'Couleur fond écran')'""</input>
<variable>COULEUR5</variable>
<action signal="button-press-event">'${dossier}'/colorpicker.sh color5</action>
<action signal="button-press-event">refresh:COULEUR5</action>
<action signal="button-press-event">disable:COULEUR5</action>
</tree>
<button tooltip-text="'$(eval_gettext 'Valeur par defaut')'">
<input file stock="gtk-clear"></input>
<action>echo "'$color5'" >"'$HOME'"/.multisystem/color5.txt</action>
<action>refresh:COULEUR5</action>
</button>
</hbox>
</frame>

<frame '$(eval_gettext 'Couleurs cadre')'>
<hbox height_request="32">
<tree hover_selection="true" headers_visible="false" exported_column="0">
<label>"'$(eval_gettext 'hexa|Titre')'"</label>
<input icon_column="0">echo "$(cat "'$HOME'"/.multisystem/color1.txt) | $(cat "'$HOME'"/.multisystem/color1.txt) | "'$(eval_gettext 'Couleur texte')'""</input>
<variable>COULEUR1</variable>
<action signal="button-press-event">'${dossier}'/colorpicker.sh color1</action>
<action signal="button-press-event">refresh:COULEUR1</action>
<action signal="button-press-event">disable:COULEUR1</action>
</tree>
<button tooltip-text="'$(eval_gettext 'Valeur par defaut')'">
<input file stock="gtk-clear"></input>
<action>echo "'$color1'" >"'$HOME'"/.multisystem/color1.txt</action>
<action>refresh:COULEUR1</action>
</button>
</hbox>

<hbox height_request="32">
<tree hover_selection="true" headers_visible="false" exported_column="0">
<label>"'$(eval_gettext 'hexa|Titre')'"</label>
<input icon_column="0">echo "$(cat "'$HOME'"/.multisystem/color2.txt) | $(cat "'$HOME'"/.multisystem/color2.txt) | "'$(eval_gettext 'Couleur fond')'""</input>
<variable>COULEUR2</variable>
<action signal="button-press-event">'${dossier}'/colorpicker.sh color2</action>
<action signal="button-press-event">refresh:COULEUR2</action>
<action signal="button-press-event">disable:COULEUR2</action>
</tree>
<button tooltip-text="'$(eval_gettext 'Valeur par defaut')'">
<input file stock="gtk-clear"></input>
<action>echo "'$color2'" >"'$HOME'"/.multisystem/color2.txt</action>
<action>refresh:COULEUR2</action>
</button>
</hbox>

<hbox height_request="32">
<tree hover_selection="true" headers_visible="false" exported_column="0">
<label>"'$(eval_gettext 'hexa|Titre')'"</label>
<input icon_column="0">echo "$(cat "'$HOME'"/.multisystem/color3.txt) | $(cat "'$HOME'"/.multisystem/color3.txt) | "'$(eval_gettext 'Couleur texte sélectionné')'""</input>
<variable>COULEUR3</variable>
<action signal="button-press-event">'${dossier}'/colorpicker.sh color3</action>
<action signal="button-press-event">refresh:COULEUR3</action>
<action signal="button-press-event">disable:COULEUR3</action>
</tree>
<button tooltip-text="'$(eval_gettext 'Valeur par defaut')'">
<input file stock="gtk-clear"></input>
<action>echo "'$color3'" >"'$HOME'"/.multisystem/color3.txt</action>
<action>refresh:COULEUR3</action>
</button>
</hbox>

<hbox  height_request="32">
<tree hover_selection="true" headers_visible="false" exported_column="0">
<label>"'$(eval_gettext 'hexa|Titre')'"</label>
<input icon_column="0">echo "$(cat "'$HOME'"/.multisystem/color4.txt) | $(cat "'$HOME'"/.multisystem/color4.txt) | "'$(eval_gettext 'Couleur fond sélectionné')'""</input>
<variable>COULEUR4</variable>
<action signal="button-press-event">'${dossier}'/colorpicker.sh color4</action>
<action signal="button-press-event">refresh:COULEUR4</action>
<action signal="button-press-event">disable:COULEUR4</action>
</tree>
<button tooltip-text="'$(eval_gettext 'Valeur par defaut')'">
<input file stock="gtk-clear"></input>
<action>echo "'$color4'" >"'$HOME'"/.multisystem/color4.txt</action>
<action>refresh:COULEUR4</action>
</button>
</hbox>

</frame>

<hbox>
<button width_request="160">
<input file icon="gtk-close"></input>
<label>"'$(eval_gettext "Fermer")'"</label>
<action type="exit">exit</action>
</button>
</hbox>
</vbox>
<action signal="enter-notify-event">refresh:choiximg</action>
<action signal="enter-notify-event">enable:COULEUR1</action>
<action signal="enter-notify-event">enable:COULEUR2</action>
<action signal="enter-notify-event">enable:COULEUR3</action>
<action signal="enter-notify-event">enable:COULEUR4</action>
<action signal="enter-notify-event">enable:COULEUR5</action>
</window>'
#monter gui
gtkdialog --program=INFO



#mettre en place le couleurs grub
if [ -d "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/splash" ]; then
echo
if [ "$(grep "set menu_color_normal=" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")"/boot/grub/grub.cfg)" ]; then
echo
if [ "$(grep "set menu_color_highlight=" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")"/boot/grub/grub.cfg)" ]; then
#set menu_color_normal=cyan/blue
#set menu_color_highlight=white/blue

#Affcher logo
gtkdialog --program=MOD_WAIT&

#mettre couleurs dans var
color1="$(cat "$HOME"/.multisystem/color1.txt)" #couleur texte
color2="$(cat "$HOME"/.multisystem/color2.txt)" #couleur fond
color3="$(cat "$HOME"/.multisystem/color3.txt)" #couleur texte délectionné
color4="$(cat "$HOME"/.multisystem/color4.txt)" #couleur fond délectionné
color5="$(cat "$HOME"/.multisystem/color5.txt)" #couleur fond écran, si pas de spalsh
#echo ${color1} ${color2} ${color3} ${color4} ${color5}

#Avec fond ecran
sed -i "s@set color_normal.* #1@set color_normal=${color1}/black #1@g" \
"$(cat "/tmp/multisystem/multisystem-mountpoint-usb")"/boot/grub/grub.cfg
sed -i "s@set color_highlight.* #1@set color_highlight=${color3}/${color4} #1@g" \
"$(cat "/tmp/multisystem/multisystem-mountpoint-usb")"/boot/grub/grub.cfg

#Sans fond ecran
sed -i "s@set menu_color_normal.* #2@set menu_color_normal=${color1}/${color2} #2@g" \
"$(cat "/tmp/multisystem/multisystem-mountpoint-usb")"/boot/grub/grub.cfg
sed -i "s@set menu_color_highlight.* #2@set menu_color_highlight=${color3}/${color4} #2@g" \
"$(cat "/tmp/multisystem/multisystem-mountpoint-usb")"/boot/grub/grub.cfg
sed -i "s@set color_normal.* #2@set color_normal=${color1}/${color5} #2@g" \
"$(cat "/tmp/multisystem/multisystem-mountpoint-usb")"/boot/grub/grub.cfg
sed -i "s@set color_highlight.* #2@set color_highlight=${color3}/${color4} #2@g" \
"$(cat "/tmp/multisystem/multisystem-mountpoint-usb")"/boot/grub/grub.cfg

#Fermer logo
sleep 1
wmctrl -c 'MultiSystem-logo'

fi
fi
fi
exit 0
