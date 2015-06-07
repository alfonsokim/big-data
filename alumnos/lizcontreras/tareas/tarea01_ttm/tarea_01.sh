#!/bin/bash

# Tarea 1

# Descargar el libro The Time Machine de H. G. Wells (ttm)
curl http://www.gutenberg.org/cache/epub/35/pg35.txt > thetimemachine.txt

# Convertir todas las letras a minusculas, mostrar el top 10 de las pablabras empleadas en el texto y guardar el resultado en archivo top10ttm.txt
cat thetimemachine.txt | tr '[:A-Z]' '[:a-z]' | grep -oE '\w+' | sort | uniq -c | sort -r -g | head -n 10 > top10ttm.txt
