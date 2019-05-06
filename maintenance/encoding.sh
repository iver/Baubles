#!/bin/bash
#enter input encoding here
FROM_ENCODING="ISO-8859"
#output encoding(UTF-8)
TO_ENCODING="UTF-8"
#convert
CONVERT="iconv -c -t $TO_ENCODING"
#loop to convert multiple files
for file in $(find "$PWD" -name *.java); do
  $CONVERT "$file" > "${file}"
  # echo "Archivo: ${file}";
done
exit 0
