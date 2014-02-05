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

#recup option
option1="$1"
option2="$2"

#verifier Install VirtualBox
if [ ! "$(which VBoxManage)" ]; then
exit 0
fi

#noms
name_vbox="multisystem"
mkdir "$HOME/.VirtualBox/" 2>/dev/null
chemin_vmdk="$HOME/.VirtualBox/${name_vbox}.vmdk"

#ram dispo?
if [ "$(free | grep "^-/+")" ]; then
RAM_LIBRE="$(($(free | grep -e "-/+" | awk '{print $4}') / 1000))"
elif [ "$(free | grep "^Total:")" ]; then
RAM_LIBRE="$(($(free | grep -e "^Total:" | awk '{print $4}') / 1000))"
fi

if [ "$RAM_LIBRE" -gt "1024" ]; then
memory="896"
vram="128"
elif [ "$RAM_LIBRE" -gt "896" ]; then
memory="768"
vram="128"
elif [ "$RAM_LIBRE" -gt "768" ]; then
memory="640"
vram="128"
elif [ "$RAM_LIBRE" -gt "640" ]; then
memory="512"
vram="128"
elif [ "$RAM_LIBRE" -gt "512" ]; then
memory="384"
vram="128"
elif [ "$RAM_LIBRE" -lt "384" ]; then
echo -e "\033[1;47;31m $(eval_gettext "Erreur: pas assez de ram libre disponible:") $RAM_LIBRE < 384 Mio \033[0m"
echo -e "\033[1;47;31m mount -t tmpfs -o size=528m none /dev/shm \033[0m"
#mount -t tmpfs -o size=528m none /dev/shm
echo -e "\033[1;47;31m $(eval_gettext "Appuyez sur enter pour continuer") \033[0m"
read
exit 0
fi
echo -e "\033[1;33;44m memory:$memory vram:$vram \033[00m"

#Arrêter VBox
VBoxManage controlvm "${name_vbox}" poweroff &>/dev/null

#Détacher disque associé vmdk
VBoxManage modifyvm "${name_vbox}" --hda none
VBoxManage closemedium disk "${chemin_vmdk}"

#Supprimer disque associé vmdk
rm -vf "${chemin_vmdk}"

#supprimer vm
VBoxManage unregistervm "${name_vbox}" --delete
#zenity --info --text "Attente"

#Créer vmdk
VBoxManage internalcommands createrawvmdk -filename "${chemin_vmdk}" \
-rawdisk $(cat /tmp/multisystem/multisystem-selection-usb | sed 's/[0-9]//') \
-relative
#suppression de l'option -register car n'exiqte plus dans v4.0

#creer vm
VBoxManage createvm --name "${name_vbox}" --register
VBoxManage modifyvm "${name_vbox}" --memory ${memory} --vram ${vram}
VBoxManage modifyvm "${name_vbox}" --acpi on --nic1 nat --ioapic on
#option specifique >= 3.1
if [ "$(echo $(VBoxManage -v) | grep -vE "(^2.0)|(^3.0)")" ]; then
VBoxManage storagectl "${name_vbox}" --name "IDE Controller" --add ide
#VBoxManage storagectl "${name_vbox}" --name "${name_vbox}" --add SATA --controller IntelAhci
#[--add <ide/sata/scsi/floppy>]
#[--controller <LsiLogic/BusLogic/IntelAhci/PIIX3/PIIX4/ICH6/I82078>]
#[--sataideemulation<1-4> <1-30>]
#[--sataportcount <1-30>]
#[--remove]
fi
VBoxManage modifyvm "${name_vbox}" --hda "${chemin_vmdk}"

#VBoxGuestAdditions
if [ -f  "/usr/share/virtualbox/VBoxGuestAdditions.iso" ]; then
VBoxManage storageattach "${name_vbox}" --storagectl "IDE Controller" \
--port 0 --device 1 --type dvddrive --medium "/usr/share/virtualbox/VBoxGuestAdditions.iso"
vboxmanage guestcontrol "${name_vbox}" updateadditions \
--source "/usr/share/virtualbox/VBoxGuestAdditions.iso" --verbose
else
VBoxManage storageattach "${name_vbox}" --storagectl "IDE Controller" \
--port 0 --device 1 --type dvddrive --medium emptydrive
fi

#Dossier partagé
#supprimer ==> vboxmanage sharedfolder remove "${name_vbox}" --name install
vboxmanage sharedfolder add "${name_vbox}" --name install --hostpath "$HOME/Public" --automount
##Dans client pour monter exemple ==> mount -t vboxsf install /mnt/install

VBoxManage modifyvm "${name_vbox}" --ostype "Linux26"
VBoxManage modifyvm "${name_vbox}" --audio alsa --audiocontroller ac97
VBoxManage modifyvm "${name_vbox}" --accelerate3d on
VBoxManage modifyvm "${name_vbox}" --pae on
VBoxManage modifyvm "${name_vbox}" --usb on --usbehci on

#Demarrer VBox [--type gui|sdl|vrdp|headless]
sleep 1
VBoxManage startvm "${name_vbox}" --type gui&

#VBoxManage controlvm "${name_vbox}" resume
#pause|resume|reset|poweroff|savestate|
echo -e "\033[1;47;31m $(eval_gettext "Appuyez sur enter pour continuer") \033[0m"
read
exit 0
