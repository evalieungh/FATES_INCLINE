##########################################
#     FATES_INCLINE traits to params     #
##########################################

# script by Eva Lieungh

# transform measured traits (SeedClim/INCLINE) into min, mean, and max parameter values for Sib_pro, Sub_pra, Ver_off.

library(tidyverse)

# Characteristic leaf dimension
# ------------------------------------------------
# fates_leaf_diameter:long_name = "Characteristic leaf dimension"
# see https://github.com/NGEET/fates/issues/815 
# For Suc_pra and Ver_off, leaf width (=WL) is measured directly.
wl <- read.csv('Data/INCLINE/SucVer_WL.csv')
wl <- na.omit(wl)
ll <- read.csv('Data/INCLINE/sibpro_ll.csv')
# For Sib pro, only leaflet length (=LL) is measured: "The ratio of the length to the breadth of the leaflet is 1-2:1 and is constant for the species throughout its geographical range" Coker, P. D. (1966). Sibbaldia Procumbens L. Journal of Ecology, 54(3), 823–831. https://doi.org/10.2307/2257820
# To convert from leaflet length to width, assume the ratio is 2:1 and divide lengths by 2
wl2 <- as.vector(ll/2)

wl_param <- wl %>%
	group_by(Species) %>%
	summarise_at(vars(WL), funs(min, mean, max)) 

mmm <- wl2 %>% summarise_at(vars(LL),funs(min, mean, max))

wl_param <- wl_param %>% 
	add_row(Species='Sib_pro',min=mmm$min, mean=mmm$mean, max=mmm$max,
					.before = 1) %>%
	pivot_longer(cols = 2:4)

(wl_param$fates_leaf_diameter <- wl_param$value*0.77/1000) # convert width to characteristic leaf dimension

write.csv(wl_param,'Data/INCLINE/fates_leaf_diameter.csv')

# Specific Leaf Area
# ------------------------------------------------
# measured data in cm^2/g
# parameters fates_leaf_slamax (Maximum Specific Leaf Area (SLA), even if under a dense canopy) and fates_leaf_slatop (Specific Leaf Area (SLA) at top of canopy, projected area basis)

double fates_leaf_slamax(fates_pft) ;
fates_leaf_slamax:units = "m^2/gC" ;
fates_leaf_slamax:long_name = "Maximum Specific Leaf Area (SLA), even if under a dense canopy" ;
## We have "SLA_cm2_g". See param under - is the measurement better suited
## for that parameter? If so, should we change both, and if so should we
## adjust this one to be a bit lower?
## Default is = 0.03 m^2/gC

double fates_leaf_slatop(fates_pft) ;
fates_leaf_slatop:units = "m^2/gC" ;
fates_leaf_slatop:long_name = "Specific Leaf Area (SLA) at top of canopy, projected area basis" ;
## We have "SLA_cm2_g". Almost directly transferrable?
## Sib_pro 191.12, Suc_pra 292.49, Ver_off 164.52 in cm^2/g. Converting to m^2/gC
## by using percent Carbon per species:
## Sib_pro (191.12*0.456)/100 = 0.872 m^2/gC,
## Suc_pra (292.49*0.463)/100 = 1.35 m^2/gC,
## Ver_off (164.52*0.479)/100 = 0.788 m^2/gC
## Default is = 0.03 m^2/gC
# paramfile line 987


double fates_recruit_hgt_min(fates_pft) ;
fates_recruit_hgt_min:units = "m" ;
fates_recruit_hgt_min:long_name = "the minimum height (ie starting height) of a newly recruited plant" ;
## Maybe lower this to e.g. mean Juvenile height from measured demography data?
## Juveniles were not measured specifically. Rather use minimum value of adult plants:
## Sib_pro 47.53 mm = 0.0475 m
## Suc_pra 146.2 mm = 0.146 m
## Ver_off 56.75 mm = 0.0568 m
## Default = 0.125 m = 125 mm
