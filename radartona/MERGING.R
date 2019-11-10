library(sf)
library(data.table)

cont <- readRDS("CONTAGE_SFTIME.rds")
unis <- unique(cont$datetime)
dias <- ifelse(nchar(1:28)<2, paste0("0", 1:28),1:28 )
hora <- ifelse(nchar(0:23)<2, paste0("0", 0:23),0:23 )


# sao_roque_2018021205.rds

for(i in 1:length(dias)){
  for(j in 1:length(hora)){
    fecha <- paste0("2018-02-", dias[i], " ", hora[j], ":00:00")
    print(fecha)
    cont_x <- cont[cont$datetime ==  fecha, ]
    saveRDS(cont_x, paste0("/media/sergio/ext4/MOBILAB/cont/cont_201802",
                           dias[i], hora[j], ".rds"))
  }
}
  

gc()

cont <- readRDS("SPEEDS_SFTIME.rds")
for(i in 1:length(dias)){
  for(j in 1:length(hora)){
    fecha <- paste0("2018-02-", dias[i], " ", hora[j], ":00:00")
    print(fecha)
    cont_x <- cont[cont$LT ==  fecha, ]
    saveRDS(cont_x, paste0("/media/sergio/ext4/MOBILAB/speeds/speeds_201802",
                           dias[i], hora[j], ".rds"))
  }
}

gc()
