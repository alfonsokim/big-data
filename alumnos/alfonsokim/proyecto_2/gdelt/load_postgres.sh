#!/bin/bash

PG_USER=postgres
PG_DATABASE=ufo
PG_TABLE=gdelt_reduced

unzip -p $1 | ./filter_columns.sh | psql -U $PG_USER -d $PG_DATABASE -c "\copy $PG_TABLE from STDIN with csv delimiter E'\t'"