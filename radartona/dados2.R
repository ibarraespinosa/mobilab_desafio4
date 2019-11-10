library(RPostgreSQL)
library(sf)
library(data.table)

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


library(stringr)
# base_radares ####
br <- st_read(con, "base_radares")
codigo2 <- str_split_fixed(br$codigo, "-", 4)
br2 <- cbind(br[, c("gid", "codigo")], codigo2)
br2$X1 <- as.numeric(gsub(pattern = " ", replacement = "", br2$X1))
br2$X2 <- as.numeric(gsub(pattern = " ", replacement = "", br2$X2))
br2$X3 <- as.numeric(gsub(pattern = " ", replacement = "", br2$X3))
br2$X4 <- as.numeric(gsub(pattern = " ", replacement = "", br2$X4))

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

#  contagens #### 
contage <- fread("~/contagens.csv")















# registros ####
r <- dbReadTable(con, "registros")
head(r)
contsaveRDS(a, "registros.rds", compress= "xz")


# base_radares ####
br <- st_read(con, "base_radares")
head(br)
saveRDS(a, "base_radares.rds", compress= "xz")



# sensor
a <- st_read(con, "sensor")
head(a)
saveRDS(a, "sensor.rds", compress= "xz")

# geography_columns
sensor <- dbReadTable(con, "sensor")
head(sensor)
saveRDS(a, "geography_columns.rds", compress= "xz")

#  geometry_columns ####
a <- dbReadTable(con, dbListTables(con)[5])
head(a)
saveRDS(a, "geometry_columns.rds", compress= "xz")


# registros ####
a <- st_read(con, dbListTables(con)[7])
head(a)
saveRDS(a, "registros.rds", compress= "xz")

# base_radares ####
a <- st_read(con, dbListTables(con)[4])
head(a)
saveRDS(a, "base_radares.rds", compress= "xz")

# sensor ####
a <- dbReadTable(con, dbListTables(con)[9])
head(a)
saveRDS(a, "sensor.rds", compress= "xz")

# sirgas_shp_logradouronbl ####
a <- st_read(con, dbListTables(con)[10])
head(a)
saveRDS(a, "sirgas_shp_logradouronbl.rds", compress= "xz")

# sirgas_shp_logradouronbl_vertices_pgr ####
a <- st_read(con, dbListTables(con)[11])
head(a)
saveRDS(a, "sirgas_shp_logradouronbl_vertices_pgr.rds", compress= "xz")




# radar_route ####
a_10000 <- st_read(con, query = "SELECT * FROM radar_route LIMIT 10000;")
saveRDS(a_10000, "radar_route_a_10000.rds", compress= "xz")

a_20000 <- st_read(con, query = "SELECT * FROM radar_route LIMIT 10000 OFFSET 20000;")
saveRDS(a_20000, "radar_route_a_20000.rds", compress= "xz")

a_30000 <- st_read(con, query = "SELECT * FROM radar_route LIMIT 20000 OFFSET 30000;")

a <- dbReadTable(conn = con, name = dbListTables(con)[6])
head(a)
saveRDS(a, "radar_route.rds", compress= "xz")
