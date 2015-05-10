#!/bin/bash

PG_USER=postgres
PG_DATABASE=ufo
PG_TABLE=gdelt_historic

unzip -p $1 | psql -U $PG_USER -d $PG_DATABASE -c "\copy $PG_TABLE from STDIN with csv delimiter E'\t'"