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

#Créer dossier nonfree
mkdir -p "$HOME"/.multisystem/nonfree 2>/dev/null

#Faire test présence de PloP et message si pas présent
#http://www.plop.at/en/bootmanager.html#licence
if [ "${option1}" == "alert-plop" ]; then
zenity --info --text "$(eval_gettext 'Veuillez installer \"PLoP Boot Manager\"\naprès avoir accepté sa licence,\nPloP est un freeware non libre.\n\nInstallation accessible via le menu: Non-libre ==> Installer partie non libre ==> Télécharger PloP Boot Manager')"
#exec ./fonctions.sh nonfree
exit 0
fi


#Attention! PloP n'est pas libre, c'est un freeware
#Télécharger plpcfgbt et configurer PloP
if [ "${option1}" == "plop" ]; then
function plop_plpbt()
{
plopversion="5.0.14"
#http://download.plop.at/files/bootmngr/plpbt-5.0.10.zip
plop_url="http://download.plop.at/files/bootmngr/plpbt-${plopversion}.zip"

#plopversion="5.0.10"
#http://liveusb.info/multisystem/nonfree/plop-5.0.0.10/PLoP%20Boot%20Manager%205.0.10.zip
#plop_url="http://liveusb.info/multisystem/nonfree/plop-${plopversion}/plpbt-${plopversion}.zip"

xdg-open http://www.plop.at/en/bootmanager/licence.html &

rm -R /tmp/multisystem/plpbt* 2>/dev/null
cd /tmp/multisystem/
wget -nd "${plop_url}" -O /tmp/multisystem/plpbt-${plopversion}.zip 2>&1 \
| sed -u 's/\([ 0-9]\+K\)[ \.]*\([0-9]\+%\) \(.*\)/\2\n#Transfert : \1 (\2) à \3/' \
| zenity --progress --auto-kill --auto-close --width 400 --title "$(eval_gettext 'Téléchargement en cours...')"
unzip /tmp/multisystem/plpbt-${plopversion}.zip
rm /tmp/multisystem/plpbt-${plopversion}.zip
cp -f /tmp/multisystem/plpbt-${plopversion}/plpbt.bin "$HOME"/.multisystem/nonfree/plpbt.bin
mkdir -p "$HOME"/.multisystem/nonfree/bootcd/boot
cp -f /tmp/multisystem/plpbt-${plopversion}/plpbt.img "$HOME"/.multisystem/nonfree/bootcd/boot/plpbt.img
cp -f /tmp/multisystem/plpbt-${plopversion}/cfg/plpcfgbt "$HOME"/.multisystem/nonfree/plpcfgbt 2>/dev/null
cp -f /tmp/multisystem/plpbt-${plopversion}/Linux/plpcfgbt "$HOME"/.multisystem/nonfree/plpcfgbt
rm -R /tmp/multisystem/plpbt-${plopversion}

#Configurer PloP
chmod +x "$HOME"/.multisystem/nonfree/plpcfgbt
"$HOME"/.multisystem/nonfree/plpcfgbt dbt=usb "$HOME"/.multisystem/nonfree/plpbt.bin

#Compiler plpcfgbt (version plpcfgbt, le binaire embarqué dans plop est compilé pour kernel 3.xx)
plop_url="http://download.plop.at/files/bootmngr/plpcfgbt-0.11.zip"
wget -nd "http://download.plop.at/files/bootmngr/plpcfgbt-0.11.zip" -O /tmp/multisystem/plpcfgbt.zip 2>&1 \
| sed -u 's/\([ 0-9]\+K\)[ \.]*\([0-9]\+%\) \(.*\)/\2\n#Transfert : \1 (\2) à \3/' \
| zenity --progress --auto-kill --auto-close --width 400 --title "$(eval_gettext 'Téléchargement en cours...')"
unzip /tmp/multisystem/plpcfgbt.zip
rm /tmp/multisystem/plpcfgbt.zip
cd /tmp/multisystem/plpcfgbt-*/src
make
/tmp/multisystem/plpcfgbt-*/src/plpcfgbt dbt=usb "$HOME"/.multisystem/nonfree/plpbt.bin
cp -f /tmp/multisystem/plpcfgbt-*/src/plpcfgbt "$HOME"/.multisystem/nonfree/plpcfgbt
rm -R /tmp/multisystem/plpcfgbt-*
cd -

#Copier dans clé USB
cp -Rf "${HOME}"/.multisystem/nonfree/plpbt.bin "$(cat "/tmp/multisystem/multisystem-mountpoint-usb" 2>/dev/null)/boot/img/plpbt" 2>/dev/null
}
plop_plpbt
fi


#Télécharger firadisk
if [ "${option1}" == "firadisk" ]; then
wget -nd http://liveusb.info/multisystem/nonfree/firadisk.ima -O "$HOME"/.multisystem/nonfree/firadisk.ima 2>&1 \
| sed -u 's/\([ 0-9]\+K\)[ \.]*\([0-9]\+%\) \(.*\)/\2\n#Transfert : \1 (\2) à \3/' \
| zenity --progress --auto-kill --auto-close --width 400 --title "$(eval_gettext 'Téléchargement en cours...')"
fi


#Microsoft Windows Server 2003 Service Pack 1 (32 bits)
#http://www.microsoft.com/downloads/details.aspx?familyid=22CFC239-337C-4D81-8354-72593B1C1F43&displaylang=fr
#http://download.microsoft.com/download/1/2/7/127c5938-d36a-4405-9df1-f00d57495652/WindowsServer2003-KB889101-SP1-x86-ENU.exe
#BartPE
if [ "${option1}" == "bartpe" ]; then
cd /tmp/multisystem/
wget -nd http://download.microsoft.com/download/1/2/7/127c5938-d36a-4405-9df1-f00d57495652/WindowsServer2003-KB889101-SP1-x86-ENU.exe -O /tmp/multisystem/WindowsServer2003-KB889101-SP1-x86-ENU.exe 2>&1 \
| sed -u 's/\([ 0-9]\+K\)[ \.]*\([0-9]\+%\) \(.*\)/\2\n#Transfert : \1 (\2) à \3/' \
| zenity --progress --auto-kill --auto-close --width 400 --title "$(eval_gettext 'Téléchargement en cours...')"
if [ -f "/tmp/multisystem/WindowsServer2003-KB889101-SP1-x86-ENU.exe" ]; then
(echo 1;$(cabextract /tmp/multisystem/WindowsServer2003-KB889101-SP1-x86-ENU.exe -d /tmp/multisystem) ;echo 100) | zenity --progress --pulsate --auto-close --width 400
rm /tmp/multisystem/WindowsServer2003-KB889101-SP1-x86-ENU.exe
cp -f /tmp/multisystem/i386/ntdetect.com "$HOME"/.multisystem/nonfree/NTDETECT.COM
cp -f /tmp/multisystem/i386/setupldr.bin "$HOME"/.multisystem/nonfree/SETUPLDR.BIN
cp -f /tmp/multisystem/i386/ramdisk.sy_ "$HOME"/.multisystem/nonfree/RAMDISK.SY_
cabextract "$HOME"/.multisystem/nonfree/RAMDISK.SY_ -d "$HOME"/.multisystem/nonfree
mv "$HOME"/.multisystem/nonfree/ramdisk.sys "$HOME"/.multisystem/nonfree/RAMDISK.SYS
rm -R /tmp/multisystem/i386
fi
cd -
#Recuperer secteur de boot win
wget -nd http://liveusb.info/multisystem/nonfree/BOOTSECT.BIN -O "$HOME"/.multisystem/nonfree/BOOTSECT.BIN 2>&1 \
| sed -u 's/\([ 0-9]\+K\)[ \.]*\([0-9]\+%\) \(.*\)/\2\n#Transfert : \1 (\2) à \3/' \
| zenity --progress --auto-close --width 400 --title "$(eval_gettext 'Téléchargement en cours...')"
fi


#Check les files
>/tmp/multisystem/multisystem-nonfree
if [ -f "$HOME"/.multisystem/nonfree/plpbt.bin ]; then
echo "gtk-ok|plpbt.bin" >>/tmp/multisystem/multisystem-nonfree
else
echo "gtk-no|plpbt.bin" >>/tmp/multisystem/multisystem-nonfree
fi
if [ -f "$HOME"/.multisystem/nonfree/plpcfgbt ]; then
echo "gtk-ok|plpcfgbt" >>/tmp/multisystem/multisystem-nonfree
else
echo "gtk-no|plpcfgbt" >>/tmp/multisystem/multisystem-nonfree
fi
if [ -f "$HOME"/.multisystem/nonfree/NTDETECT.COM ]; then
echo "gtk-ok|NTDETECT.COM" >>/tmp/multisystem/multisystem-nonfree
else
echo "gtk-no|NTDETECT.COM" >>/tmp/multisystem/multisystem-nonfree
fi
if [ -f "$HOME"/.multisystem/nonfree/SETUPLDR.BIN ]; then
echo "gtk-ok|SETUPLDR.BIN" >>/tmp/multisystem/multisystem-nonfree
else
echo "gtk-no|SETUPLDR.BIN" >>/tmp/multisystem/multisystem-nonfree
fi
if [ -f "$HOME"/.multisystem/nonfree/RAMDISK.SY_ ]; then
echo "gtk-ok|RAMDISK.SY_" >>/tmp/multisystem/multisystem-nonfree
else
echo "gtk-no|RAMDISK.SY_" >>/tmp/multisystem/multisystem-nonfree
fi
if [ -f "$HOME"/.multisystem/nonfree/RAMDISK.SYS ]; then
echo "gtk-ok|RAMDISK.SYS" >>/tmp/multisystem/multisystem-nonfree
else
echo "gtk-no|RAMDISK.SYS" >>/tmp/multisystem/multisystem-nonfree
fi
if [ -f "$HOME"/.multisystem/nonfree/BOOTSECT.BIN ]; then
echo "gtk-ok|BOOTSECT.BIN" >>/tmp/multisystem/multisystem-nonfree
else
echo "gtk-no|BOOTSECT.BIN" >>/tmp/multisystem/multisystem-nonfree
fi
if [ -f "$HOME"/.multisystem/nonfree/firadisk.ima ]; then
echo "gtk-ok|firadisk.ima" >>/tmp/multisystem/multisystem-nonfree
else
echo "gtk-no|firadisk.ima" >>/tmp/multisystem/multisystem-nonfree
fi

exit 0
