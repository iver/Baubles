#!/usr/bin/env bash
set -o errexit
set -o nounset

input=~/Documents/2024_12_pago.pdf
outfile=~/Documents/2024_12_pago_op.pdf

gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/screen -dNOPAUSE -dQUIET -dBATCH -sOutputFile=${outfile} ${input}

