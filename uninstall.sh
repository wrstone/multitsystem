#! /bin/bash
chemin="$(cd "$(dirname "$0")";pwd)/$(basename "$0")";
dossier="$(dirname "$chemin")"
cd "${dossier}"
###Pour exporter la librairie de gettext.
set -a
source gettext.sh
set +a
export TEXTDOMAIN=multisystem
export TEXTDOMAINDIR=${dossier}/locale
. gettext.sh
multisystem=$0

#test
if [ "${dossier}" != "/usr/local/share/multisystem" ]; then
zenity --error --text="$(eval_gettext "Erreur: Désinstaller n\047est disponible que si MultiSystem est installé.")"
sudo -u "$SUDO_USER" nohup "${dossier}"/gui_multisystem.sh&
sleep .1
exit 0
fi

#stop si pas sudo
if [[ ! "$SUDO_USER" || "$USER" != "root" || "$USERNAME" != "root" ]]; then
zenity --error --text="$(eval_gettext "Erreur: Désinstaller doit être lancé en sudo user.")"
sudo -u "$SUDO_USER" nohup /usr/local/share/multisystem/gui_multisystem.sh&
sleep .1
exit 0
fi

#test si .deb est installé
if [ "$(dpkg -l | grep 'multisystem' 2>/dev/null)" ]; then
#zenity --error --text "$(eval_gettext 'Erreur: Veuillez utiliser le gestionnaire de paquets.')"
#sudo -u "$SUDO_USER" nohup /usr/local/share/multisystem/gui_multisystem.sh&
#sleep 1
rm -R /usr/local/share/multisystem/isolinux 2>/dev/null
rm /usr/local/share/multisystem/nohup.out 2>/dev/null
apt-get remove -q --purge multisystem
exit 0
fi

PID_SCRIPT=$(pidof -x $(basename $0))

UNINSTALL=$(zenity \
--title="Live CD/USB" \
--text="$(eval_gettext "Choisir l\047option désirée dans la liste ci-dessous")\n$NOM_SCRIPT" \
--window-icon="/usr/local/share/pixmaps/multisystem-liveusb.png" \
--width=400 \
--height=180 \
--list \
--print-column="2" \
--radiolist \
--separator=" " \
--column="*" \
--column="Val" \
--column="$(eval_gettext "Fonction à exécuter")" \
--hide-column="2" \
FALSE "A" "$(eval_gettext "Confirmez, Supprimer MultiSystem")" \
TRUE "B" "$(eval_gettext "Ou Retour accueil")" \
)
test $? -ne 0 && exit 0 # Bouton Annuler

if [ "${UNINSTALL}" == "A" ]; then
echo $(eval_gettext "Désinstaller")
#kill -9  $(lsof -at "/usr/local/share/multisystem" | grep -v $PID_SCRIPT | xargs) 2>/dev/null
rm /tmp/multisystem/log_differences_multisystem
rm /tmp/multisystem/version-multisystem.txt
rm -R /tmp/multisystem 2>/dev/null
rm -R /usr/local/share/multisystem
#virer icon
rm -R "$HOME"/.local/share/icons/hicolor/48x48/apps/multisystem-*
rm /usr/local/share/pixmaps/multisystem-liveusb.png
rm /usr/local/share/pixmaps/multisystem-vbox.png
rm /usr/share/applications/multisystem-liveusb.desktop
rm /usr/share/applications/multisystem-vbox.desktop
#xdg-desktop-menu uninstall /usr/share/applications/multisystem-liveusb.desktop
. $HOME/.config/user-dirs.dirs
rm "$XDG_DESKTOP_DIR/multisystem-liveusb.desktop"
xdg-desktop-menu forceupdate --mode user
zenity --info --text="$(eval_gettext "Désinstallation de MultiSystem éffectuée.")"

else
#relancer gui
rm /tmp/multisystem/log_differences_multisystem
rm /tmp/multisystem/version-multisystem.txt
rm -R /tmp/multisystem 2>/dev/null
sudo -u "$SUDO_USER" nohup /usr/local/share/multisystem/gui_multisystem.sh&
sleep .1
exit 0
fi

exit 0
