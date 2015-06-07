
library(ggplot2)
library(tidyr)
library(dplyr)
library(stringr)
#Lectura de datos
setwd("/home/sophie/ITAM/metodosGranEscala/proyectos/1er_proyecto/pruebacsv/")
base <- read.csv("../dataClean.csv",stringsAsFactors=FALSE, na.strings = c("NA",""))
write.csv(data,"../dataCleanFinal.csv", row.names = FALSE)
######Procesamiento de datos
data<- separate(base ,Date...Time,c("date","time"), sep = "[[:blank:]]", extra = "drop")
#Cambiar nombre a columans
names(data) <- tolower(names(data))
#Cambiar a tipo fecha
# Convertir fechas a tipo fecha
data$date       <- as.Date(data$date,
                                        "%m/%d/%y")
data$date[str_detect(data$date,"20[2-9]{1}[0-9]{1}")] <-
str_replace(data$date[str_detect(data$date,"20[2-9]{1}[0-9]{1}")],"^20","19")
data$posted    <- as.Date(data$posted,
                                      "%m/%d/%y")
data$posted[str_detect(data$posted,"20[2-9]{1}[0-9]{1}")] <-
str_replace(data$posted[str_detect(data$posted,"20[2-9]{1}[0-9]{1}")],"^20","19")
######Analisis
###¿Cuántas observaciones totales
nrow(data)
###¿Cuál es el top 5 de estados?
#Hacer conteo de frecuencias y eliminar datos faltantes.
data <- na.omit(data)
data_state <- plyr::count(data$state)
#top 5
head(data_state[order(data_state[,2], decreasing = TRUE),], 5)
###¿Cuál es el top 5 de estados por año?
data.state.date <- plyr::count(data[,c(1,4)])
dates <- unique(format(data.state.date$date,"%Y"))
topDate <- list()
for(i in 1:length(dates)){
    data.interest <- data.state.date[format(data.state.date$date,"%Y")==dates[i],]
    data.interest <- head(data.interest[order(data.interest[,3], decreasing = TRUE), ], 5)
    topDate[[i]]  <- data.interest
}
###¿Cuál es el mes con más avistamientos? ¿El día de la semana?
data.day      <- plyr::count(weekdays(data$date))
head(data.day[order(data.day$freq, decreasing =TRUE),],5)
data.month  <- plyr::count(format(data$date, "%m"))
head(data.month[order(data.month$freq, decreasing =TRUE),],5)
###Series de tiempo
ts <- plyr::count(data$date)
plot.global <- ggplot(data = ts, aes(x = x, y = freq ) ) +
       geom_line(alpha = .5, color = "#ad1457")
png("../serietiempo.jpg")
plot.global
dev.off()
