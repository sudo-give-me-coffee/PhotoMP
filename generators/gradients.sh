#!/bin/bash

################################################
#                                              #
#  This script generates GIMP gradient files   #
#  from two colors gradients uigradients.com   #
#                                              #
################################################

echo -n "  - Generating gradients..."

mkdir -p "gradients"
cd "gradients"

gradients="$(wget -q -O - 'https://raw.githubusercontent.com/ghosh/uiGradients/master/gradients.json')"

[ ! "${?}" = 0 ]  && { 
  echo "[FAILED]"
  exit 1
}

echo "${gradients}" | grep "\"colors\":" > colors
echo "${gradients}" | grep "\"name\":" > name

function getPercentage(){
  local result=$(echo "${1}/255" | bc -l)
  echo "${result}" | grep -q ^"\\." && {
    result="0${result}"
  }
  [ "${result}" = "1.00000000000000000000" ] && {
    result=1
  }
  echo "${result}"
}

line_number=1

while read line; do
  name=$(sed -n ${line_number}p name | cut -d\" -f4)
  filename=$(echo ${name} | tr ' ' '-')
  line_chars=$(echo ${line} | wc -c )
 
  # Two colors gradients always have 33 chars per line
  [ "${line_chars}" = "33" ] && {
    color1_R=$((16#$(echo ${line} | cut -c 14-15)))
    color1_G=$((16#$(echo ${line} | cut -c 16-17)))
    color1_B=$((16#$(echo ${line} | cut -c 18-19)))
    
    color2_R=$((16#$(echo ${line} | cut -c 25-26)))
    color2_G=$((16#$(echo ${line} | cut -c 27-28)))
    color2_B=$((16#$(echo ${line} | cut -c 29-30)))
    
    color1_R=$(getPercentage ${color1_R})
    color1_G=$(getPercentage ${color1_G})
    color1_B=$(getPercentage ${color1_B})
    
    color2_R=$(getPercentage ${color2_R})
    color2_G=$(getPercentage ${color2_G})
    color2_B=$(getPercentage ${color2_B})
    
    echo "GIMP Gradient" >  "${filename}.ggr"
    echo "Name: ${name}" >> "${filename}.ggr"
    echo "1"             >> "${filename}.ggr"
    echo "0 0.5 1 ${color1_R} ${color1_G} ${color1_B} 1 ${color2_R} ${color2_G} ${color2_B} 1 0 0 0 0" >> "${filename}.ggr"

  }
  line_number=$[1+${line_number}]
done < colors

rm name colors

echo "[OK]"
