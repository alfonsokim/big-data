#!/bin/bash

# 1. Obtener los avistamientos que se han reportado fuera de Estados Unidos

# Dentro de la base se puede observar que, en general, los avistamientos registrados en otros paises tienen en comun "(" donde se especifica el pais en el que se registro el avistamiento

cat ufo-nov-dic.tsv | cut -f2 | grep -E "?[(]" | sort | wc -l

# Da como resultado 70 avistamientos 

# Para comprobar que se obtuvieron solamente estos avistamientos se da un vistazo a la lista

cat ufo-nov-dic.tsv | cut -f2 | grep -E "?[(]" | sort > avist_otro_pais.txt

# Al obtener la lista se puede observar que dentro existen estados de EEUU por lo que todavía no se cumple el objetivo. Por lo que hay que remover estos de la cuenta de 70.

cat ufo-nov-dic.tsv | cut -f2 | grep -E "?[(]" | grep -E "Queens|Ellicot|Hutchinson|Indianaplis|Los Angeles|Mansfield|New York|Orange|Orlando|Thomas" | sort | wc -l

# De los 70 casos reportados anteriormente hay 15 que tienen una ciudad de Estaodos Unidos entre parentesis por tanto el total de avistamientos en otro país son 55

# 2. Señalar cuantos avistamientos no tienen forma esferoide

cat ufo-nov-dic.tsv | cut -f4 | grep -v "Sphere" | sort | wc -l

# Da como resultado 954

# Para comprobar
cat ufo-nov-dic.tsv | cut -f4 | grep -v "Sphere" | sort | uniq -c > ufo-no-esf.txt
