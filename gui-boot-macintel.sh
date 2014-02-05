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


texte="$(eval_gettext 'Démarrer votre MultiSystem LiveUSB depuis un Macintel,\nJe ne dispose pas de Macintel pour tester cete solution,\net à ce jour pas de retour utilisateur.\nPostez un retour SVP, si cela marche pour vous...\nhttp://refit.sourceforge.net/#news')"

echo -e "$texte" >/tmp/multisystem/multisystem-download

export INFO='<window title="MultiSystem_PoPuP" window_position="1" icon-name="multisystem-icon" decorated="true" width_request="400" height_request="400">
<vbox>
<button>
<input file icon="multisystem-apple"></input>
<label>"'$(eval_gettext "Télécharger rEFIt")'"</label>
<action>xdg-open http://refit.sourceforge.net/#news&</action>
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




























