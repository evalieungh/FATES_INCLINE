#######################################
#     Function for reading in         #
#     multiple CLM-FATES nc files     #
#######################################

# Copied from https://www.r-bloggers.com/2016/08/a-netcdf-4-in-r-cheatsheet/
# Needs modification to fit CLM-FATES output!

# Define the function
process_nc <- function(files){
	# iterate through the nc
	for (i in 1:length(files)){
		# open a conneciton to the ith nc file
		nc_tmp <- nc_open(paste0("data/", files[i]))
		# store values from variables and atributes
		nc_chla <- ncvar_get(nc_tmp, attributes(nc_tmp$var)$names[1])
		nc_lat <- ncvar_get(nc_tmp, attributes(nc_tmp$dim)$names[1])
		nc_lon <- ncvar_get(nc_tmp, attributes(nc_tmp$dim)$names[2])
		nc_atts <- ncatt_get(nc_tmp, 0)
		nc_start_date <- as.Date(nc_atts$period_start_day, format = "%Y%m%d", tz = "UTC")
		# close the connection sice were finished
		nc_close(nc_tmp)
		# set the dimension names and values of your matrix to the appropriate latitude and longitude values
		dimnames(nc_chla) <- list(lon=nc_lon, lat=nc_lat)
		
		# I'm choosing to store all the data in long format.
		# depending on your workflow you can make different choices here...
		# Your variable may get unmanageably large here
		# if you have high spatial and temporal resolution nc data.
		tmp_chl_df <- melt(nc_chla, value.name = "chla")
		tmp_chl_df$date_start <- nc_start_date
		
		# set the name of my new variable and bind the new data to it
		if (exists("chla_data_monthly")){
			chla_data_monthly <- bind_rows(chla_data_monthly, tmp_chl_df)
		}else{
			chla_data_monthly <- tmp_chl_df
		}
		# tidy up, not sure if necesarry really, but neater
		rm(nc_chla, nc_lat, nc_lon, nc_tmp, nc_atts, nc_start_date, tmp_chl_df)
	}
	
	return(chla_data_monthly)
}


data <- process_nc(flist)