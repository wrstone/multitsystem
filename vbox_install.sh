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


export INFO='<window title="MultiSystem_PoPuP" icon-name="multisystem-icon" decorated="true" width_request="400" height_request="400">
<vbox>
<pixmap>
<input file>./pixmaps/multisystem-vbox.png</input>
</pixmap>
<hbox  homogeneous="true">
<text use-markup="true" wrap="true" width-chars="70" sensitive="false">
<variable>MESSAGES</variable>
<input>echo "\<b>\<big>'$(eval_gettext "ATTENTION!\nVous allez installer\nla version non libre de virtualBox")'\</big>\</b>" | sed "s%\\\%%g"</input>
</text>
</hbox>
<hbox homogeneous="true">
<button>
<input file icon="gtk-no"></input>
<label>"'$(eval_gettext "Annuler")'"</label>
<action type="exit">false</action>
</button>
<button>
<input file icon="gtk-yes"></input>
<label>"'$(eval_gettext "Installer")'"</label>
<action type="exit">true</action>
</button>
</hbox>
</vbox>
</window>'
if [ ! "$(which VBoxManage)" ]; then
#monter gui
I=$IFS; IFS=""
for MENU_INFO in  $(gtkdialog --program=INFO); do
eval $MENU_INFO
done
IFS=$I
if [ "$EXIT" != "true" ]; then
exit 0
fi
fi

#Install Slitaz
if [ "$(which tazpkg)" ]; then
sudo tazpkg get-install virtualbox
#Ajouter user vboxusers
sudo adduser -SD "vboxusers"
sudo adduser "tux" -G vboxusers
#Compiler module
sudo /etc/init.d/vboxdrv setup
exit 0
fi

#???
if [ ! "$(lsb_release -cs 2>/dev/null)" ]; then
echo lsb_release ?
read
exit 0
fi

#Install VirtualBox Ubuntu/Debian
if [ ! "$(which VBoxManage)" ]; then
echo -e "\E[37;44m\033[1m $(eval_gettext 'Veuillez saisir votre mot de passe d\047administrateur') \033[0m"
#test si dispo sans ajouter depôt (pour linuxmint)
VBoxVersion="$(aptitude search virtualbox-[0-9] | grep ^p | tail -1 | awk '{print $2}')"
if [ ! "$VBoxVersion" ]; then
echo
if [ ! "$(grep "^deb http://download.virtualbox.org/virtualbox/debian" /etc/apt/sources.list)" ]; then
#test si depot existe?
wget http://download.virtualbox.org/virtualbox/debian/dists/$(lsb_release -cs)/ -O /tmp/multisystem/test_vbox.html
if [ ! "$(cat /tmp/multisystem/test_vbox.html | grep "/virtualbox/debian/dists/$(lsb_release -cs)/")" ]; then
echo -e "\033[1;47;31m $(eval_gettext "Erreur:") depôt VirtualBox \033[0m"
else
echo -e "deb http://download.virtualbox.org/virtualbox/debian $(lsb_release -cs) non-free contrib" | sudo tee -a /etc/apt/sources.list
wget -q http://download.virtualbox.org/virtualbox/debian/sun_vbox.asc -O- | sudo apt-key add -
wget -q http://download.virtualbox.org/virtualbox/debian/oracle_vbox.asc -O- | sudo apt-key add -
sudo apt-get --quiet update
VBoxVersion="$(aptitude search virtualbox-[0-9] | grep ^p | tail -1 | awk '{print $2}')"
fi
fi
fi
if [ "$VBoxVersion" ]; then
sudo apt-get --quiet install -y --force-yes $VBoxVersion
fi
fi

#http://download.virtualbox.org/virtualbox/LATEST.TXT
#http://dlc.sun.com.edgesuite.net/virtualbox/3.2.8/MD5SUMS

#retest
if [ ! "$(which VBoxManage)" ]; then
echo -e "\033[1;47;31m $(eval_gettext "Erreur:") VBoxManage \033[0m"
echo -e "\033[1;47;31m $(eval_gettext "Appuyez sur enter pour continuer") \033[0m"
read
exit 0
fi

#verifier que version VirtualBox n'est pas virtualbox-ose
if [ "$(dpkg -l | grep -i virtualbox-ose)" ]; then
zenity --error --text "$(eval_gettext "Erreur virtualbox-ose")"
exit 0
fi

#verifier que user appartiens au group disk
if [ ! "$(grep ^disk /etc/group | grep "$SUDO_USER")" ]; then
sudo usermod -a -G disk "$SUDO_USER"
fi

#verifier que user apartiens aussi a vboxusers
if [ ! "$(grep ^vboxusers /etc/group | grep "$SUDO_USER")" ]; then
sudo adduser "$SUDO_USER" vboxusers
sudo usermod -G vboxusers -a "$SUDO_USER"
fi

#Ajouter support usb à VBox
if [ -d "/proc/bus/usb" ]; then
echo
if [ ! "$(mount -l | grep /proc/bus/usb)" ]; then
echo
#ajouter à fstab
if [ ! "$(grep /proc/bus/usb /etc/fstab)" ]; then
#echo -e "#Entrée pour VirtualBox\nnone /proc/bus/usb usbfs auto,busgid=$(sed -n '/vboxusers/ s/vboxusers:x:\(.*\):.*/\1/p' /etc/group),busmode=0775,devgid=$(sed -n '/vboxusers/ s/vboxusers:x:\(.*\):.*/\1/p' /etc/group),devmode=0664 0 0" | sudo tee -a /etc/fstab
echo -e "#Entrée pour VirtualBox\nnone /proc/bus/usb usbfs devgid=$(grep plugdev /etc/group | sed 's/plugdev:x:\(.*\):.*/\1/'),devmode=664 0 0" | sudo tee -a /etc/fstab
fi
#Monter /proc/bus/usb
sudo mount -a
fi
fi

dpkg -l | grep -i virtualbox
grep vboxdrv /etc/udev/rules.d/10-vboxdrv.rules 2>/dev/null
grep vboxusers /etc/udev/rules.d/10-vboxdrv.rules 2>/dev/null
#Recompiler module
sudo /etc/init.d/vboxdrv setup
sudo /etc/init.d/udev restart

/etc/init.d/vboxdrv status
echo -e "\E[37;44m\033[1m $(eval_gettext "Appuyez sur une touche pour continuer...") \033[0m"
read
exit 0
