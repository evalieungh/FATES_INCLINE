# Evas workflow for running FATES-CTSM for simulating the INCLINE experiment

###
### using the EMERALD-FATES-platform (see ...)
### look here for code inspiration: https://hexylena.github.io/training-material/topics/climate/tutorials/fates-jupyterlab/tutorial.html

# 1. Input data

### import data from shared files.
https://zenodo.org/record/4108341/files/inputdata_version2.0.0_ALP1.tar


# 2. running a simulation
## create new case
create_newcase --case $HOME/ctsm_cases/fates_alp1 --compset 2000_DATM%1PTGSWP3_CLM50%FATES_SICE_SOCN_MOSART_SGLC_SWAV --res 1x1_ALP1 --machine espresso --run-unsupported


## case setup
cd $HOME/ctsm_cases/fates_alp1
./case.setup

## case build
./case.build

### apply the settings from the settings_INCLINE file here?

## case submit
./case.submit

# 3. Analysing output
### output from the model run comes in netCDF format, which can be read e.g. by Panoply.
### we are interested in how well the different PFTs performed in out simulation.
### some relevant output variable to look at are ...
