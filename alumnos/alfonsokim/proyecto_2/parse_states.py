#!/usr/bin/env python

import sys
import xml.etree.ElementTree as ET

# ============================================================
def dump_state(state):
    """ Escribe el nombre del estado y sus puntos a la salida
        estandar. Revisar el formato de postgis
        :param state: El diccionario con el estado"
    """
    points_str = ','.join(('%s %s' % (p[0], p[1])) for p in state['points'])
    print '%s|%s' % (state['name'], points_str)

# ============================================================
def parse_states(states_file):
    """ Parsea el archivo buscando estados y sus poligonos
        :param states_file: El archivo con los estados
        :return: Generador con un diccionario por estado
    """
    for child in ET.parse(states_file).getroot():
        yield {'name': child.get('name'), 
               'points': [(p.get('lat'), p.get('lng')) for p in child.findall('point')]}            

# ============================================================
if __name__ == '__main__':
    """ Punto de entrada, recibe de argumento el nombre del archivo xml
    """
    for state in parse_states(sys.argv[1]):
        dump_state(state)