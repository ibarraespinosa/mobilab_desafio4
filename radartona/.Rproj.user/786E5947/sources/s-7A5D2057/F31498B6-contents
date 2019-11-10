library(sf)
library(raster)
library(stars)
library(ggplot2)
chu <- read.csv("/media/sergio/ext4/MOBILAB/met/chuva_diaria.csv", stringsAsFactors = F)
plot(y = chu$pcp, x= as.POSIXct(chu$data), pch = 16, col = "blue", type = "b",
     main  = "Chuva diaria (CGE)", xlab = "dias", ylab = "Chuva")

arqs <- list.files(path = "/media/sergio/ext4/MOBILAB/rds01/", pattern = ".rds", full.names = T)
r <- lapply(1:length(grep(pattern = "26.", x = arqs)), function(i){
  readRDS(arqs[grep(pattern = "26.", x = arqs)[i]])
})

# r <- mean(brick(r),na.rm = T)
# plot(r)
cachorro <- st_read("/media/sergio/ext4/MOBILAB/shapefile/DEINFO_SUBPREFEITURAS_2013.shp", crs = 31983)

sr <- st_as_stars(projectRaster(r[[14]], crs = "+init=epsg:31983"))
srr <- st_crop(sr, st_union(cachorro))
ggplot() + 
  geom_stars(data = srr) + 
  coord_equal() +
  scale_fill_gradientn(colours = cpt(find_cpt("radar")[1]), 
                       limits = c(0, 41),
                       na.value = "transparent") +
  theme_bw() +
  labs(title = "Radar meteorologico Sao Roque 14:00 [mm/h]")



sr <- st_as_stars(projectRaster(r[[15]], crs = "+init=epsg:31983"))
srr <- st_crop(sr, st_union(cachorro))
ggplot() + 
  geom_stars(data = srr) + 
  coord_equal() +
  scale_fill_gradientn(colours = cpt(find_cpt("radar")[1]), 
                       limits = c(0, 41),
                       na.value = "transparent") +
  theme_bw() +
  labs(title = "Radar meteorologico Sao Roque 15:00 [mm/h]" )


sr <- st_as_stars(projectRaster(r[[16]], crs = "+init=epsg:31983"))
srr <- st_crop(sr, st_union(cachorro))
ggplot() + 
  geom_stars(data = srr) + 
  coord_equal() +
  scale_fill_gradientn(colours = cpt(find_cpt("radar")[1]), 
                       limits = c(0, 41),
                       na.value = "transparent") +
  theme_bw() +
  labs(title = "Radar meteorologico Sao Roque 16:00 [mn/h]")


sr <- st_as_stars(projectRaster(r[[17]], crs = "+init=epsg:31983"))
srr <- st_crop(sr, st_union(cachorro))
ggplot() + 
  geom_stars(data = srr) + 
  coord_equal() +
  scale_fill_gradientn(colours = cpt(find_cpt("radar")[1]), 
                       limits = c(0, 41),
                       na.value = "transparent") +
  theme_bw() +
     labs("Radar meteorologico Sao Roque 17:00")

