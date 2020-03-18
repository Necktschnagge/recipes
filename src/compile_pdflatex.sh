#!/bin/bash
pdflatex -synctex=1 -interaction=nonstopmode book.tex > custom_log.log
cat custom_log.log
cat custom_log.log | grep -E 'at\s*line(s|)\s*[0-9]+' > custom_errors.log || true
cat custom_errors.log
../script/check_empty.sh
