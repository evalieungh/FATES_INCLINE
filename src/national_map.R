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
theme_set(theme_bw()) # set ggplot theme

# specify point coordinates
alp4_coords <- data.frame(longitude=c(6.41504),latitude=c(60.9335))

# download background map 
europe <- ne_countries(scale='medium', 
											 continent = 'Europe', 
											 returnclass = 'sf')

# plot map with points for sites
ggplot(data = europe) + 
		geom_sf(fill = "darkgrey") + 
		geom_point(data = alp4_coords, 
							 aes(x = longitude, y = latitude), 
							 size = 1, shape = 16, color = "red") +
		coord_sf(xlim = c(4,31.5), ylim = c(57.5,71))+
  	xlab('') + ylab('')
