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

if [[ ! "$SUDO_USER" || "$USER" != "root" || "$USERNAME" != "root" ]]; then
xterm  -title 'upgrade-src' -e "sudo $0"
sleep 1
exit 0
fi

function FCT_KILL()
{
PID_SCRIPT=$(pidof -x $(basename $0))
sudo umount "/tmp/multisystem/multisystem-mountpoint-iso" 2>/dev/null
rm "$dossier"/nohup.out 2>/dev/null
rm -R /tmp/multisystem 2>/dev/null
killall gui_multisystem.sh
wmctrl -c MultiSystem-logo 2>/dev/null
wmctrl -c VBox 2>/dev/null
#wmctrl -c MULTISYSTEM 2>/dev/null
wmctrl -c $(wmctrl -l | awk '{print $4}' | grep ^MultiSystem$) 2>/dev/null
kill -9 $(ps axu | grep  MULTISYSTEM | grep -v grep | awk '{print $1}')
lsof -at "$dossier" | grep -v $PID_SCRIPT | while read line
do
kill -9 $line
done
}
FCT_KILL

#bloquer par securité
if [ "${dossier}" != "/usr/local/share/multisystem" ]; then
zenity --error --text="$(eval_gettext "Erreur: Mise à jour n\047est disponible que si MultiSystem est installé.")"
sudo -u "$SUDO_USER" nohup "${dossier}"/gui_multisystem.sh &
sleep 1
exit 0
fi

#test si disponible dans les depôts
if [ "$(grep '^deb http://liveusb.info/multisystem' /etc/apt/sources.list 2>/dev/null)" ]; then
zenity --error --text "$(eval_gettext 'Erreur: Veuillez utiliser le gestionnaire de paquets.')"
sudo -u "$SUDO_USER" nohup "${dossier}"/gui_multisystem.sh &
sleep 1
exit 0
fi

export UPGRADE='<window title="Mises à jour" default-width="400" default-height="200" window_position="3" icon-name="gtk-edit" decorated="true">
<vbox>
<frame Différences>
<edit editable="true" cursor-visible="true" accepts-tab="true">
<width>400</width><height>200</height>
<input file>/tmp/multisystem/log_differences_multisystem</input>
</edit>
</frame>
<radiobutton active="true">
<label>"'$(eval_gettext "Ne pas mettre à jour le script")'"</label>
<variable>radiobt1</variable>
</radiobutton>
<radiobutton active="false">
<label>"'$(eval_gettext "Mettre à jour le script")'"</label>
<variable>radiobt2</variable>
</radiobutton>
<hbox>
<button cancel></button>
<button ok></button>
</hbox>
</vbox>
</window>'

#Télécharger version-multisystem.txt
rm "/tmp/multisystem/version-multisystem.txt" &>/dev/null
sudo -u $SUDO_USER wget -T 10 -t 10 http://liveusb.info/multisystem/version-multisystem.txt  -O "/tmp/multisystem/version-multisystem.txt"


#verifier presence fichier version
if [ ! -e "/tmp/multisystem/version-multisystem.txt" ]; then
echo -e "\033[1;47;31m $(eval_gettext "Erreur: impossible de télécharger le fichier version-multisystem.txt") \033[0m" ;
zenity --error --text="$(eval_gettext "Erreur: impossible de télécharger le fichier version-multisystem.txt")"
sudo -u "$SUDO_USER" nohup /usr/local/share/multisystem/gui_multisystem.sh &
sleep 1
exit 0
fi

if [ -e "/usr/local/share/multisystem/version-multisystem.txt" ]; then
echo -e "\033[1;33;44m $(eval_gettext "Chercher mise à jour") \033[00m"

if [ "$(cat /tmp/multisystem/version-multisystem.txt)" != "$(cat /usr/local/share/multisystem/version-multisystem.txt)" ]; then

#telecharger archive et decompresser dans /tmp/multisystem/
wget -r -nd http://liveusb.info/multisystem/multisystem.tar.bz2 -O /tmp/multisystem/multisystem.tar.bz2 2>&1 \
| sed -u 's/\([ 0-9]\+K\)[ \.]*\([0-9]\+%\) \(.*\)/\2\n#Transfert : \1 (\2) à \3/' \
| zenity --progress --auto-close --width 400 --title "Téléchargement de MultiSystem"
rm -R /tmp/multisystem/multisystem 2>/dev/null
cd /tmp/multisystem/
tar xvjf /tmp/multisystem/multisystem.tar.bz2
rm /tmp/multisystem/multisystem.tar.bz2
diff -r /tmp/multisystem/multisystem /usr/local/share/multisystem 2>/dev/null >/tmp/multisystem/log_differences_multisystem

#monter gui
I=$IFS; IFS=""
for MENU_UPGRADE in  $(gtkdialog --program=UPGRADE); do
eval $MENU_UPGRADE
done
IFS=$I
echo EXIT:$EXIT radiobt2:$radiobt2


#install
if [[ "$EXIT" == "OK" && "$radiobt2" == "true" ]]; then
#remplacer
rm -R /usr/local/share/multisystem
mv /tmp/multisystem/multisystem /usr/local/share/multisystem
#menage
rm -R "${dossier}/isolinux" 2>/dev/null
#Menage, virer les sauvegardes!
find "${dossier}" | egrep "~$" | perl -n -e 'system("rm $_");'
#virer icon
rm -R "$HOME"/.local/share/icons/hicolor/48x48/apps/multisystem-*
#copier icon en user
sudo chown -R $SUDO_USER:$SUDO_USER "$HOME"/.local/share/icons/
sudo -u $SUDO_USER cp -f "${dossier}"/pixmaps/* "$HOME"/.local/share/icons/hicolor/48x48/apps/
#copier img couleur
mkdir -p /usr/local/share/pixmaps 2>/dev/null
cp -f "${dossier}"/img/*.png /usr/local/share/pixmaps
#icon lanceur
mkdir /usr/local/share/pixmaps 2>/dev/null
cp -f "${dossier}/pixmaps/multisystem-liveusb.png" /usr/local/share/pixmaps/multisystem-liveusb.png
cp -f "${dossier}/pixmaps/multisystem-vbox.png" /usr/local/share/pixmaps/multisystem-vbox.png
#Ajouter un Lanceur dans Menu: /Applications/Accessoires/MultiSystem
echo -e '\E[37;44m'"\033[1m $(eval_gettext "Créer un Lanceur dans le Menu:/Applications/Accessoires/MultiSystem") \033[0m"
mkdir -p /usr/local/share/applications >/dev/null
FILE='[Desktop Entry]
Encoding=UTF-8
Version=1.0
Type=Application
Terminal=false
Icon[fr_FR]=/usr/local/share/pixmaps/multisystem-liveusb.png
Name[fr_FR]=MultiSystem
Comment[fr_FR]=Grub2 MultiSystem boot iso
Exec=/usr/local/share/multisystem/gui_multisystem.sh
Name=MultiSystem
Comment=Grub2 MultiSystem boot iso
Icon=/usr/local/share/pixmaps/multisystem-liveusb.png
Categories=Application;Utility;'
echo -e "$FILE" | tee /usr/share/applications/multisystem-liveusb.desktop
FILE2='[Desktop Entry]
Encoding=UTF-8
Version=1.0
Type=Application
Terminal=false
Icon[fr_FR]=/usr/local/share/pixmaps/multisystem-vbox.png
Name[fr_FR]=MultiSystem VirtualBox test iso
Comment[fr_FR]=Isofile drop and test with VirtualBox
Exec=/usr/local/share/multisystem/VBox_livecd_gui.sh
Name=MultiSystem VirtualBox test iso
Comment=Isofile drop and test with VirtualBox
Icon=/usr/local/share/pixmaps/multisystem-vbox.png
Categories=Application;Utility;'
echo -e "$FILE2" | tee /usr/share/applications/multisystem-vbox.desktop
xdg-desktop-menu install /usr/share/applications/multisystem-liveusb.desktop
xdg-desktop-menu install /usr/share/applications/multisystem-vbox.desktop
xdg-desktop-menu forceupdate --mode user
#Ajouter lanceur sur bureau
. $HOME/.config/user-dirs.dirs
if [ "$XDG_DESKTOP_DIR" ]; then
echo -e "$FILE" | tee "$XDG_DESKTOP_DIR/multisystem-liveusb.desktop"
chown $SUDO_USER:$SUDO_USER "$XDG_DESKTOP_DIR/multisystem-liveusb.desktop"
chmod 644 "$XDG_DESKTOP_DIR/multisystem-liveusb.desktop"
else
echo -e "$FILE" | tee "$HOME/multisystem-liveusb.desktop"
chown $SUDO_USER:$SUDO_USER "$HOME/multisystem-liveusb.desktop"
chmod 644 "$HOME/multisystem-liveusb.desktop"
fi
rm /tmp/multisystem/log_differences_multisystem
rm /tmp/multisystem/version-multisystem.txt
rm -R /tmp/multisystem 2>/dev/null

function FCT_SLITAZ()
{
if [ "$(which tazpkg)" ]; then
#Supprimer ces dépendances pour Slitaz
sed -i "s/gksudo//" ${dossier}/dependances.txt
sed -i "s/apt-get//" ${dossier}/dependances.txt
sed -i "s/fatresize//" ${dossier}/dependances.txt
#rechercher et remplacer mount -l par mount sauf dans update-src.sh
grep 'mount -l' -r ${dossier} | awk -F":" '{print $1}' | uniq | grep -v 'update-src.sh' | tee /tmp/multisystem/multisystem-mform2-slitaz
cat /tmp/multisystem/multisystem-mform2-slitaz | while read line
do
sed -i "s@mount -l@mount@g" "$line"
done
rm /tmp/multisystem/multisystem-mform2-slitaz
#Modifier les echo des input car Slitaz accepte option -e !!! et pas Ubuntu/Debian
echo "" | tee /tmp/multisystem/multisystem-mform-slitaz
grep '<input>echo ' -r ${dossier} | grep -v ' -e ' | awk -F":" '{print $1}' | uniq | tee /tmp/multisystem/multisystem-mform-slitaz
cat /tmp/multisystem/multisystem-mform-slitaz | while read line
do
sed -i "s@<input>echo @<input>echo -e @g" "$line"
done
rm /tmp/multisystem/multisystem-mform-slitaz
fi
}
FCT_SLITAZ

#lancer gui
sudo -u "$SUDO_USER" nohup /usr/local/share/multisystem/gui_multisystem.sh &
sleep 1
exit 0

else
#virer version téléchargée
rm -R /tmp/multisystem 2>/dev/null
#relancer gui
sudo -u "$SUDO_USER" nohup /usr/local/share/multisystem/gui_multisystem.sh &
sleep 1
exit 0
fi

else
echo -e '\E[37;44m'"\033[1m $(eval_gettext "Pas de mise à jour disponible,\nVous utilisez bien la dernière version du script.") \033[0m"
zenity --info --title MultiSystem_Information --text="$(eval_gettext "Pas de mise à jour disponible,\nVous utilisez bien la dernière version du script.")"
sleep 1
wmctrl -a MultiSystem_Information
sudo -u "$SUDO_USER" nohup /usr/local/share/multisystem/gui_multisystem.sh &
sleep 1
exit 0
fi

else
zenity --error --text="$(eval_gettext "Erreur:impossible de détecter la version de MultiSystem.")"
sudo -u "$SUDO_USER" nohup /usr/local/share/multisystem/gui_multisystem.sh &
sleep 1
exit 0
fi
exit 0
