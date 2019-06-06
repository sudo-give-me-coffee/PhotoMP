#!/bin/bash

HERE="$(dirname "$(readlink -f "${0}")")"

function downloadGIMP () {
  echo "\nDownloading GIMP...\n"

  VERSION="2.10.11-20190530"
  RELEASE_PATH="aferrero2707/gimp-appimage/releases/download/continuous"

  wget -c https://github.com/$RELEASE_PATH/GIMP_AppImage-git-$VERSION-x86_64.AppImage -O GIMP.AppImage

  chmod +x GIMP.AppImage
  ./GIMP.AppImage --appimage-extract 
}

function downloadAppImageTool () {
  echo "\nDownloading AppImageTool...\n"
  wget -c "https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-x86_64.AppImage"
  chmod +x ./appimagetool-x86_64.AppImage
}

function replaceFiles() {
  echo -e "\nCopying new brushes...\n"
  mv PATCH/brushes/* "squashfs-root/usr/share/gimp/2.0/brushes"

  echo -e "\nReplacing splash screen...\n"
  mv "PATCH/splashes/GPS-2_0--splash-techno-dark.png" "squashfs-root/usr/share/gimp/2.0/images/gimp-splash.png"

  echo -e "\nRemoving unneeded files...\n"
  rm -rfv PATCH/brushes
  rm -rfv PATCH/splashes
  rm -rfv PATCH/tags.xml

  mv PATCH/ squashfs-root/
}

function patchIcon() {
  echo -e "\nReplacing AppIcon...\n"

  mv ../gimp.desktop gimp.desktop
  mv ../photogimp.svg photogimp.svg
  ln -fs photogimp.svg .DirIcon
  rm gimp.png
}

function patchStartup() {
  echo -e "\nCreating PhotoGIMP startup script...\n"

  mkdir -p startup_scripts/
  chmod +x ../startup_photogimp.sh
  mv ../startup_photogimp.sh startup_scripts/photogimp.sh
}

function patchWindowIcon() {

  echo -e "\nReplacing window icon...\n"

  find usr/share/gimp/2.0/icons/ -name "gimp-wilber.svg" \
                                 -exec echo rm -v $1 {} \;  \
                                 -exec cp -v photogimp.svg $1 {} \;
}

function patchGIMP() {
  echo -e "\nPatching gimp executable...\n"

  cd usr/bin
  bbe -e 's/You can drop dockable dialogs here/                                  /' gimp-2.10 > gimp.tmp
  bbe -e 's/GNU Image Manipulation Program/PhotoGIMP 2018 for Linux      /' gimp.tmp > gimp-2.10
  chmod +x gimp-2.10

}

function packAppImage() {
  echo -e "\nPackaging AppImage...\n"
  mv squashfs-root PhotoGIMP.AppDir
  ./appimagetool-x86_64.AppImage PhotoGIMP.AppDir
}


unzip PATCH.zip
downloadGIMP 
downloadAppImageTool
replaceFiles
cd squashfs-root
patchIcon
patchStartup
patchWindowIcon
patchGIMP

cd $HERE
packAppImage
