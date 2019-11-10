library(sf)
library(data.table)
library(raster)
library(stars)

conts <- list.files(path = "/media/sergio/ext4/MOBILAB/cont", 
                    pattern = ".rds", 
                    full.names = TRUE)
speedss <- list.files(path = "/media/sergio/ext4/MOBILAB/speeds", 
                    pattern = ".rds", 
                    full.names = TRUE)
radars <- list.files(path = "/media/sergio/ext4/MOBILAB/rds01/", 
                      pattern = ".rds", 
                      full.names = TRUE)
subp <- read_sf("/media/sergio/ext4/MOBILAB/shapefile/DEINFO_SUBPREFEITURAS_2013.shp", crs = 31983)
dias <- ifelse(nchar(1:28)<2, paste0("0", 1:28),1:28 )
hora <- ifelse(nchar(0:23)<2, paste0("0", 0:23),0:23 )



for(i in 1:length(dias)){
  for(j in 1:length(hora)){
    
    fecha <- paste0("201802", dias[i], hora[j], ".rds")
    
    cont <-   readRDS(paste0("/media/sergio/ext4/MOBILAB/cont/cont_", fecha))
    cont <- cont[!is.na(cont$codigo), ]
    speeds <- readRDS(paste0("/media/sergio/ext4/MOBILAB/speeds/speeds_", fecha))
    speeds <- speeds[!is.na(speeds$id), ]
    radar <- readRDS(paste0("/media/sergio/ext4/MOBILAB/rds01/sao_roque_", fecha))
    crs(radar) <- CRS("+init=epsg:4326")
    radar[is.na(radar[])] <- 0
    radar <- st_transform(st_as_sf(st_as_stars(radar)), 31983)

    print(fecha)
    
    cont$geom <-  NULL
    cont <- st_sf(cont, geometry = cont$geometry, crs = 4326)
    cont <- st_transform(cont, 31983)
    cont_20m <- st_buffer(cont, 20)
    
    speeds_cont <- st_intersection(speeds, cont_20m)
    speeds_cont <- speeds_cont[!duplicated(speeds_cont$osm_way_id),]
    
    speeds_cont_radar <- st_intersection(speeds_cont, radar)
    speeds_cont_radar <- speeds_cont_radar[speeds_cont_radar$total >0, ]
    speeds_cont_radar <- speeds_cont_radar[speeds_cont_radar$speed_kph_mean >0, ]
    # speeds_cont_radar <- st_intersection(speeds_cont_radar, subp[, "NOME"])
    speeds_cont_radar2 <- merge(speeds[, "osm_way_id"], 
                               st_set_geometry(speeds_cont_radar, NULL), 
                               by = "osm_way_id", 
                               all = T)
    speeds_cont_radar2 <- speeds_cont_radar2[!is.na(speeds_cont_radar2$id), ]
    saveRDS(speeds_cont_radar2, 
            paste0("/media/sergio/ext4/MOBILAB/merged01/",fecha))
  }
}

