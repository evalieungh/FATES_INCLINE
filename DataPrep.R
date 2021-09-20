###################################
#     FATES_INCLINE data prep     #
###################################

# Eva Lieungh
# Data belong to the INCLINE project (V.Vandvik, J. Töpper, R. Gya ++)

library(tidyverse)


#########    TRAITS    ##########
# measured traits for three species: Veronica officinalis, Sibbaldia procumbens, Succisa pratensis
traits <- read.csv('Data/INCLINE/raw/Eva_traits.csv')
head(traits)
traits <- traits %>% 
	select(Species,Trait,Value,Trait_trans,Precip_level) # excluding most columns.
traits <- na.omit(traits) # removing rows with NA values (277 rows lost)
print(unique(traits$Trait)) # Which traits do we have?
# [1] "Plant_Height_mm"       "Wet_Mass_g"            "Dry_Mass_g"           
# [4] "Leaf_Area_cm2"         "N_percent"             "C_percent"            
# [7] "CN_ratio"              "SLA_cm2_g"             "LDMC"                 
# [10] "Leaf_Thickness_Ave_mm"

# mean trait values
traitmeans <- traits %>% 
	select(Species,Trait,mean = Value) %>% # info about trait transformations is lost! Keep this in mind.
	group_by(Trait,Species) %>%
	summarise_all(funs(mean))
# write.csv(traitmeans,'Data/INCLINE/traitmeans.csv')

# lowest trait values
traitsmin <- traits %>%
	select(Species,Trait,Value) %>% # see above
	group_by(Trait,Species) %>%
	summarise_all(funs(min))

# highest trait values
traitsmax <- traits %>%
	select(Species,Trait,Value) %>% # see above
	group_by(Trait,Species) %>%
	summarise_all(funs(max))

# combine into data frame
traitsdata <- traitmeans
traitsdata$min <- traitsmin$Value
traitsdata$max <- traitsmax$Value

write.csv(traitsdata,'Data/INCLINE/traitsdata.csv')

# Are the traits different for different precipitation levels? If so, maybe I need different parameter values for different sites. Test this later and see Ragnhild's master 



