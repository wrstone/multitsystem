#!/bin/bash
options="$*"

#Décompresser
rm -R /tmp/multisystem/multisystem-modinitrd 2>/dev/null
mkdir /tmp/multisystem/multisystem-modinitrd 2>/dev/null
cd /tmp/multisystem/multisystem-modinitrd
gzip -dc "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/bootdistro/${options}/initrd.gz" | cpio -i

rm "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/bootdistro/${options}/initrd.gz"


#read -s -n1 -p "Appuyez sur une touche pour continuer..."; echo

#Mageia version liveCD
sed -i "s@mount -n -t iso9660 -o ro \$realdev /live/media@modprobe vfat\nmount -n -t vfat -o ro /dev/disk/by-uuid/$(cat /tmp/multisystem/multisystem-selection-uuid-usb) /live/media@g" /tmp/multisystem/multisystem-modinitrd/sbin/mgalive-root

#modifier dossier du squashfs
sed -i "s@/live/media/loopbacks/@/live/media/${options}/@" /tmp/multisystem/multisystem-modinitrd/sbin/mgalive-root

#sudo gedit /tmp/multisystem/multisystem-modinitrd/sbin/mgalive-root
#read -s -n1 -p "Appuyez sur une touche pour continuer..."; echo

#Recompresser
find . | cpio -o -H newc | gzip -9 >  "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/bootdistro/${options}/initrd.gz"
cd -
rm -R /tmp/multisystem/multisystem-modinitrd
exit 0
