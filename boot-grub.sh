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

if [ ! -f "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/img/plpbt" ]; then
zenity --error --text "$(eval_gettext "Erreur: Veuillez installer PloP")"
exit 0
fi

echo -e "\E[37;44m\033[1m $(eval_gettext 'Patience Mise à jour de grub') \033[0m"

#Ajout si Grub ou Grub2 present
if [[ -f "/boot/grub/menu.lst" || -f "/boot/grub/grub.cfg" ]]; then
echo
if [[ "$(grep '### MULTISYSTEM MENU' /boot/grub/menu.lst 2>/dev/null)" || "$(grep '### MULTISYSTEM MENU' /boot/grub/grub.cfg 2>/dev/null)" ]]; then
#Sauvegarder
cp /boot/grub/menu.lst /boot/grub/menu.lst.sauvegarde.multisystem 2>/dev/null
cp /boot/grub/grub.cfg /boot/grub/grub.cfg.sauvegarde.multisystem 2>/dev/null
#Supprimer entree Grub
FICHIER="$(echo -e "$(cat /boot/grub/menu.lst 2>/dev/null)" | sed '/MULTISYSTEM MENU/,/FIN MULTISYSTEM MENU/d')"
[ -f "/boot/grub/menu.lst" ] && echo -e "$FICHIER" | tee /boot/grub/menu.lst
#Supprimer entree Grub2
[ -f "/boot/grub/grub.cfg" ] && rm /etc/grub.d/40_multisystem
update-grub
else
#Ajouter
#Sauvegarder
sudo cp /boot/grub/menu.lst /boot/grub/menu.lst.sauvegarde.multisystem 2>/dev/null
sudo cp /boot/grub/grub.cfg /boot/grub/grub.cfg.sauvegarde.multisystem 2>/dev/null
#Copier fichiers
cp -f "${HOME}"/.multisystem/nonfree/plpbt.bin /boot/plpbt
cp -f "${dossier}"/boot/img/sbootmgr.dsk /boot/sbootmgr.dsk
cp -f "${dossier}"/boot/syslinux/memdisk /boot/memdisk

#Grub
AJOUTER='### MULTISYSTEM MENU
title PLoP Boot Manager
kernel /boot/plpbt

title Smart Boot Manager
kernel /boot/memdisk
initrd /boot/sbootmgr.dsk

### FIN MULTISYSTEM MENU'
[ -f "/boot/grub/menu.lst" ] && echo -e "$AJOUTER" | tee -a /boot/grub/menu.lst

#GRub2
AJOUTER2='#! /bin/sh
exec tail -n +3 $0
# Ajout de MultiSystem

### MULTISYSTEM MENU
menuentry "PLoP Boot Manager" {
	linux16 /boot/plpbt
}

menuentry "Smart Boot Manager" {
search --set -f /boot/sbootmgr.dsk
	linux16 /boot/memdisk
	initrd16 /boot/sbootmgr.dsk
}
### FIN MULTISYSTEM MENU'
[ -f "/boot/grub/grub.cfg" ] && echo -e "$AJOUTER2" | tee /etc/grub.d/40_multisystem
[ -f "/etc/grub.d/40_multisystem" ] && chmod +x /etc/grub.d/40_multisystem

#Corriger pour grub2 v1.96
if [ "$(grub-install -v | grep 1.96)" ]; then
sed -i "s/linux16/linux/g" "/etc/grub.d/40_multisystem"
sed -i "s/initrd16/initrd/g" "/etc/grub.d/40_multisystem"
fi

update-grub
fi
fi

exit 0
