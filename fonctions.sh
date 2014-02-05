#!/bin/bash
cd "${dossier}"
options="$*"
option1="$(echo "$options" | awk -F"|" '{print $1}')"
option2="$(echo "$options" | awk -F"|" '{print $2}')"
option2="$(echo -e "${option2//\%/\\x}" | sed 's%^file://%%' | sed 's#\r##g')"
option3="$(echo "$options" | awk -F"|" '{print $3}')"


#Placer les options dans un fichier
echo "${option1}" >/tmp/multisystem/multisystem-option1
echo "${option2}" >/tmp/multisystem/multisystem-option2
echo "${option3}" >/tmp/multisystem/multisystem-option3


function FCT_KILL()
{
nohup ./kill.sh&
exit 0
}

function FCT_RELOAD()
{
sync
echo "idgui:$(cat /tmp/multisystem/multisystem-idgui)"
if [ "$(cat /tmp/multisystem/multisystem-idgui)" ]; then
xdotool windowmap $(cat /tmp/multisystem/multisystem-idgui)
#activer fenetre
xdotool windowactivate $(cat /tmp/multisystem/multisystem-idgui)
wmctrl -c "MultiSystem-logo"
fi
}

function FCT_UPDATEGRUB()
{
xterm -title 'grub-install' -e './update_grub.sh'
}


function FCT_TRANSTORM()
{
#Remplacer multiboot par multisystem ! dans la clé usb branchée.
if [ "$(grep '#MULTIBOOT' "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/grub/grub.cfg" 2>/dev/null)" ]; then
#Remplacer MULTIBOOT
#grub2
sed -i "s/\#MULTIBOOT/\#MULTISYSTEM/g" "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/grub/grub.cfg" 2>/dev/null
sed -i "s/\#MULTIBOOT/\#MULTISYSTEM/g" "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/grub/menu.lst" 2>/dev/null
#Burg
sed -i "s/\#MULTIBOOT/\#MULTISYSTEM/g" "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/burg/menu.txt" 2>/dev/null
sed -i "s/\#MULTIBOOT/\#MULTISYSTEM/g" "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/burg/burg.cfg" 2>/dev/null
#Syslinux
sed -i "s/\#MULTIBOOT/\#MULTISYSTEM/g" "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/syslinux/syslinux.cfg" 2>/dev/null
#Remplacer multiboot-v3-
#grub2
sed -i "s/multiboot-v3-/multisystem-/g" "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/grub/grub.cfg" 2>/dev/null
sed -i "s/multiboot-v3-/multisystem-/" "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/grub/menu.lst" 2>/dev/null
#Burg
sed -i "s/multiboot-v3-/multisystem-/g" "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/burg/menu.txt" 2>/dev/null
sed -i "s/multiboot-v3-/multisystem-/g" "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/burg/burg.cfg" 2>/dev/null
#Syslinux
sed -i "s/multiboot-v3-/multisystem-/g" "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/syslinux/syslinux.cfg" 2>/dev/null
sleep 1
#Supprimer multiboot.bat
if [ -f "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/multiboot.bat" ]; then
rm "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/multiboot.bat"
fi
#Renommer dans .hidden
if [ -f "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/.hidden" ]; then
sed -i "s/multiboot.bat/multisystem.bat/g" "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/.hidden"
fi
#Renommer sauvegarde du mbr
if [ -f "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/multiboot.bs.save" ]; then
mv "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/multiboot.bs.save" "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/multisystem.bs.save"
fi
FCT_UPDATEGRUB
fi
}
FCT_TRANSTORM


#Vérifier que la clé USB est bien toujours présente!
>/tmp/multisystem/multisystem-laisserpasser2-usb
unset ID_FS_UUID
unset ID_FS_LABEL
eval $(udevadm info -q all -n $(cat /tmp/multisystem/multisystem-selection-usb 2>/dev/null) 2>/dev/null | grep = | grep -v ':.*:' | awk -F: '{print $2}')

#Verif mountpoint
if [ ! -d "$(cat /tmp/multisystem/multisystem-mountpoint-usb)"  ]; then
zenity --error --text "$(eval_gettext "Erreur:le volume suivant est indisponible:")$(cat /tmp/multisystem/multisystem-selection-usb)"
#Verif UUID
elif [ "$(cat /tmp/multisystem/multisystem-selection-uuid-usb)" != "${ID_FS_UUID}" ]; then
zenity --error --text "$(eval_gettext "Erreur: La clé USB n\047est plus la même!")"
#ok
else
echo ok >/tmp/multisystem/multisystem-laisserpasser2-usb
fi
#Exit si pas ok
if [ "$(cat /tmp/multisystem/multisystem-laisserpasser2-usb)" != "ok" ]; then
zenity --error --text "$(eval_gettext "Erreur:le volume suivant est indisponible:")$(cat /tmp/multisystem/multisystem-selection-usb)"
rm -R /tmp/multisystem 2>/dev/null
FCT_KILL
exit 0
fi


#copier dossier boot si pas present
if [[ ! -f "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")"/boot/grub/grub.cfg || ! -f "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")"/boot/grub/menu.lst ]]; then
cp -Rf "${dossier}/boot" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")"/
if [ "$(grub-install -v | grep 1.96)" ]; then
echo
if [ -f "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub-v1.96.cfg" ]; then
rm "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
mv "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub-v1.96.cfg" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg"
fi
else
rm "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub-v1.96.cfg"
fi
fi


#rajouter PloP dans clé si pas présent!
if [ -f "${HOME}"/.multisystem/nonfree/plpbt.bin ]; then
echo ok plpbt.bin
if [ ! -f "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/img/plpbt" ]; then
cp -Rf "${HOME}"/.multisystem/nonfree/plpbt.bin "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/img/plpbt"
fi
fi
#copier dossier syslinux si pas present, car ajouté tardivement et user peut ne pas avoir.
if [ ! -f "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/syslinux/syslinux.cfg" ]; then
cp -Rf "${dossier}/boot/syslinux" "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/"
rm "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/syslinux/syslinux"
fi
#Ajouter un dossier .hidden pour masques fichiers/dossiers.
if [ ! -f "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/.hidden" ]; then
echo -e "#boot
autorun.inf
icon.ico
multisystem.bat" | tee "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/.hidden"
fi
#verifier presence marqueurs
if [ "$(grep "#MULTISYSTEM_ST" "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/grub/grub.cfg" | wc -l)" != "2" ]; then
zenity --error --text "$(eval_gettext "Erreurs: fichier de configuration grub.cfg non conforme")"
FCT_KILL
exit 0
elif [ "$(grep "#MULTISYSTEM_ST" "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/grub/menu.lst" | wc -l)" != "2" ]; then
zenity --error --text "$(eval_gettext "Erreurs: fichier de configuration menu.lst non conforme")"
FCT_KILL
exit 0
elif [ "$(grep "#MULTISYSTEM_ST" "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/syslinux/syslinux.cfg" | wc -l)" != "2" ]; then
zenity --error --text "$(eval_gettext "Erreurs: fichier de configuration syslinux.cfg non conforme")"
FCT_KILL
exit 0
fi

#relever idfenetre attente pour livecd
if [ "${option1}" ]; then
while true
do
#wid="$(wmctrl -l | grep " MultiSystem$" | awk '{print $1}')"
wid="$(wmctrl -p -G -l | grep '400.*420' | grep ' MultiSystem$' | awk '{print $1}')"
echo Attente idfenetre
if [ "${wid}" ]; then
echo $wid >/tmp/multisystem/multisystem-idgui
#activer fenetre
xdotool windowactivate $(cat /tmp/multisystem/multisystem-idgui)
#masquer
xdotool windowunmap $(cat /tmp/multisystem/multisystem-idgui)
break
fi
sleep .1
done
else
#wid="$(wmctrl -l | grep " MultiSystem$" | awk '{print $1}')"
wid="$(wmctrl -p -G -l | grep '400.*420' | grep ' MultiSystem$' | awk '{print $1}')"
echo $wid >/tmp/multisystem/multisystem-idgui
fi

#Conpter le nonbre de fichier iso present
echo "$(grep '^multisystem-' "/tmp/multisystem/multisystem-mise-en-forme" 2>/dev/null | wc -l)" >/tmp/multisystem/multisystem-nombreiso-usb


#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
#fonction Ajouter
#Appel fonction Ajouter
if [ "$option1" == "add" ]; then
#Gui logo
export MOD_WAIT='<window title="MultiSystem-logo" window_position="1" decorated="false">
<vbox>
<pixmap>
<input file>./logo.png</input>
</pixmap>
<pixmap>
<input file>./pixmaps/multisystem-wait.gif</input>
</pixmap>
</vbox>
</window>'
gtkdialog --program=MOD_WAIT&
xterm -title 'Add_iso' -e './iso_add.sh'
wmctrl -c "MultiSystem-logo"
fi
#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒



#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
#fonction supprimer
#Appel fonction supprimer
if [ "$option1" == "selclear" ]; then
#Interdire suppression de l'iso si elle à servi à booter !
isoremove="$(grep "^#MULTISYSTEM_MENU_DEBUT|.*${option2}" "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg" | head -n 1 | awk -F"|" '{print $3}')"
isoselect="$(grep "iso-scan/filename=/${isoremove}" /proc/cmdline 2>/dev/null)"
isouuid="$(grep "root=UUID=$(cat /tmp/multisystem/multisystem-selection-uuid-usb)" /proc/cmdline 2>/dev/null)"
#Ne pas supprimer iso multisystem si a servi à booter !
if [[ "${isouuid}" && "${isoselect}" && "${isoremove}" ]]; then
zenity --error --text "$(eval_gettext "Erreur: cette iso à servi à démarrer votre PC, il est impossible de la supprimer.")"
unset isoremove
unset isoselect
unset isouuid
# sinon ...
else
unset isoremove
unset isoselect
unset isouuid
#Avertissement!
if [ "$(cat "$HOME/.multisystem/check_rem" 2>/dev/null)" == "true" ]; then
#chercher selection dans grub.cfg
liste="$(sed -n '/^#MULTISYSTEM_MENU_DEBUT/p' "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg" | awk -F"|" '{print "|" $2 "|" $3 "|" $4 "|" $5 "|" $6}')"
ligne="$(echo -e "${liste}" | grep "${option2}")"
if [ ! "${ligne}" ]; then
#chercher selection dans menu.lst
liste="$(sed -n '/^#MULTISYSTEM_MENU_DEBUT/p' "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/menu.lst" | awk -F"|" '{print "|" $2 "|" $3 "|" $4 "|" $5 "|" $6}')"
ligne="$(echo -e "${liste}" | grep "${option2}")"
fi
if [ ! "${ligne}" ]; then
#chercher selection dans syslinux.cfg
liste="$(sed -n '/^#MULTISYSTEM_MENU_DEBUT/p' "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/syslinux/syslinux.cfg" | awk -F"|" '{print "|" $2 "|" $3 "|" $4 "|" $5 "|" $6}')"
ligne="$(echo -e "${liste}" | grep "${option2}")"
fi
fichier="$(grep "${option2}" <<<"${liste}" | awk -F"|" '{print $3}')"
if [ "${fichier}" ]; then
export INFO='<window window_position="1" title="Info" icon-name="multisystem-icon" decorated="true">
<vbox spacing="0">
<frame>
<hbox homogeneous="true">
<text use-markup="true">
<variable>MESSAGES</variable>
<input>echo "\<span color='\''red'\'' font_weight='\''bold'\'' size='\''larger'\''>'$(eval_gettext 'Attention vous allez supprimer:')'\</span>\n$(cat /tmp/multisystem/multisystem-mountpoint-usb)/'${fichier}'" | sed "s/\\\//g"</input>
</text>
</hbox>
</frame>
<hbox>
<button>
<input file stock="gtk-cancel"></input>
<variable>btnul</variable>
<label>"'$(eval_gettext 'Annuler')'"</label>
<action type="exit">cancel</action>
</button>
<button>
<input file stock="gtk-ok"></input>
<label>"'$(eval_gettext "Valider")'"</label>
<action type="exit">ok</action>
</button>
</hbox>
</vbox>
</window>'
#monter gui
I=$IFS; IFS=""
for MENU_INFO in $(gtkdialog --program=INFO); do
eval $MENU_INFO
if [ "$EXIT" != "ok" ]; then
FCT_RELOAD
exit 0
fi
done
IFS=$I
fi
fi
xterm -title 'Remove_iso' -e './iso_remove.sh'
fi
fi
#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒


#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
#selup
if [ "$option1" == "selup" ]; then
xterm -title 'Selup_iso' -e './iso_selup.sh'
fi
#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒


#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
#seldown
if [ "$option1" == "seldown" ]; then
xterm -title 'Seldown_iso' -e './iso_seldown.sh'
fi
#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒


#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
#move
if [ "$option1" == "move" ]; then
./iso_move.sh
fi
#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒


#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
if [ "$option1" == "grub" ]; then
FCT_UPDATEGRUB
fi
#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒


#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
#burg
if [ "$option1" == "burg" ]; then
./gui-burg.sh
fi
#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒


#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
#qemu
if [ "$option1" == "qemu" ]; then
xterm -title 'Qemu' -e "./qemu.sh usb"
fi
#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒


#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
#installvbox
if [ "$option1" == "installvbox" ]; then
xterm -title 'Install_VBox' -e './vbox_install.sh'
fi
#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒


#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
#Lancer VirtualBox test MultiSystem
function MOD_VBOX()
{
#Install VirtualBox si pas présent
if [ ! "$(which VBoxManage)" ]; then
xterm -title 'install VBox' -e './vbox_install.sh'
fi
xterm -title 'VBox' -e "./vbox.sh"
}
if [ "$option1" == "vbox" ]; then
MOD_VBOX
fi
#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒


#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
#Lancer VirtualBox test LiveCD gui
function MOD_VBOX()
{
#Install VirtualBox si pas présent
if [ ! "$(which VBoxManage)" ]; then
xterm -title 'install VBox' -e './vbox_install.sh'
fi
wmctrl -c "VBox"
./VBox_livecd_gui.sh&
}
if [ "$option1" == "vboxlivecd" ]; then
MOD_VBOX
fi
#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒


#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
#format (formater la clé usb)
if [ "$option1" == "format" ]; then
./format_gui.sh
#Sortie si user à formaté.
if [ ! -f "/tmp/multisystem/multisystem-idgui" ]; then
exit 0
fi
fi
#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒


#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
#persistent (créer mode persistent)
if [ "$option1" == "persistent" ]; then
xterm -title 'Add_Persistent_Mode' -e './iso_modpersistent.sh'
fi
#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒


#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
#persistent-resize (redimensionner le mode persistent)
if [ "$option1" == "persistent-resize" ]; then
xterm -title 'persistent-resize' -e './gui-persistent.sh'
fi
#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒


#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
#cdamorce (créer cd amorce)
if [ "$option1" == "cdamorce" ]; then
xterm -title 'cdamorce' -e './cdamorce.sh'
fi
#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒



#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
#pref (Réglages Grub2)
if [ "$option1" == "pref" ]; then
./gui-pref.sh
FCT_UPDATEGRUB
fi
#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒


#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
#save (sauvegarde/restauration)
function MOD_SAVE()
{
./gui-save-restaur.sh
#Si user a annulé tuer process de dd et virer fichier
if [ -f "/tmp/multisystem/multisystem-pid-save" ]; then
kill $(cat /tmp/multisystem/multisystem-pid-save) 2>/dev/null
rm /tmp/multisystem/multisystem-pid-save 2>/dev/null
rm "$(cat /tmp/multisystem/multisystem-path-save)" 2>/dev/null
rm /tmp/multisystem/multisystem-path-save 2>/dev/null
fi
}
if [ "$option1" == "save" ]; then
MOD_SAVE
fi
#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒


#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
#update (Mise à jour)
if [ "$option1" == "update" ]; then
./gui-update.sh
fi
#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒


#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
#downloadcd (liste des distro supportées)
if [ "$option1" == "downloadcd" ]; then
./gui-infodl.sh
fi
#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒


#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
#debug (pour debuger)
if [ "$option1" == "debug" ]; then
./gui-debug.sh
fi
#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒


#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
#hidden (permet de cacher certains fichiers sous nautilus)
if [ "$option1" == "hidden" ]; then
./gui-hidden.sh
fi
#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒


#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
#lang (choix du language)
if [ "$option1" == "lang" ]; then
./gui_lang.sh
fi
#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒


#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
#menu (modifier les noms des menus de démarrage)
if [ "$option1" == "menu" ]; then
./iso_menus.sh
fi
#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒


#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
#cmdline (options de boot)
if [ "$option1" == "cmdline" ]; then
./gui_cmdline.sh $option1\|$option2
if [ "$(cat /tmp/multisystem/multisystem-update-bootloader)" = "true" ]; then
echo
if [ "$(cat /tmp/multisystem/multisystem-confboot-update-grub)" = "true" ]; then
FCT_UPDATEGRUB
fi
fi
fi
#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒


#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
if [[ "$option1" == "infoboot" && "$option2" == "grub" ]]; then
#Faire test présence de PloP et message si pas présent
if [ ! -f "${HOME}"/.multisystem/nonfree/plpbt.bin ]; then
./fonctions-nonfree.sh alert-plop
else
./gui-boot-grub.sh
fi
elif [[ "$option1" == "infoboot" && "$option2" == "xp" ]]; then
./gui-boot-xp.sh
elif [[ "$option1" == "infoboot" && "$option2" == "vista" ]]; then
./gui-boot-vista.sh
elif [[ "$option1" == "infoboot" && "$option2" == "macintel" ]]; then
./gui-boot-macintel.sh
fi
#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒


#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
#mettre à jour le contenu du tree
#relever icone|iso|date
>/tmp/multisystem/multisystem-mise-en-forme
listetree="$(sed -n '/^#MULTISYSTEM_MENU_DEBUT/p' "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/grub.cfg" | awk -F"|" '{print $4 "|" $3 "|" $2 "|" $5 "|" $6 "|Grub2"}')"
if [ "${listetree}" ]; then
echo -e "$listetree" >/tmp/multisystem/multisystem-mise-en-forme
fi
listetree2="$(sed -n '/^#MULTISYSTEM_MENU_DEBUT/p' "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/grub/menu.lst" | awk -F"|" '{print $4 "|" $3 "|" $2 "|" $5 "|" $6 "|Grub4dos"}')"
if [ "${listetree2}" ]; then
echo -e "$listetree2" >>/tmp/multisystem/multisystem-mise-en-forme
fi
listetree3="$(sed -n '/^#MULTISYSTEM_MENU_DEBUT/p' "$(cat "/tmp/multisystem/multisystem-mountpoint-usb")/boot/syslinux/syslinux.cfg" | awk -F"|" '{print $4 "|" $3 "|" $2 "|" $5 "|" $6 "|Syslinux"}')"
if [ "${listetree3}" ]; then
echo -e "$listetree3" >>/tmp/multisystem/multisystem-mise-en-forme
fi
#Conpter le nonbre de fichier iso present
echo "$(grep '^multisystem-' "/tmp/multisystem/multisystem-mise-en-forme" | wc -l)" >/tmp/multisystem/multisystem-nombreiso-usb

#afficher gui
FCT_RELOAD
exit 0

