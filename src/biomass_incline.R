#################################
#    biomass data - measured    #
#################################

# Data downloaded from OSF, INCLINE project 
# https://osf.io/zhk3m/ Biomass_removal/INCLINE_biomass_removal.csv
# file last modified on OSF: 2022-06-15
# downloaded: 2022-11-23

# Script by Eva Lieungh

#--------------------------

# read the data (bmdf = biomass data frame)
bmdf <- read.csv('data/OSF_INCLINE/INCLINE_biomass_removal.csv')
head(bmdf)

# explore data
unique(bmdf$treatment) # warm (OTC treatment) and cold (ambient climate) removals. No NAs
length(unique(bmdf$plotID)) # 41 plots in total
table(bmdf$treatment,bmdf$year) # 2019,2020 and 2021 treatments
table(bmdf$functional_group,)
