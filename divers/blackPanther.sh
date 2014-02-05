#!/bin/bash
options="$*"

rm -R /tmp/multisystem/multisystem-modinitrd 2>/dev/null
mkdir /tmp/multisystem/multisystem-modinitrd 2>/dev/null
#Décompresser
gzip -d "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/bootdistro/${options}/initrd.gz"
#monter
sudo mount -o loop,rw "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/bootdistro/${options}/initrd" /tmp/multisystem/multisystem-modinitrd

#read -s -n1 -p "Appuyez sur une touche pour continuer..."; echo

#Mageia version liveCD
sed -i "s@nash-mount -o ro -t iso9660 LABEL=blackPantherOS /live/media@nash-mount -o rw -t vfat UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) /live/media@g" /tmp/multisystem/multisystem-modinitrd/linuxrc

#Remplacer le label à rechercher
sed -i "s@LABEL=blackPanther@LABEL=$(cat /tmp/multisystem/multisystem-selection-label-usb)@g" /tmp/multisystem/multisystem-modinitrd/linuxrc

#modifier dossier du squashfs
sed -i "s@/live/media/@/live/media/${options}/@" /tmp/multisystem/multisystem-modinitrd/linuxrc

#ajouter module nls_cp437
sed -i "s@probe-modules --cdrom@probe-modules --cdrom\nprobe-modules nls_cp437@" /tmp/multisystem/multisystem-modinitrd/linuxrc

#sudo gedit /tmp/multisystem/multisystem-modinitrd/linuxrc
#read -s -n1 -p "Appuyez sur une touche pour continuer..."; echo

#Démonter
sudo umount /tmp/multisystem/multisystem-modinitrd
#Recompresser
gzip "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/bootdistro/${options}/initrd"

rm -R /tmp/multisystem/multisystem-modinitrd
exit 0
