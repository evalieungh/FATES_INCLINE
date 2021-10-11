# -----------------------------------------------------------------------------
# Evas workflow for running FATES-CTSM for simulating the INCLINE experiment
# -----------------------------------------------------------------------------

### using NREC virtual machine
### using the EMERALD-FATES-platform https://github.com/NorESMhub/NorESM_LandSites_Platform
### Code is executed in MobaXterm session on eva_dev instance (a virtual machine)
### on NREC. See the 'Using Virtual Machine and MobaXterm' file for setup

# 1. Model and input data - handled by the platform
### NorESM-CLM-FATES version:
### compset:
### domain (location): 1x1_ALP1, 1x1_ALP4

# 2. Setting up custom simulations
### Define custom PFTs, see 'change_param_file' script.
### Making 9 PFTs: Min, average, and max version of three species.

### apply the settings from the settings_INCLINE file

## create new case
create_newcase --case $HOME/ctsm_cases/fates_alp1 --compset 2000_DATM%1PTGSWP3_CLM50%FATES_SICE_SOCN_MOSART_SGLC_SWAV --res 1x1_ALP1 --machine espresso --run-unsupported

## test ALP1 - case already made
## Lasse has python script to set up model

## case setup
cd $HOME/ctsm_cases/fates_alp1
./case.setup

## PFT test case
## To ensure all our custom PFTS are able to grow in the modelled climate at all,
## use FATES ‘nocomp’ mode. "Activating ‘fates_use_nocomp=.true.’ has the effect
## of putting each PFT in your parameter file on it’s own patch. From this, you
## can assess whether plants can potentially exist independent of the impacts
## of light competition"
cd ..?
fates_use_nocomp=.true.
#add manually in user clm file


# 3. running the simulation
## case build
./case.build

## case submit
./case.submit

# 4. Analysing output

## go to the directory of the case(s)
cd $HOME/work/fates_alp1
ls -la
### bld: contains object and CESM executable (cesm.exe) for the run configuration.
### run: used during the run to generate output files, etc.
### Once the run is terminated, many files are moved from the run folder
### to the archive folder.

cd $HOME/archive/fates_alp1
ls lnd/hist
### the relevant output is in “history” files.
### These files are located in lnd/hist folder.

### output from the model run comes in netCDF format, which can be read
### e.g. by Panoply, but also in R (with netcdf4 package) or Python.
### we are interested in how well the different PFTs performed in our simulation.
### some relevant output variable to look at are ...
