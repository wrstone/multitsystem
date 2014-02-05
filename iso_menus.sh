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

#Récupérer les options
option1="$(cat /tmp/multisystem/multisystem-option1 2>/dev/null)"
option2="$(cat /tmp/multisystem/multisystem-option2 2>/dev/null)"
option3="$(cat /tmp/multisystem/multisystem-option3 2>/dev/null)"

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
wmctrl -c MultiSystem-logo
fi
}


>/tmp/multisystem/multisystem-edit-menu1
>/tmp/multisystem/multisystem-edit-menu2
>/tmp/multisystem/multisystem-edit-menu3
cat "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/grub/grub.cfg" | awk '{print "gtk-edit|" $0 "|" NR}' | grep 'gtk-edit|menuentry' >>"/tmp/multisystem/multisystem-edit-menu1"
cat "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/grub/menu.lst" | awk '{print "gtk-edit|" $0 "|" NR}' | grep -i 'gtk-edit|title' >>"/tmp/multisystem/multisystem-edit-menu2"
cat "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/boot/syslinux/syslinux.cfg" | awk '{print "gtk-edit|" $0 "|" NR}' | grep -i 'gtk-edit|MENU LABEL' >>"/tmp/multisystem/multisystem-edit-menu3"
>/tmp/multisystem/multisystem-edit-menu-all
>/tmp/multisystem/multisystem-edit-menu-all-after
cat "/tmp/multisystem/multisystem-edit-menu1" >>/tmp/multisystem/multisystem-edit-menu-all
cat "/tmp/multisystem/multisystem-edit-menu2" >>/tmp/multisystem/multisystem-edit-menu-all
cat "/tmp/multisystem/multisystem-edit-menu3" >>/tmp/multisystem/multisystem-edit-menu-all

export MAIN_EDIT='<window width_request="600" height_request="400" resizable="true" title="MultiSystem_PoPuP" window_position="1" icon-name="multisystem-icon" decorated="true">
<vbox>

<notebook labels="Grub2|Grub4dos|Syslinux">


<tree rules_hint="true" headers_visible="false" hover_expand="false" hover_selection="false" exported_column="1">
<label>1|2</label>
<width>600</width><height>320</height>
<input icon_column="0">cat /tmp/multisystem/multisystem-edit-menu1</input>
<variable>treemenu1</variable>
<action>./gui-modmenus.sh $treemenu1\|1</action>
<action>refresh:treemenu1</action>
</tree>


<tree rules_hint="true" headers_visible="false" hover_expand="false" hover_selection="false" exported_column="1">
<label>1|2</label>
<input icon_column="0">cat /tmp/multisystem/multisystem-edit-menu2</input>
<variable>treemenu2</variable>
<action>./gui-modmenus.sh $treemenu2\|2</action>
<action>refresh:treemenu2</action>
</tree>

<tree rules_hint="true" headers_visible="false" hover_expand="false" hover_selection="false" exported_column="1">
<label>1|2</label>
<input icon_column="0">cat /tmp/multisystem/multisystem-edit-menu3</input>
<variable>treemenu3</variable>
<action>./gui-modmenus.sh $treemenu3\|3</action>
<action>refresh:treemenu3</action>
</tree>

</notebook>

<hbox>
<button>
<input file icon="gtk-close"></input>
<label>"'$(eval_gettext "Fermer")'"</label>
<action type="exit">exit</action>
</button>
</hbox>
</vbox>
</window>'
gtkdialog -c --program=MAIN_EDIT
if [ ! "$(cat /tmp/multisystem/multisystem-edit-menu-all-after)" ]; then
echo
elif [ "$(cat /tmp/multisystem/multisystem-edit-menu-all)" != "$(cat /tmp/multisystem/multisystem-edit-menu-all-after)" ]; then
echo
#Mettre à jour les bootloader
if [ "$(cat /tmp/multisystem/multisystem-update-bootloader)" = "true" ]; then
xterm -title 'Update_Bootloaders' -e './update_grub.sh'
fi
else
echo
fi

exit 0
