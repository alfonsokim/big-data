library(rvest)
library(downloader)
library("methods")

archivos<-html("http://data.gdeltproject.org/events/index.html")
archivos<-html_nodes(archivos,"a")
archivos<-html_attr(archivos,"href")

año<-substr(archivos[4],1,4)
mes<-substr(archivos[4],5,6)
dia<-substr(archivos[4],7,8)

fecha<-as.Date(paste(dia,mes,año,sep="/"),"%d/%m/%Y")

if(fecha==Sys.Date()-1){
  directorio<-"/home/itam/data/data/gdelt/"
  download(paste("http://data.gdeltproject.org/events/",archivos[4], sep=""),
           paste(directorio,Sys.Date()-1,".zip",sep=""))
  unzip(paste(directorio,Sys.Date()-1,".zip",sep=""),
              exdir=paste(directorio,"nuevos",sep=""))
}
