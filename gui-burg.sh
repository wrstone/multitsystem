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

#Exit si multisystem n'est pas lancé!
if [ ! "$(cat /tmp/multisystem/multisystem-selection-uuid-usb 2>/dev/null)" ]; then
exit 0
fi

#reserver pour karmic et lucid ou déjà installé
if [ "$(which tazpkg)" ]; then
echo "Burg Compil Slitaz"
elif [ "$(lsb_release -cs)" = "karmic" ]; then
echo "karmic"
elif [ "$(lsb_release -cs)" = "lucid" ]; then
echo "lucid"
elif [ "$(lsb_release -cs)" = "maverick" ]; then
echo "maverick"
elif [ "$(lsb_release -cs)" = "natty" ]; then
echo "natty"
elif [ "$(lsb_release -cs)" = "oneiric" ]; then
echo "oneiric"
elif [ "$(lsb_release -cs)" = "precise" ]; then
echo "precise"
elif [ "$(lsb_release -cs)" = "xxxx" ]; then
echo "xxxx"
else
zenity --info --text "<b>$(eval_gettext 'Cette partie du script est réservé à Ubuntu karmic et lucid'), maverick, natty, oneiric, precise</b>"
exit 0
fi

#${burg_folder}
burg_folder="/boot/burg"



#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒Install▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
#Install Burg Slitaz
if [ "$(which tazpkg)" ]; then
echo ok Slitaz
if [ ! "$(which burg-install)" ]; then
echo Compiler Burg
export INFO='<window width_request="400" height_request="140" window_position="1" title="Info" icon-name="multisystem-icon" decorated="true" resizable="false">
<vbox spacing="0">
<frame>
<hbox homogeneous="true">
<text use-markup="true">
<variable>MESSAGES</variable>
<input>echo "\<span color='\''red'\'' font_weight='\''bold'\'' size='\''larger'\''>'$(eval_gettext 'Attention! vous allez installer Burg,\nce logiciel est experimental')'\</span>" | sed "s/\\\//g"</input>
</text>
</hbox>
</frame>
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
<label>"'$(eval_gettext "Valider")'"</label>
<action type="exit">ok</action>
</button>
</hbox>
</vbox>
</window>'
#monter gui
I=$IFS; IFS=""
for MENU_INFO in  $(gtkdialog --program=INFO); do
eval $MENU_INFO
if [ "$EXIT" != "ok" ]; then
exit 0
fi
done
IFS=$I
#Lancer Install Burg Slitaz
"${dossier}/burg/burg-slitaz-compil.sh"
#exit si toujours pas présent!
if [ ! "$(which burg-install)" ]; then
exit 0
fi
#si téléchargement du thème a échoué exit!
if [ ! -d "/boot/burg/themes" ]; then
exit 0
fi
fi
fi
#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒Install▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒



#Si dossier thème perso existe pas le créer
if [ ! -d "$HOME"/.multisystem/burg/themes ]; then
mkdir -p "$HOME"/.multisystem/burg/themes
fi

#Si dossier icons perso existe pas le créer
if [ ! -d "$HOME"/.multisystem/burg/icons ]; then
mkdir -p "$HOME"/.multisystem/burg/icons
cp -Rn "${dossier}/burg/icons/." "$HOME"/.multisystem/burg/icons/ 2>/dev/null
#Copier les icones à utiliser dans dossier perso
while read line
do
cp -n "${dossier}/pixmaps/multisystem-${line}.png" "$HOME"/.multisystem/burg/icons/multisystem-${line}.png 2>/dev/null
done <<<"$(grep '#MULTISYSTEM_MENU_DEBUT' "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/grub/grub.cfg" | awk -F "|" '{print $4}' | sed "s/multisystem-//")"
fi

#Editer burg.cfg
if [ "${option1}" == "config" ]; then
if [ ! -f "$HOME"/.multisystem/burg/burg.cfg ]; then
cp -f "${dossier}/burg/burg.cfg" "$HOME"/.multisystem/burg/burg.cfg
fi
if which gedit >/dev/null 2>&1; then
gedit "$HOME"/.multisystem/burg/burg.cfg
elif which kwrite >/dev/null 2>&1; then
kwrite "$HOME"/.multisystem/burg/burg.cfg
elif which kate >/dev/null 2>&1; then
kate "$HOME"/.multisystem/burg/burg.cfg
elif which leafpad >/dev/null 2>&1; then
leafpad "$HOME"/.multisystem/burg/burg.cfg
elif which mousepad >/dev/null 2>&1; then
mousepad "$HOME"/.multisystem/burg/burg.cfg
elif which geany >/dev/null 2>&1; then
geany "$HOME"/.multisystem/burg/burg.cfg
fi
wait
cp -f "$HOME"/.multisystem/burg/burg.cfg "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/burg/burg.cfg"
fi


#Changer resolution gfxboot
if [ "${option1}" == "640" ]; then
if [ ! -f "$HOME"/.multisystem/burg/burg.cfg ]; then
cp -f "${dossier}/burg/burg.cfg" "$HOME"/.multisystem/burg/burg.cfg
fi
sed -i "s/set gfxmode=.*/set gfxmode=640x480/" "$HOME"/.multisystem/burg/burg.cfg
cat "$HOME"/.multisystem/burg/burg.cfg 2>/dev/null | sed '/set gfxmode=/!d' | awk -F "=" '{print "multisystem-display-properties|" $2}' >/tmp/multisystem/multisystem-sel-gfxboot-burg
elif [ "${option1}" == "1024" ]; then
if [ ! -f "$HOME"/.multisystem/burg/burg.cfg ]; then
cp -f "${dossier}/burg/burg.cfg" "$HOME"/.multisystem/burg/burg.cfg
fi
sed -i "s/set gfxmode=.*/set gfxmode=1024x768/" "$HOME"/.multisystem/burg/burg.cfg
cat "$HOME"/.multisystem/burg/burg.cfg 2>/dev/null | sed '/set gfxmode=/!d' | awk -F "=" '{print "multisystem-display-properties|" $2}' >/tmp/multisystem/multisystem-sel-gfxboot-burg
fi


#theme peso
if [ "${option1}" == "theme" ]; then
if [  "$(which nautilus)" ]; then
nautilus "$HOME"/.multisystem/burg/themes 2>/dev/null&
elif [ "$(which dolphin)" ]; then
dolphin "$HOME"/.multisystem/burg/themes 2>/dev/null&
elif [ "$(which rox-filer)" ]; then
rox-filer "$HOME"/.multisystem/burg/themes 2>/dev/null&
elif [ "$(which thunar)" ]; then
thunar "$HOME"/.multisystem/burg/themes 2>/dev/null&
elif [ "$(which pcmanfm)" ]; then
pcmanfm "$HOME"/.multisystem/burg/themes 2>/dev/null&
fi
fi


#Icones peso
if [ "${option1}" == "icon" ]; then
cp -Rn "${dossier}/burg/icons/." "$HOME"/.multisystem/burg/icons/ 2>/dev/null
#Copier les icones à utiliser dans dossier perso
while read line
do
cp -n "${dossier}/pixmaps/multisystem-${line}.png" "$HOME"/.multisystem/burg/icons/multisystem-${line}.png 2>/dev/null
done <<<"$(grep '#MULTISYSTEM_MENU_DEBUT' "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/grub/grub.cfg" | awk -F "|" '{print $4}' | sed "s/multisystem-//")"


if [  "$(which nautilus)" ]; then
nautilus "$HOME"/.multisystem/burg/icons 2>/dev/null&
elif [ "$(which dolphin)" ]; then
dolphin "$HOME"/.multisystem/burg/icons 2>/dev/null&
elif [ "$(which rox-filer)" ]; then
rox-filer "$HOME"/.multisystem/burg/icons 2>/dev/null&
elif [ "$(which thunar)" ]; then
thunar "$HOME"/.multisystem/burg/icons 2>/dev/null&
elif [ "$(which pcmanfm)" ]; then
pcmanfm "$HOME"/.multisystem/burg/icons 2>/dev/null&
fi
fi


#select
if [[ "${option1}" == "select" && "${option2}" && -d "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/burg" ]]; then
#Copier thèmes perso
cp -Rf "$HOME"/.multisystem/burg/themes/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/burg/themes/"
#Définir selection theme perso
sed -i "s/^set theme_name=.*/set theme_name=${option2}/" "$HOME"/.multisystem/burg/burg.cfg
#Générer la liste des thèmes disponibles dans ==> /boot/burg/list-theme-burg.txt
#  load_string '+theme_menu { -multisystem { command="set theme_name=multisystem" }}'
>"$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/burg/list-theme-burg.txt"
while read line
do
echo -e "  load_string '+theme_menu { -${line} { command=\"set theme_name=${line}\" }}'" >>"$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/burg/list-theme-burg.txt"
done <<<"$(ls "$(cat /tmp/multisystem/multisystem-mountpoint-usb)"/boot/burg/themes/ | grep -vE '(^conf.d$)|(^icons$)')" | awk '{print $1}'
fi


#refresh
if [ "${option1}" == "refresh" ]; then
#liste les thèmes disponibles
echo "$(ls "$(cat /tmp/multisystem/multisystem-mountpoint-usb)"/boot/burg/themes/ 2>/dev/null | grep -vE '(^conf.d$)|(^icons$)')" | awk '{print "multisystem-grub48|" $1}' >/tmp/multisystem/multisystem-list-themes-burg
#Relever la selection user du thème
cat "$HOME"/.multisystem/burg/burg.cfg 2>/dev/null | sed '/^set theme_name=/!d' | awk -F "=" '{print "multisystem-grub48|" $2}' >/tmp/multisystem/multisystem-sel-themes-burg
fi



#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒Maj▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
#burg
if [ "${option1}" == "burg" ]; then
rm -R "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/burg/"
#Instal Burg dans mbr
xterm -title 'burg-install' -e "\
#! /bin/bash
###Pour exporter la librairie de gettext.
set -a
source gettext.sh
set +a
export TEXTDOMAIN=multisystem
export TEXTDOMAINDIR=${dossier}/locale
. gettext.sh
multisystem=$0
echo -e \"\E[37;44m\033[1m $(eval_gettext 'Veuillez saisir votre mot de passe d\047administrateur') \033[0m\"
sudo update-burg
sudo burg-install --no-floppy --recheck --force --root-directory=\"$(cat /tmp/multisystem/multisystem-mountpoint-usb)\" \
\"$(cat /tmp/multisystem/multisystem-selection-usb | sed 's/[0-9]//')\"
"

function FCT_MFBURG()
{
#Copier themes
#cp -Rf /boot/burg/themes/ "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/burg"
mkdir "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/burg/themes/" 2>/dev/null
rsync -av --progress ${burg_folder}/themes/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/burg/themes/."
#Copier fonts
cp -Rf ${burg_folder}/fonts/ "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/burg"
cp -f ${burg_folder}/unicode.pf2 "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/burg/unicode.pf2" 2>/dev/null
#Copier thème multisystem
cp -Rf "${dossier}/burg/multisystem" "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/burg/themes/"

#virer thèmes qui deconnent!
rm -R "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/burg/themes/debian-theme"
#rm -R "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/burg/themes/radiance"
#rm -R "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/burg/themes/radiancetext"
#rm -R "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/burg/themes/sora"
#rm -R "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/burg/themes/sora_clean"
#rm -R "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/burg/themes/sora_extended"
#rm -R "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/burg/themes/black_and_white"
#rm -R "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/burg/themes/coffee"

#Copier thèmes perso
cp -Rf "$HOME"/.multisystem/burg/themes/. "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/burg/themes/"

#Remplacer chemins des icones pour thèmes avec fichier icons/icons
#Remplacer
#include "icons/icons"
#par
#include "../icons/hover"
while read line
do
echo $line
if [ -f "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/burg/themes/${line}/icons/icons" ]; then
sed -i 's@include "icons/icons"@include "../icons/hover"@' "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/burg/themes/${line}/theme"
fi
done <<<"$(ls "$(cat /tmp/multisystem/multisystem-mountpoint-usb)"/boot/burg/themes/ | grep -vE '(^conf.d$)|(^icons$)')" | awk '{print $1}'
#Créer fichier load.cfg
echo -e "search.fs_uuid $(cat /tmp/multisystem/multisystem-selection-uuid-usb) root 
set prefix=($root)/boot/burg" | tee "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/burg/load.cfg"
#Copier squelette burg.cfg
if [ ! -f "$HOME"/.multisystem/burg/burg.cfg ]; then
cp -f "${dossier}/burg/burg.cfg" "$HOME"/.multisystem/burg/burg.cfg
fi
cp -f "$HOME"/.multisystem/burg/burg.cfg "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/burg/burg.cfg"
#Remplacer UUID du disque dans burg.cfg
sed -i "s@xxxx-xxxx@$(cat /tmp/multisystem/multisystem-selection-uuid-usb)@" "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/burg/burg.cfg"
#Remplacer lang
lang_burg="$(echo "${LANG}" | awk -F "_" '{print $1 }')"
sed -i "s@set lang=.*@set lang=${lang_burg}@" "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/burg/burg.cfg"



#Recupérer les menu de grub2 dans fichier ==> "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/burg/menu-temp.txt"
sed -n "/^#MULTISYSTEM_MENU_DEBUT.*$/,/^#MULTISYSTEM_MENU_FIN.*$/p" "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/grub/grub.cfg" >"$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/burg/menu-temp.txt"
#phraser le fichier menu-temp.txt
sed -i "s/{/xxxx {/" "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/burg/menu-temp.txt"
>"$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/burg/menu.txt"
while read line
do
date="$(echo "${line}" | awk -F "|" '{print $2}')"
icone="$(echo "${line}" | awk -F "|" '{print $4}' | sed "s/multisystem-//")"
paragraphe="$(sed -n "/^#MULTISYSTEM_MENU_DEBUT|${date}/,/^#MULTISYSTEM_MENU_FIN|${date}/p" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/burg/menu-temp.txt")"
echo "${paragraphe}"  | sed "s/xxxx/--class ${icone} --class gnu-linux --class gnu --class os --group group_main/g" >>"$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/burg/menu.txt"
done <<<"$(sed -n '/^#MULTISYSTEM_MENU_DEBUT/p' "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/burg/menu-temp.txt" | sed "s/#MULTISYSTEM_MENU_DEBUT//")"
rm "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/burg/menu-temp.txt"



#Créer icones pour les thèmes
#128 pixels
#/media/*/boot/burg/themes/icons/large
#24 pixels
#/media/*/boot/burg/themes/icons/small
#128 pixels
#/media/*/boot/burg/themes/icons/hover
#haut du fichier
echo -e '+class\n{' >"$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/burg/themes/icons/hover"
echo -e '+class\n{' >"$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/burg/themes/icons/small"
echo -e '+class\n{' >"$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/burg/themes/icons/large"
echo -e '+class\n{' >"$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/burg/themes/icons/multisystem"
echo -e '+class\n{' >"$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/burg/themes/icons/grey"
#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
#centre du fichier
#debut boucle
while read line
do
echo "${line}"
echo "  -${line} { image = \"\$\$/grey_${line}.png:\$\$/large_${line}.png\" }" >>"$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/burg/themes/icons/hover"
echo "  -${line} { image = \"\$\$/small_${line}.png\" }" >>"$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/burg/themes/icons/small"
echo "  -${line} { image = \"\$\$/large_${line}.png\" }" >>"$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/burg/themes/icons/large"
echo "  -${line} { image = \"\$\$/multisystem_${line}.png\" }" >>"$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/burg/themes/icons/multisystem"
echo "  -${line} { image = \"\$\$/grey_${line}.png\" }" >>"$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/burg/themes/icons/grey"

#Dossier ou prendre les icones? perso ou dans pixmaps
if [ -f "$HOME"/.multisystem/burg/icons/multisystem-${line}.png ]; then
usefolder="$HOME/.multisystem/burg/icons"
else
usefolder="${dossier}/pixmaps/"
fi

#Convertir en 24x24 pixels small
convert "${usefolder}/multisystem-${line}.png" \
-depth 8 \
-density 72x72 \
-units PixelsPerInch \
-resize 24x24 \
-colorspace RGB \
-type TrueColorMatte \
"$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/burg/themes/icons/small_${line}.png"

#Convertir en 48x48 pixels multisystem
convert "${usefolder}/multisystem-${line}.png" \
-depth 8 \
-density 72x72 \
-units PixelsPerInch \
-resize 48x48 \
-colorspace RGB \
-type TrueColorMatte \
"$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/burg/themes/icons/multisystem_${line}.png"

#Convertir en niveau de gris 128 pixels -colorspace gray
convert "${usefolder}/multisystem-${line}.png" \
-depth 8 \
-density 72x72 \
-units PixelsPerInch \
-resize 128x128 \
-colorspace Gray \
-type TrueColorMatte \
"$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/burg/themes/icons/grey_${line}.png"

#Convertir en 128 pixels large
convert "${usefolder}/multisystem-${line}.png" \
-depth 8 \
-density 72x72 \
-units PixelsPerInch \
-resize 128x128 \
-colorspace RGB \
-type TrueColorMatte \
"$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/burg/themes/icons/large_${line}.png"

done <<<"$(grep '#MULTISYSTEM_MENU_DEBUT' "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/grub/grub.cfg" | awk -F "|" '{print $4}' | sed "s/multisystem-//")"
#fin boucle
#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
#debut boucle icon bas du menu de multisystem
while read line
do
echo "${line}"
echo "  -${line} { image = \"\$\$/grey_${line}.png:\$\$/large_${line}.png\" }" >>"$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/burg/themes/icons/hover"
echo "  -${line} { image = \"\$\$/small_${line}.png\" }" >>"$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/burg/themes/icons/small"
echo "  -${line} { image = \"\$\$/large_${line}.png\" }" >>"$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/burg/themes/icons/large"
echo "  -${line} { image = \"\$\$/multisystem_${line}.png\" }" >>"$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/burg/themes/icons/multisystem"
echo "  -${line} { image = \"\$\$/grey_${line}.png\" }" >>"$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/burg/themes/icons/grey"

#Dossier ou prendre les icones? perso ou dans pixmaps
if [ -f "$HOME"/.multisystem/burg/icons/multisystem-${line}.png ]; then
usefolder="$HOME/.multisystem/burg/icons"
else
usefolder="${dossier}/burg/icons/"
fi

#Convertir en 24x24 pixels small
convert "${usefolder}/multisystem-${line}.png" \
-depth 8 \
-density 72x72 \
-units PixelsPerInch \
-resize 24x24 \
-colorspace RGB \
-type TrueColorMatte \
"$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/burg/themes/icons/small_${line}.png"

#Convertir en 48x48 pixels multisystem
convert "${usefolder}/multisystem-${line}.png" \
-depth 8 \
-density 72x72 \
-units PixelsPerInch \
-resize 48x48 \
-colorspace RGB \
-type TrueColorMatte \
"$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/burg/themes/icons/multisystem_${line}.png"

#Convertir en niveau de gris 128 pixels grey
convert "${usefolder}/multisystem-${line}.png" \
-depth 8 \
-density 72x72 \
-units PixelsPerInch \
-resize 128x128 \
-colorspace Gray \
-type TrueColorMatte \
"$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/burg/themes/icons/grey_${line}.png"

#Convertir en 128 pixels large
convert "${usefolder}/multisystem-${line}.png" \
-depth 8 \
-density 72x72 \
-units PixelsPerInch \
-resize 128x128 \
-colorspace RGB \
-type TrueColorMatte \
"$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/burg/themes/icons/large_${line}.png"

done <<<"$(ls "${dossier}/burg/icons" | sed "s/^multisystem-//" | sed "s/.png$//")"
#fin boucle icon bas du menu de multisystem

#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
#bas du fichier
echo -e '  -image { image = "$$/grey_unknown.png:$$/large_unknown.png" }\n}' >>"$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/burg/themes/icons/hover"
echo -e '  -image { image = "$$/small_unknown.png" }\n}' >>"$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/burg/themes/icons/small"
echo -e '  -image { image = "$$/large_unknown.png" }\n}' >>"$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/burg/themes/icons/large"
echo -e '  -image { image = "$$/multisystem_unknown.png" }\n}' >>"$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/burg/themes/icons/multisystem"
echo -e '  -image { image = "$$/grey_unknown.png" }\n}' >>"$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/burg/themes/icons/grey"
#Custom
echo -e '\n  -include "../custom/icon_large"' >>"$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/burg/themes/icons/hover"
echo -e '\n  -include "../custom/icon_small"' >>"$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/burg/themes/icons/small"
echo -e '\n  -include "../custom/icon_large"' >>"$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/burg/themes/icons/large"
echo -e '\n  -include "../custom/icon_multisystem"' >>"$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/burg/themes/icons/multisystem"
echo -e '\n  -include "../custom/icon_grey"' >>"$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/burg/themes/icons/grey"

#Générer la liste des thèmes disponibles dans ==> /boot/burg/list-theme-burg.txt
#  load_string '+theme_menu { -multisystem { command="set theme_name=multisystem" }}'
>"$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/burg/list-theme-burg.txt"
while read line
do
echo -e "  load_string '+theme_menu { -${line} { command=\"set theme_name=${line}\" }}'" >>"$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/burg/list-theme-burg.txt"
done <<<"$(ls "$(cat /tmp/multisystem/multisystem-mountpoint-usb)"/boot/burg/themes/ | grep -vE '(^conf.d$)|(^icons$)')" | awk '{print $1}'
}
(echo 1;FCT_MFBURG ;echo 100) | zenity --progress --pulsate --auto-close --width 400 --title "burg-install"

#Instal Burg dans mbr
xterm -title 'burg-install' -e "\
#! /bin/bash
###Pour exporter la librairie de gettext.
set -a
source gettext.sh
set +a
export TEXTDOMAIN=multisystem
export TEXTDOMAINDIR=${dossier}/locale
. gettext.sh
multisystem=$0
echo -e \"\E[37;44m\033[1m $(eval_gettext 'Veuillez saisir votre mot de passe d\047administrateur') \033[0m\"
sudo burg-install --no-floppy --recheck --force --root-directory=\"$(cat /tmp/multisystem/multisystem-mountpoint-usb)\" \
\"$(cat /tmp/multisystem/multisystem-selection-usb | sed 's/[0-9]//')\"
"

exit 0
fi
#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒Fin-Maj▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒



#liste les thèmes disponibles
listdispo="$(echo "$(ls "$(cat /tmp/multisystem/multisystem-mountpoint-usb)"/boot/burg/themes/ 2>/dev/null | grep -vE '(^conf.d$)|(^icons$)')" | awk '{print "multisystem-grub48|" $1}')"
if [ "${listdispo}" != "multisystem-grub48|" ]; then
echo -e "${listdispo}" >/tmp/multisystem/multisystem-list-themes-burg
else
echo "multisystem-grub48|N/A" >/tmp/multisystem/multisystem-list-themes-burg
fi

#Relever la selection user du thème
cat "$HOME"/.multisystem/burg/burg.cfg 2>/dev/null | sed '/^set theme_name=/!d' | awk -F "=" '{print "multisystem-grub48|" $2}' >/tmp/multisystem/multisystem-sel-themes-burg
cat "$HOME"/.multisystem/burg/burg.cfg 2>/dev/null | sed '/set gfxmode=/!d' | grep -v '#'| awk -F "=" '{print "multisystem-display-propertiesoo|" $2}' >/tmp/multisystem/multisystem-sel-gfxboot-burg

#Exit si option demandée!
if [ "${options}" ]; then
exit 0
fi


#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒Install▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
#Installer Burg
if [ ! "$(which burg-install)" ]; then
export INFO='<window width_request="400" height_request="140" window_position="1" title="Info" icon-name="multisystem-icon" decorated="true" resizable="false">
<vbox spacing="0">
<frame>
<hbox homogeneous="true">
<text use-markup="true">
<variable>MESSAGES</variable>
<input>echo "\<span color='\''red'\'' font_weight='\''bold'\'' size='\''larger'\''>'$(eval_gettext 'Attention! vous allez installer Burg,\nce logiciel est experimental')'\</span>" | sed "s/\\\//g"</input>
</text>
</hbox>
</frame>
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
<label>"'$(eval_gettext "Valider")'"</label>
<action type="exit">ok</action>
</button>
</hbox>
</vbox>
</window>'
#monter gui
I=$IFS; IFS=""
for MENU_INFO in  $(gtkdialog --program=INFO); do
eval $MENU_INFO
if [ "$EXIT" != "ok" ]; then
exit 0
fi
done
IFS=$I

xterm -title 'burg-install' -e "\
#! /bin/bash
###Pour exporter la librairie de gettext.
set -a
source gettext.sh
set +a
export TEXTDOMAIN=multisystem
export TEXTDOMAINDIR=${dossier}/locale
. gettext.sh
multisystem=$0
echo -e \"\E[37;44m\033[1m $(eval_gettext 'Veuillez saisir votre mot de passe d\047administrateur') \033[0m\"
if [ \"$(lsb_release -cs)\" = \"natty\" ]; then
#http://www.webdevonlinux.fr/2011/05/ubuntu-11-04-installer-burg-pour-de-beaux-themes-de-boot/
#http://www.omgubuntu.co.uk/2011/05/beautiful-burg-boot-loader-gets-ubuntu-11-04-ppa/
#https://launchpad.net/~n-muench/+archive/burg?field.series_filter=natty
sudo add-apt-repository ppa:n-muench/burg
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys EAE0D85C
sudo apt-get update
sudo apt-get install burg burg-common burg-emu burg-pc burg-themes burg-themes-common

elif [ \"$(lsb_release -cs)\" = \"oneiric\" ]; then
sudo add-apt-repository ppa:n-muench/burg
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys EAE0D85C
sudo apt-get update
sudo apt-get install burg burg-common burg-emu burg-pc burg-themes burg-themes-common

elif [ \"$(lsb_release -cs)\" = \"precise\" ]; then
sudo add-apt-repository ppa:n-muench/burg
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys EAE0D85C
sudo apt-get update
sudo apt-get install burg burg-common burg-emu burg-pc burg-themes burg-themes-common

else
sudo add-apt-repository ppa:bean123ch/burg
sudo apt-get update
sudo apt-get install -y burg burg-themes burg-emu
fi
"
fi
#exit si toujours pas présent!
if [ ! "$(which burg-install)" ]; then
exit 0
fi
#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒Fin-Install▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒



texte_annonce="$(eval_gettext "Burg")"
export INFO='<window width_request="400" height_request="400" resizable="false" title="MultiSystem_PoPuP" window_position="1" icon-name="multisystem-icon" decorated="true">
<vbox spacing="0">

<frame>
<text use-markup="true" wrap="true" sensitive="false">
<input>echo "\<b>\<big>'$texte_annonce'\</big>\</b>" | sed "s%\\\%%g"</input>
</text>
</frame>

<hbox homogeneous="true" height_request="32">
<button>
<input file icon="gtk-preferences"></input>
<label>'$(eval_gettext 'Thèmes personnels')'</label>
<action>./gui-burg.sh theme</action>
<action>refresh:select</action>
<action>refresh:tree</action>
</button>
<button>
<input file icon="gtk-preferences"></input>
<label>'$(eval_gettext 'Icones personnelles')'</label>
<action>./gui-burg.sh icon</action>
<action>refresh:select</action>
<action>refresh:tree</action>
</button>
</hbox>

<hbox homogeneous="true" height_request="32">
<button>
<input file icon="gtk-preferences"></input>
<label>burg.cfg</label>
<action>./gui-burg.sh config</action>
<action>refresh:select</action>
<action>refresh:tree</action>
</button>
</hbox>

<hbox homogeneous="true" height_request="32">
<button relief="1">
<input file icon="multisystem-display-properties"></input>
<label>640x480</label>
<action>./gui-burg.sh 640</action>
<action>refresh:gfxboot</action>
</button>
<tree headers_visible="false" exported_column="0">
<label>sel</label>
<input icon_column="0">cat /tmp/multisystem/multisystem-sel-gfxboot-burg</input>
<variable>gfxboot</variable>
<action signal="button-press-event">refresh:gfxboot</action>
</tree>
<button>
<input file icon="multisystem-display-properties"></input>
<label>1024x768</label>
<action>./gui-burg.sh 1024</action>
<action>refresh:gfxboot</action>
</button>
</hbox>

<frame>
<hbox height_request="25">
<text use-markup="true">
<input>echo "\<b>'$(eval_gettext 'Thème par defaut:')'\</b>" | sed "s%\\\%%g"</input>
</text>
<tree headers_visible="false" exported_column="0">
<label>sel</label>
<input icon_column="0">cat /tmp/multisystem/multisystem-sel-themes-burg</input>
<variable>select</variable>
<action signal="button-press-event">refresh:select</action>
<action signal="button-press-event">refresh:tree</action>
</tree>
</hbox>
</frame>

<frame '$(eval_gettext 'Choix du thème à utiliser par defaut')'>
<hbox height_request="70">
<tree hover_selection="true" headers_visible="false" exported_column="0">
<label>files</label>
<input icon_column="0">cat /tmp/multisystem/multisystem-list-themes-burg</input>
<variable>tree</variable>
<action signal="button-press-event">./gui-burg.sh select\|$tree</action>
<action signal="button-press-event">./gui-burg.sh refresh</action>
<action signal="button-press-event">refresh:select</action>
<action signal="button-press-event">refresh:tree</action>
</tree>
</hbox>
</frame>

<button>
<input file icon="multisystem-grub"></input>
<label>'$(eval_gettext 'Installer/Mettre Burg à jour (patience)')'</label>
<action>./gui-burg.sh burg</action>
<action>refresh:select</action>
<action>refresh:tree</action>
</button>

<hbox>
<button width_request="160">
<input file icon="gtk-close"></input>
<label>"'$(eval_gettext "Fermer")'"</label>
<action type="exit">exit</action>
</button>
</hbox>

</vbox>
</window>'
gtkdialog --program=INFO

exit 0
#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒F.I.N▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
#Extraire les menu de grub.cfg
sed -n "/^#MULTISYSTEM_MENU_DEBUT.*$/,/^#MULTISYSTEM_MENU_FIN.*$/p" $(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/grub/grub.cfg 

#Extraire le nom des icones du menu de grub2
grep '#MULTISYSTEM_MENU_DEBUT' $(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/grub/grub.cfg | awk -F "|" '{print $4}' | sed "s/multisystem-//"

#Generer burg.cfg dans terminal
sudo burg-mkconfig

#mettre a jour burg
sudo burg-install --no-floppy --recheck --force --root-directory="$(cat /tmp/multisystem/multisystem-mountpoint-usb)" \
"$(cat /tmp/multisystem/multisystem-selection-usb | sed 's/[0-9]//')"

#Quelques adresses...
#https://help.ubuntu.com/community/Burg
#http://code.google.com/p/burg/wiki/InstallUbuntu
#http://forum.ubuntu-fr.org/viewtopic.php?pid=3369046
#http://grub.gibibit.com/Themes

#Thèmes...
#http://gnome-look.org/content/show.php/Gnome+theme+for+burg?content=122560&amp;PHPSESSID=3b0dcc8194977066b5c0a11d95682d91
#http://www.sourceslist.eu/guide/altri-temi-per-il-burg-basati-su-sora-clean/

#http://code.google.com/p/burg/wiki/InstallUbuntu
#http://forum.ubuntu-fr.org/viewtopic.php?pid=3369046

#Ci-dessous la liste des raccourcis clavier définis dans le menu de burg (au moment du boot ou dans l'émulateur):
t – Ouvre le menu de sélection du thème
f – Basculer entre le mode simple et avancé
w – Saut vers Windows
u – Saut vers Ubuntu
e – modifier la commande courante de démarrage
c – Ouvre une fenêtre de terminal
2 – Ouvre deux fenêtres de terminal
h – Affiche la fenêtre d’aide (disponible uniquement dans la Sora thème)
i – Affiche des informations sur la fenêtre (disponible uniquement dans le thème sora)
q - Retour à l’ancien menu Grub
F5/ctrl-x – fin des modifications
F6 – Switch window in dual terminal mode ???
F7 – Liste les éléments de démarrage dans le dossier
F8 – Passer du mode graphique au mode texte et vice versa
F9 – Shutdowm
F10 – Redémarrez
ESC – Quitter dans le menu ou la boîte de dialogue en cours
