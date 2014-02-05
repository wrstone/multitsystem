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
echo 'cddev="$(/usr/sbin/hwinfo --disk | grep sd | grep "Device File:" | cut -f2 -d: | cut -f2 -d " " | sed "s/\\(\\/dev\\/sd[a-z]\\)/\\11:/g")"\ncddev="$(echo $cddev | sed "s/\\s//g")"'
}
sed -i "s@		CDDevice@$(FCT_REMPLACER)@" /tmp/multisystem/multisystem-modinitrd/include

#sudo gedit /tmp/multisystem/multisystem-modinitrd/include
#echo attente
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
