#!/bin/sh
gs -q -sPAPERSIZE=letter -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -sOutputFile=21-484Notes.pdf notes/*.pdf
