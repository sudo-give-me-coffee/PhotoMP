#!/bin/bash

###################################################################
#                                                                 #
#  Download GIMP 2.10, AppImageTool and PhotoGIMP patch           #
#                                                                 #
###################################################################

echo -e "\nDownloading components...\n"
wget -c "https://github.com/aferrero2707/gimp-appimage/releases/download/continuous/GIMP_AppImage-git-2.10.9-withplugins-20190328-x86_64.AppImage"
wget -c "https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-x86_64.AppImage"
wget -c "https://dl.bintray.com/sudo-give-me-coffee/granite/PHOTOGIMP-2018.zip"
chmod +x ./GIMP_AppImage-git-2.10.9-withplugins-20190328-x86_64.AppImage
chmod +x ./appimagetool-x86_64.AppImage

pwd

###################################################################
#                                                                 #
#  Extract GIMP and PhotoGIMP patch                               #
#                                                                 #
###################################################################

echo -e "\nExtracting components...\n"

./GIMP_AppImage*.AppImage --appimage-extract 
unzip -o "PHOTOGIMP-2018" -d .
mv "PHOTOGIMP V2018 - DIOLINUX/PATCH/" .
mv PATCH squashfs-root/
cd squashfs-root

###################################################################
#                                                                 #
#  Move custom brushes and replace splashscreen                   #
#                                                                 #
###################################################################

echo -e "\nCopying new brushes...\n"
mv PATCH/brushes/* "usr/share/gimp/2.0/brushes"

echo -e "\nReplacing splash screen...\n"
mv "PATCH/splashes/GPS-2_0--splash-techno-dark.png" "usr/share/gimp/2.0/images/gimp-splash.png"

echo -e "\nRemoving unneeded files...\n"
rm -rfv PATCH/brushes
rm -rfv PATCH/splashes
rm -rfv PATCH/tags.xml

###################################################################
#                                                                 #
#  Download icon and patch desktop laucher                        #
#                                                                 #
###################################################################

echo -e "\nDownloading AppIcon...\n"
wget -c "https://dl.bintray.com/sudo-give-me-coffee/granite/PhotoGIMP.svg" -O photogimp.svg
ln -fs photogimp.svg .DirIcon
rm gimp.png

echo -e "\nPatching Desktop file...\n"
sed -i '/^Name\[/d' gimp.desktop
sed -i 's/GNU Image Manipulation Program/PhotoGIMP 2018/g' gimp.desktop
sed -i 's/Icon=gimp/Icon=photogimp/g' gimp.desktop

###################################################################
#                                                                 #
#  Create helper script, they will set the "home" to the GIMP     #
#  settings and create a basic environment that repositions       #
#  items                                                          #
#                                                                 #
###################################################################

echo -e "\nCreating PhotoGIMP startup script...\n"

cat > startup_scripts/photogimp.sh <<\EOF
#!/bin/bash

  HERE="$(dirname "$(readlink -f "${0}")")"

  if [ -z ${XDG_CONFIG_HOME} ]; then
    export GIMP2_DIRECTORY="$HOME/.config/PhotoGIMP/";
  else
    export GIMP2_DIRECTORY="$XDG_CONFIG_HOME/PhotoGIMP/";
  fi

  mkdir -p "$XDG_CONFIG_HOME/PhotoGIMP/gradients"

  if [ ! -f "$XDG_CONFIG_HOME/PhotoGIMP/firstrun" ]; then
    mkdir -p "$GIMP2_DIRECTORY";
    cp -rf "$HERE/PATCH"/* "$GIMP2_DIRECTORY";
  fi

  echo > "$XDG_CONFIG_HOME/PhotoGIMP/firstrun"

EOF

chmod +x startup_scripts/photogimp.sh

###################################################################
#                                                                 #
#  Replace default window icon (Wilber)                           #
#                                                                 #
###################################################################

echo -e "\nReplacing window icon...\n"

find usr/share/gimp/2.0/icons/ -name "gimp-wilber.svg" \
                               -exec echo rm -v $1 {} \;  \
                               -exec cp -v photogimp.svg $1 {} \;

###################################################################
#                                                                 #
#  Patch gimp-2.10 binaries                                       #
#                                                                 #
###################################################################

echo -e "\nPatching gimp executable...\n"

cd usr/bin
bbe -e 's/You can drop dockable dialogs here/                                  /' gimp-2.10 > gimp.tmp
bbe -e 's/GNU Image Manipulation Program/PhotoGIMP 2018 for Linux      /' gimp.tmp > gimp-2.10
chmod +x gimp-2.10

###################################################################
#                                                                 #
#  Turn squashfs-root into AppDir                                 #
#                                                                 #
###################################################################

cd ../../../
mv squashfs-root PhotoGIMP.AppDir
chmod +x appimagetool-x86_64.AppImage

###################################################################
#                                                                 #
#  Pack AppImage file                                             #
#                                                                 #
###################################################################

echo -e "\nPackaging AppImage\n"

./appimagetool-x86_64.AppImage PhotoGIMP.AppDir

exit 0


