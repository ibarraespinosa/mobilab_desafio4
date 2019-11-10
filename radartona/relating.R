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
names(contage) <- c("numrow", "datetime", "localidade", "tipo", "total", "infr", "placas")
contage
contage$time <- as.POSIXct(contage$datetime, tz = "America/Sao_Paulo")
contage$codigo <- as.numeric(as.character(contage$localidade))
br_codigo_contage <- merge(br_codigo, contage, by = "codigo", all = T)


r <- st_read(con, "registros")
dim(r)
head(r)
