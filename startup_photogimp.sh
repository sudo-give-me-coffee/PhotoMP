#!/bin/bash

HERE="$(dirname "$(readlink -f "${0}")")"

if [ -z ${XDG_CONFIG_HOME} ]; then
  export GIMP2_DIRECTORY="$HOME/.config/PhotoGIMP/";
else
  export GIMP2_DIRECTORY="$XDG_CONFIG_HOME/PhotoGIMP/";
fi

mkdir -p "$GIMP2_DIRECTORY/gradients"

if [ ! -f "$GIMP2_DIRECTORY/firstrun" ]; then
  mkdir -p "$GIMP2_DIRECTORY";
  cp -rf "$HERE/PATCH"/* "$GIMP2_DIRECTORY";
fi

echo > "$GIMP2_DIRECTORY/firstrun"