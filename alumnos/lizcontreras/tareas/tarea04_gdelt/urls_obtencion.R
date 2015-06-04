# Obtener el archivo que contenga una lista con las URLS

library(rvest)

lista_url <- "http://data.gdeltproject.org/events/"

# Se obtiene el index
index <- html(paste0(lista_url, "index.html"))

# Se obtienen las URLS por dia
urls_diarias <- paste0(index  %>%
                       html_nodes(xpath = "// /a[contains(@href, 'export')]")  %>%
                       html_attr("href")
)

# Se completan las URLS
urls <- paste0(lista_url, urls_diarias)

# Se guarda en un archivo .txt
write.table(urls_diarias, "urls_gdelt.txt")
