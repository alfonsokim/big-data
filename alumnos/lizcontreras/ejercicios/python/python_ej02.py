#!/usr/bin/env python

import re
import sys

n = int(sys.argv[1]) # Leemos un entero como argumento (opcional)

while True:
  linea = sys.stdin.readline()

  if not linea:
    break
