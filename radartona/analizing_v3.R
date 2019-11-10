library(sf)
library(ggplot2)
library(data.table)
library(mgcv)
df <- readRDS("/media/sergio/ext4/MOBILAB/merged.rds")
df <- df[df$LT %in% unique(df$LT)[433:672], ]
names(df)
hist(df[df$LT == unique(df$LT)[1], ]$speed_kph_mean)
p <- unlist(lapply(1:length(unique(df$LT)), function(i){
  shapiro.test(df[df$LT == unique(df$LT)[i], ]$speed_kph_mean)$p.value  
}))
plot(p)
# TODA A VELOCIDADE E NORMAL
df2 <- df[!df$NOME %in% c("SANTO AMARO", "SAPOPEMBA", "SE", "VILA MARIA-VILA GUILHERME",
                          "M'BOI MIRIM", "VILA PRUDENTE"), ]
m1 <- lm(speed_kph_mean ~ +layer + total + tipo + highway + NOME, data = df2)
summary(m1)
speed_masp <- function(rain) -9.216e-02*rain


df2 <- df[!df$NOME %in% c("SANTO AMARO", "SAPOPEMBA", "SE", "VILA MARIA-VILA GUILHERME",
                          "M'BOI MIRIM", "VILA PRUDENTE", "BUTANTA", "GUAIANAZES", "IPIRANGA",
                          "CAPELA DO SOCORRO"), ]
m1 <- gam(speed_kph_mean ~ + layer + ts(total) + ts(tipo) + ts(highway) + ts(NOME), data = df2)
summary(m1)
speed_masp <- function(rain) -9.216e-02*rain



m1 <- lm(speed_kph_mean ~ +layer + total + tipo + highway + NOME, data = df2)
summary(m1)
speed_masp <- function(rain) -9.216e-02*rain


acc <- read.csv("/media/sergio/ext4/MOBILAB/02) CET_Acidentes_SAT/Acidentes2018_Fev.csv", stringsAsFactors = F)
acc <- acc[!is.na(acc$longitude), ]
acc$time <- as.POSIXct(paste(acc$data, acc$hora), format = "%d/%m/%Y %H:%M", tz = "America/Sao_Paulo")
acc$time_h <- paste0(strftime(acc$time, "%Y-%m-%d %H"), ":00")
setDT(acc)
sfacc <- st_as_sf(as.data.frame(acc), coords = c("longitude", "latitude"), crs = 4326)
plot(sfacc["TipoAcidente"], axes = T)
acc$um <- 1
df_acc <- acc[, sum(um, na.rm = T), by = .(time_h, longitude, latitude)]

sfacc <- st_as_sf(as.data.frame(df_acc), coords = c("longitude", "latitude"), crs = 4326)
acc_20 <- st_transform(sfacc, 31983)
acc_20 <- st_buffer(acc_20, 20)
dfa <- lapply(1:length(unique(df$LT)), function(i) {
  print(unique(df$LT)[i])
  st_intersection(df[df$LT == unique(df$LT)[i], ], 
                  acc_20[acc_20$time_h == unique(acc_20$time_h)[i], ])
})

dfa <-do.call("rbind", dfa)
dim(dfa)
head(dfa)
plot(dfa$V1, dfa$speed_kph_mean)
plot(sfacc["TipoAccidente"])


df3 <- readRDS("SPEEDS_SFTIME.rds")
dfa <- lapply(1:length(unique(df3$LT)), function(i) {
  print(unique(df3$LT)[i])
  st_intersection(df3[df3$LT == unique(df3$LT)[i], ], 
                  acc_20[acc$time_h == unique(acc_20$time_h)[i], ])
})
dfa <-do.call("rbind", dfa)
