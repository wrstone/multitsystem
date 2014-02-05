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

texte="$(eval_gettext 'Ajouter au gestionnaire de boot de Windows Vista\nun menu pour démarrer votre LiveUSB.\n\nA faire apres un boot sur vista\nTéléchargez EasyBCD\nbrancher votre clé usb\nlancez EasyBCD\ncliquez sur le bouton "Add/Remove Entries"\nsélectionnez l\047onglet linux\nréglez comme suit:\nType: grub\nName: LiveUSB\nDrive: (sélectionnez la partition 0 de votre clé usb)\nne cochez pas! "GRUB isn\047t installed to the boot sector"\ncliquez sur le bouton: "+ Add Entry"\ncliquez sur le bouton: "Save"\nc\047est fini! .\nCapture d\047écran:\nhttp://neosmart.net/gallery/v/neosmart/EasyBCD/1_70/Add-Remove+Entries+-+Linux.png.html\nAu prochain démarrage selectionnez LiveUSB,\nil vous dit de brancher le volume,\ncliquez sur enter.\n\nAutre méthode,\nAjouter plop bootloader au gestionnaire de démarrage de windows vista\nvoir méthode: http://www.plop.at/en/bootmanager.html#runwin')"

#remplacer url neosmart plus valide ...
echo -e "$texte" | sed 's@http://neosmart.net/gallery/v/neosmart/EasyBCD/1_70/Add-Remove+Entries+-+Linux.png.html@http://neosmart.net/gallery/photo/view/neosmart/EasyBCD/EasyBCD+1.0/Add-Remove+Entries+-+Linux/o/@' >/tmp/multisystem/multisystem-download

export INFO='<window title="MultiSystem_PoPuP" window_position="1" icon-name="multisystem-icon" decorated="true" width_request="400" height_request="400">
<vbox>
<button>
<input file icon="multisystem-windows"></input>
<label>"'$(eval_gettext "Télécharger EasyBCD")'"</label>
<action>xdg-open http://neosmart.net/dl.php?id=1&</action>
</button>
<edit editable="true" cursor-visible="true" accepts-tab="true" left-margin="2" right-margin="2" indent="2">
<input file>/tmp/multisystem/multisystem-download</input>
</edit>
<hbox>
<button width_request="160">
<input file icon="gtk-close"></input>
<label>"'$(eval_gettext "Fermer")'"</label>
<action type="exit">exit</action>
</button>
</hbox>
</vbox>
</window>'
gtkdialog --program=INFO &>/dev/null
exit 0
