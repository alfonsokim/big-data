#!/usr/bin/env Rscript

f <- file("stdin")

open(f)

dat <- read.table(f)
n <- nrow(dat)
suma <- sum(dat$V1)
media <- round(mean(dat$V1), 0)
minimo <- min(dat$V1)
maximo <- max(dat$V1)
mediana <- median(dat$V1)
desviacion <- round(sd(dat$V1), 0)
varianza <- round(var(dat$V1), 0)

print(paste("N = ", n, sep = " "))
print(paste("Suma = ", suma, sep = " "))
print(paste("Media = " , media, sep = " "))
print(paste("Maximo = ", maximo, sep = " "))
print(paste("Minimo = ", minimo, sep = " "))
print(paste("Mediana = ", mediana, sep = " "))
print(paste("Desviacion estandar = ", desviacion, sep = " "))
print(paste("Varianza = ", varianza, sep = " "))

close(f)