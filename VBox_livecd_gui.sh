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

#verifier Install VirtualBox
if [ ! "$(which VBoxManage)" ]; then
xterm -title 'install VBox' -e './vbox_install.sh'
fi

#re-verifier Install VirtualBox
if [ ! "$(which VBoxManage)" ]; then
echo "Erreur1 VBoxManage"
exit 0
fi

function FCT_THEME1()
{
#theme blue '${theme_bdo}' '${theme_btn}'
theme_bdo="./pxls-blue.png"
theme_btn="multisystem-drop-blue"
}
function FCT_THEME2()
{
#theme red
theme_bdo="./pxls-red.png"
theme_btn="multisystem-drop-red"
}
function FCT_THEME3()
{
#theme green
theme_bdo="./pxls.png"
theme_btn="multisystem-drop"
}
export theme_bdo
export theme_btn

if [ "$(cat "${HOME}"/.multisystem-theme 2>/dev/null)" == "blue" ]; then
FCT_THEME1
elif [ "$(cat "${HOME}"/.multisystem-theme 2>/dev/null)" == "red" ]; then
FCT_THEME2
elif [ "$(cat "${HOME}"/.multisystem-theme 2>/dev/null)" == "green" ]; then
FCT_THEME3
else
FCT_THEME3
fi

#Au cas ou lance directement par son menu...
mkdir /tmp/multisystem 2>/dev/null

#
export MOD_WAIT2='<window title="MultiSystem-logo2" window_position="1" decorated="false">
<vbox>
<pixmap>
<input file>./logo.png</input>
</pixmap>
<pixmap>
<input file>./pixmaps/multisystem-wait.gif</input>
</pixmap>
</vbox>
</window>'
gtkdialog --program=MOD_WAIT2 &


#
function FCT_livecd()
{
cp -f ./pixmaps/multisystem-wait.gif /tmp/multisystem/multisystem-load.gif
DAG2="$(echo -e "${DAG2//\%/\\x}" | sed 's%^file://%%' | sed 's#\r##g' | sed 's# $##g')"
#zenity --info --text " iso1:${iso1}\nDAG2:${DAG2}\nostypes:${ostypes}"


if [[ ! -f "${DAG2}" || ! "$(grep -iE  "(\.iso)|(\.img)" <"${DAG2}")" ]]; then
echo "Erreur2 ${DAG2}"
cp -f "${theme_bdo}" /tmp/multisystem/multisystem-load.gif
exit 0
fi

name="MultiSystem-Test-liveCD"
if [[ -f "${DAG2}" && "$(grep -iE  "(\.iso)|(\.img)" <"${DAG2}")" ]]; then
cheminiso="${DAG2}"
oldcheminiso="$(VBoxManage showvminfo "${name}" --machinereadable | grep '^dvd=' | awk -F\" '{print $2}')"
else
exit 0
fi

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
#echo -e "\033[1;47;31m $(eval_gettext "Appuyez sur enter pour continuer") \033[0m"
#read
cp -f "${theme_bdo}" /tmp/multisystem/multisystem-load.gif
exit 0
fi
export memory vram
echo -e "\033[1;33;44m memory:$memory vram:$vram \033[00m"


#stop
VBoxManage controlvm "${name}" poweroff &>/dev/null
#dissocier
VBoxManage modifyvm "${name}" --hda none
#supprimer vm
VBoxManage unregistervm "${name}" --delete
#supprimer entrée iso
VBoxManage closemedium dvd "${oldcheminiso}"

#creer entrée
VBoxManage createvm --name "${name}" --register
#option specifique >= 3.1
if [ "$(echo $(VBoxManage -v) | grep -vE "(^2.0)|(^3.0)")" ]; then
VBoxManage storagectl "${name}" --name "IDE Controller" --add ide
VBoxManage storageattach ${name} --storagectl "IDE Controller" \
--port 0 --device 0 --type dvddrive --medium "${cheminiso}"
fi
#Ajouter fichier iso
VBoxManage registerimage dvd "${cheminiso}"
#Attacher iso à entree vbox
VBoxManage modifyvm "${name}" --dvd "${cheminiso}"
VBoxManage modifyvm "${name}" --memory ${memory} --vram ${vram} --acpi on --nic1 nat --ioapic on \
--ostype "${ostypes}" \
--audio alsa --audiocontroller ac97 \
--accelerate3d on \
--pae on \
--usb on --usbehci on

#start
VBoxManage startvm "${name}" --type gui
cp -f "${theme_bdo}" /tmp/multisystem/multisystem-load.gif
}
export -f FCT_livecd



function FCT_listtypes()
{
echo -e "Linux26
$(VBoxManage list -l ostypes | grep '^ID: ' | grep -v Other | awk '{print $2}')
"
}
export -f FCT_listtypes


#Copier "${theme_bdo}" dans /tmp/multisystem/multisystem-load.gif
cp -f "${theme_bdo}" /tmp/multisystem/multisystem-load.gif


sleep .5
wmctrl -c "MultiSystem-logo2"


DROPISO='<window width_request="400" window_position="1" title="VBox" icon-name="multisystem-icon" decorated="true" resizable="false">
<vbox spacing="0">

<pixmap>
<input file>'${theme_bdo}'</input>
</pixmap>

<comboboxtext>
<variable>ostypes</variable>
<input>bash -c "FCT_listtypes"</input>
</comboboxtext>

<pixmap>
<input file>'${theme_bdo}'</input>
</pixmap>

<hbox>
<frame '$(eval_gettext 'Glisser/Déposer iso/img')'>
<hbox>

<entry 
accept="filename" activates-default="true" fs-folder="'$HOME/'" fs-action="file" 
fs-filters="*.iso" show-hidden="false" fs-title="Select an iso file"

primary-icon-name="'${theme_btn}'" 
secondary-icon-name="multisystem-virtualbox" 

tooltip-text="'$(eval_gettext "Glisser/Déposer iso/img")'\n'$(eval_gettext 'Ajouter un liveCD')'"
primary-icon-tooltip-text="'$(eval_gettext 'Utilisez ce bouton si le Glisser/Déposer ne fonctionne pas.')'"
secondary-icon-tooltip-text="'$(eval_gettext 'Ouvrir VirtualBox')'">

<variable>DAG2</variable>
<width>50</width><height>50</height>
<action signal="changed">test $DAG2 && bash -c "FCT_livecd" &</action>
<action signal="changed">clear:DAG2</action>
<action signal="changed">refresh:DAG2</action>

<action signal="primary-icon-press">fileselect:DAG2</action>
<action signal="secondary-icon-press">VirtualBox &</action>
</entry>

</hbox>
</frame>

</hbox>

<vbox>
<pixmap>
<variable>multisystem-wait</variable>
<input file>/tmp/multisystem/multisystem-load.gif</input>
</pixmap>

<timer milliseconds="true" interval="500" visible="false">
<variable>TIMER</variable>
<sensitive>true</sensitive>
<action>refresh:multisystem-wait</action>
</timer>
</vbox>

</vbox>
</window>'
export DROPISO
gtkdialog -p DROPISO
exit 0
