library(methods)
library(rvest)
base_url <- "http://www.nuforc.org/webreports/"

# Para obtener una página (en este caso el index)
ufo_index <- html(paste0(base_url, "ndxevent.html"))

# Obtenemos las URLs de las páginas por día
daily_urls <- paste0(base_url, ufo_index %>%
                       html_nodes(xpath = "//*/td[1]/*/a[contains(@href, 'ndxe')]")  %>%
                       html_attr("href")
)

dat <- daily_urls[1] %>%
  html %>%
  html_nodes(xpath = '//*/table') %>%
  html_table()

a<-dat[[1]]

n <- length(daily_urls)

dat <- dat[[1]]

#2:(length(daily_urls)-1)
for (i in 2:(length(daily_urls)-1)){
  dat  <-  daily_urls[i] %>%
    html %>%
    html_nodes(xpath = '//*/table') %>%
    html_table()
  a<-rbind(a,dat[[1]])
  write.table(a, file="dat.txt",sep = "\t", col.names = TRUE)
}

