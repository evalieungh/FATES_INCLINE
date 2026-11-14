# Simulation setup instructions

This document was created 2025-05-12 and is inspired by several sources, e.g. https://hackmd.io/@pYjjfkwmSfW932OvIjzLHA/H1YNgFXqJl

Created by Eva Lieungh with help from Yeliz Yilmaz, Lasse T. Keetz and others.

This guide is written to document model installation, simulations setup, and running the model on the Norwegian HPC Betzy. The model repo (CTSM) is stored under my home folder (/cluster/home/evaler/). My own forcing data (subset and modified from defaults), and shared default data (used for subsetting) is available in the project. The FATES_INCLINE repo, case folders, and model outputs are in my Betzy work folder (/cluster/work/users/evaler/).

The goal is to perform four simulations, the first being a spinup simulation to create a baseline file to restart other cases from. All simulations will be restricted to grass PFTs only and feature improved surface data (changed according to local observations) and simple grazing enabled for all land use classes and PFTs. The spinup simulation will be a cold start from bare ground, with default GSWP3 atmospheric forcing. All simulations will use an I2000 compset, thus representing a recent climate and *not* historical progression. The goal is to run simulations that are long enough to get an equilibrium with the climate and stable soil properties.

Three restart simulations will represent different climates and be used to simulate climate warming and the open-top-chamber effect from the INCLINE field experiment.
These three simulations will start from the spinup restart file, and run for two cycles the 113 years of GSWP3 forcing. Results will be presented from the final 14 years (2000--2014). The simulations will differ only in atmospheric forcing:
	1. Bias-corrected GSWP3 ("cold")
	2. Default GSWP3 which has a warm bias ("warm")
	3. Warming treatment with open-top-chamber effect ("experiment")

All simulaitons are single-site, at the Skjellingahaugen site of the Vestland Climate Grid. This site is also available in the LSP. Skjellingahaugen has coordinates lon 6.41504, lat 60.9335, at 1088 m elevation, and land cover is open, alpine vegetation. Mean summer temperature is 7 degrees C, and mean annual precipitation is 3402 mm.

## 1. Initial set up of model and environment

Download the Community Terrestrial Systems Model (incl. CLM), checkout a specific tag and update submodules. Used the most recent tag as of May 2025.

```
cd /cluster/home/evaler
git clone https://github.com/NorESMhub/CTSM.git
cd CTSM
git checkout tags/ctsm5.3.034_noresm_v6 -b ctsm5.3.034_noresm_v6
./bin/git-fleximod update
```

### 1.1 Create and load conda environment

Create a conda environment with the packages CTSM needs to subset global data. The conda env should be placed in the project folder because it will create very many files that would otherwise make the home folder exceed the max allowed file number. Run the shell script `create_conda_env.sh` which will purge (unload) existing modules, install conda with Miniforge, specify that packages should be under /cluster/projects/nn9774k/conda/evaler, and create the ctsm-env conda environment containing a list of packages listed under CTSM/python/conda_env_ctsm_latest.txt. Then activate the environment in the terminal you are working in.

```
cd /cluster/home/evaler/FATES_INCLINE/src/data_handling
./create_conda_env.sh

module purge 
module load Miniforge3/24.1.2-0
conda init
conda activate /cluster/projects/nn9774k/conda/evaler/ctsm-env
```

## 2. Set up model input data

Store model input data (atmospheric forcing, durface data, domain) under /cluster/shared/noresm/inputdata/evaler/inputdata/. 

### 2.1 Atmospheric forcing data

#### 2.1.2 Default GSWP3 (with warm bias)
See [notes on forcing data preparation](../data_handling/create_singlepoint_gswp3.md). This creates a single-site subset of the GSWP3 data that fits the model version used here. 
Finished default GSWP3 data for site Skjellingahaugen is stored in /cluster/shared/noresm/inputdata/evaler/inputdata/skj_pt_gswp3. The default, warm forcing

#### 2.1.2 Cold adjustment (simplistic bias correction)
From the default atmospheric forcing, create a bias-corrected version. First, find a correction factor based on local observations. 

```
python bias_gswp3_vs_vcg_temperature.py > bias_correctionfactor_log.txt
```

Then make a copy of the default forcing and modify it

```
cd /cluster/shared/noresm/inputdata/evaler/inputdata
cp -r skj_pt_gswp3 skj_pt_gswp3-cold

cd /cluster/work/users/evaler/noresm/FATES_INCLINE/src/data_handling
chmod +x create_cold_gswp3.sh
./create_cold_gswp3.sh
```
Make sure the temperature looks reasonable, e.g. by looking at the numbers of a sample file with `ncdump`. 

#### 2.1.3 Experimental treatment (Open-Top-Chamber effect)
From the cold version, create the open-top-camber (OTC) version of atmospheric forcing. Assuming logger placement/removal dates coincide well with OTC placement and removal dates, data from INCLINE_metadata_LoggerDates. csv, https://osf.io/5nmfe, gives these dates:

| Site  | placement  |  removal  |
|  ---- | --------   | --------- |
| Ulvehaugen, ALP1 | 2019-06-11, 2021-06-17 | 2020-09-22, 2021-09-29 |
| Lavisdalen, ALP2 | 2019-06-19, 2021-06-15 | 2020-09-29, 2021-09-28 |
| Gudmedalen, ALP3 | 2019-06-12, 2021-06-16 | 2020-09-30, 2021-09-28 |
| Skjellingahaugen, ALP4 | 2019-06-20, 2021-06-18 | 2020-09-28, 2021-09-27 |

For simplicity, use June 1st and Sept 30 as placement and removal dates for all sites and years. We only apply the OTC effect between these dates. 

We choose 1 degree (C or K) as a flat increase for the general representation of warming treatment, and add a 2-degree flat increase as an extreme version of the heating treatment.

The forcing data is provided at 3-hourly time steps. Let's choose 06:00 to 21:00 as 'daytime' when we apply the temperature modification. We choose 21:00 instead of 18:00 because high temperatures generally persist into the evenings in the summer because the sun goes down late in summer. For GSWP3 forcing, times are given in fractional days, 'days since start of month'. We want to modify TBOT when the time has one of these decimals:
.3125 corresponds to hourly interval 06-09
.4375 corresponds to hourly interval 09-12
.5625 corresponds to hourly interval 12-15
.6875 corresponds to hourly interval 15-18
.8125 corresponds to hourly interval 18-21

Also, add the correct input data folder to the `shell_commands` file after creating each version.

```
cd /cluster/work/users/evaler/noresm/FATES_INCLINE/src/data_handling
chmod +x otc_effect_forcing_modification.sh
./otc_effect_forcing_modification.sh
cd /cluster/shared/noresm/inputdata/evaler/inputdata
rm copy*
vi skj_pt_gswp3/user_mods/shell_commands
```

### 2.3 Modify surface data
First, manually upload the following Vestland Climate Grid data files (from https://osf.io/npfa9) to the data folder (/cluster/work/users/evaler/noresm/FATES_INCLINE/data/VCG_OSF):
- VCG_clean_gridded_daily_climate_2008-2022.csv (https://osf.io/s9k7c)
- VCG_clean_soil_chemistry_2009_2010_2013_2015.csv
- VCG_clean_soil_structure_2013_2014_2018.csv
- VCG_clean_soilmoisture_plotlevel_2015-2018.csv
- INCLINE_metadata.csv

Then run this shell script that executes a python script to read and process data and create a modified version, and replaces the surface data in the input data folders with the new modified version:

```
cd /cluster/work/users/evaler/noresm/FATES_INCLINE/src/data_handling
chmod +x surfacedata_mod_exec.sh
chmod +x surfacedata_modification.py
./surfacedata_mod_exec.sh
```

Make sure the surface data is in the correct format. Convert from netcdf-4 to cdf5 if necessary.

```
cd /cluster/work/users/evaler/noresm/FATES_INCLINE/src/data_handling
chmod +x surfacedata_file_conversion.sh
./surfacedata_file_conversion.sh
```

The finished modified surface data is stored as `/cluster/shared/noresm/inputdata/evaler/inputdata/surfdata_ALP4_hist_2000_16pfts_c250701_modified.nc`
Copy it into each input data folder so it can be used from there following the standard format in user_nl_clm (e.g. fsurdat = '$CLM_USRDAT_DIR/surfdata_ALP4_hist_2000_16pfts_c250701_modified.nc')

```
cd /cluster/shared/noresm/inputdata/evaler/inputdata
cp surfdata_ALP4_hist_2000_16pfts_c250701_modified.nc skj_pt_gswp3/surfdata_ALP4_hist_2000_16pfts_c250701_modified.nc 
```

### 2.4 Modify SLA and grazing, and create grass-only FATES parameter file
Run a script to copy and modify FATES parameter file. It uses FATES' script tools/modify_fates_paramfile.py to change the SLA accroding to local observtions. For fates_leaf_slatop, set the parameter to 0.0376 m²/gC (from 0.03 m²/gC default). Use FATES' IndexSwapper script to make a new FATES parameter file with only grass PFTs. Grass PFTs are arctic_c3_grass,cool_c3_grass,c4_grass (index numbers 12,13,14).

See e.g. <https://fates-users-guide.readthedocs.io/projects/tutorial/en/latest/parameter_file_tools.html>

The script first makes a copy of the default parameter file and renames it `fates_params_default_unchanged.cdl`. 

```
cd /cluster/work/users/evaler/noresm/FATES_INCLINE/src/simulation_setup/
chmod u+x modify_FATES_PFTs.sh
./modify_FATES_PFTs.sh
```

The correct parameterfile must be specified in the namelist (user_nl_clm) of each case if it differs from the (new) default with all PFTs. Also check `CTSM/bld/namelist_files/namelist_defauls_ctsm.xml`. The FATES parameter file is set on line 536 (and the CLM parameter file just above on L58). 

New as of early 2025, FATES can also perform a simple grazing process. See <https://github.com/NGEET/fates/pull/1140>.
It applies to fates-sci.1.80.14_api.37.0.0-ctsm5.3.024 and newer. By default, grazing is only supposed to apply to the 'rangeland' (and pasture?) land use class, but I want to add it to all the land use classes to make sure it applies to my site as well. The grazing rate may be necessary to adjust, but I will set it to a relatively small amount for testing (0.05 relative intensity of leaf grazing/browsing).

See these relevant FATES parameters:

| parameter | notes     | longname |
| --------- | --------- | -------- |
|  fates_landuseclass_name =  "primaryland",   "secondaryland",   "rangeland",   "pastureland",  "cropland" ; | Main FATES will by default apply grazing functionality to rangeland (I think) | "Name of the land use classes, for variables associated with dimension fates_landuseclass" |
| fates_landuse_grazing_rate = 0, 0, 0, 0, 0 ;  | Has same dimensions as land use classes - assume the rate applies to that land use class (first index = primaryland). Set this to some small amount | "fraction of leaf biomass consumed by grazers per day" |
| fates_landuse_grazing_palatability = 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1 ; | By default grazing only applies to grass PFTs. Change to apply to all. Unitless, 0-1 | "Relative intensity of leaf grazing/browsing per PFT" |
| fates_landuse_grazing_maxheight | in m, by default =1. Change to 1.5? Cows, sheep and elk should be able to reach above 1m I think.  | "maximum height that grazers (browsers, actually) can reach" |
| fates_landuse_grazing_carbon_use_eff, fates_landuse_grazing_nitrogen_use_eff, fates_landuse_grazing_phosphorus_use_eff, | Do not change for now. | |

Grazing modification is executed with a script: 

```
cd /cluster/work/users/evaler/noresm/FATES_INCLINE/src/simulation_setup
chmod+x modify_FATES_grazing_params.sh
./modify_FATES_grazing_params.sh
```

## 3. Set up cases and run the model

Create cases, which will be placed in /cluster/work/users/evaler/noresm/FATES_INCLINE/cases/casename. Make the 'cases' folder if necessary (`mkdir cases`). There is one create case script per case. Make them executable with `chmod +x <create_case_....sh>`. Next, run ./case.setup to build the namelist. 

```
cd /cluster/work/users/evaler/noresm/FATES_INCLINE/src/simulation_setup/create_case_scripts
./create_case_spinup.sh

cd /cluster/work/users/evaler/noresm/FATES_INCLINE/cases/spinup
./case.setup
```

### 3.1 Namelist and xml changes

Xml changes and namelist changes are added by scripts. The changes are applied using ./xmlchange (simulation time etc.) and lines added to user_nl_clm (inside case directory), changing the surface data and parameter files (other options: `fates_params_grassonly.nc` or `fates_params_default.nc`). For the simulations based on cold-adjusted forcing, a CLM snow parameter (precip_repartition_nonglc_all_snow_t) was changed from 0 to -1 in order to get less snow between 0 and -1 degrees C.

```
cd /cluster/work/users/evaler/noresm/FATES_INCLINE/src/simulation_setup/xmlchage_scripts
chmod +x xmlchange_spinup.sh
./xmlchange_spinup.sh
```
Check that user_nl_clm now contains these lines:

```
fsurdat = '$CLM_USRDAT_DIR/surfdata_ALP4_hist_2000_16pfts_c250701_modified.nc'
fates_paramfile='/cluster/home/evaler/CTSM/src/fates/parameter_files/fates_params_grazing_grassonly.nc'
use_excess_ice = .false.
# and for restart simulations (cold, warm, experiment):
finidat = '/cluster/work/users/evaler/noresm/spinup/run/spinup.clm2.r.4726-01-01-00000.nc'
```

NB! To be able to use the soil depth (zbedrock) modification in the modified surface data, 
`use_bedrock = .true.` also needs to be set in the namelist. But it results in an error related to CN balance checks, so we have to take it out for now. This means that even though I have changed the depth to bedrock in the surface data, this information will not be used in the simulation. See <https://github.com/ESCOMP/CTSM/pull/1902> and <https://github.com/ESCOMP/CTSM/issues/1888>.  <https://bb.cgd.ucar.edu/cesm/threads/use_bedrock-leading-to-cnbalancecheck-error-in-clm-fates.11577/>

To continue a run of the same case, run `./xmlchange CONTINUE_RUN=TRUE` for the case before submitting.

### 3.2 Build the case
Then, build the case so it is ready for running, and run a check to see if there are any issues. If the case has already been built before and you need to change something, run `./case.build --clean` first.

```
cd /cluster/work/users/evaler/noresm/FATES_INCLINE/cases/BA-GSWP3
./case.build
```

Build logs, and output from the simulation, will be placed under /cluster/work/users/evaler/noresm/casename. 
Go there and check the logs just in case to see that there are no errors. 

### 3.3 Submit the case
The final step is to submit a job to run the model.

```
./case.submit
```

When a case is running, output files will be stored temporarily in the run directory (e.g. /cluster/work/users/evaler/noresm/spinup/run) befor it is moved to archive.

## 4. Download case folder and model output
The output from a case will be in /cluster/work/users/evaler/archive/<casename>. 

### 4.1 Concatenate case
The output is given as monthly files, so I will combine them first so it's easier to plot and work with a single file. Combine the files, then download all the output to do analysis offline. First, concatenate/combine history files for a given case name:

```
cd /cluster/work/users/evaler/noresm/FATES_INCLINE/src/data_handling
chmod u+x ./concatenate_case.sh
./concatenate_case.sh cold
```
NB! If there are multiple history tapes, these should be concatenated separately. Add it to the script ^ or do it manually if necessary. 

NB! Older versions of Panoply cannot open new NetCDF data. My Panoply version can open new model output after conversion to NetCDF4. 

### 4.2 Download files
Open a local wsl terminal and download all the cases and archives. For each case, download the run and bld directories as well. Example for case 'cold':

```
rsync --info=progress2 -a evaler@betzy.sigma2.no:/cluster/work/users/evaler/noresm/FATES_INCLINE/cases .
rsync --info=progress2 -a evaler@betzy.sigma2.no:/cluster/work/users/evaler/archive .
cd cases/cold
rsync --info=progress2 -a evaler@betzy.sigma2.no:/cluster/work/users/evaler/noresm/cold/bld .
rsync --info=progress2 -a evaler@betzy.sigma2.no:/cluster/work/users/evaler/noresm/cold/run .
```

Download the input data as well to ensure possibility to replicate simulations. These will be uploaded to zenodo later.

```
rsync --info=progress2 -a evaler@betzy.sigma2.no:/cluster/shared/noresm/inputdata/evaler/inputdata .
```

Download the model. Move altered files into `/src/model_modifications`

```
rsync --info=progress2 -a evaler@betzy.sigma2.no:/cluster/home/evaler/CTSM /mnt/c/Users/evaler/model_output/.
```

------------------------------------------------------------------------------

## Useful commands

```
# jobs
squeue --me
scancel <jobID>
Ctrl z [to stop process running in terminal]

# model versions/tags
./bin/git-fleximod status
git describe --tags

# data usage and quota
dusage

# NetCDF conversion
nccopy -k 'cdf5' in.nc out.nc
nccopy -k 'netCDF-4' in.nc out.nc
ncdump in.nc > out.cdl

# inspect data
ncdump file.nc
ncks -v TBOT forcingTPQWLfile.nc
```

## Model modifications

Modified versions of model files are stored under ../model_modifications for reference.

cp <file> /cluster/work/users/evaler/noresm/FATES_INCLINE/src/model_modifications


# LOG / TO DO

Download the entire work dir for backup of model output, repo and case folders in case something is lost with:
`rsync --info=progress2 -a evaler@betzy.sigma2.no:/cluster/work/users/evaler  /mnt/c/Users/evaler/model_output`
Done 2025-07-11, make another backup before end of August!

- zip spinup and simulation history files
- download outputs
- sort into archive & finished results
- upload finished results to zenodo
