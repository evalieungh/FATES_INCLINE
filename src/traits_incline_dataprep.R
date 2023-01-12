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
print(unique(traits$Trait_trans)) # Wich traits are transformed, and how?
# [1] "Plant_Height_mm_log"   "Wet_Mass_g_log"        "Dry_Mass_g_log"       
# [4] "Leaf_Area_cm2_log"     "N_percent"             "C_percent"            
# [7] "CN_ratio_log"          "SLA_cm2_g_log"         "LDMC"                 
# [10] "Leaf_Thickness_Ave_mm"

# De-transform values for all log transformed variables
traits <- traits %>%
	mutate(rawValue = ifelse(str_detect(Trait_trans,'log'),exp(Value),NA)) %>%
	mutate(rawValue = coalesce(rawValue,Value))

# mean trait values
traitmeans <- traits %>% 
	select(Species,Trait,mean = rawValue) %>% # info about trait transformations is lost! Keep this in mind.
	group_by(Trait,Species) %>%
	summarise_all(funs(mean))
# write.csv(traitmeans,'Data/INCLINE/traitmeans.csv')

# lowest trait values
traitsmin <- traits %>%
	select(Species,Trait,rawValue) %>% # see above
	group_by(Trait,Species) %>%
	summarise_all(funs(min))

# highest trait values
traitsmax <- traits %>%
	select(Species,Trait,rawValue) %>% # see above
	group_by(Trait,Species) %>%
	summarise_all(funs(max))

# combine into data frame
traitsdata <- traitmeans
traitsdata$min <- traitsmin$rawValue
traitsdata$max <- traitsmax$rawValue

write.csv(traitsdata,'Data/INCLINE/traitsdata.csv')

# Are the traits different for different precipitation levels? If so, maybe I need different parameter values for different sites. Test this later and see Ragnhild's master 



