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

>/tmp/multisystem/multisystem-persistent-list
echo "$(eval_gettext "Pas de sélection")" >/tmp/multisystem/multisystem-persistent-detail

#Detection des fichiers et mise en forme pour tree gtkdialog
liste="$(find "$(cat /tmp/multisystem/multisystem-mountpoint-usb)" -type f -regex '.*\(casper-rw\|live-rw\|home-rw\|overlay-.*\|home.img\)' -print)"
echo -e "$liste" | while read line
do
echo "multisystem-usbpen|$(basename "$line")|$(($(du -sB 1 "$line" | awk '{print $1}')/1024/1024))Mio|$line|" >>/tmp/multisystem/multisystem-persistent-list
done

#pas trouvé de mode persistent...
if [ ! "$(cat /tmp/multisystem/multisystem-persistent-list)" ]; then
echo "N/A" >/tmp/multisystem/multisystem-persistent-detail
fi

export INFO='<window title="MultiSystem_PoPuP" icon-name="multisystem-icon" decorated="true" width_request="400" height_request="400">
<vbox>

<hbox>
<frame>
<hbox homogeneous="true" height_request="180">
<text sensitive="false">
<variable>MESSAGES</variable>
<input>cat /tmp/multisystem/multisystem-persistent-detail</input>
</text>
</hbox>
</frame>
</hbox>

<tree rules_hint="true" headers_visible="false" hover_expand="false" exported_column="2">
<label>1|2|3</label>
<variable>tree</variable>
<input icon_column="0">cat /tmp/multisystem/multisystem-persistent-list</input>
<action signal="button-release-event">parted -s "$tree" unit MB print >/tmp/multisystem/multisystem-persistent-detail</action>
<action signal="button-release-event">refresh:MESSAGES</action>
</tree>

<hbox homogeneous="true">
<button width_request="160">
<input file icon="multisystem-resize"></input>
<label>"'$(eval_gettext "Redimensionner")'"</label>
<action>exit:resize</action>
</button>
<button width_request="160">
<input file icon="gtk-clear"></input>
<label>"'$(eval_gettext "Effacer contenu")'"</label>
<action>exit:clear</action>
</button>
</hbox>

<hbox>
<button width_request="160">
<input file icon="gtk-close"></input>
<label>"'$(eval_gettext "Fermer")'"</label>
<action type="exit">exit</action>
</button>
</hbox>
</vbox>
</window>'
while true
do
MENU_INFO="$(gtkdialog --program=INFO)"
eval $MENU_INFO
if [[ "$tree" && "$EXIT" == "resize" ]]; then
echo "resize $tree"
break
elif [[ "$tree" && "$EXIT" == "clear" ]]; then
echo "clear $tree"
break
elif [[ ! "$tree" && $(echo $EXIT | grep -E "(clear)|(resize)") ]]; then
#pas de sélection
echo "error"
else
exit 0
fi
done



#resize, redimensionner le mode persistent.
if [[ "$tree" && "$EXIT" == "resize" ]]; then
echo "resize $tree"

echo -e "\E[37;44m\033[1m $(eval_gettext 'Veuillez saisir votre mot de passe d\047administrateur') \033[0m"
sudo umount /tmp/multisystem/multisystem-mount-persistent 2>/dev/null
sudo mkdir /tmp/multisystem/multisystem-mount-persistent 2>/dev/null
sudo mount -t auto -o loop "$tree" /tmp/multisystem/multisystem-mount-persistent 2>/dev/null

if [ "$(mount -l 2>/dev/null | grep /tmp/multisystem/multisystem-mount-persistent)" ];then

#taille de persistent
valuepersistent="$(($(du -sB 1 "$tree" | awk '{print $1}')/1024/1024))"

#taille occupée dans persistent
busypersistent="$(($(df -aB 1 /tmp/multisystem/multisystem-mount-persistent | grep /tmp/multisystem/multisystem-mount-persistent | awk '{print $3}')/1024/1024))"

#espace dispo dans clé usb
available="$(($(df -aB 1 $(cat /tmp/multisystem/multisystem-mountpoint-usb) | grep ^$(cat /tmp/multisystem/multisystem-selection-usb) | awk '{print $4}')/1024/1024))"

#maxsize
maxsize="$available"

#
if [ "$maxsize" -le "$available" ]; then #<=
maxsize="$(($valuepersistent+$available))"
fi

#limit max 4095!
if [ "$maxsize" -gt "4095" ]; then #>
maxsize="4095"
fi

ninisize="$(($busypersistent+128))"
if [ "$ninisize" -lt "512" ]; then #<
ninisize="512"
fi

if [ "$valuepersistent" -lt "$ninisize" ]; then #<
valuepersistent="$ninisize"
fi

#zenity --info --text "valuepersistent:$valuepersistent\nbusypersistent:$busypersistent\navailable:$available\nmaxsize:$maxsize\nninisize:$ninisize"
echo valuepersistent:$valuepersistent
echo busypersistent:$busypersistent
echo available:$available
echo maxsize:$maxsize
echo ninisize:$ninisize

tpersistent="$(zenity --scale --text "$(eval_gettext "Taille du mode persistent en Mio")" --min-value=$ninisize --max-value=$maxsize --value=$valuepersistent --step 128)"
stop="$?"
echo tpersistent:$tpersistent

echo -e "\E[37;44m\033[1m $(eval_gettext 'Veuillez saisir votre mot de passe d\047administrateur') \033[0m"
sudo umount /tmp/multisystem/multisystem-mount-persistent 2>/dev/null
sudo rmdir /tmp/multisystem/multisystem-mount-persistent 2>/dev/null

if [ "$stop" -eq "0" ]; then
echo tpersistent:$tpersistent
e2fsck -y -f "$tree"
resize2fs -p "$tree" ${tpersistent}M
e2fsck -y -f "$tree"
resize2fs -p "$tree"
#echo Attente
#read
fi
else
zenity --error --text "$(eval_gettext "Erreur: impossible de monter le volume:")\n$tree"
fi


#clear, effacer le contenu du mode persistent
elif [[ "$tree" && "$EXIT" == "clear" ]]; then
export INFO2='<window width_request="400" height_request="140" window_position="1" title="Info" icon-name="multisystem-icon" decorated="true" resizable="false">
<vbox spacing="0">
<frame>
<hbox homogeneous="true">
<text use-markup="true">
<variable>MESSAGES</variable>
<input>echo "\<span color='\''red'\'' font_weight='\''bold'\'' size='\''larger'\''>'$(eval_gettext 'Attention!')'\</span>\n'$(eval_gettext 'vous allez supprimer le contenu de:')'\n'$tree'" | sed "s/\\\//g"</input>
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
MENU_INFO2="$(gtkdialog --program=INFO2)"
eval $MENU_INFO2
if [ "$EXIT" == "ok" ]; then
echo -e "\E[37;44m\033[1m $(eval_gettext 'Veuillez saisir votre mot de passe d\047administrateur') \033[0m"
sudo umount /tmp/multisystem/multisystem-mount-persistent 2>/dev/null
sudo mkdir /tmp/multisystem/multisystem-mount-persistent 2>/dev/null
sudo mount -t auto -o loop "$tree" /tmp/multisystem/multisystem-mount-persistent 2>/dev/null

if [ "$(mount -l 2>/dev/null | grep /tmp/multisystem/multisystem-mount-persistent)" ];then
echo -e "\E[37;44m\033[1m $(eval_gettext 'Veuillez saisir votre mot de passe d\047administrateur') \033[0m"
sudo rm -R /tmp/multisystem/multisystem-mount-persistent/* 2>/dev/null
sudo umount /tmp/multisystem/multisystem-mount-persistent 2>/dev/null
sudo rmdir /tmp/multisystem/multisystem-mount-persistent 2>/dev/null

#echo Attente
#read

else
zenity --error --text "$(eval_gettext "Erreur: impossible de monter le volume:")\n$tree"
fi
fi
fi
exit 0
