#!/bin/bash
# Porteus-openbox strip script
# After installing packages to a directory
# copy the TREE here and run this script

if [ `uname -m|grep -o 64` ]; then
  LIB="usr/lib64"
  SHARCH=64
  LIBSUFFIX=64
  SUFFIX=64
  else
  LIB="usr/lib"
  SHARCH=32
  LIBSUFFIX=""
  SUFFIX=32
fi

CWD=`pwd`
exp=../export${SUFFIX}
MODULE="003-box.xzm"

echo "Size BEFORE stripping: `du -sh`"

########### CUSTOM PORTEUS STUFF #############
rm -rf install
rm -rf usr/var/lib/scrollkeeper
rm -rf usr/share/swat/*
rm -rf usr/share/devhelp/*
rm -rf usr/share/gnome/help/*
rm -rf usr/share/help/*
rm -rf var/lib/scrollkeeper/*
rm -rf var/scrollkeeper/*
rm -f usr/share/applications/gksu.desktop
rm -f usr/share/applications/uxterm.desktop
rm -f usr/share/applications/xhtml2ps.desktop
rm etc/xdg/autostart/polkit-gnome-authentication-agent-1.desktop

## Create symlinks
#ln -sf /etc/X11/xinit/xinitrc.openbox etc/X11/xinit/xinitrc
[ ! -d opt/porteus-scripts/xorg ] && mkdir -p opt/porteus-scripts/xorg
ln -sf /usr/bin/gksu opt/porteus-scripts/xorg/psu
ln -sf /usr/bin/spacefm opt/porteus-scripts/xorg/fmanager
ln -sf /usr/bin/beaver opt/porteus-scripts/xorg/editor
ln -sf /usr/bin/sakura opt/porteus-scripts/xorg/terminal
if [ "$SHARCH" = "64" ]; then
[ ! -e usr/lib64/libudev.so.1 ] && ln -sf /lib64/libudev.so.0.13.1 usr/lib64/libudev.so.1
fi

## Fix/remove some icons
#usip=usr/share/icons/Paper
#if [ -d $usip ]; then
#	rm -rf usr/share/icons/Paper/512x512@2x/*
#	rm -rf usr/share/icons/Paper/512x512/*
#	for a in `cat $CWD/../scripts/paper-icon-strip.txt`; do find $usip -type f -name "$a*" | xargs -n1 -i rm {}; done
#	for a in `cat $CWD/../scripts/paper-icon-strip.txt`; do find $usip -type l -name "$a*" | xargs -n1 -i rm {}; done
#	cd usr/share/icons/Paper/scalable/actions
#	ln -s help-info-symbolic.svg gtk-info.svg
#	find -L $usip -type l|xargs -n1 -i rm {}
#fi

# Recompress svgz icons:
#for x in `find -type f -name "*.svgz"`; do zcat $x > /tmp/.file 2>/dev/null && mv /tmp/.file $x; done

#ln -sf /usr/share/icons/Faenza/mimetypes/48/encrypted.png usr/share/pixmaps/porteus/binary.png
#ln -sf /usr/share/icons/Faenza/apps/48/help-browser.png usr/share/pixmaps/help-hint.png

# Clipman panel icon for dark background
#for a in `find usr/share/icons/ -name "edit-paste*" | grep Faenza-Dark | egrep "/32/|/24/|/22/"`; do
#rm $a
#ln -sf /usr/share/icons/Faenza-Dark/status/24/gtg-panel.png $a
#done
find usr/share/icons/hicolor/256x256/ -type f|xargs rm
find usr/share/icons/hicolor/128x128/ -type f|xargs rm
find usr/share/icons/hicolor/scalable/ -type f|xargs rm

## Remove misc gtk3 stuff
rm -rf usr/share/gtk-3.0/demo/*
rm usr/bin/gtk3-demo-application
rm usr/bin/gtk3-demo
rm usr/bin/gtk3-widget-factory
rm usr/share/applications/gtk3-demo.desktop
rm usr/share/applications/gtk3-widget-factory.desktop
#[ "$SUFFIX" == "32" ] && rm -r usr/lib64

## Theme changes
rm -rf usr/share/themes/{HighContrast,Clearlooks,Crux,ThinIce,Mist,Industrial}

## Remove broken links
icons=usr/share/icons
find -L $icons -type l -delete

## Remove xbit from icon theme.
find usr/share/icons -type f|xargs chmod -x 2>/dev/null
# Apply porteus patches:
for x in `find openbox-patches -type f`; do patch -p1 < $x; done
rm -rf openbox-patches

## Fix some menu items
sed -i 's/Exec=.*/Exec=gksu gparted/g' usr/share/applications/gparted.desktop
#sed -i 's/Utility;/Graphics;/g' usr/share/applications/gcolor2.desktop

## suid slock
#chmod u+s usr/bin/slock

### make version file
echo "$MODULE:`date +%Y%m%d`" > etc/porteus/${MODULE%.*}.ver

########### END OF CUSTOM PORTEUS STUFF ##########

# Remove unnecessary stuff:
find . -type f -name "*~"|xargs rm -f
rm -rf usr/info/*
rm -rf usr/doc/*
rm -rf usr/man/*
rm -rf usr/share/gtk-2.0/demo
rm -rf usr/share/gtk-doc/*
rm -rf usr/share/doc
rm -rf var/log/scripts/*
rm -rf var/log/setup/*
rm -rf var/log/removed*
rm -rf usr/share/gnome-session/sessions/*
rm -rf usr/share/xsessions/openbox-kde.desktop
rm -rf usr/share/xsessions/openbox-gnome.desktop
#rm etc/xfce/xdg/autostart/xscreensaver.desktop
#rm usr/lib64/libgcr-ui*
#rm usr/bin/gcr-viewer
#rm usr/share/applications/gcr-viewer.desktop
#rm usr/share/applications/gcr-prompter.desktop
rm usr/share/applications/compton.desktop
#rm usr/share/applications/tint2conf.desktop
rm -rf usr/src/*

# Strip icons
#rm openbox-icon-remove.txt

# Remove HighContrast icons
rm -rf usr/share/icons/HighContrast

#remove large hicolor icons and 64 icons in Humanity if present
( cd usr/share/icons; for a in 64 128x128 256x256 64x64 96x96 160x160 192x192 72x72; do find . -name $a|xargs rm -rf; done )

# Setup export directory for 05-devel and language-selection-tool
[ ! -d $exp/include ] && mkdir -p $exp/include
[ ! -d $exp/togo/locale ] && mkdir -p $exp/togo/locale
echo "Removing old local headers and locales"
rm -rf $exp/include/* 2>/dev/null
rm -rf $exp/togo/locale/* 2>/dev/null

# Set default perms, extract compressed files, strip debugging symbols:
echo "Changing permissions..."
find ./ -type d | xargs chmod -v 755 >/dev/null 2>&1
echo "Extracting All manpages..."
find . | grep .gz | xargs gunzip >/dev/null 2>&1
echo "stripping Unneeded Symbols..."
find . | xargs file | grep ELF | cut -f 1 -d : | xargs strip --strip-unneeded >/dev/null 2>&1

# Set correct permissions
chown -R 1000:1000 home/guest
chown -R root:root root opt usr/share/applications  

# Move headers, .gir/.cmake files:
find -type f -name "*.h" | xargs -n1 -i cp -a --parents {} $exp/include
rm -rf usr/include/*
cp -a --parents  usr/share/gir-1.0 $exp/include
rm -rf  usr/share/gir-1.0

# Remove static headers
find . -name "*.a" | xargs -n1 -i cp -a --parents {} $exp/include
find . -name "*.a" | xargs rm -f
find . -name "*.la" | xargs -n1 -i cp -a --parents {} $exp/include
find . -name "*.la" | xargs rm -f

# Move translations/localized man pages:
echo "moving locales"
cp -a usr/share/locale/* $exp/togo/locale/
rm -rf usr/share/locale/*


for x in `ls usr/man | grep -v man`; do
rm -r usr/man/$x
done

echo "COMPLETE!"
echo "Size AFTER stripping: `du -sh`"