library(rvest)

base_url <- "http://www.nuforc.org/webreports/"

ufo_reports_index <- html(paste0(base_url, "ndxevent.html"))

ufo_reports_index %>%
  html_nodes(xpath = "//*/td[2]")

daily_urls <- paste0(base_url, ufo_reports_index %>%
                       html_nodes(xpath = "//*/td[1]/*/a[contains(@href, 'ndxe')]")  %>%
                       html_attr("href")
)

dataufo<- lapply(1:862,function(i){daily_urls[[i]] %>%
                                     html  %>%
                                     html_table(fill = TRUE)%>%as.data.frame})

dataufot<-rbindlist(dataufo)
write.csv(dataufot,"dataufo.csv")
write.table(dataufot,file='ufotest2.tsv', quote=FALSE, sep='\t', col.names=NA)

