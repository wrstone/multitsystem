#Créer dossier pref
if [ ! -d "$HOME/.multisystem/" ]; then
mkdir "$HOME/.multisystem/" 2>/dev/null
fi
#Créer dossier pour check update
[ ! "$(cat "$HOME/.multisystem/checkupdate" 2>/dev/null)" ] && echo true >"$HOME/.multisystem/checkupdate"
varupdate="$(cat "$HOME/.multisystem/checkupdate")"

#/sys/block/${dev}/removable
#/sys/block/${dev}/uevent
#/sys/block/${dev}/size
#/sys/block/${dev}/ro

rm -R /tmp/multisystem 2>/dev/null
mkdir /tmp/multisystem
if [ "$(ls -A /tmp/multisystem/multisystem-* 2>/dev/null)" ]; then
zenity --error --text "$(eval_gettext "Erreur: impossible de supprimer:") $(ls -A /tmp/multisystem/multisystem-* 2>/dev/null)"
nohup "$dossier"/kill.sh&
exit 0
fi

#Special boot toram ! on démonte /isodevice
#if [[ "$(grep 'toram' /proc/cmdline 2>/dev/null)" && "$(grep 'boot=casper' /proc/cmdline 2>/dev/null)" ]]; then
if [ "$(grep 'boot=casper' /proc/cmdline 2>/dev/null)" ]; then
sudo umount -l -r -f /isodevice
diskuuid="$(cat /proc/cmdline | awk -F"root=UUID=" '{print $2}' | awk '{print $1}')"
gvfs-mount -d "$(blkid | grep "${diskuuid}" | awk -F: '{print $1}')"
sleep 2
fi

function FCT_DETECT()
{
#detection clé usb
>/tmp/multisystem/multisystem-debog-detect-list
>/tmp/multisystem/multisystem-detection-usb
>/tmp/multisystem/multisystem-statusbar

#Détection
while read line
do
unset DISK_MOUNTPOINT
unset DISK_MOUNT
unset ID_FS_LABEL
unset ID_FS_LABEL_ENC
unset ID_FS_UUID
unset ID_FS_TYPE
unset ID_FS_VERSION
unset ID_TYPE
unset ID_BUS
unset ID_USB_DRIVER
unset ID_PART_TABLE_TYPE
unset DEVNAME
unset ID_SERIAL
unset ID_SERIAL_SHORT
unset UDISKS_PARTITION_NUMBER
unset DISK_MOUNT
unset UDISKS_PARTITION_SIZE
unset ID_VENDOR
unset ID_MODEL
#certaines clé USB ne se montrent pas en UDISKS_ mais en DKD_
unset DKD_PARTITION_NUMBER
unset DKD_PARTITION_SIZE

DISK_MOUNT="$(echo ${line} | awk '{print $1}')"
#Check que est bien monté dans /media
DISK_MOUNTPOINT="$(echo "${line}" | awk '{print $3}' | grep ^/media)"
DISK_MOUNT="$(echo "${line}" | awk '{print $1}' | grep ^/dev/)"
if [ "${DISK_MOUNT}" ]; then
eval $(udevadm info -q all -n ${DISK_MOUNT} 2>/dev/null | grep = | grep -v ':.*:' | awk -F: '{print $2}')
#████████████████████████████████████████████████████████████████████████████████████████████████████████████
#████ATTENTION!████ corrige un bug udevadm, selon les versions DEVNAME retourne sdx1 et sur d'autres /dev/sdx1
#Merci akaoni :)
DEVNAME=$(basename ${DEVNAME})

#ATTENTION certaines clé USB ne se montrent pas en UDISKS_ mais en DKD_
if [ "${DKD_PARTITION_NUMBER}" ]; then
UDISKS_PARTITION_NUMBER="${DKD_PARTITION_NUMBER}"
fi
if [ "${DKD_PARTITION_SIZE}" ]; then
UDISKS_PARTITION_SIZE="${DKD_PARTITION_SIZE}"
fi

#████████████████████████████████████████████████████████████████████████████████████████████████████████████
#Debug
echo -e "line:${line}
DISK_MOUNT:${DISK_MOUNT}
DISK_MOUNTPOINT:${DISK_MOUNTPOINT}
ID_FS_LABEL:${ID_FS_LABEL}
ID_FS_LABEL_ENC:${ID_FS_LABEL_ENC}
ID_FS_UUID:${ID_FS_UUID}
ID_FS_TYPE:${ID_FS_TYPE}
ID_FS_VERSION:${ID_FS_VERSION}
ID_TYPE:${ID_TYPE}
ID_BUS:${ID_BUS}
ID_USB_DRIVER:${ID_USB_DRIVER}
ID_PART_TABLE_TYPE:${ID_PART_TABLE_TYPE}
DEVNAME:${DEVNAME}
ID_SERIAL:${ID_SERIAL}
ID_SERIAL_SHORT:${ID_SERIAL_SHORT}
UDISKS_PARTITION_NUMBER:${UDISKS_PARTITION_NUMBER}
DISK_MOUNT:${DISK_MOUNT}
UDISKS_PARTITION_SIZE:${UDISKS_PARTITION_SIZE}
ID_VENDOR:${ID_VENDOR}
ID_MODEL:${ID_MODEL} \n" >>/tmp/multisystem/multisystem-debog-detect-list
#Limiter aux disques montés dans /media
if [ "$(grep '/media/' <<<"${DISK_MOUNTPOINT}")" ]; then
echo
#Verif que device dans mount et udevadm sont identique
if [ "${DISK_MOUNT}" = "/dev/${DEVNAME}" ]; then
echo
#Verif type (disk)|(sd_mmc)|(floppy)
if [ "$(echo "${ID_TYPE}" | grep -E "(disk)|(sd_mmc)|(floppy)")" ]; then
echo
#Verif bus (usb)|(mmc)
if [ "$(echo "${ID_BUS}" | grep -E "(usb)|(mmc)|(ata)")" ]; then
echo
#Verif FAT32
if [ "${ID_FS_VERSION}" = "FAT32" ]; then
echo
#Verif que est bien la première partition
if [ "${UDISKS_PARTITION_NUMBER}" = "1" ]; then
echo
#Verif que releve bien UUID
if [ "${ID_FS_UUID}" ]; then
#DEVICE|VENDOR|MODEL|DISK_SIZE|DISK_AVAILABLE|DISK_USE|TYPE|DRIVER|MOUNTPOINT|UUID
echo "${DISK_MOUNT}|${ID_VENDOR}|${ID_MODEL}|$(($(/bin/df | grep -w ^${DISK_MOUNT} | awk '{print $2}')/1024)) Mio|$(($(/bin/df | grep -w ^${DISK_MOUNT} | awk '{print $3}')/1024)) Mio|$(($(/bin/df | grep -w ^${DISK_MOUNT} | awk '{print $4}')/1024)) Mio|${ID_TYPE}|${ID_BUS}|${DISK_MOUNTPOINT}|${ID_FS_UUID}" >>/tmp/multisystem/multisystem-detection-usb
fi
fi
fi
fi
fi
fi
fi
fi
done <<<"$(mount | grep vfat)"
}
export -f FCT_DETECT
FCT_DETECT

#Lister les lang
function FCT_lister_lang()
{
cat "$HOME/.multisystem/lang_sel.txt" | awk -F'|' '{print $1}'
cat "${dossier}/lang_list.txt" | sed "/^$/d" | awk -F'|' '{print $1}'
}
export -f FCT_lister_lang

#Icon thème
cp -f "./pixmaps/multisystem-$(cat "${HOME}"/.multisystem-theme).png" /tmp/multisystem/multisystem-theme.png

#Message statusbar
function FCT_statusbar()
{
echo device:${device}
if [ ! "$(cat /tmp/multisystem/multisystem-detection-usb 2>/dev/null)" ]; then
echo -e "$(eval_gettext "Avez-vous branché votre clé USB ?\n\nVeuillez connecter un volume usb\nformaté en fat32\net le monter dans /media\n\nPuis relancez MultiSystem.")" >/tmp/multisystem/multisystem-statusbar

elif [ "${device}" ]; then
echo "Device:${device}" >/tmp/multisystem/multisystem-statusbar

else
rm /tmp/multisystem/multisystem-statusbar
fi
}
export -f FCT_statusbar
FCT_statusbar

#liste des volumes usb trouvés
#cat /tmp/multisystem/multisystem-detection-usb
export GUIENTER='
<window width_request="400" height_request="420" window_position="1" title="MultiSystem" icon-name="multisystem-icon" decorated="true" resizable="false">
<vbox>

<hbox homogeneous="true">

<hbox spacing="0">
<checkbox active="'${varupdate}'" use-underline="true" tooltip-text="'$(eval_gettext 'Vérifier les mise à jour à chaque lancement')'">
<label>_</label>
<variable>checkupdate2</variable>
<action>if true echo true >"'$HOME'/.multisystem/checkupdate"</action>
<action>if false echo false >"'$HOME'/.multisystem/checkupdate"</action>
</checkbox>

<button>
<input file stock="gtk-connect"></input>
<label>"'$(eval_gettext 'Mise à jour')'"</label>
<variable>btmaj2</variable>
<action>./update-sel.sh &</action>
<action>echo cancel >/tmp/multisystem/multisystem-selection-usb</action>
<action type="exit">exit</action>
</button>
</hbox>

<button>
<input file stock="gtk-delete"></input>
<label>"'$(eval_gettext 'Désinstaller')'"</label>
<variable>btuninstall2</variable>
<action>nohup xterm -title 'Remove' -e "sudo ./uninstall.sh"&</action>
<action type="exit">exit</action>
</button>
</hbox>

<hbox spacing="0">
<pixmap>
<input file icon="config-language"></input>
<height>32</height>
<width>32</width>
</pixmap>
<text width_request="5" use-underline="true"><label>_</label></text>
<comboboxtext allow-empty="false" value-in-list="true" tooltip-text="'$(eval_gettext 'Changer de language')'">
<variable>lister_lang</variable>
<input>bash -c "FCT_lister_lang"</input>
<action signal="changed">echo "$(grep "^$lister_lang" "'${dossier}'/lang_list.txt")" >"$HOME/.multisystem/lang_sel.txt"</action>
<action signal="changed">echo changelang >/tmp/multisystem/multisystem-selection-usb</action>
<action signal="changed">exit:changelang</action>
</comboboxtext>
</hbox>

<hbox spacing="0">
<button relief="2" tooltip-text="'$(eval_gettext "Thème Rouge")'">
<width>24</width>
<input file icon="multisystem-red"></input>
<action>echo red > "${HOME}"/.multisystem-theme</action>
<action>cp -f ./pixmaps/multisystem-red.png /tmp/multisystem/multisystem-theme.png</action>
<action>refresh:theme_pixmap</action>
</button>
<button relief="2" tooltip-text="'$(eval_gettext "Thème Vert")'">
<width>24</width>
<input file icon="multisystem-green"></input>
<action>echo green > "${HOME}"/.multisystem-theme</action>
<action>cp -f ./pixmaps/multisystem-green.png /tmp/multisystem/multisystem-theme.png</action>
<action>refresh:theme_pixmap</action>
</button>
<button relief="2" tooltip-text="'$(eval_gettext "Thème Bleu")'">
<width>24</width>
<input file icon="multisystem-blue"></input>
<action>echo blue > "${HOME}"/.multisystem-theme</action>
<action>cp -f ./pixmaps/multisystem-blue.png /tmp/multisystem/multisystem-theme.png</action>
<action>refresh:theme_pixmap</action>
</button>
<text>
<label>'$(eval_gettext "  Thème actuel:")' </label>
</text>
<pixmap>
<variable>theme_pixmap</variable>
<width>24</width>
<input file>/tmp/multisystem/multisystem-theme.png</input>
</pixmap>
</hbox>

<frame '$(eval_gettext 'Informations')'>
<vbox scrollable="true">
<text sensitive="false">
<variable>statusbar</variable>
<input file>/tmp/multisystem/multisystem-statusbar</input>
</text>
<text use-markup="true" sensitive="false">
<variable>MESSAGES</variable>
<input>echo "'$(eval_gettext "\<b>\<big>Veuillez sélectionner le volume USB\nà utiliser dans la liste ci-dessous.\n\<span color='red'>ATTENTION!,\nGrub2 sera installé dans son mbr.\</span>\</big>\</b>")'" | sed "s%\\\%%g"</input>
</text>
</vbox>
</frame>

<hbox scrollable="true">

<button tooltip-text="Refresh device">
<input file stock="gtk-refresh"></input>
<action>refresh:device</action>
<action>bash -c "FCT_DETECT"</action>
<action>bash -c "FCT_statusbar"</action>
<action>refresh:device</action>
<action>refresh:statusbar</action>
</button>

<tree block-function-signalst="false" rules_hint="true" headers_visible="true" hover_expand="true" hover_selection="false" exported_column="0">
<label>"'$(eval_gettext 'Device|Marque|Modèle|Taille|Occupé|Libre|bus|driver|mountpoint')'"</label>
<variable>device</variable>
<input>cat /tmp/multisystem/multisystem-detection-usb</input>
<action>echo $device >/tmp/multisystem/multisystem-selection-usb</action>
<action type="exit">detection</action>
<action signal="button-release-event">bash -c "FCT_statusbar"</action>
<action signal="button-release-event">refresh:statusbar</action>
</tree>
</hbox>

<hbox>

<button>
<input file stock="gtk-cancel"></input>
<label>"'$(eval_gettext 'Annuler')'"</label>
<action>echo cancel >/tmp/multisystem/multisystem-selection-usb</action>
<action>EXIT:quit</action>
</button>

<button>
<input file stock="gtk-ok"></input>
<label>"'$(eval_gettext 'Valider')'"</label>
<action>echo "$device" >/tmp/multisystem/multisystem-selection-usb</action>
<action type="exit">detection</action>
</button>
</hbox>

</vbox>
<action signal="delete-event">echo cancel >/tmp/multisystem/multisystem-selection-usb</action>
</window>
'
#kill $(ps aux | grep MOD_WAIT | grep -v grep | awk '{print $2}' | xargs) 2>/dev/null
wmctrl -c MultiSystem-logo
gtkdialog --program=GUIENTER 2>/dev/null
if [ "$(cat /tmp/multisystem/multisystem-selection-usb 2>/dev/null)" = "cancel" ]; then
exit 0

elif [ "$(cat /tmp/multisystem/multisystem-selection-usb 2>/dev/null)" = "changelang" ]; then
"${dossier}/gui_multisystem.sh" &
exit 0

#Pas de sélection
elif [ ! "$(cat /tmp/multisystem/multisystem-selection-usb 2>/dev/null)" ]; then
zenity --info --text "$(eval_gettext "Erreur: pas de sélection.")"
"${dossier}/gui_multisystem.sh" &
exit 0
fi

#Verif de la sélection
#DEVICE|VENDOR|MODEL|DISK_SIZE|DISK_AVAILABLE|DISK_USE|TYPE|DRIVER|MOUNTPOINT|UUID
SEL_LINE="$(grep "^$(cat /tmp/multisystem/multisystem-selection-usb 2>/dev/null)\|" /tmp/multisystem/multisystem-detection-usb 2>/dev/null)"
if [ "${SEL_LINE}" ]; then
unset ID_FS_UUID
unset ID_FS_LABEL
unset ID_SERIAL_SHORT
unset ID_FS_LABEL_ENC
#unset ID_PART_TABLE_TYPE
#unset UDISKS_PARTITION_NUMBER

eval $(udevadm info -q all -n $(cat /tmp/multisystem/multisystem-selection-usb 2>/dev/null) 2>/dev/null | grep = | grep -v ':.*:' | awk -F: '{print $2}')
DISK_MOUNTPOINT="$(grep "$(cat /tmp/multisystem/multisystem-selection-usb 2>/dev/null)" /tmp/multisystem/multisystem-detection-usb 2>/dev/null | awk -F\| '{print $9}')"

echo ok >/tmp/multisystem/multisystem-laisserpasser-usb
echo "${ID_FS_UUID}" >/tmp/multisystem/multisystem-selection-uuid-usb
echo "${DISK_MOUNTPOINT}" >/tmp/multisystem/multisystem-mountpoint-usb
echo "${ID_FS_LABEL}" >/tmp/multisystem/multisystem-selection-label-usb
echo "${ID_SERIAL_SHORT}" >/tmp/multisystem/multisystem-selection-serial-usb
rm -f "${DISK_MOUNTPOINT}"/.multisystem-test
fi

#zenity --info --text "${ID_FS_LABEL_ENC}\n${DISK_MOUNTPOINT}\n/media/${ID_FS_LABEL}"

#Espace dans label
if [ "$(grep '\x20' <<<"${ID_FS_LABEL_ENC}")" ]; then
zenity --error --text "$(eval_gettext "Erreur: MultiSystem n\'accepte pas les espaces dans les label de disques.")"
nohup "$dossier"/kill.sh&
exit 0
fi

#Vérifier type de table de partitions (dos)
#if [ ! "${ID_PART_TABLE_TYPE}" ]; then
#zenity --error --text "$(eval_gettext "Erreur: Impossible de détecter le type de table de partitions.")"
#nohup "$dossier"/kill.sh&
#exit 0
#fi

#Vérifier numéro de la partition (1)
#if [ ! "${UDISKS_PARTITION_NUMBER}" ]; then
#zenity --error --text "$(eval_gettext "Erreur: Impossible de détecter le numéro de la partition.")"
#nohup "$dossier"/kill.sh&
#exit 0
#fi

#Si clé usb n'a pas de label mettre un label et erreur!
if [ ! "$(cat /tmp/multisystem/multisystem-selection-label-usb 2>/dev/null)" ]; then
test ! "$(grep 'mtools_skip_check=1' ~/.mtoolsrc)" && echo mtools_skip_check=1 >> ~/.mtoolsrc
xterm -title 'label' -e "\
echo -e \"\E[37;44m\033[1m $(eval_gettext 'Veuillez saisir votre mot de passe d\047administrateur') \033[0m\"
sudo umount $(cat /tmp/multisystem/multisystem-selection-usb)
sudo mlabel -i $(cat /tmp/multisystem/multisystem-selection-usb) ::multisystem

#label doubler dosfslabel - paquet ==> dosfstools
#sudo dosfslabel $(cat /tmp/multisystem/multisystem-selection-usb) multisystem
"
zenity --error --text "$(eval_gettext "votre clé USB ne possédait pas de label/étiquette, multisystem viens de corriger cela,\nveuillez débrancher/rebrancher votre clé USB pour valider ce changement.")"
nohup "$dossier"/kill.sh&
exit 0
fi

#Interdire 2 label identiques !
if [ "${DISK_MOUNTPOINT}" != "/media/${ID_FS_LABEL}" ]; then
zenity --error --text "$(eval_gettext "Débranchez/rebranchez votre clé USB car le point de montage ne correspond pas au label!")"
nohup "$dossier"/kill.sh&
exit 0
fi

#Verif ecriture dans device
if [ "$(cat /tmp/multisystem/multisystem-laisserpasser-usb)" = "ok" ]; then
echo 123456789 > "$(cat /tmp/multisystem/multisystem-mountpoint-usb)"/.multisystem-test
if [ "$(cat "$(cat /tmp/multisystem/multisystem-mountpoint-usb)"/.multisystem-test)" != "123456789" ]; then
zenity --error --text "$(eval_gettext "Erreur:Avez vous le droit d\047écriture dans le dossier:") $(cat /tmp/multisystem/multisystem-mountpoint-usb 2>/dev/null)"
rm -R /tmp/multisystem 2>/dev/null
else
rm -f "$(cat /tmp/multisystem/multisystem-mountpoint-usb)"/.multisystem-test
fi
fi

#bloquer si est monté en root !
if [ "$(stat -c %U "$(cat /tmp/multisystem/multisystem-mountpoint-usb 2>/dev/null)"/autorun.inf 2>/dev/null)" = "root" ]; then
echo -e "\033[1;47;31m Error: disk root user! \033[0m"
rm -R /tmp/multisystem 2>/dev/null
exit 0
fi

#
if [ "$(cat /tmp/multisystem/multisystem-laisserpasser-usb)" != "ok" ]; then
zenity --error --text "$(eval_gettext "Erreur:") \n\
<b>EXIT:</b> $EXIT \n\
<b>laisserpasser-usb:</b> $(cat /tmp/multisystem/multisystem-laisserpasser-usb) \n\
<b>selection-usb:</b> $(cat /tmp/multisystem/multisystem-selection-usb) \n\
<b>mountpoint-usb:</b> $(cat /tmp/multisystem/multisystem-mountpoint-usb) \n\
<b>selection-uuid-usb:</b> $(cat /tmp/multisystem/multisystem-selection-uuid-usb) \n\
device:$device"
exit 0
fi

#Valider install de Grub2 dans sélection ou exit!
if [[ "$(cat /tmp/multisystem/multisystem-selection-usb)" && ! -f "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/multisystem.bs.save" ]]; then
export VALID_GRUB='<window window_position="1" icon-name="multisystem-icon">
<vbox>
<frame>
<text use-markup="true" width_request="500">
<label>"<b>'$(eval_gettext "Veuillez confirmer installation de Grub2 dans le volume:")'</b> '$(cat /tmp/multisystem/multisystem-selection-usb)'"</label>
</text>
<pixmap icon_size="6">
<input file stock="gtk-dialog-warning"></input>
</pixmap>
</frame>
<hbox>
<button cancel>
<action type="exit">exit</action>
</button>
<button ok>
<action type="exit">detection</action>
</button>
</hbox>
</vbox>
</window>'
MENU_DIALOG="$(gtkdialog --program=VALID_GRUB)"
eval ${MENU_DIALOG}
if [ "${EXIT}" != "detection" ]; then
rm -R /tmp/multisystem 2>/dev/null
exit 0
fi

fi
