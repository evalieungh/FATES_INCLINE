# -----------------------------------------------------------------------------
# Evas workflow for running FATES-CTSM for simulating the INCLINE experiment
# -----------------------------------------------------------------------------

### using NREC virtual machine
### using the EMERALD-FATES-platform (see ...)
### look here for code inspiration:
### https://hexylena.github.io/training-material/topics/climate/tutorials/fates-jupyterlab/tutorial.html


# 1. Model and input data - OK
### install the platform
git clone https://github.com/NorESMhub/NorESM_LandSites_Platform.git

### import data from shared files. - OK
https://zenodo.org/record/4108341/files/inputdata_version2.0.0_ALP1.tar
#### See all parameters specifying CTSM running options in this appendix:
#### https://www.cesm.ucar.edu/models/ccsm4.0/ccsm_doc/a4234.html


# 2. running a simulation

### apply the settings from the settings_INCLINE file here

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

## case build
./case.build

## case submit
./case.submit

cd $HOME/work/fates_alp1
ls -la
### bld: contains object and CESM executable (called cesm.exe) for the run configuration
### run: used during the run to generate output files, etc.
### Once the run is terminated, many files are moved from the run folder to the archive folder

cd $HOME/archive/fates_alp1
ls lnd/hist
### the relevant output is in “history” files. These files are located in lnd/hist folder

# 3. Analysing output
### output from the model run comes in netCDF format, which can be read e.g. by Panoply.
### we are interested in how well the different PFTs performed in out simulation.
### some relevant output variable to look at are ...

## make plots using xarray
import xarray as xr
xr.set_options(display_style="html")
%matplotlib inline

case = 'fates_alp1'    # change case names here
path = os.path.join(os.getenv('HOME'), 'archive', case, 'lnd', 'hist')
dset = xr.open_mfdataset(path + '/*.nc', combine='by_coords')    # open_mfdataset to read all the netCDF files available in the history folder. The option combine='by_coords') is used to tell the method open_mfdataset how to combine the different files together
dset

dset['AREA_TREES'].plot(aspect=3, size=6) # change the variable name in '' to plot different variables!


## saving a plot
import matplotlib.pyplot as plt
fig = plt.figure(1, figsize=[14,7])
ax = plt.subplot(1, 1, 1)
dset['AREA_TREES'].plot(ax=ax)
ax.set_title(dset['AREA_TREES'].long_name)
fig.savefig('AREA_TREES.png')
