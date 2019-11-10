library(sf)
library(ggplot2)
library(data.table)
hora <- ifelse(nchar(0:23)<2, paste0("0", 0:23),0:23 )

# arqs <- list.files(path = "/media/sergio/ext4/MOBILAB/merged", 
#                    pattern = ".rds", 
#                    full.names = TRUE)
# df <- do.call("rbind", lapply(arqs, readRDS))
# format(object.size(df), units = "Mb")
# 
# summary(df$layer)
# df$Chuva <- ifelse(df$layer > 1 & df$layer <= 5, "Fraca",
#                 ifelse(df$layer > 5 & df$layer <= 25, "Moderada",
#                        ifelse(df$layer > 25 & df$layer <= 50,"Forte", 
#                               ifelse(df$layer > 50, "Forte" , "Sem chuva"))))
# df$Chuva <- factor(x = df$Chuva, levels = c("Sem chuva", "Fraca", "Moderada", "Forte"))
# saveRDS(df, "/media/sergio/ext4/MOBILAB/merged.rds", compress = "xz")

df <- readRDS("/media/sergio/ext4/MOBILAB/merged.rds")

table(df$Chuva)
png(filename = "/media/sergio/ext4/MOBILAB/figures/fudnamental_all_v1.png", width = 1000, height = 500)
  p <-  ggplot(df[df$total > 500 & df$total < 8500, ], 
       aes(x = total, 
           y = speed_kph_mean, 
           colour = Chuva,
           shape = Chuva)) +
  geom_point(size = 2) +
    facet_wrap(~Chuva, nrow= 1) +
    theme_bw() +
    labs(x = "Veiculos contagem [veh/h]", 
         y = "Velocidade [km/h]") +
    scale_colour_discrete("Chuva [mm/h]") +
    theme(legend.key.size = unit(2.5,"line"),
          legend.position = "bottom",
          legend.key.height=unit(2,"line"),
          legend.key.width=unit(4,"line"),
          legend.justification = "center",
          legend.text = element_text(size = 15),
          text = element_text(size = 15, colour = "black"),
          axis.text = element_text(size = 15, colour = "black"),
          plot.title  = element_text(hjust = 0.5))
    
print(p)
dev.off()




png(filename = "/media/sergio/ext4/MOBILAB/figures/fudnamental_all_v1_motorway.png", 
    width = 1000, height = 500)
p <-  ggplot(df[df$total > 500 & df$total < 8500 &
                  df$highway %in% c("motorway", "motorway_link"), ], 
             aes(x = total, 
                 y = speed_kph_mean, 
                 colour = Chuva,
                 shape = Chuva)) +
  geom_point(size = 2) +
  facet_wrap(~Chuva, nrow= 1) +
  theme_bw() +
  labs(x = "Veiculos contagem [veh/h]", 
       y = "Velocidade [km/h]", 
       title = "Ruas Motorway") +
  scale_colour_discrete("Chuva [mm/h]") +
  theme(legend.key.size = unit(2.5,"line"),
        legend.position = "bottom",
        legend.key.height=unit(2,"line"),
        legend.key.width=unit(4,"line"),
        legend.justification = "center",
        legend.text = element_text(size = 15),
        text = element_text(size = 15, colour = "black"),
        axis.text = element_text(size = 15, colour = "black"),
        plot.title  = element_text(hjust = 0.5))

print(p)
dev.off()



png(filename = "/media/sergio/ext4/MOBILAB/figures/fudnamental_all_v1_trunk.png", 
    width = 1000, height = 500)
p <-  ggplot(df[df$total > 500 & df$total < 8500 &
                  df$highway %in% c("trunk", "trunk_link"), ], 
             aes(x = total, 
                 y = speed_kph_mean, 
                 colour = Chuva,
                 shape = Chuva)) +
  geom_point(size = 2) +
  facet_wrap(~Chuva, nrow= 1) +
  theme_bw() +
  labs(x = "Veiculos contagem [veh/h]", 
       y = "Velocidade [km/h]", 
       title = "Ruas Trunk") +
  scale_colour_discrete("Chuva [mm/h]") +
  theme(legend.key.size = unit(2.5,"line"),
        legend.position = "bottom",
        legend.key.height=unit(2,"line"),
        legend.key.width=unit(4,"line"),
        legend.justification = "center",
        legend.text = element_text(size = 15),
        text = element_text(size = 15, colour = "black"),
        axis.text = element_text(size = 15, colour = "black"),
        plot.title  = element_text(hjust = 0.5))

print(p)
dev.off()

png(filename = "/media/sergio/ext4/MOBILAB/figures/fudnamental_all_v1_primary.png", 
    width = 1000, height = 500)
p <-  ggplot(df[df$total > 500 & df$total < 8500 &
                  df$highway %in% c("primary", "primary_link"), ], 
             aes(x = total, 
                 y = speed_kph_mean, 
                 colour = Chuva,
                 shape = Chuva)) +
  geom_point(size = 2) +
  facet_wrap(~Chuva, nrow= 1) +
  theme_bw() +
  labs(x = "Veiculos contagem [veh/h]", 
       y = "Velocidade [km/h]", 
       title = "Ruas Primary") +
  scale_colour_discrete("Chuva [mm/h]") +
  theme(legend.key.size = unit(2.5,"line"),
        legend.position = "bottom",
        legend.key.height=unit(2,"line"),
        legend.key.width=unit(4,"line"),
        legend.justification = "center",
        legend.text = element_text(size = 15),
        text = element_text(size = 15, colour = "black"),
        axis.text = element_text(size = 15, colour = "black"),
        plot.title  = element_text(hjust = 0.5))

print(p)
dev.off()



png(filename = "/media/sergio/ext4/MOBILAB/figures/fudnamental_all_v1_secondary.png", 
    width = 1000, height = 500)
p <-  ggplot(df[df$total > 500 & df$total < 8500 &
                  df$highway %in% c("secondary", "secondary_link"), ], 
             aes(x = total, 
                 y = speed_kph_mean, 
                 colour = Chuva,
                 shape = Chuva)) +
  geom_point(size = 2) +
  facet_wrap(~Chuva, nrow= 1) +
  theme_bw() +
  labs(x = "Veiculos contagem [veh/h]", 
       y = "Velocidade [km/h]", 
       title = "Ruas Secondary") +
  scale_colour_discrete("Chuva [mm/h]") +
  theme(legend.key.size = unit(2.5,"line"),
        legend.position = "bottom",
        legend.key.height=unit(2,"line"),
        legend.key.width=unit(4,"line"),
        legend.justification = "center",
        legend.text = element_text(size = 15),
        text = element_text(size = 15, colour = "black"),
        axis.text = element_text(size = 15, colour = "black"),
        plot.title  = element_text(hjust = 0.5))

print(p)
dev.off()



dt <- as.data.table(df)

dt[, mean(speed_kph_mean, na.rm = T),
   by = .(highway, Chuva)]
