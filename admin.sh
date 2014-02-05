#! /bin/bash
chemin="$(cd "$(dirname "$0")";pwd)/$(basename "$0")";
dossier="$(dirname "$chemin")"
cd "${dossier}"
###Pour exporter la librairie de gettext.
set -a
source gettext.sh
set +a
export TEXTDOMAIN=multisystem
export TEXTDOMAINDIR="${dossier}/locale"
. gettext.sh
multisystem=$0

#_________________________________________________
#░▒▓███████████████████ADMIN███████████████████▓▒░

#si dans /usr/local/share/multisystem
if [[ ! "$SUDO_USER" && "${dossier}" == "/usr/local/share/multisystem" ]]; then
gksudo -k "$chemin"
exit 0
fi

mkdir /tmp/multisystem 2>/dev/null


#liste des langues
#VARLANGUES="fr en es de it"
#cat /usr/share/language-selector/data/languagelist
selang="$(cat "${dossier}/lang_list.txt")"
VARLANGUES="$(echo -e "$selang" | awk -F"|" '{print $2}' | xargs)"

##Voir fichier ==> .../lang_list.txt
#Et modifier aussi support dans fichier ==> .../gui_multisystem.sh
##Voir fichier ==> .../gui_lang.sh
#Rajouter icone drapeau si pas présente.

#English|en|en_US.UTF-8|Ryan J Nicholson|rjn256@gmail.com
#Spanish|es|es_ES.UTF-8|Jesús MUÑOZ|jesus.munoz@luztic.org
#French|fr|fr_FR.UTF-8|Fabre François|liveusb@gmail.com
#Hebrew|he|he_IL.UTF-8|Matanya Moses|matanya.moses@gmail.com
#Portuguese|pt|pt_PT.UTF-8|Pedro Peres|peter.p@sapo.pt
#Italian|it|it_IT.UTF-8|Federico Kircheis|fekir1.618@gmail.com
#German|de|de_DE.UTF-8|Daniel|daniel@daniel-ritter.de
#Dutch|nl|nl_NL.UTF-8|Jeroen|webmaster@jvanoort.nl
#Portuguese (Brazil)|pt_BR|pt_BR.UTF-8|Eduengler|eduengler@gmail.com
#Czech|cs|cs_CZ.UTF-8|kubijo|kubijo@gmail.com
#Türkçe|tr_TR|tr_TR.UTF-8|M.Emin KARA|meminkara@yahoo.com
#Croatian|hr|hr_HR.UTF-8|Goran Vidovic|trebelnik2@gmail.com
#Russian|ru|ru_RU.UTF-8|Stas kolobkov|zetwin@gmail.com
#Romanian|ro|ro_RO.UTF-8|Marian Vasile|marianvasile@upcmail.ro
#Chinese|zh_CN|zh_CN.UTF-8|Gavin|bjeasy@163.com
#Greek|el_GR|el_GR.UTF-8|Efstathios Iosifidis|diamond_gr@freemail.gr
#Indonesian|id_ID|id_ID.UTF-8|Rahadian Koesdijarto Putra|rahadian.ironman@gmail.com
#Hungarian|hu|hu_HU.UTF-8|Zsolt Boldizsár|boldizsarzsolt@gmail.com
#A corrigé le Tchèque/Czech => Josef Kubíček|kubijo@gmail.com
#Bulgarian|bg|bg_BG.UTF-8|Havy D|hhavyy@gmail.com
#Polish|pl|pl_PL.UTF-8|Igor Vozny|igor.vozny@gmail.com


#En cours, ou du moins ont proposé de traduire...
#Norwegian|||Hans-Olav Kalleberg|hans.olav@hybelen.net
#Bengali|bn|bn_BD||ashickur.noor@gmail.com
#Estonian|et|et_EE.UTF-8|Kaarel|kaar3l@gmail.com
#Bulgarian|bg|bg_BG.UTF-8|Plamen Peev|peev.pl@gmail.com
#Arabe|ar|ar_EG.UTF-8|kaspi124|kaspi124


#liste des fichiers a prendre en compte pour traduction des .po
list_po="
"${dossier}"/admin.sh
"${dossier}"/cdamorce.sh
"${dossier}"/colorpicker.sh
"${dossier}"/fonctions.sh
"${dossier}"/gui-detect.sh
"${dossier}"/gui-infodl.sh
"${dossier}"/gui_multisystem.sh
"${dossier}"/gui-pref.sh
"${dossier}"/install.sh
"${dossier}"/qemu.sh
"${dossier}"/vbox.sh
"${dossier}"/vbox_install.sh
"${dossier}"/VBox_livecd_gui.sh
"${dossier}"/uninstall.sh
"${dossier}"/update_deb.sh
"${dossier}"/update-sel.sh
"${dossier}"/update-src.sh
"${dossier}"/gui-boot-grub.sh
"${dossier}"/gui-boot-macintel.sh
"${dossier}"/gui-boot-vista.sh
"${dossier}"/gui-boot-xp.sh
"${dossier}"/boot-grub.sh
"${dossier}"/gui_lang.sh
"${dossier}"/gui_multi_sel.sh
"${dossier}"/gui-persistent.sh
"${dossier}"/fonctions-nonfree.sh
"${dossier}"/gui-burg.sh
"${dossier}"/gui-update.sh
"${dossier}"/gui-modmenus.sh
"${dossier}"/os_support.sh
"${dossier}"/gui_cmdline.sh
"${dossier}"/update_grub.sh
"${dossier}"/iso_add.sh
"${dossier}"/iso_remove.sh
"${dossier}"/iso_selup.sh
"${dossier}"/iso_seldown.sh
"${dossier}"/iso_move.sh
"${dossier}"/iso_menus.sh
"${dossier}"/iso_modpersistent.sh
"
export list_po

#Attention pour que gettext ne se plante pas dans les traductions remplacer ' et \' et '\'' par son equivalent en octal \047
#pour les simple quote: ' ==> \\047
#et pour les double quote: " ==> \\042

#$(eval_gettext "Temps d\047execution: \$MIN Minutes et \$SEC Secondes")
#$(eval_gettext "")
#$(eval_gettext "Choisir l\047option \$var")
#$(eval_gettext '')
#
#syntaxe a adopter dans les fichiers en gtkdialog
#"'$(eval_gettext '')'"
#"'$(eval_gettext '')'"
#"'$(eval_gettext "Editer \$HOME/.md5_live_perso.txt")'"
#"'$(eval_gettext "Chemin de l'iso:")'"
#export LC_ALL=fr_FR.UTF-8
#export LC_ALL="en_US.UTF-8"


#Menage, virer les sauvegardes!
find "${dossier}" | egrep "~$" | perl -n -e 'system("rm $_");'

#menage dans grub
rm "${dossier}"/boot/grub/*.mod 2>/dev/null
rm "${dossier}"/boot/grub/*.img 2>/dev/null
rm "${dossier}"/boot/grub/*.map 2>/dev/null
rm "${dossier}"/boot/grub/grub_eltorito 2>/dev/null
#menage isolinux
sudo rm -Rf "${dossier}"/isolinux 2>/dev/null
#
rm "${dossier}"/nohup.out 2>/dev/null

function internationalisation()
{
#Mettre en place internationalisation
cd "${dossier}"
#Créer les .po
for L in $VARLANGUES
do
if [ ! -e "${dossier}/locale/${L}/LC_MESSAGES/multisystem.${L}.po" ]; then 
echo -e "Créer: ${L}"
mkdir -p "${dossier}/locale/${L}/LC_MESSAGES"
xgettext --from-code=UTF-8 \
--no-location \
-L shell --no-wrap \
-o "${dossier}/locale/${L}/LC_MESSAGES/multisystem.${L}.po" $(printf "$list_po" | xargs)
#Modifier CHARSET
sed -i "s%charset=CHARSET%charset=UTF-8%" "${dossier}"/locale/${L}/LC_MESSAGES/multisystem.${L}.po
#Créer les binaires .mo
msgfmt -o "${dossier}"/locale/${L}/LC_MESSAGES/multisystem.mo \
"${dossier}"/locale/${L}/LC_MESSAGES/multisystem.${L}.po
fi
done
}
internationalisation


#Appliquer manuellement apres chaque modification du script!
function internationalisation_update()
{

#mise à jour. ,regenerer les .po avec en plus les nouveaux champs.
for L in $VARLANGUES
do
xgettext -join-existing \
--no-location \
--from-code=UTF-8 \
--package-name=multisystem \
-L shell \
--no-wrap \
-o "${dossier}"/locale/${L}/LC_MESSAGES/multisystem.${L}.po $(printf "$list_po" | xargs)
done

#Recréer les .mo
for L in $VARLANGUES
do
msgfmt \
-o "${dossier}"/locale/${L}/LC_MESSAGES/multisystem.mo \
"${dossier}"/locale/${L}/LC_MESSAGES/multisystem.${L}.po
done

#Retraduire les champs msgstr non traduits avec poedit ou gtranslator
#Editeurs poedit, gtranslator, ...

if [ ! "$(which poedit)" ]; then
sudo apt-get install -y poedit
fi

echo  'zenity \
--title="Live CD" \
--text="Veuillez sélectionner le fichier .po à traduire
dans la liste ci-dessous.
ATTENTION!
Veuillez respecter la longueur des phrases
ainsi que les saut de lignes sous peine
de provoquer des bogs d'\''affichage
ne traduisez pas les variables commençant par $
" \
--width=360 \
--height=400 \
--list \
--print-column="2" \
--radiolist \
--separator=" " \
--column="*" \
--column="Val" \' >/tmp/multisystem/multisystem-tr
echo -e "$(ls -A "${dossier}"/locale | tr " " "\n" | awk '{print "FALSE " $0 " \\"}')" >>/tmp/multisystem/multisystem-tr
RETOUR_TRANSLATE=$(. /tmp/multisystem/multisystem-tr)
if [ -e "${dossier}/locale/${RETOUR_TRANSLATE}/LC_MESSAGES/multisystem.${RETOUR_TRANSLATE}.po" ]; then
poedit "${dossier}"/locale/${RETOUR_TRANSLATE}/LC_MESSAGES/multisystem.${RETOUR_TRANSLATE}.po
msgfmt -o "${dossier}"/locale/${RETOUR_TRANSLATE}/LC_MESSAGES/multisystem.mo \
"${dossier}"/locale/${RETOUR_TRANSLATE}/LC_MESSAGES/multisystem.${RETOUR_TRANSLATE}.po
else
#Supprimer
rm -R /tmp/multisystem
exit 0
fi

}
internationalisation_update
echo -e "\033[1;47;31m Attention, pensez a faire une copie en local du fichier:${dossier}/locale/*/LC_MESSAGES/multisystem.*.po\nCar toute mise à jour n\047integrant pas ce fichier l\047ecrasera\!,\net vous perdrez votre travail... \033[0m"

#Supprimer
rm -R /tmp/multisystem
exit 0


#virer commentaires
find /home/frafa/Documents/sauvegarde/scripts/multisystem/multisystem/locale/ \
-iname "*.po" -exec sed -i "s@#: /home/frafa/Documents/sauvegarde/scripts/multisystem/multisystem/.*@@g" {} \;
#virer lignes vides
find /home/frafa/Documents/sauvegarde/scripts/multisystem/multisystem/locale/ \
-iname "*.po" -exec sed -i "/^$/d" {} \;
