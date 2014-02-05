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

#zenity --info --text "Attente"
#sleep .5

PID_SCRIPT=$(pidof -x $(basename $0))

rm "$dossier"/nohup.out 2>/dev/null
rm -R /tmp/multisystem 2>/dev/null
#killall gui_multisystem.sh
wmctrl -c MultiSystem-logo 2>/dev/null
wmctrl -c VBox 2>/dev/null
#wmctrl -c MULTISYSTEM 2>/dev/null
test "$(wmctrl -p -G -l | grep '400.*420' | grep ' MultiSystem$' | awk '{print $1}')" && wmctrl -c $(wmctrl -p -G -l | grep '400.*420' | grep ' MultiSystem$' | awk '{print $1}') 2>/dev/null

#zenity --info --text "Attente"
kill $(ps axu | grep "/bin/bash.*gui_multisystem.sh" | grep -v grep | xargs) 2>/dev/null
kill -9 $(lsof | grep ${dossier} | awk '{print $2}' | grep -v ${PID_SCRIPT} | xargs) 2>/dev/null
kill -9 $(ps aux | grep ${dossier} | grep -v ${PID_SCRIPT} | grep /bin/bash | grep -v grep | awk '{print $2}' | xargs) 2>/dev/null
kill -9 $(ps ax | grep gtkdialog | grep MULTISYSTEM | awk '{print $1}')
exit 0
