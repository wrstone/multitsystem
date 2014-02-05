#!/bin/bash
rm -R /tmp/multisystem/multisystem-modinitrd 2>/dev/null
mkdir /tmp/multisystem/multisystem-modinitrd 2>/dev/null
cd /tmp/multisystem/multisystem-modinitrd
gzip -dc "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/casper/initrd.gz" | cpio -i
rm /tmp/multisystem/multisystem-modinitrd/conf/uuid.conf
#read -s -n1 -p "Appuyez sur une touche pour continuer..."; echo
find . | sudo cpio -o -H newc | gzip -9 | tee "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/casper/initrd.gz"
cd -
rm -R /tmp/multisystem/multisystem-modinitrd
exit 0










