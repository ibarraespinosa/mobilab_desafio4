library(sf)
library(ggplot2)
library(data.table)
library(mgcv)
library(cptcity)
library("ggmap")
acc <- read.csv("/media/sergio/ext4/MOBILAB/02) CET_Acidentes_SAT/Acidentes2018_Fev.csv", stringsAsFactors = F)
acc <- acc[!is.na(acc$longitude), ]
acc$time <- as.POSIXct(paste(acc$data, acc$hora), format = "%d/%m/%Y %H:%M", tz = "America/Sao_Paulo")
GOOGLE_API <- "API"
register_google(GOOGLE_API)
map_sf <- get_map('Sao Paulo', zoom = 11, maptype = 'satellite')
ggmap(map_sf) + 
  labs(title = 'Atropelamentos em  Sao Paulo') +
  stat_density2d(data = acc[acc$TipoAcidente == "Atropelamento", ], 
                 aes(x = longitude, 
                     y = latitude, 
                     fill = ..density..,), 
                 geom = 'tile', 
                 contour = F, alpha = .5)  +
  scale_fill_gradientn(colours = cpt("mpl_viridis"))


unique(acc$TipoAcidente)
ggmap(map_sf) + 
  labs(title = 'Colisoes em  Sao Paulo') +
  stat_density2d(data = acc[acc$TipoAcidente %in% unique(acc$TipoAcidente)[grep("Col", unique(acc$TipoAcidente))], ], 
                 aes(x = longitude, 
                     y = latitude, 
                     fill = ..density..,), 
                 geom = 'tile', 
                 contour = F, alpha = .5)  +
  scale_fill_gradientn(colours = cpt("mpl_inferno"))


ggmap(map_sf) + 
  labs(title = 'Choques em  Sao Paulo') +
  stat_density2d(data = acc[acc$TipoAcidente %in% unique(acc$TipoAcidente)[grep("Ch", unique(acc$TipoAcidente))], ], 
                 aes(x = longitude, 
                     y = latitude, 
                     fill = ..density..,), 
                 geom = 'tile', 
                 contour = F, alpha = .5)  +
  scale_fill_gradientn(colours = cpt("mpl_viridis"))




ggmap(map_sf) + 
  labs(title = 'Queda em  Sao Paulo') +
  stat_density2d(data = acc[acc$TipoAcidente %in% unique(acc$TipoAcidente)[grep("Q", unique(acc$TipoAcidente))], ], 
                 aes(x = longitude, 
                     y = latitude, 
                     fill = ..density..,), 
                 geom = 'tile', 
                 contour = F, alpha = .5)  +
  scale_fill_gradientn(colours = cpt("mpl_inferno"))






acc$dia <- as.POSIXct(strftime(acc$time, "%Y-%m-%d"))
acc2 <- acc[, sum(.N), by = dia]

rain <- fread("/media/sergio/ext4/MOBILAB/met/chuva_diaria.csv", stringsAsFactors = F)
df <- readRDS("/media/sergio/ext4/MOBILAB/merged.rds")
setDT(df)
df$dia <- as.POSIXct(strftime(df$LT, "%Y-%m-%d"))
df2 <-  df[, mean(total), by = dia]
speed <-  df[, mean(speed_kph_mean), by = dia]

acc2$rain <- rain$pcp
acc2$vei <- df2$V1
acc2$speed <-speed$V1

plot(x = 1:28, y = acc2$V1, type = "b", pch = 16, ylab = "accidentes", ylim= c(23, 52))
legend(x = 0, y = 52, legend = "Acidentes diarios em fevereiro", pch = 16)
plot(x = 1:28, y = acc2$rain, type = "b", pch = 16,col = "red", ylab = "[mm/h]")
legend(x = 0, y = 40, legend = "Chuva [mm/h] diaria em fevereiro", col = "red", pch = 16)
plot(x = 1:28, y = acc2$vei, type = "b", pch = 16, col = "blue",  ylab = "[veh]")
legend(x = 0, y = 230, legend = "Fluxo [veh] medio diarios", col = "blue", pch = 16)
plot(x = 1:28, y = acc2$speed, type = "b", pch = 16, col = "brown",
     xlab= "dias Fev 2018", ylab = "[km/h]", ylim = c(35, 41))
legend(x = 0, y = 41, legend = "Velocidade [km/h] media diaria", col = "brown", pch = 16)

cor(acc2$acc, acc2$rain)
cor(acc2$acc, acc2$vei)
cor(acc2$acc, acc2$speed)

source("https://raw.githubusercontent.com/briatte/ggcorr/master/ggcorr.R")

setDF(acc2)
names(acc2)[2] <- "acc"
ggcorr(acc2[, 2:5], label= T)

