Rscript data/data/scrap_gdelt.R

cat data/data/gdelt/nuevos/*.CSV | cat data/data/gdelt/nuevos/gdelt_headers.tsv -> data/data/gdelt/nuevos/diario.CSV

kite-dataset csv-import data/data/gdelt/nuevos/diario.CSV dataset:hdfs:/user/jared27/datasets/gdelt --delimiter "\t"
kite-dataset csv-import data/data/gdelt/nuevos/diario.CSV dataset:hive:gdelt --delimiter "\t"


rm data/data/gdelt/nuevos/*.CSV
rm data/data/gdelt/*.zip

impala-shell -B -o data/data/gdelt/reporte.csv --output_delimiter=',' -q "select ActionGeo_CountryCode, EventCode, avg(cast(ActionGeo_Lat as float)), avg(cast(ActionGeo_Long as float)), count(ActionGeo_CountryCode) from gdelt where EventCode in (select EventCode from gdelt group by EventCode order by count(EventCode) desc limit 5) group by ActionGeo_CountryCode, EventCode;"
