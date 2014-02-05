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

options="$*"
option1="$(echo "$options" | awk -F"|" '{print $1}')"
option2="$(echo "$options" | awk -F"|" '{print $2}')"

date="${option2}"

#Thème
. ./theme.sh

if [[ ! "${option1}" || ! "${date}" ]]; then
exit 0
fi

./gui_cmdline_fct.sh date\|${date}

#Sortie
if [ "$(cat /tmp/multisystem/multisystem-confboot-exit 2>/dev/null)" = "exit" ]; then
exit 0
fi

export INFO='<window title="MultiSystem_PoPuP" window_position="1" icon-name="multisystem-icon" decorated="true" width_request="400" height_request="400">
<vbox>

<vbox height_request="20">
<text use-markup="true">
<input>echo "Bootloader: $(cat /tmp/multisystem/multisystem-confboot-namebootloader)"</input>
</text>
</vbox>

<pixmap>
<input file>'${theme_bdo}'</input>
</pixmap>

<vbox height_request="110">
<tree rules_hint="true" headers_visible="false" hover_expand="false" hover_selection="false" exported_column="0">
<label>1|2|3</label>
<variable>cmdline_tree</variable>
<input>cat /tmp/multisystem/multisystem-confboot-tree</input>
<action signal="button-press-event">clear:cmdline_kernel</action>
<action signal="button-press-event">clear:checkbox1</action>
<action signal="button-press-event">clear:checkbox2</action>
<action signal="button-press-event">clear:checkbox3</action>
<action signal="button-press-event">clear:checkbox4</action>
<action signal="button-press-event">clear:checkbox5</action>
<action signal="button-press-event">clear:checkbox6</action>
<action signal="button-press-event">clear:checkbox7</action>
<action signal="button-press-event">clear:checkbox8</action>
<action signal="button-press-event">clear:entry1</action>

<action signal="button-press-event">disable:cmdline_title</action>
<action signal="button-press-event">disable:checkbox1</action>
<action signal="button-press-event">disable:checkbox2</action>
<action signal="button-press-event">disable:checkbox3</action>
<action signal="button-press-event">disable:checkbox4</action>
<action signal="button-press-event">disable:checkbox5</action>
<action signal="button-press-event">disable:checkbox6</action>
<action signal="button-press-event">disable:checkbox7</action>
<action signal="button-press-event">disable:checkbox8</action>
<action signal="button-press-event">disable:entry1</action>
<action signal="button-press-event">disable:cmdline_backup</action>


<action signal="button-release-event">./gui_cmdline_fct.sh date\|'${date}'\|${cmdline_tree}</action>
<action signal="button-release-event">refresh:cmdline_kernel</action>
<action signal="button-release-event">refresh:cmdline_title</action>

<action signal="button-release-event">refresh:checkbox1</action>
<action signal="button-release-event">refresh:checkbox2</action>
<action signal="button-release-event">refresh:checkbox3</action>
<action signal="button-release-event">refresh:checkbox4</action>
<action signal="button-release-event">refresh:checkbox5</action>
<action signal="button-release-event">refresh:checkbox6</action>
<action signal="button-release-event">refresh:checkbox7</action>
<action signal="button-release-event">refresh:checkbox8</action>
<action signal="button-release-event">clear:entry1</action>

<action signal="button-release-event">enable:cmdline_title</action>
<action signal="button-release-event">enable:checkbox1</action>
<action signal="button-release-event">enable:checkbox2</action>
<action signal="button-release-event">enable:checkbox3</action>
<action signal="button-release-event">enable:checkbox4</action>
<action signal="button-release-event">enable:checkbox5</action>
<action signal="button-release-event">enable:checkbox6</action>
<action signal="button-release-event">enable:checkbox7</action>
<action signal="button-release-event">enable:checkbox8</action>
<action signal="button-release-event">enable:entry1</action>
<action signal="button-release-event">enable:cmdline_backup</action>

<action>zenity --info --text "$(cat /tmp/multisystem/multisystem-confboot-tree | grep "$cmdline_tree|" | awk -F\| '\''{print $3}'\'')\n\n$(cat /tmp/multisystem/multisystem-confboot-kernel)"</action>
</tree>
</vbox>

<pixmap>
<input file>'${theme_bdo}'</input>
</pixmap>


<vbox height_request="40">
<text sensitive="false">
<variable>cmdline_title</variable>
<default>.</default>
<input>test $cmdline_tree && echo '$(eval_gettext "Titre")': $(cat /tmp/multisystem/multisystem-confboot-tree | grep "$cmdline_tree|" | awk -F\| '\''{print $3}'\'')</input>
</text>
</vbox>

<hbox>

<vbox>
<checkbox sensitive="false">
<label>acpi=off</label>
<variable>checkbox1</variable>
<input>test $cmdline_tree && cat /tmp/multisystem/multisystem-confboot-checkbox1</input>
</checkbox>
<checkbox sensitive="false">
<label>edd=on</label>
<variable>checkbox2</variable>
<input>test $cmdline_tree && cat /tmp/multisystem/multisystem-confboot-checkbox2</input>
</checkbox>
<checkbox sensitive="false">
<label>all_generic_ide</label>
<variable>checkbox3</variable>
<input>test $cmdline_tree && cat /tmp/multisystem/multisystem-confboot-checkbox3</input>
</checkbox>
</vbox>

<vbox>
<checkbox sensitive="false">
<label>irqpoll</label>
<variable>checkbox4</variable>
<input>test $cmdline_tree && cat /tmp/multisystem/multisystem-confboot-checkbox4</input>
</checkbox>
<checkbox sensitive="false">
<label>nomodeset</label>
<variable>checkbox5</variable>
<input>test $cmdline_tree && cat /tmp/multisystem/multisystem-confboot-checkbox5</input>
</checkbox>
<checkbox sensitive="false">
<label>noacpi</label>
<variable>checkbox6</variable>
<input>test $cmdline_tree && cat /tmp/multisystem/multisystem-confboot-checkbox6</input>
</checkbox>
</vbox>

<vbox>
<checkbox sensitive="false">
<label>noapic</label>
<variable>checkbox7</variable>
<input>test $cmdline_tree && cat /tmp/multisystem/multisystem-confboot-checkbox7</input>
</checkbox>
<checkbox sensitive="false">
<label>xforcevesa</label>
<variable>checkbox8</variable>
<input>test $cmdline_tree && cat /tmp/multisystem/multisystem-confboot-checkbox8</input>
</checkbox>
<entry width_chars="15" sensitive="false">
<variable>entry1</variable>
</entry>
</vbox>

</hbox>

<button sensitive="false">
<input file stock="gtk-save"></input>
<variable>cmdline_backup</variable>
<label>"'$(eval_gettext "Sauvegarder")'"</label>
<action>echo $checkbox1 $checkbox2 $checkbox3 $checkbox4 $checkbox5 $checkbox6 $checkbox7 $checkbox8 $entry1 >/tmp/multisystem/multisystem-confboot-modifs</action>
<action type="exit">save</action>
</button>

<pixmap>
<input file>'${theme_bdo}'</input>
</pixmap>

<hbox>
<button width_request="160">
<input file icon="gtk-close"></input>
<label>"'$(eval_gettext "Fermer")'"</label>
<action type="exit">exit</action>
</button>
</hbox>

</vbox>
</window>'
#monter gui
MENU_INFO="$(gtkdialog --program=INFO)"
eval $MENU_INFO
if [ "$EXIT" = "save" ]; then
echo
if [ ! "$(grep '@' "$(cat /tmp/multisystem/multisystem-confboot-pathbootloader)")" ]; then

#la ligne à remplacer
confboot_sel="$(awk 'NR=='${cmdline_tree}'' /tmp/multisystem/multisystem-confboot-temp)"

#Insérer marqueur zzCMDLINEzz après le champ N°3
confboot_replace="$(awk 'NR=='${cmdline_tree}' { $3 = $3" zzCMDLINEzz"; print }' /tmp/multisystem/multisystem-confboot-temp)"

###noprompt

#acpi=off checkbox1
#edd=on checkbox2
#all_generic_ide checkbox3
#irqpoll checkbox4
#nomodeset checkbox5
#noacpi checkbox6
#noapic checkbox7
#xforcevesa checkbox8
#entry1

#Supprimer cmdline
confboot_cmdline="acpi=off"
if [[ "${checkbox1}" = "false" && "$(grep ${confboot_cmdline} /tmp/multisystem/multisystem-confboot-kernel)" ]]; then
confboot_replace="$(sed "s@${confboot_cmdline}@@" <<<"${confboot_replace}")"
#Ajouter cmdline
elif [[ "${checkbox1}" = "true" && ! "$(grep ${confboot_cmdline} /tmp/multisystem/multisystem-confboot-kernel)" ]]; then
confboot_replace="$(sed "s@zzCMDLINEzz@zzCMDLINEzz ${confboot_cmdline}@" <<<"${confboot_replace}")"
fi

#Supprimer cmdline
confboot_cmdline="edd=on"
if [[ "${checkbox2}" = "false" && "$(grep ${confboot_cmdline} /tmp/multisystem/multisystem-confboot-kernel)" ]]; then
confboot_replace="$(sed "s@${confboot_cmdline}@@" <<<"${confboot_replace}")"
#Ajouter cmdline
elif [[ "${checkbox2}" = "true" && ! "$(grep ${confboot_cmdline} /tmp/multisystem/multisystem-confboot-kernel)" ]]; then
confboot_replace="$(sed "s@zzCMDLINEzz@zzCMDLINEzz ${confboot_cmdline}@" <<<"${confboot_replace}")"
fi

#Supprimer cmdline
confboot_cmdline="all_generic_ide"
if [[ "${checkbox3}" = "false" && "$(grep ${confboot_cmdline} /tmp/multisystem/multisystem-confboot-kernel)" ]]; then
confboot_replace="$(sed "s@${confboot_cmdline}@@" <<<"${confboot_replace}")"
#Ajouter cmdline
elif [[ "${checkbox3}" = "true" && ! "$(grep ${confboot_cmdline} /tmp/multisystem/multisystem-confboot-kernel)" ]]; then
confboot_replace="$(sed "s@zzCMDLINEzz@zzCMDLINEzz ${confboot_cmdline}@" <<<"${confboot_replace}")"
fi

#Supprimer cmdline
confboot_cmdline="irqpoll"
if [[ "${checkbox4}" = "false" && "$(grep ${confboot_cmdline} /tmp/multisystem/multisystem-confboot-kernel)" ]]; then
confboot_replace="$(sed "s@${confboot_cmdline}@@" <<<"${confboot_replace}")"
#Ajouter cmdline
elif [[ "${checkbox4}" = "true" && ! "$(grep ${confboot_cmdline} /tmp/multisystem/multisystem-confboot-kernel)" ]]; then
confboot_replace="$(sed "s@zzCMDLINEzz@zzCMDLINEzz ${confboot_cmdline}@" <<<"${confboot_replace}")"
fi

#Supprimer cmdline
confboot_cmdline="nomodeset"
if [[ "${checkbox5}" = "false" && "$(grep ${confboot_cmdline} /tmp/multisystem/multisystem-confboot-kernel)" ]]; then
confboot_replace="$(sed "s@${confboot_cmdline}@@" <<<"${confboot_replace}")"
#Ajouter cmdline
elif [[ "${checkbox5}" = "true" && ! "$(grep ${confboot_cmdline} /tmp/multisystem/multisystem-confboot-kernel)" ]]; then
confboot_replace="$(sed "s@zzCMDLINEzz@zzCMDLINEzz ${confboot_cmdline}@" <<<"${confboot_replace}")"
fi

#Supprimer cmdline
confboot_cmdline="noacpi"
if [[ "${checkbox6}" = "false" && "$(grep ${confboot_cmdline} /tmp/multisystem/multisystem-confboot-kernel)" ]]; then
confboot_replace="$(sed "s@${confboot_cmdline}@@" <<<"${confboot_replace}")"
#Ajouter cmdline
elif [[ "${checkbox6}" = "true" && ! "$(grep ${confboot_cmdline} /tmp/multisystem/multisystem-confboot-kernel)" ]]; then
confboot_replace="$(sed "s@zzCMDLINEzz@zzCMDLINEzz ${confboot_cmdline}@" <<<"${confboot_replace}")"
fi

#Supprimer cmdline
confboot_cmdline="noapic"
if [[ "${checkbox7}" = "false" && "$(grep ${confboot_cmdline} /tmp/multisystem/multisystem-confboot-kernel)" ]]; then
confboot_replace="$(sed "s@${confboot_cmdline}@@" <<<"${confboot_replace}")"
#Ajouter cmdline
elif [[ "${checkbox7}" = "true" && ! "$(grep ${confboot_cmdline} /tmp/multisystem/multisystem-confboot-kernel)" ]]; then
confboot_replace="$(sed "s@zzCMDLINEzz@zzCMDLINEzz ${confboot_cmdline}@" <<<"${confboot_replace}")"
fi

#Supprimer cmdline
confboot_cmdline="xforcevesa"
if [[ "${checkbox8}" = "false" && "$(grep ${confboot_cmdline} /tmp/multisystem/multisystem-confboot-kernel)" ]]; then
confboot_replace="$(sed "s@${confboot_cmdline}@@" <<<"${confboot_replace}")"
#Ajouter cmdline
elif [[ "${checkbox8}" = "true" && ! "$(grep ${confboot_cmdline} /tmp/multisystem/multisystem-confboot-kernel)" ]]; then
confboot_replace="$(sed "s@zzCMDLINEzz@zzCMDLINEzz ${confboot_cmdline}@" <<<"${confboot_replace}")"
fi

#Supprimer cmdline
if [[ "${entry1}" && "$(grep ${entry1} /tmp/multisystem/multisystem-confboot-kernel)" ]]; then
confboot_replace="$(sed "s@${entry1}@@" <<<"${confboot_replace}")"
#Ajouter cmdline
elif [[ "${entry1}" && ! "$(grep "${entry1}" /tmp/multisystem/multisystem-confboot-kernel)" ]]; then
confboot_replace="$(sed "s@zzCMDLINEzz@zzCMDLINEzz ${entry1}@" <<<"${confboot_replace}")"
fi

#Remplacer les lignes
sed -i "s@${confboot_sel}@${confboot_replace}@" /tmp/multisystem/multisystem-confboot-temp

#Supprimer le numéro de ligne et remplacer les fichiers de conf
awk '{ $1 = ""; print }' /tmp/multisystem/multisystem-confboot-temp >/tmp/multisystem/multisystem-confboot-temp-new
#Suprimer espaces debut de ligne
sed -i "s@^ @@g" /tmp/multisystem/multisystem-confboot-temp-new
#Virer zzCMDLINEzz de la ligne ${confboot_replace}
sed -i "s@ zzCMDLINEzz@@g" /tmp/multisystem/multisystem-confboot-temp-new

#Test si différences
if [ "${confboot_sel}" != "${cmdline_tree} $(sed -n "${cmdline_tree} p" /tmp/multisystem/multisystem-confboot-temp-new)" ]; then
echo
#Remplacer les fichiers de conf
if [ "$(grep "#MULTISYSTEM_ST" /tmp/multisystem/multisystem-confboot-temp-new | wc -l)" = "2" ]; then
cp -f /tmp/multisystem/multisystem-confboot-temp-new "$(cat /tmp/multisystem/multisystem-confboot-pathbootloader)"
#Mettre à jour les bootloader
echo true >/tmp/multisystem/multisystem-confboot-update-grub
fi
fi
exit 0
fi
fi
exit 0
