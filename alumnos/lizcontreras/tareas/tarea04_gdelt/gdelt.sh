# Se arregla el archivo urls_gdelt.txt

cat urls_gdelt.txt | sed '1d' | sed 's/ / url=/' | cut -d ' ' -f2 > urls.txt

# Descargar los datos en paralelo

parallel -j0 curl --config 'urls.txt' --remote-name
