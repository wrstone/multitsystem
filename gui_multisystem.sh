#! /bin/bash --posix
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

#stop si root!
if [ "$(id -u)" == "0" ]; then
zenity --error --text "$(eval_gettext "Erreur: pas en root!")"
nohup "$dossier"/kill.sh&
exit 0
fi

#gtkrc perso
#bonne adresse pour les styles gtkrc ==> http://orford.org/gtk/
# Example pour modifier style des boutons nommés stylebt
#style "styleBorderless" {
#	GtkButton::inner-border = {10, 0, 0, 10}
#	xthickness = 0
#	ythickness = 0
#}
#widget "*stylebt" style "styleBorderless"
#
#Exemple pour changer police d'un widget nommé GtkEditFontMonospace
#style "styleGtkEditFontMonospace" {
#   text[NORMAL] = "#ffffff"
#   base[NORMAL] = "#000000"
#   font_name = "monospace 16"
#}
#widget "*GtkEditFontMonospace" style "styleGtkEditFontMonospace"
#
if [ -f "$HOME/.multisystem/gtkrc" ]; then
export GTK2_RC_FILES=$HOME/.multisystem/gtkrc:~/.gtkrc-2.0
fi

#Test les path et ajout à .profile de user si path existe et non present dans $PATH
#pour fonctionnement de which en user non sudo sur les bases Debian
function FCT_CHECKPATH()
{
[ ! -f "$HOME/.profile" ] && >"$HOME/.profile"
. $HOME/.profile
export PATH=$PATH
path_curents="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games"
path_actuels="$(echo $PATH | tr ":" "\n")"
path_add=""
I=$IFS; IFS=":"
for test_path in $path_curents; do
if [[ ! "$(grep "^${test_path}$" <<<"${path_actuels}")" ]]; then
path_add="${path_add}${test_path}:"
echo Ajouter PATH: ${test_path}
fi
done
IFS=$I
if [ "${path_add}" ]; then
echo "PATH=\"${path_add}\$PATH\"" | tee -a "$HOME/.profile"
export PATH="${path_add}$PATH"
fi
}
FCT_CHECKPATH

#Path gtkdialog
GTKDIALOG=gtkdialog
export GTKDIALOG

#Check version gtkdialog
function funcGTKDVGet() {
GTKVMINI="0.8.0"
GTKDV=( $($GTKDIALOG -v) )
GTKDV=${GTKDV[2]}
echo "Gtkdialog version: $GTKDV"
if [[ $GTKDV < $GTKVMINI ]]; then
GTKVADV="This application requires at least gtkdialog-$GTKVMINI,\nPlease updrade your version.\nWebsite: http://code.google.com/p/gtkdialog/"
echo -e "\033[1;47;31m $GTKVADV \033[0m"
zenity --info --text  "$GTKVADV"&
exit 0
fi
}
funcGTKDVGet 

#Créer dossier pref
if [ ! -d "$HOME/.multisystem/" ]; then
mkdir "$HOME/.multisystem/" 2>/dev/null
fi

#Mettre à jour les icones GTK ! à revoir ...
#http://developer.gimp.org/api/2.0/gtk/gtk-update-icon-cache.html
#gtk-update-icon-cache -t "$HOME"/.local/share/icons/hicolor/
#manque ==> index.theme voir ==> /usr/share/icons/hicolor/index.theme

#Caler lang si user n'a pas réglé dans gui de multisystem
if [ ! -f "$HOME/.multisystem/lang_sel.txt" ]; then
echo
>"$HOME/.multisystem/lang_sel.txt"
while read line
do
if [ "$(grep -i "$(echo $line | awk -F'|' '{print $3}'| sed "s/\..*//")" <<<"${LANG}")" ]; then
echo $line | awk -F'|' '{print $3}'| sed "s/\..*//"
echo $line >"$HOME/.multisystem/lang_sel.txt"
break
fi
done <<<"$(cat "${dossier}/lang_list.txt" | sed "/^$/d")"

#Si ne trouve pas de traduction passer en Anglais.
if [ ! "$(cat "$HOME/.multisystem/lang_sel.txt")" ]; then
echo "English|en|en_US.UTF-8" >"$HOME/.multisystem/lang_sel.txt"
fi
cat "$HOME/.multisystem/lang_sel.txt"
fi

#pour slitaz
if [ "$(which tazpkg 2>/dev/null)" ]; then
export LANG="$(awk -F\| '{print $3}' "$HOME/.multisystem/lang_sel.txt")"
else
declare -x LANGUAGE="$(awk -F\| '{print $3}' "$HOME/.multisystem/lang_sel.txt")"
fi

echo LANG:$LANG 
echo LANGUAGE:$LANGUAGE
echo LANGSEL:$(cat "$HOME/.multisystem/lang_sel.txt")

#zenity --info --text "$(export)"
#locale -a
#cat /etc/default/locale
#/etc/environment or ~/.gtkrc 
#sudo locale-gen --purge fr_FR.UTF-8
#locale-gen
#dpkg-reconfigure locales
#dpkg-reconfigure console-data
#dpkg-reconfigure console-setup
#id

#if [ ! "$(ps ax | grep -v grep | grep "hal-lock --interface org.freedesktop.Hal.Device.Volume --exclusive --run ${chemin}")" ]; then
#hal-lock --interface org.freedesktop.Hal.Device.Volume --exclusive --run "${chemin}"
#exit 0
#fi

#Thème
. ./theme.sh

#Gui logo
# font-family=\"purisa\" weight=\"bold\"
if [ "$(grep "fr_FR" <<<"${LANG}")" ]; then
export MOD_WAIT='<window title="MultiSystem-logo" window_position="1" decorated="false">
<vbox>
<text sensitive="false" use-markup="true" wrap="false" angle="10">
<variable>MESSAGES</variable>
<input>echo "\<b>\<span color=\"#EB2C00\" size=\"larger\">○ NOUVEAU !\nLa première clé USB MultiSystem du marché\nest disponible sur liveusb.info.\</span>\</b>" | sed "s%\\\%%g" | sed "s%\\\\n\\\\n\\\\n%%g"</input>
</text>
<pixmap>
<input file>./logo_pub.jpg</input>
</pixmap>
<pixmap>
<input file>./pixmaps/multisystem-wait.gif</input>
</pixmap>
</vbox>
</window>'
else
export MOD_WAIT='<window title="MultiSystem-logo" window_position="1" decorated="false">
<vbox>
<pixmap>
<input file>./logo.png</input>
</pixmap>
<pixmap>
<input file>./pixmaps/multisystem-wait.gif</input>
</pixmap>
</vbox>
</window>'
fi

#Lancer logo
gtkdialog --program=MOD_WAIT &
sleep .5

function FCT_DETECT_PROCESS()
{
#detect process
#zenity --info --text "$(pgrep -xlc multisystem) $(pgrep -xlc gui_multisystem)"
if [[ "$(pgrep -xlc multisystem)" -gt "1" || "$(pgrep -xlc gui_multisystem)" -gt "1" ]]; then
wmctrl -c "MultiSystem-logo"
#Activer fenetre
xdotool windowactivate $(wmctrl -l | grep 'MultiSystem' | awk '{print $1}')
exit 0
fi
}
FCT_DETECT_PROCESS

#Verif dépendances...
errorlist=()
testlist="$(cat "${dossier}/dependances.txt")"
for i in $(grep -v "^#" <<<"${testlist}" | xargs)
do
if [ ! "$(which $i 2>/dev/null)" ]; then
errorlist=(${errorlist[@]} $i)
fi
done
#Stop si
if [ "$(echo "${errorlist[@]}")" ]; then
echo -e "\033[1;47;31m $(eval_gettext 'Erreur il manque: ')${errorlist[@]} \033[0m"
exit 0
fi
#dpkg -L grub-pc

#mettre en place les icon pour lancement si pas installé!
mkdir -p "$HOME"/.local/share/icons/hicolor/48x48/apps/ 2>/dev/null
#comparer nombre icon et maj si diff
if [ "$(ls -A "${dossier}"/pixmaps/multisystem-* 2>/dev/null | wc -l)" != "$(ls -A "$HOME"/.local/share/icons/hicolor/48x48/apps/multisystem-* 2>/dev/null | wc -l)" ]; then
cp -f "${dossier}/pixmaps/"* "$HOME"/.local/share/icons/hicolor/48x48/apps/
fi

#Vérifier que GParted n'est pas open!
if [ "$(ps aux | grep -v grep | grep 'hal-lock.*interface org.freedesktop.Hal.Device.Storage.*exclusive')" ]; then
zenity --error --text "$(eval_gettext "Erreur: un logiciel bloque l\'utilisation des disques, veuillez le fermer.")"
nohup "$dossier"/kill.sh&
exit 0
fi

#Vérifier que user est bien administrateur
if [ "$(cat /etc/group | grep ^adm)" ]; then
echo
if [ ! "$(cat /etc/group | grep ^adm | grep $USER)" ]; then
zenity --error --text "$(eval_gettext "Erreur:") USER:$USER is not admin!"
nohup "$dossier"/kill.sh&
exit 0
fi
fi

#Fermer logo
#zenity --info --text "logo3"
#wmctrl -c "MultiSystem-logo"

#Système de détection
source ./gui-detect.sh
sleep .1

#Thème (laisser en doublon ici !)
. ./theme.sh

#mettre en place autorun.inf/multisystem.bat/icon.ico
if [ ! -f "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/autorun.inf" ]; then
#echo -e '[AutoRun]\r\nShellexecute=multisystem.bat\r\nICON=icon.ico\r\nLabel=MultiSystem' | tee "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/autorun.inf"
echo -e '[AutoRun]\r\nICON=icon.ico\r\nLabel=MultiSystem\r\n\r\n[Content]\r\nMusicFiles=false\r\nPictureFiles=false\r\nVideoFiles=false' | tee "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/autorun.inf"
#copier .ico
cp -f "${dossier}/icon.ico" "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/icon.ico"
fi

#par securité verifier multisystem.bat
#7295356a95fc3e312ec342f57b944662  .../multisystem.bat
#if [ "7295356a95fc3e312ec342f57b944662" != "$(md5sum "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/multisystem.bat" | awk '{print $1}')" ]; then
#zenity --info --text "$(eval_gettext "ATTENTION!\nle fichier multisystem.bat à été modifié, Virus?")"
#fi

#Vérifier les mise à jour! / uniquement si installé!
if [[ "${dossier}" == "/usr/local/share/multisystem" && "$(cat "$HOME/.multisystem/checkupdate")" = "true" ]]; then
wget -t1 -T1 http://liveusb.info/multisystem/version-multisystem.txt -O "/tmp/multisystem/version-multisystem.txt"
if [ "$(cat /tmp/multisystem/version-multisystem.txt 2>/dev/null)" ]; then
echo ok
if [ "$(cat /tmp/multisystem/version-multisystem.txt)" != "$(cat /usr/local/share/multisystem/version-multisystem.txt)" ]; then
zenity --info --text "$(eval_gettext "Une mise à jour de multisystem est disponible")"&
fi
fi
fi

#Avertissement si user supprime OS dans gui de multisystem
[ ! "$(cat "$HOME/.multisystem/check_rem" 2>/dev/null)" ] && echo "true" >"$HOME/.multisystem/check_rem"
check_rem="$(cat "$HOME/.multisystem/check_rem")"

#Activer icon dans menu gnome
if [[ ! "$(cat /proc/cmdline | grep casper)" && "$(which gconf-editor)" && "$(gconftool-2  --get "/desktop/gnome/interface/menus_have_icons" 2>/dev/null)" = "false" ]]; then
echo
if [ ! -f "$HOME/.multisystem/active_icon" ]; then
zenity --question --text="$(eval_gettext "Activer les icones dans les menus de gnome ?")"
if [ $? = "0" ]; then
echo ok >"$HOME/.multisystem/active_icon"
gconftool-2 --set "/desktop/gnome/interface/menus_have_icons" --type bool "true"
fi
fi
fi

#mettre à jour le menu du tree
#relever icone|iso|date
gtkdialog --program=MOD_WAIT &
sleep .1
./fonctions.sh
#wmctrl -c "MultiSystem-logo"

#Corriger bug 1.96 de mon grub.cfg
if [ "$(grub-install -v | grep 1.96)" ]; then
sed -i "s/linux16/linux/g" "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/grub/grub.cfg"
sed -i "s/initrd16/initrd/g" "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/grub/grub.cfg"
sed -i "s/--config-file=\/boot\/grub\/menu.lst//g" "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/grub/grub.cfg"
sed -i "s/(\${root})//g" "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/grub/grub.cfg"
sed -i "s/^set root=${root}/#set root=${root}/g" "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/grub/grub.cfg"
sed -i "s/\#set root=(hd0,1)/set root=(hd0,1)/g" "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/grub/grub.cfg"
fi

#Onglet À propos
>/tmp/multisystem/multisystem-about
while read line
do
echo "multisystem-$(echo ${line} | awk -F'|' '{print $2}')|$(eval_gettext 'Traducteur') $(echo ${line} | awk -F'|' '{print $1}'), $(echo ${line} | awk -F'|' '{print $4}')|$(echo ${line} | awk -F'|' '{print $5}')" >>/tmp/multisystem/multisystem-about
done <<<"$(cat "${dossier}/lang_list.txt" | sed "/^$/d")"
#check .deb
verify_update="$(dpkg -l "multisystem" | grep "^ii  multisystem" 2>/dev/null | awk '{print $3}')"
#Si .deb est installé
if [ "${verify_update}" ]; then
echo "<span color='"'#4CB23F'"'>Version:${verify_update} $(cat ./version-multisystem.txt)</span>" >/tmp/multisystem/multisystem-inputversion
#Si .deb n'est pas installé
elif [ ! "${verify_update}" ]; then
echo "<span color='"'#4CB23F'"'>Version:$(cat ./version-multisystem.txt)</span>" >/tmp/multisystem/multisystem-inputversion
fi

#Onglet Non-Libre
#Créer dossier nonfree
mkdir -p "$HOME"/.multisystem/nonfree 2>/dev/null
#Check les files
>/tmp/multisystem/multisystem-nonfree
if [ -f "$HOME"/.multisystem/nonfree/plpbt.bin ]; then
echo 'gtk-ok|plpbt.bin' >>/tmp/multisystem/multisystem-nonfree
else
echo 'gtk-no|plpbt.bin' >>/tmp/multisystem/multisystem-nonfree
fi
if [ -f "$HOME"/.multisystem/nonfree/plpcfgbt ]; then
echo 'gtk-ok|plpcfgbt' >>/tmp/multisystem/multisystem-nonfree
else
echo 'gtk-no|plpcfgbt' >>/tmp/multisystem/multisystem-nonfree
fi
if [ -f "$HOME"/.multisystem/nonfree/NTDETECT.COM ]; then
echo 'gtk-ok|NTDETECT.COM' >>/tmp/multisystem/multisystem-nonfree
else
echo 'gtk-no|NTDETECT.COM' >>/tmp/multisystem/multisystem-nonfree
fi
if [ -f "$HOME"/.multisystem/nonfree/SETUPLDR.BIN ]; then
echo 'gtk-ok|SETUPLDR.BIN' >>/tmp/multisystem/multisystem-nonfree
else
echo 'gtk-no|SETUPLDR.BIN' >>/tmp/multisystem/multisystem-nonfree
fi
if [ -f "$HOME"/.multisystem/nonfree/RAMDISK.SY_ ]; then
echo 'gtk-ok|RAMDISK.SY_' >>/tmp/multisystem/multisystem-nonfree
else
echo 'gtk-no|RAMDISK.SY_' >>/tmp/multisystem/multisystem-nonfree
fi
if [ -f "$HOME"/.multisystem/nonfree/RAMDISK.SYS ]; then
echo 'gtk-ok|RAMDISK.SYS' >>/tmp/multisystem/multisystem-nonfree
else
echo 'gtk-no|RAMDISK.SYS' >>/tmp/multisystem/multisystem-nonfree
fi
if [ -f "$HOME"/.multisystem/nonfree/BOOTSECT.BIN ]; then
echo 'gtk-ok|BOOTSECT.BIN' >>/tmp/multisystem/multisystem-nonfree
else
echo 'gtk-no|BOOTSECT.BIN' >>/tmp/multisystem/multisystem-nonfree
fi
if [ -f "$HOME"/.multisystem/nonfree/firadisk.ima ]; then
echo 'gtk-ok|firadisk.ima' >>/tmp/multisystem/multisystem-nonfree
else
echo 'gtk-no|firadisk.ima' >>/tmp/multisystem/multisystem-nonfree
fi
#Détreminer éditeur text
if [  "$(which nautilus)" ]; then
navuse="nautilus"
elif [ "$(which dolphin)" ]; then
navuse="dolphin"
elif [ "$(which rox-filer)" ]; then
navuse="rox-filer"
elif [ "$(which thunar)" ]; then
navuse="thunar"
elif [ "$(which pcmanfm)" ]; then
navuse="pcmanfm"
fi

#forcer à true par defaut
echo 'true' >/tmp/multisystem/multisystem-update-bootloader

#Onglet par defaut
echo 0 >/tmp/multisystem/multisystem-inputtab1
echo 0 >/tmp/multisystem/multisystem-inputtab2
echo 0 >/tmp/multisystem/multisystem-inputtab3

#Bas de pages commun des onglets secondaires
function FCT_HOME()
{
echo '<pixmap>
<input file>'${theme_bdo}'</input>
</pixmap>
<hbox spacing="0">
<button name="stylebt" height_request="30" image-position="0" relief="2" xalign="0" yalign="0">
<height>16</height>
<input file icon="multisystem-home"></input>
<label>'$(eval_gettext 'Retour Accueil')'</label>
<action>echo 0 > /tmp/multisystem/multisystem-inputtab1</action>
<action>echo 0 > /tmp/multisystem/multisystem-inputtab2</action>
<action>refresh:tab1</action>
<action>refresh:tab2</action>
<action>refresh:tree</action>
<action>refresh:MESSAGES</action>
</button>
<button name="stylebt" height_request="30" image-position="0" relief="2" xalign="0" yalign="0">
<height>16</height>
<input file stock="gtk-quit"></input>
<label>'$(eval_gettext 'Quitter')'</label>
<action>wmctrl -c "MultiSystem-logo"</action>
<action>wmctrl -c "MultiSystem-logo2"</action>
<action>wmctrl -c "VBox"</action>
<action>exit:exit</action>
</button>
</hbox>'
}


#Onglet lister_lang
function FCT_lister_lang()
{
cat "$HOME/.multisystem/lang_sel.txt" | awk -F'|' '{print $1}'
cat "${dossier}/lang_list.txt" | sed "/^$/d" | awk -F'|' '{print $1}'
}
export -f FCT_lister_lang
export texte_annonce="MultiSystem recherche des traducteurs,\nMerci de nous contacter\nsi vous souhaitez participer\nContact:liveusb@gmail.com\n\nMultiSystem looking for translators,\nThank you contact us\nif you want to participate\nContact:liveusb@gmail.com"


#Onglet Télécharger des LiveCD
echo All | tee /tmp/multisystem/multisystem-output-list
function FCT_download_livecd()
{
listcat="$(cat /tmp/multisystem/multisystem-output-list 2>/dev/null)"
#Audio Utility Antivirus Gamer
if [ "$(grep -E "(Audio)|(Utility)|(Antivirus)|(Gamer)" <<<"${listcat}" 2>/dev/null)" ]; then
cat "${dossier}/list.txt" | sed "/^#/d" | sed "/^$/d"  | grep -E "\|${listcat}\|"
elif [ "${listcat}" = "All" ]; then
cat "${dossier}/list.txt" | grep -v "^#" | sed "/^$/d"
elif [ "${listcat}" = "clear" ]; then
echo "||||"
elif [ "${listcat}" ]; then
cat "${dossier}/list.txt" | sed "/^#/d" | sed "/^$/d" | grep -iE "\|.*${listcat}.*\|.*\|.*\|"
fi
}
export -f FCT_download_livecd


#Onglet Mise à jour
function FCT_update()
{
$radio1 && xdg-open 'http://liveusb.info/dotclear/index.php?pages/Soutien'&
if [ "$radio3" == "true" ]; then
nohup ./update-sel.sh &
#maj partielle
elif [ "$radio4" == "true" ]; then
wget -nd http://liveusb.info/multisystem/os_support.sh -O /tmp/multisystem/os_support.sh 2>&1 \
| sed -u 's/\([ 0-9]\+K\)[ \.]*\([0-9]\+%\) \(.*\)/\2\n#Transfert : \1 (\2) à \3/' \
| zenity --progress --auto-kill --auto-close --width 400 --title "$(eval_gettext 'Téléchargement en cours...')"
if [ "$(diff /tmp/multisystem/os_support.sh ${dossier}/os_support.sh 2>/dev/null)" ]; then
#Remplacer...
echo
if [ "$(du -h "/tmp/multisystem/os_support.sh" 2>/dev/null | awk '{print $1}')" == "0" ]; then
zenity --error --text "$(eval_gettext 'Erreur de téléchargement')"
elif [ "$(grep FCT_RELOAD /tmp/multisystem/os_support.sh 2>/dev/null)" ]; then
cp -f /tmp/multisystem/os_support.sh "${dossier}/os_support.sh"
fi
else
zenity --info --title MultiSystem_Information --text="$(eval_gettext "Pas de mise à jour disponible,\nVous utilisez bien la dernière version du script.")"
fi
#Relancer gui
nohup "${dossier}/gui_multisystem.sh" &
sleep 1
exit 0
fi
}
export -f FCT_update


#Onglet Déboguer
echo "" >/tmp/multisystem/multisystem-test-usb
export message_debug="$(eval_gettext "Patience test en cours...")"

#test écriture sur disque
function FCT_debug_write()
{
#espace dispo dans clé usb
available="$(($(df -aB 1 $(cat /tmp/multisystem/multisystem-mountpoint-usb) | grep ^$(cat /tmp/multisystem/multisystem-selection-usb) | awk '{print $4}')/1024/1024))"
if [ "${available}" -lt "1024" ]; then
message_debug="$(eval_gettext "Erreur: pas suffisament de place libre pour effectuer ce test,") ${available} < 1024Mio"
echo "${message_debug}" >/tmp/multisystem/multisystem-test-usb
exit 0
fi
echo -e "\E[37;44m\033[1m ${message_debug} \033[0m"
dd if=/dev/zero bs=1024 count=1000000 of="$(cat /tmp/multisystem/multisystem-mountpoint-usb)/multisystem-1Gb.file"
rm "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/multisystem-1Gb.file"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Attente, appuyez sur enter pour continuer.') \033[0m"
read
echo "" >/tmp/multisystem/multisystem-test-usb
}
#test lecture
function FCT_debug_read()
{
#dd if=/dev/zero bs=1024 count=1000000 of="$(cat /tmp/multisystem/multisystem-mountpoint-usb)/multisystem-1Gb.file" >dev/null
#dd if="$(cat /tmp/multisystem/multisystem-mountpoint-usb)/multisystem-1Gb.file" bs=64k | dd of=/dev/null
#rm "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/multisystem-1Gb.file"
echo -e "\E[37;44m\033[1m $(eval_gettext 'Veuillez saisir votre mot de passe d\047administrateur') \033[0m"
sudo hdparm -Tt $(cat /tmp/multisystem/multisystem-selection-usb)
echo -e "\E[37;44m\033[1m $(eval_gettext 'Attente, appuyez sur enter pour continuer.') \033[0m"
read
}
#reparer
function FCT_debug_repair()
{
echo -e "\E[37;44m\033[1m $(eval_gettext 'Veuillez saisir votre mot de passe d\047administrateur') \033[0m"
#redimensionner
sudo umount -f $(cat /tmp/multisystem/multisystem-selection-usb | sed 's/[0-9]//')1 2>/dev/null
sleep 2
sudo dosfsck -r -w -v  $(cat /tmp/multisystem/multisystem-selection-usb)
calc_fatresize="$(sudo fatresize -i $(cat /tmp/multisystem/multisystem-selection-usb) -q | grep '^Max size' | awk '{print $3}')"
echo calc_fatresize:${calc_fatresize} $((${calc_fatresize}/1000/1000))M
sudo fatresize -p -s $((${calc_fatresize}/1000/1000))M $(cat /tmp/multisystem/multisystem-selection-usb)
gvfs-mount -d $(cat /tmp/multisystem/multisystem-selection-usb) 2>/dev/null
echo -e "\E[37;44m\033[1m $(eval_gettext 'Attente, appuyez sur enter pour continuer.') \033[0m"
read
}
export -f FCT_debug_write FCT_debug_read FCT_debug_repair


#Onglet N°5 Formater votre clé USB
export format_text="$(parted -s $(cat /tmp/multisystem/multisystem-selection-usb | sed 's/[0-9]//') unit MB print)"
echo -e "${format_text}" >/tmp/multisystem/multisystem-format-text
function FCT_format()
{
echo -e "\E[37;44m\033[1m $(eval_gettext 'Veuillez saisir votre mot de passe d\047administrateur') \033[0m"
sudo echo
#Démonter
sudo umount -f $(cat /tmp/multisystem/multisystem-selection-usb | sed 's/[0-9]//')1 2>/dev/null
echo -e "\E[37;44m\033[1m $(eval_gettext 'Veuillez saisir votre mot de passe d\047administrateur') \033[0m"
#shred  - Écrire par dessus un fichier pour en camoufler le contenu, et optionnellement l’effacer
#shred -n 1 -z -v $(cat /tmp/multisystem/multisystem-selection-usb | sed 's/[0-9]//')
dd if=/dev/zero of=$(cat /tmp/multisystem/multisystem-selection-usb | sed 's/[0-9]//') bs=512 count=1
sudo parted -a cylinder -s $(cat /tmp/multisystem/multisystem-selection-usb | sed 's/[0-9]//') mklabel msdos
sudo parted -a cylinder -s $(cat /tmp/multisystem/multisystem-selection-usb | sed 's/[0-9]//') unit MB mkpart primary fat32 1 100%
sleep 2
sudo umount -f $(cat /tmp/multisystem/multisystem-selection-usb | sed 's/[0-9]//')1 2>/dev/null
sudo mkdosfs -F32 -v -S512 -n multisystem $(cat /tmp/multisystem/multisystem-selection-usb | sed 's/[0-9]//')1
sleep 2
sudo parted -s $(cat /tmp/multisystem/multisystem-selection-usb | sed 's/[0-9]//') set 1 boot on
#Vérifier/Réparer fat32
#sudo dosfsck -t -a -r -v $(cat /tmp/multisystem/multisystem-selection-usb)
sudo dosfsck -p -a -w -v $(cat /tmp/multisystem/multisystem-selection-usb)
sleep 2
sudo umount $(cat /tmp/multisystem/multisystem-selection-usb | sed 's/[0-9]//')1 2>/dev/null
#redimensionner
#calc_fatresize="$(sudo fatresize -i $(cat /tmp/multisystem/multisystem-selection-usb) | grep '^Max size' | awk '{print $3}')"
#sudo fatresize -p -s ${calc_fatresize} $(cat /tmp/multisystem/multisystem-selection-usb)
echo -e "\E[37;44m\033[1m $(eval_gettext 'Formatage effectué,\nveuillez débrancher/rebrancher votre clé USB\navant de relancer multisystem.') \033[0m"
read
exit 0
}
export -f FCT_format


#Onglet N°6 Afficher/Masquer des fichiers/dossiers dans votre clé usb
function FCT_hidden_update_tree()
{
#Mettre en forme pour le tree
>/tmp/multisystem/multisystem-hidden
echo -e "$(stat  -c %n "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/"* | awk '{print $0}')" | while read line
do
var="$(echo "$line" | sed "s|$(cat /tmp/multisystem/multisystem-mountpoint-usb)/||")"
echo "var:${var}"
if [ "$(grep "^${var}$" "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/.hidden")" ]; then
echo "multisystem-red|$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${var}" >>/tmp/multisystem/multisystem-hidden
else
echo "multisystem-green|$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${var}" >>/tmp/multisystem/multisystem-hidden
fi
done
}
FCT_hidden_update_tree
function FCT_hidden_showall()
{
stat  -c %n "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/"* | awk '{print "multisystem-green|" $0}' >/tmp/multisystem/multisystem-hidden
echo "" >"$(cat /tmp/multisystem/multisystem-mountpoint-usb)/.hidden"
FCT_hidden_update_tree
}
function FCT_hidden_hiddenall()
{
stat  -c %n "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/"* | awk '{print "multisystem-red|" $0}' >/tmp/multisystem/multisystem-hidden
echo -e "$(stat  -c %n "$(cat /tmp/multisystem/multisystem-mountpoint-usb )/"* | awk '{print $0}')" | sed "s|$(cat /tmp/multisystem/multisystem-mountpoint-usb)/||" >"$(cat /tmp/multisystem/multisystem-mountpoint-usb)/.hidden"
FCT_hidden_update_tree
}
function FCT_hidden_modify()
{
echo
rechercher="$(echo "${1}" | sed "s|$(cat /tmp/multisystem/multisystem-mountpoint-usb)/||")"
if [ ! "$(grep "^${rechercher}$" "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/.hidden")" ]; then
#zenity --info --text "Masquer ${rechercher}"
echo "${rechercher}" >>"$(cat /tmp/multisystem/multisystem-mountpoint-usb)/.hidden"
else
#zenity --info --text "Afficher ${rechercher}"
sed -i "s|^${rechercher}$||" "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/.hidden"
sed -i "/^$/d" "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/.hidden"
fi
FCT_hidden_update_tree
}
export -f FCT_hidden_showall FCT_hidden_hiddenall FCT_hidden_modify FCT_hidden_update_tree

function comment() 
{ true; }
export -f comment


MULTISYSTEM='<window spacing="0" width_request="400" height_request="420" window_position="1" title="MultiSystem" icon-name="multisystem-icon" decorated="true" resizable="false">

<notebook show-border="false" show_tabs="false" page="0" labels="0|1">

'$(comment Onglet masqué primaire 0)'
<vbox spacing="0">

<notebook tab-pos="2" show-border="false" scrollable="true" show-tabs="true" page="0" enable-popup="true" homogeneous="false" labels="MS|'$(eval_gettext 'Menus')'|'$(eval_gettext 'Démarrage')'|'$(eval_gettext 'Non-Libre')'|'$(eval_gettext 'À propos')'">

'$(comment Onglet N°0 MultiSystem)'
<vbox spacing="0" height_request="380">
<pixmap>
<input file>'${theme_bdo}'</input>
</pixmap>
<hbox height_request="200">

<vbox spacing="0">
<button name="stylebt"  width_request="32" height_request="100" tooltip-text="'$(eval_gettext 'Tester dans Qemu')'">
<input file icon="multisystem-qemu"></input>
<action>./fonctions.sh qemu</action>
<action>refresh:MESSAGES</action>
</button>
<button name="stylebt" width_request="32" height_request="100" tooltip-text="'$(eval_gettext 'Tester dans VirtualBox')'">
<input file icon="multisystem-vbox"></input>
<action>./fonctions.sh vbox</action>
<action>refresh:MESSAGES</action>
</button>
</vbox>

<tree icon="multisystem-tux" tooltip-text="'$(eval_gettext "Double clic pour modifier les noms dans le menu du bootloader.")'" rules_hint="true" headers_visible="false" hover_expand="false" hover_selection="false" exported_column="1">
<label>1|2|3|4|5</label>
<variable>tree</variable>
<input icon_column="0">if [ "$(cat /tmp/multisystem/multisystem-laisserpasser-usb)" = "ok" ];then cat /tmp/multisystem/multisystem-mise-en-forme;else echo "multisystem-logo|||||||";fi</input>
<action>./fonctions.sh menu\|$tree</action>
<action>refresh:tree</action>
<action>refresh:MESSAGES</action>
</tree>


<vbox spacing="0">
<button name="stylebt" width_request="32" height_request="40" tooltip-text="Menu up">
<input file stock="gtk-go-up"></input>
<action>test $tree && ./fonctions.sh selup\|$tree</action>
<variable>btup</variable>
<action>refresh:tree</action>
<action>refresh:MESSAGES</action>
</button>

<button name="stylebt" width_request="32" height_request="40" tooltip-text="Menu move">
<input file stock="gtk-jump-to"></input>
<action>test $tree && ./fonctions.sh move\|$tree</action>
<variable>btmove</variable>
<action>refresh:tree</action>
<action>refresh:MESSAGES</action>
</button>

<button name="stylebt" width_request="32" height_request="40" tooltip-text="Menu down">
<input file stock="gtk-go-down"></input>
<action>test $tree && ./fonctions.sh seldown\|$tree</action>
<variable>btdown</variable>
<action>refresh:tree</action>
<action>refresh:MESSAGES</action>
</button>

<button name="stylebt" width_request="32" height_request="40" tooltip-text="'$(eval_gettext "Supprimer un système d'exploitation")'">
<input file stock="gtk-delete"></input>
<action>test $tree && ./fonctions.sh selclear\|$tree</action>
<variable>btclear</variable>
<action>refresh:tree</action>
<action>refresh:MESSAGES</action>
</button>

<checkbox width_request="32" height_request="40" use-underline="true" active="'$check_rem'" tooltip-text="'$(eval_gettext "Prévenir avant de supprimer")'">
<label>_</label>
<variable>ckeckrem</variable>
<action>if true echo "true" >"$HOME/.multisystem/check_rem"</action>
<action>if false echo "false" >"$HOME/.multisystem/check_rem"</action>
</checkbox>
</vbox>

<vbox spacing="0">
<button name="stylebt" width_request="32" height_request="40" tooltip-text="'$(eval_gettext "Afficher/Masquer des fichiers/dossiers dans votre clé usb")'">
<input file icon="multisystem-hidden"></input>
<action>echo 1 > /tmp/multisystem/multisystem-inputtab1</action>
<action>echo 6 > /tmp/multisystem/multisystem-inputtab3</action>
<action>refresh:tab1</action>
<action>refresh:tab3</action>
<action>refresh:MESSAGES</action>
</button>

<button name="stylebt" width_request="32" height_request="40" tooltip-text="'$(eval_gettext "Ajouter une option de démarrage (cmdline)")'">
<input file stock="gtk-edit"></input>
<variable>btcmdline</variable>
<action>test $tree && ./fonctions.sh cmdline\|$tree</action>
<action>refresh:tree</action>
<action>refresh:MESSAGES</action>
</button>

<button name="stylebt" width_request="32" height_request="40" tooltip-text="'$(eval_gettext "Ajouter mode persistent")'">
<input file icon="multisystem-save"></input>
<variable>btpersistent1</variable>
<action>./fonctions.sh persistent\|$tree</action>
<action>refresh:tree</action>
<action>refresh:MESSAGES</action>
</button>

<button name="stylebt" width_request="32" height_request="40" tooltip-text="'$(eval_gettext "Créer CD pour lancer USB")'">
<input file icon="multisystem-cdrom"></input>
<variable>btcdamorce2</variable>
<action>./fonctions.sh cdamorce</action>
<action>refresh:MESSAGES</action>
</button>

<button name="stylebt" width_request="32" height_request="40" tooltip-text="'$(eval_gettext "Internationalisation")'">
<input file icon="multisystem-language"></input>
<variable>btlang1</variable>
<action>echo 1 > /tmp/multisystem/multisystem-inputtab1</action>
<action>echo 1 > /tmp/multisystem/multisystem-inputtab3</action>
<action>refresh:tab1</action>
<action>refresh:tab3</action>
<action>refresh:MESSAGES</action>
</button>
</vbox>

<vbox spacing="0">
<button name="stylebt" width_request="32" height_request="80" tooltip-text="'$(eval_gettext "Réglages Grub")'">
<input file stock="gtk-preferences"></input>
<variable>btpref2</variable>
<action>./fonctions.sh pref</action>
<action>refresh:MESSAGES</action>
</button>
<button name="stylebt" width_request="32" height_request="80" tooltip-text="'$(eval_gettext "Mettre à jour Grub2")'">
<input file icon="multisystem-grub48"></input>
<variable>btgrub</variable>
<action>./fonctions.sh grub</action>
<action>refresh:MESSAGES</action>
</button>
<checkbox width_request="32" height_request="40" use-underline="true" active="true" tooltip-text="'$(eval_gettext "Décochez pour déplacer rapidement les menus, ne pas mettre à jour les bootloader, ATTENTION! cochez lors du dernier déplacement pour mettre à jour les bootloader.")'">
<label>_</label>
<variable>update_bootloader</variable>
<action>if true echo true >/tmp/multisystem/multisystem-update-bootloader</action>
<action>if false echo false >/tmp/multisystem/multisystem-update-bootloader</action>
</checkbox>
</vbox>

<vbox spacing="0">
<button name="stylebt" width_request="32" height_request="80" tooltip-text="'$(eval_gettext "Télécharger des LiveCD")'">
<input file icon="multisystem-download"></input>
<variable>btdownload1</variable>
<action>echo All | tee /tmp/multisystem/multisystem-output-list</action>
<action>refresh:tree_list</action>
<action>clear:QUOI</action>
<action>echo 1 > /tmp/multisystem/multisystem-inputtab1</action>
<action>echo 2 > /tmp/multisystem/multisystem-inputtab3</action>
<action>refresh:tab1</action>
<action>refresh:tab3</action>
<action>refresh:tree</action>
<action>refresh:MESSAGES</action>
</button>
<button name="stylebt" width_request="32" height_request="80" tooltip-text="'$(eval_gettext "Mise à jour")'">
<input file icon="multisystem-update"></input>
<variable>btmaj1</variable>
<action>echo 1 > /tmp/multisystem/multisystem-inputtab1</action>
<action>echo 3 > /tmp/multisystem/multisystem-inputtab3</action>
<action>refresh:tab1</action>
<action>refresh:tab3</action>
<action>refresh:MESSAGES</action>
</button>

<checkbox width_request="32" height_request="40" use-underline="true" tooltip-text="'$(eval_gettext 'Vérifier les mise à jour à chaque lancement')'">
<label>_</label>
<variable>checkupdate2</variable>
<default>true</default>
<action>if true echo true >"'$HOME'/.multisystem/checkupdate"</action>
<action>if false echo false >"'$HOME'/.multisystem/checkupdate"</action>
<input>cat "'$HOME'/.multisystem/checkupdate"</input>
<action>refresh:checkupdate</action>
<action>refresh:checkupdate2</action>
</checkbox>

</vbox>

</hbox>

<pixmap>
<input file>'${theme_bdo}'</input>
</pixmap>
<vbox height_request="70" spacing="0">
<text sensitive="false">
<variable>MESSAGES</variable>
<input>echo "'$(eval_gettext "Volume USB:")'$(cat /tmp/multisystem/multisystem-selection-usb) UUID:$(cat /tmp/multisystem/multisystem-selection-uuid-usb)\n'$(eval_gettext 'Point de montage:')'$(cat /tmp/multisystem/multisystem-mountpoint-usb)\n'$(eval_gettext 'Taille:')'$(($(df | grep ^$(cat /tmp/multisystem/multisystem-selection-usb) | awk '\''{print $2}'\'')/1024))Mio '$(eval_gettext 'Occupé:')'$(($(df | grep ^$(cat /tmp/multisystem/multisystem-selection-usb) | awk '\''{print $3}'\'')/1024))Mio '$(eval_gettext 'Libre:')'$(($(df | grep ^$(cat /tmp/multisystem/multisystem-selection-usb) | awk '\''{print $4}'\'')/1024))Mio\n'$(eval_gettext 'Nombre de LiveCD:')'$(cat /tmp/multisystem/multisystem-nombreiso-usb)"</input>
</text>
</vbox>
<pixmap>
<input file>'${theme_bdo}'</input>
</pixmap>

<hbox spacing="0">

<button name="stylebt" relief="2" tooltip-text="'$(eval_gettext 'Sauvegarde/Restauration')'">
<input file icon="multisystem-save2"></input>
<action>./fonctions.sh save</action>
</button>

<frame '$(eval_gettext "Glisser/Déposer iso/img")'>
<hbox spacing="0">
<entry primary-icon-name="multisystem-seliso" secondary-icon-name="'${theme_btn}'" 
accept="filename" activates-default="false" fs-folder="'$HOME/'" fs-action="file" 
fs-filters="*.iso|*.img" show-hidden="false" fs-title="Select an iso file" 
tooltip-text="'$(eval_gettext "Glisser/Déposer iso/img")'" 
primary-icon-tooltip-text="'$(eval_gettext 'Utilisez ce bouton si le Glisser/Déposer ne fonctionne pas.')'"
secondary-icon-tooltip-text="'$(eval_gettext "Ajouter un liveCD")'">
<variable>DAG</variable>
<width>50</width><height>50</height>
<action signal="changed">test "$DAG" && echo "DAG:$DAG"</action>
<action signal="changed">test "$DAG" && ./fonctions.sh add\|"${DAG}" &</action>
<action signal="changed">clear:DAG</action>
<action signal="changed">refresh:DAG</action>
<action signal="changed">refresh:MESSAGES</action>
<action signal="changed">refresh:tree</action>
<action signal="primary-icon-press">fileselect:DAG</action>
<action signal="secondary-icon-press">./gui_multi_sel_launch.sh</action>
</entry>
</hbox>
</frame>



<button name="stylebt" relief="2" tooltip-text="'$(eval_gettext "Quitter")'">
<input file icon="multisystem-exit"></input>
<action>wmctrl -c "MultiSystem-logo"</action>
<action>wmctrl -c "MultiSystem-logo2"</action>
<action>wmctrl -c "VBox"</action>
<action type="exit">exit</action>
</button>

</hbox>
</vbox>





'$(comment Onglet N°1 Menus)'
<vbox spacing="0">

<hbox spacing="0">
<hbox spacing="0">
<button name="stylebt" width_request="36" height_request="36">
<input file stock="gtk-preferences"></input>
<variable>btpref</variable>
<action>./fonctions.sh pref</action>
<action>refresh:MESSAGES</action>
</button>
<text width_request="157" use-markup="true">
<label>"<b>'$(eval_gettext 'Réglages Grub')'</b>"</label>
</text>
</hbox>

<hbox spacing="0">
<button name="stylebt" width_request="36" height_request="36">
<input file icon="multisystem-grub48"></input>
<variable>btgrub2</variable>
<action>./fonctions.sh grub</action>
<action>refresh:MESSAGES</action>
</button>
<text width_request="157" use-markup="true">
<label>"<b>'$(eval_gettext 'Mettre à jour Grub2')'</b>"</label>
</text>
</hbox>
</hbox>

<hbox>
<button name="stylebt" width_request="36" height_request="36">
<input file icon="multisystem-grub48"></input>
<variable>btburg</variable>
<action>./fonctions.sh burg</action>
<action>refresh:MESSAGES</action>
</button>
<text width_request="345" use-markup="true">
<label>"<b>'$(eval_gettext 'Mettre à jour Burg')'</b>"</label>
</text>
</hbox>

<hbox>
<button name="stylebt" width_request="36" height_request="36">
<input file stock="gtk-save"></input>
<variable>btsave</variable>
<action>./fonctions.sh save</action>
<action>refresh:MESSAGES</action>
</button>
<text width_request="345" use-markup="true">
<label>"<b>'$(eval_gettext 'Sauvegarde/Restauration')'</b>"</label>
</text>
</hbox>

<hbox>
<button name="stylebt" width_request="36" height_request="36">
<input file icon="multisystem-save"></input>
<variable>btpersistent2</variable>
<action>./fonctions.sh persistent\|$tree</action>
<action>refresh:MESSAGES</action>
<action>refresh:tree</action>
</button>
<text width_request="345" use-markup="true">
<label>"<b>'$(eval_gettext 'Ajouter mode persistent')'</b>"</label>
</text>
</hbox>

<hbox>
<button name="stylebt" width_request="36" height_request="36">
<input file icon="multisystem-resize"></input>
<variable>btpersistent3</variable>
<action>./fonctions.sh persistent-resize</action>
<action>refresh:MESSAGES</action>
<action>refresh:tree</action>
</button>
<text width_request="345" use-markup="true">
<label>"<b>'$(eval_gettext 'Redimensionner persistent')'</b>"</label>
</text>
</hbox>

<hbox>
<button name="stylebt" width_request="36" height_request="36">
<input file icon="multisystem-download"></input>
<variable>btdownload2</variable>
<action>echo All | tee /tmp/multisystem/multisystem-output-list</action>
<action>refresh:tree_list</action>
<action>clear:QUOI</action>
<action>echo 1 > /tmp/multisystem/multisystem-inputtab1</action>
<action>echo 2 > /tmp/multisystem/multisystem-inputtab3</action>
<action>refresh:tab1</action>
<action>refresh:tab3</action>
<action>refresh:tree</action>
<action>refresh:MESSAGES</action>
</button>
<text width_request="345" use-markup="true">
<label>"<b>'$(eval_gettext 'Télécharger des LiveCD')'</b>"</label>
</text>
</hbox>

<hbox>
<button name="stylebt" width_request="36" height_request="36">
<input file icon="multisystem-language"></input>
<variable>btlang2</variable>
<action>echo 1 > /tmp/multisystem/multisystem-inputtab1</action>
<action>echo 1 > /tmp/multisystem/multisystem-inputtab3</action>
<action>refresh:tab1</action>
<action>refresh:tab3</action>
<action>refresh:MESSAGES</action>
</button>
<text width_request="345" use-markup="true">
<label>"<b>'$(eval_gettext 'Internationalisation')'</b>"</label>
</text>
</hbox>

<hbox>
<button name="stylebt" width_request="36" height_request="36">
<input file icon="multisystem-gparted64"></input>
<variable>btformat</variable>
<action>echo 1 > /tmp/multisystem/multisystem-inputtab1</action>
<action>echo 5 > /tmp/multisystem/multisystem-inputtab3</action>
<action>refresh:tab1</action>
<action>refresh:tab3</action>
<action>refresh:MESSAGES</action>
</button>
<text width_request="345" use-markup="true">
<label>"<b>'$(eval_gettext 'Formater votre clé USB')'</b>"</label>
</text>
</hbox>

<hbox spacing="0">
<hbox spacing="0">
<button name="stylebt" width_request="36" height_request="36">
<input file stock="gtk-execute"></input>
<variable>btdebug</variable>
<action>echo "" >/tmp/multisystem/multisystem-test-usb</action>
<action>refresh:debug_edit</action>
<action>echo 1 > /tmp/multisystem/multisystem-inputtab1</action>
<action>echo 4 > /tmp/multisystem/multisystem-inputtab3</action>
<action>refresh:tab1</action>
<action>refresh:tab3</action>
<action>refresh:MESSAGES</action>
</button>
<text width_request="157" use-markup="true">
<label>"<b>'$(eval_gettext 'Déboguer')'</b>"</label>
</text>
</hbox>

<hbox spacing="0">
<button name="stylebt" width_request="36" height_request="36">
<input file icon="multisystem-vbox"></input>
<variable>btinstallvbox</variable>
<action>./fonctions.sh installvbox</action>
<action>refresh:MESSAGES</action>
</button>
<text width_request="157" use-markup="true">
<label>"<b>'$(eval_gettext 'Installer VirtualBox')'</b>"</label>
</text>
</hbox>
</hbox>

<hbox spacing="0">
<hbox spacing="0">
<button name="stylebt" width_request="36" height_request="36">
<input file icon="multisystem-update"></input>
<variable>btmaj2</variable>
<action>echo 1 > /tmp/multisystem/multisystem-inputtab1</action>
<action>echo 3 > /tmp/multisystem/multisystem-inputtab3</action>
<action>refresh:tab1</action>
<action>refresh:tab3</action>
<action>refresh:MESSAGES</action>
</button>
<text width_request="157" use-markup="true">
<label>"<b>'$(eval_gettext 'Mise à jour')'</b>"</label>
</text>
</hbox>

<hbox spacing="0">
<button name="stylebt" width_request="36" height_request="36">
<input file stock="gtk-delete"></input>
<variable>btuninstall</variable>
<action>nohup xterm -title 'Uninstall' -e "sudo ./uninstall.sh" &</action>
<action>wmctrl -c "MultiSystem-logo"</action>
<action>wmctrl -c "MultiSystem-logo2"</action>
<action>wmctrl -c "VBox"</action>
<action type="exit">exit</action>
</button><text width_request="157" use-markup="true">
<label>"<b>'$(eval_gettext 'Désinstaller')'</b>"</label>
</text>
</hbox>
</hbox>

</vbox>






'$(comment Onglet N°2 Démarrage)'
<vbox spacing="0">
<hbox>
<button name="stylebt" width_request="36" height_request="36">
<input file icon="multisystem-cdrom"></input>
<variable>btcdamorce</variable>
<action>./fonctions.sh cdamorce</action>
<action>refresh:MESSAGES</action>
</button>
<text width_request="345" use-markup="true">
<label>"<b>'$(eval_gettext 'Créer CD pour lancer USB')'</b>"</label>
</text>
</hbox>
<pixmap>
<input file>'${theme_bdo}'</input>
</pixmap>
<hbox>
<button name="stylebt" width_request="36" height_request="36">
<input file icon="multisystem-grub48"></input>
<variable>btinfoboot</variable>
<action>./fonctions.sh infoboot\|grub</action>
<action>refresh:MESSAGES</action>
</button>
<text width_request="345" use-markup="true">
<label>"<b>'$(eval_gettext 'Boot depuis Grub/Grub2')'</b>"</label>
</text>
</hbox>
<hbox>
<button name="stylebt" width_request="36" height_request="36">
<input file icon="multisystem-windows48"></input>
<variable>btinfoboot</variable>
<action>./fonctions.sh infoboot\|xp</action>
<action>refresh:MESSAGES</action>
</button>
<text width_request="345" use-markup="true">
<label>"<b>'$(eval_gettext 'Boot depuis Windows XP')'</b>"</label>
</text>
</hbox>
<hbox>
<button name="stylebt" width_request="36" height_request="36">
<input file icon="multisystem-windows48"></input>
<variable>btinfoboot</variable>
<action>./fonctions.sh infoboot\|vista</action>
<action>refresh:MESSAGES</action>
</button>
<text width_request="345" use-markup="true">
<label>"<b>'$(eval_gettext 'Boot depuis Windows Vista')'</b>"</label>
</text>
</hbox>
<hbox>
<button name="stylebt" width_request="36" height_request="36">
<input file icon="multisystem-apple48"></input>
<variable>btinfoboot</variable>
<action>./fonctions.sh infoboot\|macintel</action>
<action>refresh:MESSAGES</action>
</button>
<text width_request="345" use-markup="true">
<label>"<b>'$(eval_gettext 'Boot depuis MacIntel')'</b>"</label>
</text>
</hbox>
<pixmap>
<input file>'${theme_bdo}'</input>
</pixmap>
<hbox>
<button name="stylebt" width_request="36" height_request="36">
<input file icon="multisystem-qemu"></input>
<variable>btqemu</variable>
<action>./fonctions.sh qemu</action>
<action>refresh:MESSAGES</action>
</button>
<text width_request="345" use-markup="true">
<label>"<b>'$(eval_gettext 'Tester votre liveUSB dans Qemu')'</b>"</label>
</text>
</hbox>
<hbox>
<button name="stylebt" width_request="36" height_request="36">
<input file icon="multisystem-vbox"></input>
<variable>btvbox1</variable>
<action>./fonctions.sh vbox</action>
<action>refresh:MESSAGES</action>
</button>
<text width_request="345" use-markup="true">
<label>"<b>'$(eval_gettext 'Tester votre liveUSB dans VirtualBox')'</b>"</label>
</text>
</hbox>
<hbox>
<button name="stylebt" width_request="36" height_request="36">
<input file icon="multisystem-vbox"></input>
<variable>btvbox2</variable>
<action>wmctrl -c "VBox"</action>
<action>./VBox_livecd_gui.sh &</action>
<action>refresh:MESSAGES</action>
</button>
<text width_request="345" use-markup="true">
<label>"<b>'$(eval_gettext 'Tester un LiveCD dans VirtualBox')'</b>"</label>
</text>
</hbox>
</vbox>



'$(comment Onglet N°3 Non-Libre)'
<vbox spacing="0">
<text use-markup="true" wrap="true" width-chars="70" sensitive="false">
<input>echo "\<b>\<big>'$(eval_gettext "Partie Non Libre de MultiSystem")'\</big>\</b>" | sed "s%\\\%%g"</input>
</text>

<pixmap>
<input file>'${theme_bdo}'</input>
</pixmap>

<hbox>
<button name="stylebt" tooltip-text="'$(eval_gettext 'PLoP Boot Manager est un freeware.')'">
<input file icon="multisystem-plop-logo"></input>
<label>'$(eval_gettext 'Télécharger PLoP Boot Manager')'</label>
<action>./fonctions-nonfree.sh plop</action>
<action>refresh:tree2</action>
</button>
</hbox>

<pixmap>
<input file>'${theme_bdo}'</input>
</pixmap>

<hbox>
<button name="stylebt" tooltip-text="'$(eval_gettext 'Utilisé pour démarrer les iso de Windows XP')'">
<input file icon="multisystem-windows48"></input>
<label>'$(eval_gettext 'Télécharger firadisk.ima')'</label>
<action>./fonctions-nonfree.sh firadisk</action>
<action>refresh:tree2</action>
</button>
</hbox>

<pixmap>
<input file>'${theme_bdo}'</input>
</pixmap>

<vbox homogeneous="true">
<hbox>
<button name="stylebt" tooltip-text="'$(eval_gettext 'Utilisé pour les iso BartPE')'">
<input file icon="multisystem-windows48"></input>
<label>'$(eval_gettext 'Télécharger Microsoft Windows Server 2003 SP1')'</label>
<action>./fonctions-nonfree.sh bartpe</action>
<action>refresh:tree2</action>
</button>
</hbox>
</vbox>

<pixmap>
<input file>'${theme_bdo}'</input>
</pixmap>

<hbox height_request="200">
<tree hover_selection="true" headers_visible="false" exported_column="0">
<label>files</label>
<input icon_column="0">cat /tmp/multisystem/multisystem-nonfree</input>
<variable>tree2</variable>
<action signal="button-press-event">nohup '${navuse}' "$HOME"/.multisystem/nonfree&</action>
</tree>
</hbox>

<pixmap>
<input file>'${theme_bdo}'</input>
</pixmap>

</vbox>




'$(comment Onglet N°4 À propos)'
<vbox spacing="0">
<text use-markup="true" wrap="true" sensitive="false">
<input>echo "\<b>'$(eval_gettext 'MultiSystem recherche des traducteurs,\nSi vous souhaitez participer,\nMerci de nous contacter.\nContact:')'liveusb@gmail.com\</b>" | sed "s%\\\%%g"</input>
</text>
<pixmap>
<input file>'${theme_bdo}'</input>
</pixmap>
<vbox height_request="32" homogeneous="true">
<text use-underline="true"><label>_</label></text>
<text use-markup="true">
<input file>/tmp/multisystem/multisystem-inputversion</input>
</text>
</vbox>
<pixmap>
<input file>'${theme_bdo}'</input>
</pixmap>
<hbox>
<pixmap>
<input file>"'${dossier}'/pixmaps/multisystem-map-flags.png"</input>
</pixmap>
</hbox>
<pixmap>
<input file>'${theme_bdo}'</input>
</pixmap>
<hbox height_request="160">
<tree headers_visible="false" exported_column="1">
<label>1|2|3</label>
<input icon_column="0">cat /tmp/multisystem/multisystem-about</input>
<variable>tree3</variable>
<action>xdg-email --utf8 --subject "MultiSystem translation" --body "message" "${tree3}" &</action>
</tree>
</hbox>
<pixmap>
<input file>'${theme_bdo}'</input>
</pixmap>
</vbox>


<variable>tab2</variable>
<input file>/tmp/multisystem/multisystem-inputtab2</input>
<action signal="show">refresh:tree</action>
</notebook>
</vbox>




'$(comment Onglet masqué secondaire 1)'
<vbox spacing="0">
<notebook show-border="false" show_tabs="false" page="0" labels="0|1|2|3|4|5|6|7|8|9|10|11">



'$(comment Onglet N°0 N/A)'
<vbox spacing="0">
<vbox height_request="370">
<pixmap>
<input file>'${theme_bdo}'</input>
</pixmap>
<text><label>N/A</label></text>
</vbox>
'$(FCT_HOME)'
</vbox>



'$(comment Onglet N°1 Internationalisation)'
<vbox spacing="0">
<vbox height_request="370">
<frame '$(eval_gettext 'Changer de language')'>
<hbox spacing="0" height_request="32">
<pixmap>
<input file icon="config-language"></input>
<height>32</height>
<width>32</width>
</pixmap>
<text width_request="5" use-underline="true"><label>_</label></text>
<comboboxtext allow-empty="false" value-in-list="true" tooltip-text="'$(eval_gettext 'Changer de language')'">
<variable>lister_lang</variable>
<input>bash -c "FCT_lister_lang"</input>
<action signal="changed">echo "$(grep "^$lister_lang" "'${dossier}'/lang_list.txt")" >"$HOME/.multisystem/lang_sel.txt"</action>
<action signal="changed">nohup "${dossier}/gui_multisystem.sh" &</action>
<action signal="changed">wmctrl -c "MultiSystem-logo"</action>
<action signal="changed">wmctrl -c "MultiSystem-logo2"</action>
<action signal="changed">wmctrl -c "VBox"</action>
<action signal="changed">exit:selang</action>
</comboboxtext>
</hbox>
</frame>

<pixmap>
<input file>'${theme_bdo}'</input>
</pixmap>

<frame>
<text use-markup="true" wrap="true" sensitive="false">
<input>echo "\<b>\<big>'$texte_annonce'\</big>\</b>" | sed "s%\\\%%g"</input>
</text>
</frame>
</vbox>
'$(FCT_HOME)'
</vbox>






'$(comment Onglet N°2 Télécharger des LiveCD)'
<vbox spacing="0">
<vbox height_request="370">

<hbox>
<entry activates_default="true">
<variable>QUOI</variable>
</entry>
<button name="stylebt">
<input file stock="gtk-find"></input>
<variable>RECHERCHER</variable>
<action>echo "$QUOI" >/tmp/multisystem/multisystem-output-list</action>
<action>refresh:tree_list</action>
</button>
</hbox>

<hbox>
<button name="stylebt">
<label>All</label>
<input file stock="gtk-find"></input>
<action>clear:QUOI</action>
<action>echo All | tee /tmp/multisystem/multisystem-output-list</action>
<action>refresh:tree_list</action>
</button>

<button name="stylebt">
<label>Audio</label>
<input file stock="gtk-find"></input>
<action>clear:QUOI</action>
<action>echo Audio | tee /tmp/multisystem/multisystem-output-list</action>
<action>refresh:tree_list</action>
</button>

<button name="stylebt">
<label>Utility</label>
<input file stock="gtk-find"></input>
<action>clear:QUOI</action>
<action>echo Utility | tee /tmp/multisystem/multisystem-output-list</action>
<action>refresh:tree_list</action>
</button>

<button name="stylebt">
<label>Antivirus</label>
<input file stock="gtk-find"></input>
<action>clear:QUOI</action>
<action>echo Antivirus | tee /tmp/multisystem/multisystem-output-list</action>
<action>refresh:tree_list</action>
</button>

<button name="stylebt">
<label>Gamer</label>
<input file stock="gtk-find"></input>
<action>clear:QUOI</action>
<action>echo Gamer | tee /tmp/multisystem/multisystem-output-list</action>
<action>refresh:tree_list</action>
</button>
</hbox>

<tree  headers_visible="true" exported_column="3" rules_hint="true">
<label>Name|Bootloader|Category|URL Download</label>
<variable>tree_list</variable>
<input icon_column="0">bash -c "FCT_download_livecd"</input>
<action>test ${tree_list} && xdg-open ${tree_list} &</action>
</tree>
</vbox>
'$(FCT_HOME)'
</vbox>





'$(comment Onglet N°3 Mise à jour)'
<vbox spacing="0">
<vbox height_request="370">
<pixmap>
<input file>'${theme_bdo}'</input>
</pixmap>
<vbox width_request="400" width_request="50"scrollable="true">
<text use-markup="true" wrap="true" width-chars="70">
<input>echo "\<b>\<span color=\"red\">'$(eval_gettext "A ce jour MultiSystem est gratuit\nmais son développement n\\047est pas sans frais!\nSi vous l\\047utilisez régulièrement\net que vous souhaitez qu\\047il continue à évoluer,\nmerci de faire un geste de soutien via paypal.\n\npar avance MERCI!\nFrançois Fabre @frafa")'\</span>\</b>" | sed "s%\\\%%g" | sed "s%\\\\n\\\\n\\\\n%%g"</input>
</text>
</vbox>
<pixmap>
<input file>'${theme_bdo}'</input>
</pixmap>

<checkbox>
<label>"'$(eval_gettext 'Vérifier les mise à jour à chaque lancement')'"</label>
<variable>checkupdate</variable>
<default>true</default>
<action>if true echo true >"'$HOME'/.multisystem/checkupdate"</action>
<action>if false echo false >"'$HOME'/.multisystem/checkupdate"</action>
<input>cat "'$HOME'/.multisystem/checkupdate"</input>
<action>refresh:checkupdate</action>
<action>refresh:checkupdate2</action>
</checkbox>

<pixmap>
<input file>'${theme_bdo}'</input>
</pixmap>
<vbox spacing="0">
<radiobutton active="true">
<label>"'$(eval_gettext "Faire une donation")'"</label>
<variable>radio1</variable>
</radiobutton>
<radiobutton>
<label>"'$(eval_gettext "Ne pas faire de donation")'"</label>
<variable>radio2</variable>
</radiobutton>
</vbox>
<pixmap>
<input file>'${theme_bdo}'</input>
</pixmap>
<vbox spacing="0">
<radiobutton active="true">
<label>"'$(eval_gettext "Mise à jour")'"</label>
<variable>radio3</variable>
</radiobutton>
<radiobutton>
<label>"'$(eval_gettext "Mise à jour partielle")'"</label>
<variable>radio4</variable>
</radiobutton>
</vbox>
<pixmap>
<input file>'${theme_bdo}'</input>
</pixmap>
<hbox>
<button name="stylebt">
<input file icon="multisystem-update"></input>
<label>'$(eval_gettext 'Mise à jour')'</label>
<action>bash -c "FCT_update" &</action>
<action>wmctrl -c "MultiSystem-logo"</action>
<action>wmctrl -c "MultiSystem-logo2"</action>
<action>wmctrl -c "VBox"</action>
<action type="exit">exit</action>
</button>
</hbox>
</vbox>
'$(FCT_HOME)'
</vbox>





'$(comment Onglet N°4 Déboguer)'
<vbox spacing="0">
<vbox height_request="370">

<frame Debug>
<vbox scrollable="true">
<edit>
<variable>debug_edit</variable>
<input file>/tmp/multisystem/multisystem-test-usb</input>
</edit>
</vbox>
</frame>

<hbox homogeneous="true">
<button name="stylebt" width_request="180">
<input file icon="gtk-execute"></input>
<label>"'$(eval_gettext "fdisk -l")'"</label>
<action>fdisk -l $(cat /tmp/multisystem/multisystem-selection-usb | sed '\''s/[0-9]//'\'')>/tmp/multisystem/multisystem-test-usb</action>
<action>refresh:debug_edit</action>
</button>
<button name="stylebt" width_request="180">
<input file icon="gtk-execute"></input>
<label>"'$(eval_gettext "parted print")'"</label>
<action>parted -s $(cat /tmp/multisystem/multisystem-selection-usb | sed '\''s/[0-9]//'\'') unit MB print >/tmp/multisystem/multisystem-test-usb</action>
<action>refresh:debug_edit</action>
</button>
</hbox>

<hbox homogeneous="true">
<hbox spacing="0">
<button name="stylebt" width_request="115">
<input file icon="gtk-execute"></input>
<label>"'$(eval_gettext "Afficher mbr")'"</label>
<action>dd if="$(cat /tmp/multisystem/multisystem-selection-usb | sed '\''s/[0-9]//'\'')" bs=512 count=1 | xxd >/tmp/multisystem/multisystem-test-usb</action>
<action>refresh:debug_edit</action>
</button>
<button name="stylebt" width_request="65">
<input file icon="gtk-execute"></input>
<label>"'$(cat /tmp/multisystem/multisystem-selection-usb | sed 's@/dev/@@')'"</label>
<action>dd if="$(cat /tmp/multisystem/multisystem-selection-usb)" bs=512 count=1 | xxd >/tmp/multisystem/multisystem-test-usb</action>
<action>refresh:debug_edit</action>
</button>
</hbox>

<button name="stylebt" width_request="180">
<input file icon="gtk-execute"></input>
<label>"'$(eval_gettext "udevadm info")'"</label>
<action>udevadm info -q all -n $(cat /tmp/multisystem/multisystem-selection-usb | sed '\''s/[0-9]//'\'') >/tmp/multisystem/multisystem-test-usb</action>
<action>refresh:debug_edit</action>
</button>
</hbox>

<hbox homogeneous="true">
<button name="stylebt" width_request="180">
<input file icon="gtk-execute"></input>
<label>"'$(eval_gettext "Version Grub2")'"</label>
<action>grub-install -v >/tmp/multisystem/multisystem-test-usb</action>
<action>refresh:debug_edit</action>
</button>
<button name="stylebt" width_request="180">
<input file icon="gtk-execute"></input>
<label>"'$(eval_gettext "Réparer fat32")'"</label>
<action signal="button-press-event">echo '${message_debug}' >/tmp/multisystem/multisystem-test-usb</action>
<action signal="button-press-event">refresh:debug_edit</action>
<action signal="button-release-event">bash -c "xterm -e FCT_debug_repair"</action>
<action signal="button-release-event">echo >/tmp/multisystem/multisystem-test-usb</action>
<action signal="button-release-event">refresh:debug_edit</action>
</button>
</hbox>

<hbox homogeneous="true">
<button name="stylebt" width_request="180">
<input file icon="gtk-execute"></input>
<label>"'$(eval_gettext "Benchmark écriture")'"</label>
<action signal="button-press-event">echo '${message_debug}' >/tmp/multisystem/multisystem-test-usb</action>
<action signal="button-press-event">refresh:debug_edit</action>
<action signal="button-release-event">bash -c "xterm -e FCT_debug_write"</action>
<action signal="button-release-event">refresh:debug_edit</action>
</button>
<button name="stylebt" width_request="180">
<input file icon="gtk-execute"></input>
<label>"'$(eval_gettext "Benchmark lecture")'"</label>
<action signal="button-press-event">echo '${message_debug}' >/tmp/multisystem/multisystem-test-usb</action>
<action signal="button-press-event">refresh:debug_edit</action>
<action signal="button-release-event">bash -c "xterm -e FCT_debug_read"</action>
<action signal="button-release-event">echo >/tmp/multisystem/multisystem-test-usb</action>
<action signal="button-release-event">refresh:debug_edit</action>
</button>
</hbox>
</vbox>
'$(FCT_HOME)'
</vbox>





'$(comment Onglet N°5 Formater votre clé USB)'
<vbox spacing="0">
<vbox height_request="370">
<frame '$(eval_gettext 'Informations')'>
<vbox scrollable="true">
<text use-markup="true" sensitive="false">
<input>echo "\<b>\<big>'$(eval_gettext "ATTENTION!\nVous allez formater\nle volume amovible:")' $(cat /tmp/multisystem/multisystem-selection-usb | sed 's/[0-9]//')'$(eval_gettext "\nTout son contenu\nsera définitivement éffacé.")'\</big>\</b>" | sed "s%\\\%%g"</input>
</text>
</vbox>
</frame>
<edit editable="true" cursor-visible="true" accepts-tab="true" left-margin="2" right-margin="2" indent="2">
<input file>/tmp/multisystem/multisystem-format-text</input>
</edit>
<pixmap>
<input file>./pixmaps/multisystem-usbpendrive.png</input>
</pixmap>
<hbox>
<button name="stylebt" relief="2" tooltip-text="'$(eval_gettext 'Valider')'">
<input file stock="gtk-apply"></input>
<label>"'$(eval_gettext 'Valider')'"</label>
<action>bash -c "xterm -e FCT_format" &</action>
<action>wmctrl -c "MultiSystem-logo"</action>
<action>wmctrl -c "MultiSystem-logo2"</action>
<action>wmctrl -c "VBox"</action>
<action type="exit">format</action>
</button>
</hbox>
</vbox>
'$(FCT_HOME)'
</vbox>





'$(comment Onglet N°6 Afficher/Masquer des fichiers/dossiers dans votre clé usb)'
<vbox spacing="0">
<vbox height_request="370">

<frame>
<text use-markup="true" wrap="true" width-chars="70" sensitive="false">
<input>echo "\<b>\<big>'$(eval_gettext "Afficher/Masquer des fichiers/dossiers\nFonctionne uniquement avec Nautilus.")'\</big>\</b>" | sed "s%\\\%%g"</input>
</text>
</frame>

<hbox homogeneous="true">
<button name="stylebt" tooltip-text="'$(eval_gettext 'Afficher tous')'">
<input file icon="multisystem-green"></input>
<label>'$(eval_gettext 'Afficher tous')'</label>
<action>bash -c "FCT_hidden_showall"</action>
<action>refresh:hidden_tree</action>
</button>
<button name="stylebt" tooltip-text="'$(eval_gettext 'Masquer tous')'">
<input file icon="multisystem-red"></input>
<label>'$(eval_gettext 'Masquer tous')'</label>
<action>bash -c "FCT_hidden_hiddenall"</action>
<action>refresh:hidden_tree</action>
</button>
</hbox>

<frame '$(eval_gettext 'Contenu de votre clé USB')'>
<hbox height_request="210">
<tree hover_selection="true" headers_visible="false" exported_column="0">
<label>files</label>
<input icon_column="0">cat /tmp/multisystem/multisystem-hidden</input>
<variable>hidden_tree</variable>
<action signal="button-press-event">bash -c "FCT_hidden_modify $hidden_tree"</action>
<action signal="button-press-event">refresh:hidden_tree</action>
</tree>
</hbox>
</frame>

</vbox>
'$(FCT_HOME)'
</vbox>





'$(comment Onglet N°7 N/A)'
<vbox spacing="0">
<vbox height_request="370">
<pixmap>
<input file>'${theme_bdo}'</input>
</pixmap>
<text><label>N/A 7</label></text>
</vbox>
'$(FCT_HOME)'
</vbox>






'$(comment Onglet N°8 N/A)'
<vbox spacing="0">
<vbox height_request="370">
<pixmap>
<input file>'${theme_bdo}'</input>
</pixmap>
<text><label>N/A 8</label></text>
</vbox>
'$(FCT_HOME)'
</vbox>





'$(comment Onglet N°9 N/A)'
<vbox spacing="0">
<vbox height_request="370">
<pixmap>
<input file>'${theme_bdo}'</input>
</pixmap>
<text><label>N/A 9</label></text>
</vbox>
'$(FCT_HOME)'
</vbox>






<variable>tab3</variable>
<input file>/tmp/multisystem/multisystem-inputtab3</input>
</notebook>
</vbox>


<variable>tab1</variable>
<input file>/tmp/multisystem/multisystem-inputtab1</input>
</notebook>

<action signal="delete-event">wmctrl -c "MultiSystem-logo"</action>
<action signal="delete-event">wmctrl -c "MultiSystem-logo"2</action>
<action signal="delete-event">wmctrl -c "VBox"</action>

<action signal="focus-in-event">clear:DAG</action>
<action signal="focus-in-event">refresh:DAG</action>
<action signal="focus-in-event">refresh:MESSAGES</action>
<action signal="focus-in-event">refresh:tree</action>
<action signal="show">wmctrl -c "MultiSystem-logo"</action>
<action signal="show">refresh:MESSAGES</action>
<action signal="show">refresh:tree</action>
<action signal="hide">refresh:DAG</action>
</window>'
export MULTISYSTEM
$GTKDIALOG -c --program=MULTISYSTEM

#echo -e "$MULTISYSTEM" >/tmp/multisystem/multisystem.xml
#$GTKDIALOG -f /tmp/multisystem/multisystem.xml
exit 0

