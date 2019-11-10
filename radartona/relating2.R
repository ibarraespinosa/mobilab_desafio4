library(RPostgreSQL)
library(sf)
library(data.table)
library(stringr)

db <- 'hackatona'  #provide the name of your db
host_db <- "192.168.167.44" #i.e. # i.e. 'ec2-54-83-201-96.compute-1.amazonaws.com'  
db_port <- '5432'  # or any other port specified by the DBA
db_user <- "mobilab"  
db_password <- "mobilab"

con <- dbConnect(PostgreSQL(), 
                 dbname = db, 
                 host=host_db, 
                 port=db_port, 
                 user=db_user, 
                 password=db_password)  


dbListTables(con)


# base_radares ####
br <- readRDS("base_radares.rds")
br$latitude_l <- gsub(pattern = "\\(", replacement = "", br$latitude_l)
br$latitude_l <- gsub(pattern = "\\)", replacement = "", br$latitude_l)

latlon <- as.data.frame(str_split_fixed(br$latitude_l, " ", 2))
head(latlon)
latlon$lon <- as.numeric(as.character(latlon$V1))
latlon$lat <-  as.numeric(as.character(latlon$V2))
br <- cbind(br, latlon)
br <- br[!is.na(br$lon), ]
br <- st_as_sf(br, coords = c("lon", "lat"), crs = 4326)


codigo2 <- str_split_fixed(br$codigo, "-", 4)
br2 <- cbind(br[, c("gid", "codigo", "V2", "V1")], codigo2)
br2$X1 <- as.numeric(gsub(pattern = " ", replacement = "", br2$X1))
br2$X2 <- as.numeric(gsub(pattern = " ", replacement = "", br2$X2))
br2$X3 <- as.numeric(gsub(pattern = " ", replacement = "", br2$X3))
br2$X4 <- as.numeric(gsub(pattern = " ", replacement = "", br2$X4))

br2_X1 <- br2[!is.na(br2$X1), c("X1", "V2", "V1")]
names(br2_X1)[1] <- "codigo"
br2_X2 <- br2[!is.na(br2$X2), c("X2", "V2", "V1")]
names(br2_X2)[1] <- "codigo"
br2_X3 <- br2[!is.na(br2$X3),  c("X3", "V2", "V1")]
names(br2_X3)[1] <- "codigo"
br2_X4 <- br2[!is.na(br2$X4),  c("X4", "V2", "V1")]
names(br2_X4)[1] <- "codigo"
br_codigo <- rbind(br2_X1, br2_X2, br2_X3, br2_X4)
saveRDS(br_codigo, "br_codigo_sf.rds", compress = "xz")
rm(br2_X1, br2_X2, br2_X3, br2_X4)
gc()

geobr <- br_codigo$geometry
br_codigo <- st_set_geometry(br_codigo, NULL)
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

br_codigo_contage_noNA <- br_codigo_contage[!is.na(br_codigo_contage$V1), ]
names(br_codigo_contage_noNA)[2] <- "lat"
names(br_codigo_contage_noNA)[3] <- "lon"
br_codigo_contage_noNA$lat <- as.numeric(as.character(br_codigo_contage_noNA$lat))
br_codigo_contage_noNA$lon <- as.numeric(as.character(br_codigo_contage_noNA$lon))
br_codigo_contage_noNA <- st_as_sf(br_codigo_contage_noNA,
                                   coords = c("lon", "lat"),
                                   crs = 4326)

saveRDS(br_codigo_contage_noNA, "CONTAGE_SFTIME.rds", compress = "xz")


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
