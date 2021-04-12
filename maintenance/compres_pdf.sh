#!/usr/bin/env bash
set -o errexit
set -o nounset

outfile=triptico_a.pdf
input=triptico_sec.pdf

gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/screen -dNOPAUSE -dQUIET -dBATCH -sOutputFile=${input} ${outfile}

