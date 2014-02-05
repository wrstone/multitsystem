#!/bin/bash
options="$*"

rm -R /tmp/multisystem/multisystem-modinitrd 2>/dev/null
mkdir /tmp/multisystem/multisystem-modinitrd 2>/dev/null
cd /tmp/multisystem/multisystem-modinitrd
gzip -dc "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${options}/initrd1.img" | cpio -i

#correction bug debian-live 502
sed -i 's@grep "^${device} " /proc/mounts@grep -m1 "^${device} " /proc/mounts@g' /tmp/multisystem/multisystem-modinitrd/scripts/live-helpers

#gedit /tmp/multisystem/multisystem-modinitrd/scripts/live-helpers
#read -s -n1 -p "Appuyez sur une touche pour continuer..."; echo

find . | sudo cpio -o -H newc | gzip -9 | tee "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/${options}/initrd1.img"
cd -
rm -R /tmp/multisystem/multisystem-modinitrd
exit 0










