#!/bin/bash
options="$*"

rm -R /tmp/multisystem/multisystem-modinitrd 2>/dev/null
mkdir /tmp/multisystem/multisystem-modinitrd 2>/dev/null
#Décompresser
gzip -d "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/bootdistro/${options}/initrd.gz"
#monter
sudo mount -o loop,rw "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/bootdistro/${options}/initrd" /tmp/multisystem/multisystem-modinitrd

#read -s -n1 -p "Appuyez sur une touche pour continuer..."; echo

#adaptation de mandriva 2010 pour support boot en liveusb
sed -i "s@nash-mount -o ro -t iso9660 LABEL=One-2010-GNOME /live/media@nash-mount -o rw -t vfat UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) /live/media@g" /tmp/multisystem/multisystem-modinitrd/linuxrc
sed -i "s@nash-mount -o ro -t iso9660 LABEL=One-2010-KDE4 /live/media@nash-mount -o rw -t vfat UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) /live/media@g" /tmp/multisystem/multisystem-modinitrd/linuxrc

#adaptation de mandriva 2010 pour support boot en liveusb
#Mandriva Linux One 2010 Spring
sed -i "s@nash-mount -o ro -t iso9660 LABEL=One-2010S-GNOME /live/media@nash-mount -o rw -t vfat UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) /live/media@g" /tmp/multisystem/multisystem-modinitrd/linuxrc
sed -i "s@nash-mount -o ro -t iso9660 LABEL=One-2010S-KDE4 /live/media@nash-mount -o rw -t vfat UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) /live/media@g" /tmp/multisystem/multisystem-modinitrd/linuxrc

#Mandriva Linux One 2010.2
sed -i "s@nash-mount -o ro -t iso9660 LABEL=One-2010.2-GNOME /live/media@nash-mount -o rw -t vfat UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) /live/media@g" /tmp/multisystem/multisystem-modinitrd/linuxrc
sed -i "s@nash-mount -o ro -t iso9660 LABEL=One-2010.2-KDE4 /live/media@nash-mount -o rw -t vfat UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb) /live/media@g" /tmp/multisystem/multisystem-modinitrd/linuxrc

#modifier dossier du squashfs
sed -i "s@/live/media/loopbacks/@/live/media/${options}/@" /tmp/multisystem/multisystem-modinitrd/linuxrc

#sudo gedit /tmp/multisystem/multisystem-modinitrd/linuxrc
#read -s -n1 -p "Appuyez sur une touche pour continuer..."; echo

#Démonter
sudo umount /tmp/multisystem/multisystem-modinitrd
#Recompresser
gzip "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/bootdistro/${options}/initrd"
rm -R /tmp/multisystem/multisystem-modinitrd
exit 0
