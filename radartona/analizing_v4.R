library(sf)
library(ggplot2)
library(data.table)
library(cptcity)
df <- readRDS("/media/sergio/ext4/MOBILAB/merged.rds")
summary(df$total)
dfgo <- df$geometry
plot(df[df$total<2000 & df$LT %in% unique(df$LT)[433], ]["total"], axes = T, lwd =3,
     breaks = seq(0,7000, 500),
     pal = cpt(rev = T, colorRampPalette = T, pal = "mpl_viridis"),
     main = "Fluxo veicular [veh/h] 2018-02-19 00:00")
plot(df[df$total<15000 & df$LT %in% unique(df$LT)[440], ]["total"], axes = T, lwd =3,
     breaks = seq(0,7000, 500),
     pal = cpt(rev = T, colorRampPalette = T, pal = "mpl_viridis"),
     main = "Fluxo veicular [veh/h] 2018-02-19 07:00")

plot(df[df$total<15000 & df$LT %in% unique(df$LT)[446], ]["total"], axes = T, lwd =3,
     breaks = seq(0,7000, 500),
     pal = cpt(rev = T, colorRampPalette = T, pal = "mpl_viridis"),
     main = "Fluxo veicular [veh/h] 2018-02-19 13:00")

plot(df[df$total<15000 & df$LT %in% unique(df$LT)[452], ]["total"], axes = T, lwd =3,
     breaks = seq(0,7000, 500),
     pal = cpt(rev = T, colorRampPalette = T, pal = "mpl_viridis"),
     main = "Fluxo veicular [veh/h] 2018-02-19 19:00")

df <- readRDS("/media/sergio/ext4/MOBILAB/merged.rds")
dt <- df[df$LT %in% unique(df$LT)[433:(433+24*7)], ]
dt <- as.data.table(dt)
dt <- dt[total < 9000]
summary(dt$total)

dt2 <- dt[, sum(total), by = LT]
plot(dt2, type = "b", col = "blue",
     main = "contagem medio de veiculos por radar \n
     2018-02-19 00:00 ate 2018-02-26 00:00:00",
     pch = 16)
