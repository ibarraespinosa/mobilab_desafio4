library(sf)
library(ggplot2)
library(data.table)
df <- readRDS("/media/sergio/ext4/MOBILAB/merged.rds")
# SEMANA de dia 25 ate 

df <- df[df$LT %in% unique(df$LT)[433:672], ]

png(filename = "/media/sergio/ext4/MOBILAB/figures/fudnamental_all_v1_NO_CARNAVAL.png", width = 1000, height = 500)
p <-  ggplot(df[df$total > 500 & df$total < 8500, ], 
             aes(x = total, 
                 y = speed_kph_mean, 
                 colour = Chuva,
                 shape = Chuva)) +
  geom_point(size = 4) +
  facet_wrap(~Chuva, nrow= 1) +
  theme_bw() +
  labs(x = "Veiculos contagem [veh/h]", 
       y = "Velocidade [km/h]",
       title = "Desde 2018-02-19 00:00 ate 2018-02-28 23:00 (Depois Carnaval)") +
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





png(filename = "/media/sergio/ext4/MOBILAB/figures/fudnamental_all_v1_NO_CARNAVAL.png", width = 1000, height = 500)
p <-  ggplot(df[df$total > 500 & df$total < 8500, ], 
             aes(x = total, 
                 y = speed_kph_mean, 
                 colour = Chuva,
                 shape = Chuva)) +
  geom_point(size = 4) +
  facet_wrap(~tipo, nrow= 1) +
  theme_bw() +
  labs(x = "Veiculos contagem [veh/h]", 
       y = "Velocidade [km/h]",
       title = "Desde 2018-02-19 00:00 ate 2018-02-28 23:00 (Depois Carnaval)") +
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



