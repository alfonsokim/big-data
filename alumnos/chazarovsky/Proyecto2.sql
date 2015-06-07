Proyecto 2
Edwin Chazaro

Para crear el esquema

CREATE TABLE gdelt (field1 varchar(255),field2 varchar(255),field3 varchar(255),field4 varchar(255),field5 varchar(255),field6 varchar(255),field7 varchar(255),field8 varchar(255),field9 varchar(255),field10 varchar(255),field11 varchar(255),field12 varchar(255),field13 varchar(255),field14 varchar(255),field15 varchar(255),field16 varchar(255),field17 varchar(255),field18 varchar(255),field19 varchar(255),field20 varchar(255),field21 varchar(255),field22 varchar(255),field23 varchar(255),field24 varchar(255),field25 varchar(255),field26 varchar(255),field27 varchar(255),field28 varchar(255),field29 varchar(255),field30 varchar(255),field31 varchar(255),field32 varchar(255),field33 varchar(255),field34 varchar(255),field35 varchar(255),field36 varchar(255),field37 varchar(255),field38 varchar(255),field39 varchar(255),field40 varchar(255),field41 varchar(255),field42 varchar(255),field43 varchar(255),field44 varchar(255),field45 varchar(255),field46 varchar(255),field47 varchar(255),field48 varchar(255),field49 varchar(255),field50 varchar(255),field51 varchar(255),field52 varchar(255),field53 varchar(255),field54 varchar(255),field55 varchar(255),field56 varchar(255),field57 varchar(255));

Para cargar las tablas


-- para ingestar todas las tablas

load_tables.sh 

#!/bin/bash

for file in *.zip
do
unzip -p $file | \
psql -U postgres -c "COPY gdelt FROM STDIN WITH DELIMITER E'\t' NULL AS 'NA';"
done

--Consultas



--Selecciona todos los eventos que pertenecen a mexico y los agrupa por el codigo del evento

SELECT field27, count(*)
FROM (SELECT * FROM gdelt
WHERE field17='MEXICO' -- field 17 es el codigo del pais
) AS foo
GROUP BY field27 --field 27 es el codigo del evento
ORDER BY count DESC;

--Inspeccion general

--saca el promedio de la escala de goldstein y el avg tone por mes por pais

SELECT field18, field3, avg(field31::numeric) goldstein, avg(field35::numeric) tone
FROM gdelt
GROUP BY field18, field3
ORDER BY field18, field3;

--SEÑALANDO EL CASO DE MEXICO

SELECT field18, field3, avg(field31::numeric) goldstein, avg(field35::numeric) tone
FROM gdelt
WHERE field18='MCO'
GROUP BY field18, field3
ORDER BY field18, field3;



-- Qué más bases se pueden meter?
para los ultimos años tuiter y sentiment analisis
indicadores economicos a nivel anual
indicadores diarios de la bolsa


KEDS/Reuters Levant
GDELT: Global Data on Events, Location and Tone, 1979-2012. ∗ Kalev Leetaru Philip A. Schrodt
The KEDS Levant data set (http://eventdata.psu.edu/data.dir/levant.html), which cov- ers April-1979 to December-2011, is the only available event data set that is comparable to GDELT in terms of temporal coverage. While it is also coded with Tabari, the dictionaries for this set were extensively configured over a period of years under a number of NSF-funded projects from about 1990 to 2005—the Tabari .verbs dictionaries used for the global cod- ing were largely developed on Levant texts—whereas GDELT uses generic global .actors and .agents dictionaries. In this respect, comparing the two datasets is an assessment of whether the GDELT approach using global dictionaries produces results comparable to the laboriously hand-tuned KEDS data.
The larger difference between the two sets, however, is in the sources. The Levant data consists of two single-source datasets, one based in Reuters, the other—covering only 2000 to the present—on AFP.6 GDELT, of course, uses a much larger set of sources—though it does not directly incorporate Reuters—so any differences between the two sets will be a function of both the dictionaries and the sources.


