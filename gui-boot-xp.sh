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

texte="$(eval_gettext 'Ajouter plop bootloader\nau gestionnaire de démarrage de windows vista\nvoir méthode: http://www.plop.at/en/bootmanager.html#runwin')"

echo -e "$texte" >/tmp/multisystem/multisystem-download

export INFO='<window title="MultiSystem_PoPuP" window_position="1" icon-name="multisystem-icon" decorated="true" width_request="400" height_request="400">
<vbox>
<button>
<input file icon="multisystem-windows"></input>
<label>"'$(eval_gettext "Ajouter plop Bootloader à Windows XP")'"</label>
<action>xdg-open http://www.plop.at/en/bootmanager.html#runwin&</action>
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




























