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

#recup option cdrom
option="$1"

echo -e '\E[37;44m'"\033[1m $(eval_gettext "Qemu nécéssite les droits d\047administrateur") \033[0m"
#
/etc/init.d/kqemu-source force-reload 2>/dev/null

#radiobuttonMultiSystem='Lancer Qemu'
echo -e '\E[37;44m'"\033[1m $(eval_gettext "Démarrer Qemu CLE_USB:")$(cat /tmp/multisystem/multisystem-selection-usb) \033[0m"

if [ $(which apt-get) ]; then
echo
if [ ! $(which kvm) ]; then
echo "$(eval_gettext "installation de qemu")"
apt-get install -y qemu qemu-kvm kvm-pxe
fi
fi

#ram dispo?
if [ "$(free | grep "^-/+")" ]; then
RAM_LIBRE="$(($(free | grep -e "-/+" | awk '{print $4}') / 1000))"
elif [ "$(free | grep "^Total:")" ]; then
RAM_LIBRE="$(($(free | grep -e "^Total:" | awk '{print $4}') / 1000))"
fi
if [ "$RAM_LIBRE" -gt "512" ]; then
RAM_LIBRE=512
elif [ "$RAM_LIBRE" -gt "256" ]; then
echo -e '\E[37;44m'"\033[1m $(eval_gettext "Espace ram disponible: ")$RAM_LIBRE Mio \033[0m"
RAM_LIBRE=256
elif [ "$RAM_LIBRE" -lt "256" ]; then
echo -e "\033[1;47;31m $(eval_gettext "Erreur: pas assez de ram libre disponible:\$RAM_LIBRE souhaité:256 Mio") \033[0m"
echo -e "\033[1;47;31m mount -t tmpfs -o size=528m none /dev/shm \033[0m"
#mount -t tmpfs -o size=528m none /dev/shm
read
exit 0
fi
echo "$(eval_gettext "Démarrer qemu pour vérification de boot")"

# Clear filesystem memory cache
# sync
# echo 3 > /proc/sys/vm/drop_caches

#QEMU_AUDIO_DRV=sdl
QEMU_AUDIO_DRV=alsa
if [ ! "${option}" ]; then
echo N/A
elif [ "${option}" == "usb" ]; then
sudo kvm -no-acpi -boot c -usb -usbdevice "disk:$(cat /tmp/multisystem/multisystem-selection-usb | sed 's/[0-9]//')" -hda "$(cat /tmp/multisystem/multisystem-selection-usb | sed 's/[0-9]//')" -m $RAM_LIBRE
elif [ "${option}" == "cdrom" ]; then
sudo kvm -no-acpi -boot d -cdrom "$HOME/MultiSystem-LiveCD.iso" -m $RAM_LIBRE
elif [ "${option}" == "cdamorce" ]; then
sudo kvm -no-acpi -usb -boot d -cdrom "$HOME/cd-boot-liveusb.iso" -hda "$(cat /tmp/multisystem/multisystem-selection-usb | sed 's/[0-9]//')" -usbdevice "disk:$(cat /tmp/multisystem/multisystem-selection-usb | sed 's/[0-9]//')" -m $RAM_LIBRE
fi
exit 0
#ls /lib/modules/$(uname -r)/kernel/arch/*/kvm/
#sudo modprobe kvm
#dmesg | grep kvm
#lsmod | grep kvm
#-no-kvm
#kvm-ok #commande pour tester si proc compatible avec kvm
