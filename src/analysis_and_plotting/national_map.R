# National site illustration map
#--------------------------------

# copied and modified from https://github.com/evalieungh/map_scripts
# 2023-04-19

library(rnaturalearth) 
library(tidyverse)
library(ggplot2)
library(mapdata)
library(raster)
library(sf)

# specify point coordinates
alp4_coords <- data.frame(longitude=c(6.41504),latitude=c(60.9335))

# download background map 
europe <- ne_countries(scale='medium', 
											 continent = 'Europe', 
											 returnclass = 'sf')

# plot map with points for sites
fig1_map <- ggplot(data = europe) +
  geom_sf(fill = "darkgrey",
          size = 1) +
  geom_point(
    data = alp4_coords,
    aes(x = longitude, y = latitude),
    size = 1,
    shape = 19,
    color = "red"
  ) +
  coord_sf(xlim = c(-6, 23),
           ylim = c(45, 70)) +
  xlab('') + ylab('') +
  theme_minimal() +
  theme(axis.text = element_blank()
  #  axis.text.x = element_text(
  #    size = 8,
  #    angle = 270,
  #    hjust = 0,
  #    vjust = 0.5
  #  ),
  #  axis.text.y = element_text(size = 8),
  )
fig1_map

# save the figure
ggsave("../results/figures/fig1_map.jpeg",
       plot = fig1_map,
       device = "jpeg",
       width = 500, 
       height = 750,
       dpi = "print",
       units = "px")
