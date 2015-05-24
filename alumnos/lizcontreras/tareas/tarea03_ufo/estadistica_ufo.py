#!/usr/bin/env python

import re
import sys
import math
from sys import stdin

dat = []
datdat = []
media = 0
maximo = 0
minimo = 0
mediana = 0
varianza = 0
desviacion = 0

while True:
    x = int(sys.stdin.readline())
    dat.append(x)
    datdat.append(x*x)
    if not x:
       break

n = len(dat)
media = int(sum(dat)/n)
maximo = max(dat)
minimo = min(dat)
varianza = int((sum(datdat)/n) - (media*media))
desviacion = int(math.sqrt(varianza))
# Mediana
dat_sort = sorted(dat)
mitad = n / 2
if n % 2 == 0:
   mediana = (dat_sort[mitad + 1] + dat_sort[mitad + 2]) / 2
else:
   mediana = dat_sort[mitad + 1]

print "suma", sum(dat)
print "n=", n
print "Media = ", media
print "Maximo = ", maximo
print "Minimo = ", minimo
print "Mediana = ", mediana
print "Desviacion estandar = ", desviacion
print "Varianza = ", varianza
