#!/bin/bash

HERE="$(dirname "$(readlink -f "${0}")")"

if [ -z ${XDG_CONFIG_HOME} ]; then
  export GIMP2_DIRECTORY="${HOME}/.config/PhotoMP/";
else
  export GIMP2_DIRECTORY="${XDG_CONFIG_HOME}/PhotoMP/";
fi

mkdir -p "${GIMP2_DIRECTORY}/gradients"

if [ ! -f "${GIMP2_DIRECTORY}/firstrun" ]; then
  mkdir -p "${GIMP2_DIRECTORY}";
  cp -rf "${HERE}/configuration/sessionrc" "${GIMP2_DIRECTORY}";
fi

echo > "${GIMP2_DIRECTORY}/firstrun"
