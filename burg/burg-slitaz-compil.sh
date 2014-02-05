#! /bin/sh
#http://www.burgloader.com/
#http://code.google.com/p/burg/wiki/ManualInstall
#https://launchpad.net/burg

if [ ! "$(which tazpkg)" ]; then
echo tazpkg?
exit 0
fi

if [ "$USER" != "tux" ]; then
echo tux?
exit 0
fi

if [ ! -d "/home/tux" ]; then
echo /home/tux?
exit 0
fi

if [ "$HOME" != "/root" ]; then
xterm -e "gksu "$0";read"
exit 0
fi

tazpkg get-install bazaar
tazpkg get-install gcc
tazpkg get-install bison 
tazpkg get-install autoconf
tazpkg get-install automake
tazpkg get-install make
tazpkg get-install ruby
tazpkg get-install ruby-dev
tazpkg get-install flex --forced


mkdir -p  /usr/local/share
rm -R /usr/local/share/burg 2>/dev/null
rm -R /usr/local/share/burg_pc 2>/dev/null

cd /usr/local/share
bzr branch lp:burg

cd /usr/local/share/burg
./autogen.sh

mkdir /usr/local/share/burg_pc
cd /usr/local/share/burg_pc
/usr/local/share/burg/configure --with-platform=pc --prefix=/usr
make
make install

#Télécharger les thèmes pour Slitaz
#http://code.google.com/p/burg/downloads/list
if [ ! -d "/boot/burg/themes" ]; then
dl_burg="burg-themes_20100506.zip"
mkdir /boot/burg
cd /boot/burg
wget -r -nd http://burg.googlecode.com/files/${dl_burg} 2>&1 \
| sed -u 's/\([ 0-9]\+K\)[ \.]*\([0-9]\+%\) \(.*\)/\2\n#Transfert : \1 (\2) à \3/' \
| zenity --progress --auto-kill --auto-close --width 400
unzip ./${dl_burg}
rm ./${dl_burg}
cd -
fi

exit 0
