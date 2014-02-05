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

#stop si pas sudo
if [ ! "$SUDO_USER" ]; then
zenity --error --text="$(eval_gettext "Erreur: Installation doit être lancé en sudo user.")"
exit 0
fi

#test
if [ "${dossier}" == "/usr/local/share/multisystem" ]; then
zenity --error --text="$(eval_gettext "Erreur: MultiSystem est déjà installé.")"
exit 0
fi

#test si disponible dans les depôts
if [ "$(grep '^deb http://liveusb.info/multisystem' /etc/apt/sources.list 2>/dev/null)" ]; then
zenity --error --text "$(eval_gettext 'Erreur: Veuillez utiliser le gestionnaire de paquets.')"
exit 0
fi

#test /tmp
if [ "${dossier}" != "/tmp/multisystem/multisystem" ]; then
zenity --error --text="$(eval_gettext "Erreur: MultiSystem doit être installé depuis le dossier: /tmp/multisystem/multisystem.")"
exit 0
fi

PID_SCRIPT=$(pidof -x $(basename $0))
kill -9  $(lsof -at "/usr/local/share/multisystem" | grep -v $PID_SCRIPT | xargs) 2>/dev/null

#quelques test...
errorlist=()
testlist="$(cat "${dossier}/dependances.txt")"
for i in $(echo -e "${testlist}" | grep -v "^#" | xargs)
do
if [ ! "$(which $i)" ]; then
errorlist=(${errorlist[@]} $i)
fi
done
#Stop si
if [ "$(echo "${errorlist[@]}")" ]; then
echo -e "\033[1;47;31m $(eval_gettext 'Erreur il manque: ')${errorlist[@]} \033[0m"
exit 0
fi

#virer fichiers de conf si present
rm -R /tmp/multisystem/multisystem-v3* 2>/dev/null
rm "/tmp/multisystem/version-multisystem.txt" 2>/dev/null

#si existe le virer
rm -R /usr/local/share/multisystem 2>/dev/null
#virer old icon
rm -R "$HOME"/.local/share/icons/hicolor/48x48/apps/multisystem-*

#Creer dossier hicolor user
sudo -u $SUDO_USER mkdir -p "$HOME"/.local/share/icons/hicolor/48x48/apps/ 2>/dev/null
#copier icon
sudo chown -R $SUDO_USER:$SUDO_USER "$HOME"/.local/share/icons/
sudo -u $SUDO_USER cp -f "${dossier}"/pixmaps/* "$HOME"/.local/share/icons/hicolor/48x48/apps/

#copier img couleur
mkdir -p /usr/local/share/pixmaps 2>/dev/null
cp -f "${dossier}"/img/*.png /usr/local/share/pixmaps

#icon lanceur
mkdir /usr/local/share/pixmaps 2>/dev/null
cp -f "${dossier}/pixmaps/multisystem-liveusb.png" /usr/local/share/pixmaps/multisystem-liveusb.png

#verifier que user appartiens au group disk
if [ ! "$(grep disk /etc/group | grep $SUDO_USER)" ]; then
sudo usermod -a -G disk $SUDO_USER
fi

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
xdg-desktop-menu install /usr/share/applications/multisystem-liveusb.desktop
cp -f "${dossier}/pixmaps/multisystem-vbox.png" /usr/local/share/pixmaps/multisystem-vbox.png
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

#deplacer
mv "${dossier}" /usr/local/share/

#message
echo -e '\E[37;44m'"\033[1m $(eval_gettext "Mise en place d\047un lanceur MultiSystem dans\nle Menu: /Applications/Accessoires/MultiSystem") \033[0m"
zenity --info --text "<b>$(eval_gettext 'Dorénavant pour lancer le script veuillez utiliser\nle Menu: /Applications/Accessoires/MultiSystem.')</b>"

#lancer gui
sudo -u "$SUDO_USER" nohup "/usr/local/share/multisystem/gui_multisystem.sh"&

exit 0
