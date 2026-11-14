# Script for finding bias correction factor for GSWP3 temperature, relative to local observations.

import xarray as xr  # NetCDF data handling
import matplotlib.pyplot as plt  # Plotting
import pandas as pd  # Tabular data handling
import time  # Keeping track of runtime
import json  # For reading data dictionaries stored in json format
import datetime as dt  # for workaround with long simulations (beyond year 2262)
from pathlib import Path
import urllib.request  
import shutil
import zipfile

# Define site code and paths to climate forcing and local observations
#site_code = "ALP4"
gswp3_path = Path("/cluster/shared/noresm/inputdata/evaler/inputdata/skj_pt_gswp3/datmdata")
vcg_path = Path("/cluster/work/users/evaler/noresm/FATES_INCLINE/data/VCG_OSF/VCG_clean_gridded_daily_climate_2008-2022.csv")

# load observation data and subset temperature
print("Read observation data. It looks like this:")
obs_climate_df = pd.read_csv(vcg_path, low_memory=False)
print(obs_climate_df.head())

print(obs_climate_df["siteID"].unique())

print("Subset temperature at Skjellingahaugen. New subset:")
temperature_df = obs_climate_df[(obs_climate_df["siteID"] == "Skjelingahaugen") & (obs_climate_df["variable"] == "temperature")].reset_index(drop=True)
temperature_df['date_pd'] = pd.to_datetime(temperature_df['date'])
print(f"Shape: {temperature_df.shape}")
print(f"Data types:\n{temperature_df.dtypes}")
print(temperature_df.head())

print("------------- observation temperature stats -------------")
print("Mean temperature:", temperature_df['value'].mean())
print("Median temperature:", temperature_df['value'].median())
print("Min temperature:", temperature_df['value'].min())
print("Max temperature:", temperature_df['value'].max())
print("Standard deviation:", temperature_df['value'].std())
print("Quantiles:", temperature_df['value'].quantile())

# Load GSWP3 netcdf data
print("----------------------------------------------------")
print("start reading gswp3 data")
start_time = time.time()
gswp3_temperature = xr.open_mfdataset(
    f'{gswp3_path}/*TPQWL*.nc',
    concat_dim='time',
    combine='nested',
    decode_times=True
)
print(f"it took {round(float(time.time() - start_time), 3)} seconds to read the gswp3 data.")

# convert gswp3 data to data frame
gswp3_df = pd.DataFrame(columns=['date', 'temperature'])
# Subset date, convert to datetime format. Expect a warning due to GSWP3 special NOLEAP calendar format.
gswp3_df['date'] = gswp3_temperature.indexes['time'].to_datetimeindex()
# Subset temperature, convert from degrees Kelvin to Celcius
gswp3_df['temperature'] = gswp3_temperature['TBOT'].values.flatten() - 273.15
# Convert to daily means
gswp3_daily_temp_df = gswp3_df.groupby(pd.Grouper(key='date', freq='D'))['temperature'].mean()
print("The GSWP3 data frame looks like this after conversion from 3-hourly data to daily means:")
print(gswp3_daily_temp_df.head())

print("------------- GSWP3 temperature stats -------------")
print("Mean temperature:", gswp3_daily_temp_df.mean())
print("Median temperature:", gswp3_daily_temp_df.median())
print("Min temperature:", gswp3_daily_temp_df.min())
print("Max temperature:", gswp3_daily_temp_df.max())
print("Standard deviation:", gswp3_daily_temp_df.std())
print("Quantiles:", gswp3_daily_temp_df.quantile())

print("----------------------------------------------------")
print("-------------- comparison ------------------")
print("Difference in means = ", gswp3_daily_temp_df.mean() - temperature_df['value'].mean())
