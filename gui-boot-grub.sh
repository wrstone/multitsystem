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

if [[ "$(grep '### MULTISYSTEM MENU' /boot/grub/menu.lst)" || "$(grep '### MULTISYSTEM MENU' /boot/grub/grub.cfg)" ]]; then
vartest="$(eval_gettext 'Supprimer Plop de Grub/Grub2')"
else
vartest="$(eval_gettext 'Ajouter Plop à Grub/Grub2')"
fi

texte="$(eval_gettext 'Cette interface vous permet d\047ajouter\nou de supprimer Plop bootloader\nde votre gestionnaire de démarrage\nsi vous utilisez grub ou grub2.\n\nPermet de démarrer votre MultiSystem LiveUSB facilement.')"

echo -e "$texte" >/tmp/multisystem/multisystem-download

export INFO='<window title="MultiSystem_PoPuP" window_position="1" icon-name="multisystem-icon" decorated="true" width_request="400" height_request="400">
<vbox>
<button>
<input file icon="multisystem-grub"></input>
<label>"'${vartest}'"</label>
<action>nohup xterm -title 'update-grub' -e "sudo ./boot-grub.sh"&</action>
<action type="exit">exit</action>
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
