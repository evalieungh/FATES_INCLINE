#######################################
#     CLM-FATES output analysis       #
#######################################

# For inspiration, see:
# https://www.r-bloggers.com/2016/08/a-netcdf-4-in-r-cheatsheet/ 
# 

library(ncdf4)
library(fields)

ncpath <- 'Data/platformtest_alp4_august2020/archive/platformtest_alp4_jun2020/lnd/hist/'
files = list.files(ncpath,pattern='*.nc',full.names=TRUE)# there are over 21 thousand files! Reading the first and last for now.
ncname1 <- 'platformtest_alp4_jun2020.clm2.h0.0001-01'
ncname2 <- 'platformtest_alp4_jun2020.clm2.h0.1791-12'
ncfname <- paste(ncpath, ncname1, ".nc", sep="")
ncdata <- nc_open(ncfname)
View(ncdata) # the variables are inside the 'var' list at the bottom.

# make a text file to view the nc file attributes there
{
	sink('platformtest_aug_2020_alp1.txt')
	print(ncdata)
	sink()
}

# look at the file attributes
nc_atts <- ncatt_get(ncdata, 0); View(nc_atts)
attributes(ncdata)$names
print(paste("The file has",ncdata$nvars,"variables,",ncdata$ndims,"dimensions and",ncdata$natts,"NetCDF attributes")) # The file has 436 variables, 41 dimensions and 36 NetCDF attributes
attributes(ncdata$dim)$names

# Get a list of the nc variable names.
attributes(ncdata$var)$names

ncatt_get(ncdata, attributes(ncdata$var)$names[1]) # replace number to see different variables

# Retrieve a matrix of the first var, "FATES size-class map into size x patch age"
sizeClassMap <- ncvar_get(ncdata, attributes(ncdata$var)$names[1]) # 
dim(sizeClassMap) # 91 

# Look at some one-dimensional values
AREA_PLANT <- ncvar_get(ncdata, 'AREA_PLANT') # total area occupied by plants 
CANOPY_AREA_BY_AGE <- ncvar_get(ncdata, 'CANOPY_AREA_BY_AGE')
ED_NCOHORTS <- ncvar_get(ncdata, 'ED_NCOHORTS') # 
ED_NPATCHES <- ncvar_get(ncdata, 'ED_NPATCHES') #
ED_balive <- ncvar_get(ncdata, 'ED_balive') # gC_m^2
ED_biomass <- ncvar_get(ncdata, 'ED_biomass')
ELAI <- ncvar_get(ncdata, 'ELAI')# exposed one-sided leaf area index, unit m2/m2
SEED_BANK <- ncvar_get(ncdata, 'SEED_BANK') # 
SEEDS_IN_LOCAL_ELEM <- ncvar_get(ncdata, 'SEEDS_IN_LOCAL_ELEM') # 
SEEDS_IN_EXTERN_ELEM <- ncvar_get(ncdata, 'SEEDS_IN_EXTERN_ELEM') # 
LEAF_HEIGHT_DIST <- ncvar_get(ncdata, 'LEAF_HEIGHT_DIST')

RECRUITMENT
SEEDS_IN
SEEDS_IN_EXTERN_ELEM #  External Seed Influx Rate
SEED_BANK
SEED_BANK_ELEM
SEED_GERM_ELEM

# 




# close the connection to the nc file when done!
nc_close(ncdata)
