library(sf)
library(data.table)
library(cptcity)
library(stringr)

# 1semana
a <- do.call("rbind", lapply(conts[433:601], readRDS))
a$LT <- as.POSIXct(a$datetime)
a$geom <-NULL
a <- st_sf(a, geometry = a$geometry, crs = 4326)
dt <- as.data.table(a)    
dth <- dt[, sum(infr, na.rm = T), by = datetime]
plot(x = 1:169, y = dth$V1, type = "b", col = "red", pch = 16,
     main = "Numero Infracoes 2018-02-19 00:00  ate 2018-02-22 00:00")


plot(a["infr"])


infr <- fread("/media/sergio/ext4/MOBILAB/03) SMT_Autuações/INFRACOES_Fev2018.csv", encoding = "UTF-8")
names(infr)[5] <- "dia"
names(infr)[6] <- "hora"
names(infr)[10] <- "tipo_vei"
names(infr)[8] <- "des_local"
names(infr)[12] <- "cat_vei"
infr
infr$LT <- as.POSIXct(paste(infr$dia, infr$hora), format = "%d/%m/%Y %H:%M", tz = "America/Sao_Paulo")
# enlazar codigo con codigo local
infr$LTH <- strftime(infr$LT, "%Y-%m-%d %H:00")

infr$um <- 1
df_infr <- infr[, sum(um), by = .(LTH, COD_LOCAL, Enquadramento)]


# base_radares tiene coordenadas CODE
br <- readRDS("base_radares_sf.rds")
codigo2 <- as.data.frame(str_split_fixed(br$codigo, "-", 4))
br2 <- br[, c("gid", "codigo")]
br2$X1 <- as.numeric(gsub(pattern = " ", replacement = "", codigo2$V1))
br2$X2 <- as.numeric(gsub(pattern = " ", replacement = "", codigo2$V2))
br2$X3 <- as.numeric(gsub(pattern = " ", replacement = "", codigo2$V3))
br2$X4 <- as.numeric(gsub(pattern = " ", replacement = "", codigo2$V4))

br2_X1 <- br2[!is.na(br2$X1), "X1"]
names(br2_X1)[1] <- "codigo"
br2_X2 <- br2[!is.na(br2$X2), "X2"]
names(br2_X2)[1] <- "codigo"
br2_X3 <- br2[!is.na(br2$X3), "X3"]
names(br2_X3)[1] <- "codigo"
br2_X4 <- br2[!is.na(br2$X4), "X4"]
names(br2_X4)[1] <- "codigo"
br_codigo <- rbind(br2_X1, br2_X2, br2_X3, br2_X4)
rm(br2_X1, br2_X2, br2_X3, br2_X4)
gc()
br_codigo$lon <- st_coordinates(br_codigo)[, 1]
br_codigo$lat <- st_coordinates(br_codigo)[, 2]
geobr <- br_codigo$geom

class(br_codigo)

dt <- as.data.table(br_codigo, key = "codigo")
df_infr$codigo <- df_infr$COD_LOCAL
setkey(df_infr, "codigo")


dt_infr <- merge(dt, df_infr, by = "codigo", all = T)
setDF(dt_infr)
head(dt_infr)
dt_infr <- dt_infr[!is.na(dt_infr$codigo), ]

sf_infr <- st_sf(dt_infr, geometry = st_sfc(dt_infr$geom))
sf_infr <- sf_infr[!is.na(sf_infr$LTH), ]
dim(sf_infr)

#  que infracoes acontecem quando chove??
# radares meteorologicos
chu <- read.csv("/media/sergio/ext4/MOBILAB/met/chuva_diaria.csv", stringsAsFactors = F)

# Dia 26


sf_infr_26 <- sf_infr[sf_infr$LTH %in% paste0("2018-02-26 ", 14:17, ":00"), ]
dim(sf_infr_26)
table(sf_infr_26$Enquadramento)



sf_infr_19 <- sf_infr[sf_infr$LTH %in% paste0("2018-02-19 ", 14:17, ":00"), ]
dim(sf_infr_19)
table(sf_infr_19$Enquadramento)
