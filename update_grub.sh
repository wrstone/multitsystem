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

echo -e " \E[37;44m\033[1m $(eval_gettext 'Patience Mise à jour de grub') \033[0m"
echo -e " \E[37;44m\033[1m $(eval_gettext 'Grub nécéssite les droits d\047administrateur') \033[0m"
sudo echo
#dosfsck -n $(cat /tmp/multisystem/multisystem-selection-usb)

#Pause de 5 secondes ...
declare -i  i=5
while (( i > 0 ))
do
echo -e " \E[37;44m\033[1m wait $i \033[0m"
(( i = i - 1 ))
sleep 1
done

#remonter au cas ou ?
sudo mount -o remount,rw $(cat /tmp/multisystem/multisystem-selection-usb)
#sudo mount -o remount,rw,sync $(cat /tmp/multisystem/multisystem-selection-usb)
#gvfs-mount -d $(cat /tmp/multisystem/multisystem-selection-usb) 2>/dev/null

#echo Attente
#read

#Stop si pas accès à la clé USB.
echo test >"$(cat /tmp/multisystem/multisystem-mountpoint-usb)/.1234"
if [ -f "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/.1234" ]; then
rm "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/.1234"
else
zenity --info --text "Error: please unplug/replug your USB key."
exit 0
fi

#Sauver précédent fichier de conf de Grub2
if [ "$(grep "#MULTISYSTEM_ST" "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/grub/grub.cfg" 2>/dev/null | wc -l)" = "2" ]; then
cp -f "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/grub/grub.cfg" "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/grub/grub.save.cfg"
fi

#Ancienne syntaxe de Grub2! ==> 1.96 ... 1.98
if [ "$(grub-install -v | grep -E '(1.96)|(1.97)|(1.98)')" ]; then
sed -i "s@search --no-floppy --fs-uuid --set=root @search --no-floppy --fs-uuid --set @g" "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/grub/grub.cfg" 2>/dev/null

#Nouvelle syntaxe de Grub2! 1.99
elif [ "$(grub-install -v | grep -E '(1.99)')" ]; then
sed -i "s@search --no-floppy --fs-uuid --set @search --no-floppy --fs-uuid --set=root @g" "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/grub/grub.cfg" 2>/dev/null

else
zenity --error --text "Error: grub-pc version ?"
sed -i "s@search --no-floppy --fs-uuid --set @search --no-floppy --fs-uuid --set=root @g" "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/grub/grub.cfg" 2>/dev/null

fi

#Décharger le module videotest pour Ubuntu Maverick Meerkat
sed -i "s/^insmod videotest/#insmod videotest/" $(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/grub/grub.cfg
#http://www.linuxpedia.fr/doku.php/expert/grub2

#Supprimer 40_multiboot si présent, car a changé de nom !
sudo rm /etc/grub.d/40_multiboot 2>/dev/null

#Copier/maj Virtualisation win VBox
if [ ! "$(grep 'VERSION=1.1' "$(cat /tmp/multisystem/multisystem-mountpoint-usb 2>/dev/null)/multisystem.bat" 2>/dev/null)" ]; then
cp -f "${dossier}/divers/multisystem.bat" "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/multisystem.bat"
#Numéro de série
sudo ${dossier}/divers/vin_vbox.sh
fi

#Sauver mbr origine
if [ ! -e "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/multisystem.bs.save" ]; then
sudo dd if="$(cat /tmp/multisystem/multisystem-selection-usb | sed 's/[0-9]//')" of="$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/multisystem.bs.save" bs=446 count=1
#reset mbr
#if [ "$(which tazpkg)" ]; then
#sudo dd if="/usr/share/boot/mbr.bin" of="$(cat /tmp/multisystem/multisystem-selection-usb | sed 's/[0-9]//')"
#else
#sudo dd if="/usr/lib/syslinux/mbr.bin" of="$(cat /tmp/multisystem/multisystem-selection-usb | sed 's/[0-9]//')"
#fi
fi

#Mettre flag boot sur on
sudo  parted -s "$(cat /tmp/multisystem/multisystem-selection-usb | sed 's/[0-9]//')" set 1 boot on

#Insérer UUID dans conf de Grub2
if [ "$(grep 'uuid-uuid-uuid' "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/grub/grub.cfg" 2>/dev/null)" ]; then
sed -i "s@uuid-uuid-uuid@$(cat /tmp/multisystem/multisystem-selection-uuid-usb)@" "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/grub/grub.cfg"
fi

#virer les lignes vides dans conf de Grub2
sed -i "/^$/d" "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/grub/grub.cfg"

#Option --force de Grub2 dispo après Jaunty!
if [ "$(grub-install -h 2>/dev/null | grep '\--force')" ]; then
options_grub2=" --force "
fi

#Mettre à jour grub4dos
if [ "$(diff "${dossier}"/boot/grub.exe "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/grub.exe" 2>/dev/null)" ]; then
cp -f "${dossier}"/boot/grub.exe "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/grub.exe"
fi

sync
#echo Attente
#read

#Installer Grub2
#Spécial install wubi Natty !
echo -e " \E[37;44m\033[1m Update Grub2 \033[0m"
if [[ "$(which grub-install.real)" && "$(grep 'loop=/ubuntu/disks/root.disk' <<<"$(cat /proc/cmdline)" 2>/dev/null)" ]]; then
sudo grub-install.real --root-directory="$(cat /tmp/multisystem/multisystem-mountpoint-usb)" \
--no-floppy ${options_grub2} --recheck "$(cat /tmp/multisystem/multisystem-selection-usb | sed 's/[0-9]//')"
else
sudo grub-install --root-directory="$(cat /tmp/multisystem/multisystem-mountpoint-usb)" \
--no-floppy ${options_grub2} --recheck "$(cat /tmp/multisystem/multisystem-selection-usb | sed 's/[0-9]//')"
fi
sync

#Installer Syslinux
if [ ! -f  "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/syslinux/ldlinux.sys" ]; then
echo -e " \E[37;44m\033[1m Update Syslinux \033[0m"
#Copier/maj des fichiers Syslinux
if [ "$(which tazpkg)" ]; then
sudo unlzma /usr/share/boot/chain.c32.lzma 2>/dev/null
sudo unlzma /usr/share/boot/vesamenu.c32.lzma 2>/dev/null
sudo unlzma /usr/share/boot/hdt.c32.lzma 2>/dev/null
sudo unlzma /usr/share/boot/ifplop.c32 2>/dev/null
cp -f /bin/syslinux $(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/syslinux/
cp -f /boot/isolinux/reboot.c32 $(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/syslinux/
cp -f /usr/share/boot/chain.c32 $(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/syslinux/
cp -f /usr/share/boot/vesamenu.c32 $(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/syslinux/
cp -f /usr/share/boot/hdt.c32 $(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/syslinux/
cp -f /usr/share/boot/ifplop.c32 $(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/syslinux/
else
cp -f /usr/lib/syslinux/menu.c32 $(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/syslinux/
cp -f /usr/lib/syslinux/chain.c32 $(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/syslinux/
cp -f /usr/lib/syslinux/hdt.c32 $(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/syslinux/ 2>/dev/null
cp -f /usr/lib/syslinux/memdisk $(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/syslinux/
cp -f /usr/lib/syslinux/reboot.c32 $(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/syslinux/
cp -f /usr/lib/syslinux/vesamenu.c32 $(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/syslinux/
cp -f /usr/lib/syslinux/ifplop.c32 $(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/syslinux/
fi
sleep 1

#Demonter
sudo umount $(cat /tmp/multisystem/multisystem-selection-usb)

#option -i pas disponible sous lucid ....
sudo syslinux -i -d /boot/syslinux $(cat /tmp/multisystem/multisystem-selection-usb)
sync

#Réparer
sudo dosfsck -a -w -v $(cat /tmp/multisystem/multisystem-selection-usb)
sync

calc_fatresize="$(sudo fatresize -i $(cat /tmp/multisystem/multisystem-selection-usb) | grep '^Max size' | awk '{print $3}')"
echo $((${calc_fatresize}/1000/1000-1))

#Diminuer un poil
sudo fatresize -p -s $((${calc_fatresize}/1000/1000-256))M $(cat /tmp/multisystem/multisystem-selection-usb)
sync

#Remettre à la dimmension
sudo fatresize -p -s $((${calc_fatresize}/1000/1000-1))M $(cat /tmp/multisystem/multisystem-selection-usb)
sync

#Réparer
sudo dosfsck -a -w -v $(cat /tmp/multisystem/multisystem-selection-usb)
sync

#Remonter
gvfs-mount -d $(cat /tmp/multisystem/multisystem-selection-usb) 2>/dev/null
sync

#Seule methode qui fonctionne pour booter Syslinux avec grub2 1.98, chainer sur le mbr ...
sudo dd if="$(cat /tmp/multisystem/multisystem-selection-usb)" of="$(cat /tmp/multisystem/multisystem-mountpoint-usb 2>/dev/null)/boot/img/syslinux.mbr" bs=512 count=1
sync
fi


#Vérifier si volume est ok ?
dosfsck -n $(cat /tmp/multisystem/multisystem-selection-usb)
if [ "$?" != "0" ]; then
#Réparer automatiquement
dosfsck -a -w -v $(cat /tmp/multisystem/multisystem-selection-usb)
#Réparer ?
#if [ "$?" != "0" ]; then
#zenity --error --text "ATTENTION ! le volume $(cat /tmp/multisystem/multisystem-selection-usb) nécéssite une réparation manuelle."
#fi
fi

exit 0
