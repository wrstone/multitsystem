#!/bin/bash
chemin="$(cd "$(dirname "$0")";pwd)/$(basename "$0")";
dossier="$(dirname "$chemin")"
export chemin dossier
cd "${dossier}"

option="$*"

###Pour exporter la librairie de gettext.
set -a
source gettext.sh
set +a
export TEXTDOMAIN=multisystem
export TEXTDOMAINDIR=${dossier}/locale
. gettext.sh
multisystem=$0

rm -R /tmp/multisystem/multisystem-modinitrd 2>/dev/null
mkdir /tmp/multisystem/multisystem-modinitrd 2>/dev/null
cd /tmp/multisystem/multisystem-modinitrd

#Detection 32 ou 64bits.
if [ -f "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${option}/boot/i386/loader/initrd" ]; then
gzip -dc "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${option}/boot/i386/loader/initrd" | cpio -i
else
gzip -dc "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${option}/boot/x86_64/loader/initrd" | cpio -i
fi

function FCT_REMPLACER()
{
echo '\t\tcddev="$(/usr/sbin/hwinfo --disk | grep sd | grep "Device File:" | cut -f2 -d: | cut -f2 -d " " | sed "s/\\(\\/dev\\/sd[a-z]\\)/\\11:/g")"\n\t\tcddev="$(echo $cddev | sed "s/\\s//g")"'
}
#sudo sed -i "s@\t\tCDDevice@$(FCT_REMPLACER)@" /tmp/multisystem/multisystem-modinitrd/include
#plus que 1 tab ...
#sudo sed -i "s@\tCDDevice@$(FCT_REMPLACER)@" /tmp/multisystem/multisystem-modinitrd/include

#Version openSUSE-12.1
#sudo sed -i "s@\tsearchImageCDMedia@\tcddev=\"/dev/disk/by-uuid/$(cat /tmp/multisystem/multisystem-selection-uuid-usb)\"\n\tcdopt=\"-t vfat\"@" /tmp/multisystem/multisystem-modinitrd/include
sudo sed -i "s@\tsearchImageHybridMedia@\tcddev=\"/dev/disk/by-uuid/$(cat /tmp/multisystem/multisystem-selection-uuid-usb)\"\n\tcdopt=\"-t vfat\"@" /tmp/multisystem/multisystem-modinitrd/include


#Nouveau ramdisk ! openSUSE 12.2
sudo sed -i "s@searchImageISODevice@[ ! -d \"/cdrom\" ]@" /tmp/multisystem/multisystem-modinitrd/init
sudo sed -i "s@\tkiwiMount \"\$biosBootDevice\" \"/cdrom\" \"-o ro\" 1>\&2@\tmkdir -p /cdrom\n\tbiosBootDevice=\"/dev/disk/by-uuid/$(cat /tmp/multisystem/multisystem-selection-uuid-usb)\"\n\tkiwiMount \"\$biosBootDevice\" \"/cdrom\" \"-o ro\" 1>\&2\n\tsleep 2\n\tkiwiMount \"\$biosBootDevice\" \"/cdrom\" \"-o ro\" 1>\&2\n\techo \"Debug MS: \$(mount | grep cdrom)\"@" /tmp/multisystem/multisystem-modinitrd/init


#Eventuellement modifier .profile du ramdisk pour changer langue, a essayer ...
#kiwi_language='en_US' kiwi_language='fr_FR'
#sudo sed -i "s@kiwi_language='en_US'@kiwi_language='fr_FR'@" /tmp/multisystem/multisystem-modinitrd/.profile

#sudo gedit /tmp/multisystem/multisystem-modinitrd/include
#sudo gedit /tmp/multisystem/multisystem-modinitrd/init
#echo Attente
#read

#Detection 32 ou 64bits.
if [ -f "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${option}/boot/i386/loader/initrd" ]; then
find . | sudo cpio -o -H newc | gzip -9 | tee "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${option}/boot/i386/loader/initrd"
else
find . | sudo cpio -o -H newc | gzip -9 | tee "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${option}/boot/x86_64/loader/initrd"
fi

cd -
rm -R /tmp/multisystem/multisystem-modinitrd
exit 0
