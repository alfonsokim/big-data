library(maptools)
library(rgdal)
library(dplyr)
library(cshapes)
library(ggplot2)


world <- cshp(date=as.Date("2008-1-1"))
world.points <- fortify(world, region='CNTRY_NAME')

reporte <- read.csv(
  "~/big-data/alumnos/jared275/data/gdelt/reporte.csv",
  header=FALSE, stringsAsFactors = FALSE)

names(reporte)<-c("FIPS","Evento","Latitud","Longitud","Conteo")

reporte$Longitud<-as.numeric(reporte$Longitud)
reporte$Latitud<-as.numeric(reporte$Latitud)

reporte<-reporte[complete.cases(reporte),]%>%
  group_by(FIPS)%>%
  dplyr::mutate(conteo_tot=sum(Conteo), conteo_por=Conteo/conteo_tot)

eventos<-unique(reporte$Evento)

for( i in 1:5){
reporte_mapa<-data.frame(reporte[reporte$Evento==eventos[i],])

p <- SpatialPointsDataFrame(reporte_mapa[,c(4,3)], 
                            data.frame(id=1:nrow(reporte_mapa)),
                            proj4string=CRS(proj4string(world)))

res <- over(p, world,returnList=T)

paises<-sapply(res,function(x){
  as.character(x[1,1])
})

names(paises)<-NULL

reporte_mapa$id<-paises

mapa<-left_join(world.points,reporte_mapa)

ggplot(mapa, aes(long,lat,group=group, fill=conteo_por)) + geom_polygon()+
  theme(legend.position=c(.1,.2),axis.text.x = element_blank(),
        axis.text.y = element_blank(),axis.title.x = element_blank(),
        axis.title.y = element_blank())+ ggtitle(paste("Evento",eventos[i]))

ggsave(filename=paste("mapas_conteo",i,".jpg",sep=""))
}


