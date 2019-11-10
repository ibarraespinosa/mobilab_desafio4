library(sf)
library(data.table)
library(stringr)

# base_radares ####
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
setDT(br_codigo, key = "codigo")

#  contagens #### 
contage <- fread("~/contagens.csv")
names(contage) <- c("numrow", "datetime", "localidade", "tipo", "total", "infr", "placas")
contage
contage$time <- as.POSIXct(contage$datetime, tz = "America/Sao_Paulo")
contage$codigo <- as.numeric(as.character(contage$localidade))
setDT(contage, key = "codigo")

br_codigo_contage <- merge(br_codigo, 
                           contage, 
                           by = "codigo", all = T)

br_codigo_contage <- br_codigo_contage[!is.na(br_codigo_contage$lon), ]
br_codigo_contage <- br_codigo_contage[!is.na(br_codigo_contage$total), ]
setDF(br_codigo_contage)
br_codigo_contage <- st_as_sf(br_codigo_contage, coords = c("lon", "lat"))
saveRDS(br_codigo_contage, "CONTAGE_SFTIME.rds", compress = "xz")


# uber
r <- fread("/media/sergio/ext4/MOBILAB/08) Uber_Movement_Speeds/movement-speeds-hourly-sao-paulo-2018-2.csv")

# agregar dados por velocidade media e OSM ID
r$dia <- ifelse(nchar(r$day) < 2, paste0(0, r$day),
                r$day)
r$hora <- ifelse(nchar(r$hour) < 2, paste0(0, r$hour),
                 r$hour)
r$mes <- ifelse(nchar(r$month) < 2, paste0(0, r$month),
                r$month)
r$LT <- as.POSIXct(paste0(r$year, r$mes, r$dia, r$hora, ":00"), 
                   format = "%Y%m%d%H:%M", 
                   tz = "America/Sao_Paulo")


r[, mean(speed_kph_mean, na.rm = T),
  by = .("osm_way_id", "LT")]

speeds <- r[, lapply(.SD, mean, na.rm=TRUE), 
            by = c("osm_way_id", "LT"), 
            .SDcols= "speed_kph_mean"]
saveRDS(speeds, "speeds.rds",compress = "xz")
osm <- readRDS("/media/sergio/ext4/MOBILAB/osm/osm.rds")
osmgeo <- osm$geometry
setDT(osm, key = "id")
speeds$id <- speeds$osm_way_id
setkey(speeds, key = "id")
speeds2 <- merge(speeds, osm, by = "id", all = T)
speeds2 <-st_sf(speeds2, geometry = speeds2$geometry)
saveRDS(speeds2, "SPEEDS_SFTIME.rds", compress = "xz")
