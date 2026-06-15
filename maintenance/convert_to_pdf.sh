#!/usr/bin/env bash
set -o errexit
set -o nounset

# previous=""
for file in $(ls -1 imagenes/*.HEIC);
do
  # echo "fil-> ${file%.JPG}"
  # previous="${previous} ${file%.JPG}.pdf"
  convert "${file}" -resize 1024x -quality 80% "${file%.HEIC}.pdf"
done
# echo "salida-> ${previous}"
