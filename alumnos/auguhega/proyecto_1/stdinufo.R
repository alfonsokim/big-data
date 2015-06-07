#!/usr/bin/env Rscript
library(dplyr)
library(tidyr)
library(ggplot2)

arg<-commandArgs(trailingOnly=TRUE)
dataufo<-read.delim("/dev/stdin", header=F, na.strings="")

dataufo<- dataufo[c(2,3,4,5,6,7,8)]
colnames(dataufo)<-c("datetime", "City", "State", "Shape", "Duration", "Summary", "Posted")
dataufo_l<-filter(dataufo_l, date<"2015-02-19")

#Separamos la fecha, la hora y calculamos el día de la semana a partir de la fecha
dataufo_l<-dataufo%>%
  separate(col=datetime, into=c("date", "time"), sep=" ",remove=F, extra="drop")%>%
  mutate(date=as.Date(date, format='%m/%d/%y'), dia=weekdays(date), State=toupper(State))

#Grafica de la serie de tiempo

ggplot(data.lag, aes(x = date, y = freq, color = city, group = city)) +
  geom_line() + 
  theme(axis.text.x = element_text(angle = 90, hjust = 1))