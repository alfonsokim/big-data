#!/bin/bash

#chmod +x run.sh  en la terminal para hacerlo ejecutable

for i in *.html; do
    cat $i | python2.7 html_to_csv.py  > $i.csv
    cat $i.csv >> UFOS.csv
done 

cat UFOS.csv | sed '/Date/,/Posted/d' | grep '.'  > UFOS2.csv
cat UFOS.csv | head -1 > head.csv
cat head.csv UFOS2.csv > dataClean.csv
