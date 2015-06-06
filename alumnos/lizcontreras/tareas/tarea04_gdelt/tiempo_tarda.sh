#!/bin/bash

#Procesamiento en serie
{ time ./proc_serie.sh; } 2> time_serie.txt

#Procesamiento en serie sin cut
{ time ./proc_serie_sincut.sh; } 2> time_serie_sincut.txt

#Procesamiento en paralelo
{ time ./proc_paralelo.sh; } 2> time_paralelo.txt

#Procesamiento en paralelo sin cut
{ time ./proc_paralelo_sincut.sh; } 2> time_paralelo_sincut.txt
