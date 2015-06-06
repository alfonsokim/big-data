#!/usr/bin/python
from bs4 import BeautifulSoup
import sys
import re
import csv

def cell_text(cell):
    return " ".join(cell.stripped_strings).encode('utf8')

soup = BeautifulSoup(sys.stdin.read())
output = csv.writer(sys.stdout)

for table in soup.find_all('table'):
    for row in table.find_all('tr'):
        col = map(cell_text, row.find_all(re.compile('t[dh]')))
        output.writerow(col)
    output.writerow([])
