import sys
from datetime import datetime
import matplotlib.pyplot as plt

DATE_FORMATS = ['%m/%d/%y %H:%M', '%m/%d/%y']

# ==================================================================
def safe_parse_date(date_str):
    """ Intenta convertir un string a fecha usando 2 formatos,
        si no puede devuelve None en lugar de tronar
        :param date_str: La fecha en string
    """
    for format in DATE_FORMATS:
        try: return datetime.strptime(date_str, format)
        except: continue
    return None

# ==================================================================
def format_datetime(header=True):
    line = sys.stdin.readline()
    bad_dates = 0
    while line:
        data = line.strip().split('|')
        date = safe_parse_date(data[1])
        if date and len(data) == 9:
            data[1] = date.strftime('%Y-%m-%d %H:%M:%S')
        else:
            data[1] = '1900-01-01 00:00:00'
            bad_dates += 1
        if len(data) == 9:
            print '|'.join(data)
        line = sys.stdin.readline()
    #print 'Malas: %i' % bad_dates

# ==================================================================
if __name__ == '__main__':
    format_datetime()