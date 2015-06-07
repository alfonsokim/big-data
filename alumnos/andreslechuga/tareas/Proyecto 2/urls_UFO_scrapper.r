library(rvest)
library(parallel)
library(dplyr)

url_base <- "http://www.nuforc.org/webreports/"

# Para obtener el índice
index_url_ufo <- html(paste0(url_base, "ndxevent.html"))

# Puedo utilizar Xpath para navegar por el árbol
# En este caso en particular obtengo la seguna columna (el conteo de observaciones)
reportes_ufo <-index_url_ufo %>%
  html_nodes(xpath = "//*/td[2]")

# Obtenemos las URLs de las páginas por día
everyday_urls <- paste0(url_base, reportes_ufo %>%
                       html_nodes(xpath = "//*/td[1]/*/a[contains(@href, 'ndxe')]")  %>%
                       html_attr("href")
)

everyday_urls <- unique(everyday_urls)
# eliminamos el ultimo que no tiene fecha especificada
everyday_urls <- everyday_urls[which(everyday_urls!="http://www.nuforc.org/webreports/ndxe.html")]

# guardamos lo primero que necesitamos
save(url_base, everyday_urls, file="/Users/lechuga/Desktop/Andres/ESCUELA/ITAM/CLASES/2do semestre/Metodos a gran escala/Proyecto 2/datos/urls_UFO.rdata")

# reportes
tables <- mclapply(everyday_urls, FUN=function(x){
  x %>% 
    html %>% 
    html_table(fill=T) }, mc.cores = getOption("mc.cores", 4L))

tables_complete <- mclapply(tables, FUN=function(x){data.frame(x[1])})
ufos_1 <- Reduce("rbind", tables_complete)

#Jala las tablas de la pagina en formato de lista
table <- everyday_urls[1] %>%
     html  %>%
     html_table(fill = TRUE)
 

# podemos traer la primera opción de la tabla 
 table_2  <-  everyday_urls[1] %>%
     html %>%
     html_nodes(xpath = '//*/table[1]') %>%
     html_table(fill = TRUE)

#salvamos los datos 
saveRDS(ufos_1, file="/Users/lechuga/Desktop/Andres/ESCUELA/ITAM/CLASES/2do semestre/Metodos a gran escala/Proyecto 2/datos/ufos_1.rds")  #antes ufos_p1.rds
saveRDS(table_2, file="/Users/lechuga/Desktop/Andres/ESCUELA/ITAM/CLASES/2do semestre/Metodos a gran escala/Proyecto 2/datos/ufos_2.rds") #antes ufos_p2.rds
load("/Users/lechuga/Desktop/Andres/ESCUELA/ITAM/CLASES/2do semestre/Metodos a gran escala/Proyecto 2/datos/urls_UFO.rdata")

# Queremos quedarnos tambien con los reportes de los avistamientos
get_reportes_urls <- function(url_base, url){
  reportes_url <- paste0(url_base, url %>%
                           html %>%
                           html_nodes(xpath = '//*/td[1]/*/a') %>%
                           html_attr('href')
  )
  reportes_url
}

get_reports <- function(reportes_url){
  reports <- sapply(mclapply(reportes_url, FUN=function(x){
    tryCatch({
      x %>% html %>% html_nodes(xpath='//*/tr[2]') %>%
        html_text
    }, error=function(err){
      NA
    })
  }, mc.cores = getOption("mc.cores", 4L)), FUN=function(x){x},
  simplify=T)
  reports
}


lurls <- mclapply(everyday_urls, FUN=function(x){get_reportes_urls(url_base, x)})
report.urls <- unlist(lurls)

l.reports <- get_reports(report.urls)

saveRDS(l.reports, file="/Users/lechuga/Desktop/Andres/ESCUELA/ITAM/CLASES/2do semestre/Metodos a gran escala/Proyecto 2/datos/ufos_2.rds")


#llemos los datos para juntarlos en un sólo data frame
ufos_1_df <- readRDS("/Users/lechuga/Desktop/Andres/ESCUELA/ITAM/CLASES/2do semestre/Metodos a gran escala/Proyecto 2/datos/ufos_1.rds")

ufos_2_df <- readRDS("/Users/lechuga/Desktop/Andres/ESCUELA/ITAM/CLASES/2do semestre/Metodos a gran escala/Proyecto 2/datos/ufos_2.rds")

reportes_df <- as.character(ufos_2_df)
ufos <- data.frame(ufos_1_df, report=reportes_df)

saveRDS(ufos, file="/Users/lechuga/Desktop/Andres/ESCUELA/ITAM/CLASES/2do semestre/Metodos a gran escala/Proyecto 2/datos/ufos.rds")



