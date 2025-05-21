# Simulation setup instructions

This document was created 2025-05-12 and is heavily inspired by https://hackmd.io/@pYjjfkwmSfW932OvIjzLHA/H1YNgFXqJl

This guide is written to document model installation, simulations setup, and running the model on the Norwegian HPC Betzy. 

## Simulations

The goal is to perform:

* two initial out-of-the-box simulations (B - baseline), but with improved surface data changed according to local observations. One will include all the default PFTs (A), while the other will be restricted to grass PFTs only (G). These will use a 2000 compset and cold start, thus representing a recent climate and *not* historical progression. The goal is to see how the model performs out of the box, and run simulations that are long enough to get an equilibrium with the climate and stable soil properties. These serve two purposes: First, results from the last 10(?) years will be reported on as the model's baseline for the site. Second, restart files from these two simulations will be re-used as spinup for the subsequent simulations.
	* GSWP3 forcing, All PFTs - (BA-GSWP3)
	* GSWP3 forcing, Grass PFTs - (BG-GSWP3)
* three improved (I) simulations, using the two baseline simulations as spinup, where the vegetation will reach a new equilibrium and data for the results will be taken from the final 14/16 years. These simulations will also be run with a year-2000 compset, and either of all (A) or grass (G) PFTs. A regional data set, COSMO-REA6, will be used as atmospheric forcing. An additional simulation will have  modified, warmed COSMO-REA6 forcing (COSMO-Warmed) with 1 degree C higher temperature.
	* COSMO forcing, All PFTs - (IA-COSMO)
	* COSMO forcing, Grass PFTs - (IG-COSMO)
	* Warmed COSMO forcing, Grass PFTs, (IG-COSMO-W)
	
All simulaitons are single-site, at the Skjellingahaugen site of the Vestland Climate Grid (see e.g. ...)

Site info from the LSP's resources/config/sites.json:
```
      "type": "Feature",
      "geometry": {
        "type": "Point",
        "coordinates": [
          6.41504,
          60.9335
        ]
      },
      "properties": {
        "name": "ALP4",
        "long_name": "Skjellingahaugen",
        "description": "Alpine vegetation at 1088 m elevation. Mean summer temperature is 7 degrees C, and mean annual precipitation is 3402 mm.",
        "compset": "2000_DATM%GSWP3v1_CLM51%FATES_SICE_SOCN_MOSART_SGLC_SWAV",
        "res": "1x1_ALP4",
        "data_url": "https://raw.githubusercontent.com/NorESMhub/noresm-lsp-data/main/sites/ALP4.zip",
        "group": "SeedClim"
      }
```

## Initial set up of model 

Download the Community Terrestrial Systems Model (incl. CLM)

```
git clone https://github.com/NorESMhub/CTSM.git
cd CTSM
git checkout -b ctsm5.3.11-noresm_v2
./bin/git-fleximod update
```

Possibly load some modules? `module load ESMF/8.6.0-foss-2023a`

## Download data

Check whether it's possible to re-use the data from the old setup. If not, I have to find forcing for the site and bias-correct before applying forcing again. 

Prepared single-site forcing available on GitHub, modified from the [NorESM-LSP](). All these prepared folders include modified surface data (see [the dataprep_surfacedata notebook](https://github.com/evalieungh/FATES_INCLINE/blob/main/src/data_handling/dataprep_surfacedata.ipynb)). Zipped files are available for GSWP3, COSMO, and COSMO-Warmed under [evalieungh/FATES_INCLINE/main/data/](https://github.com/evalieungh/FATES_INCLINE/tree/main/data).

Download the data using direct download links to the zipped files for ALP4 (Skjellingahaugen):

```
cd ~/fates_incline/inputdata
# GSWP3
wget https://raw.githubusercontent.com/evalieungh/FATES_INCLINE/main/data/ALP4.zip
# COSMO
wget https://raw.githubusercontent.com/evalieungh/FATES_INCLINE/main/data/ALP4_cosmorea_noleap.zip
# COSMO-Warmed
wget https://raw.githubusercontent.com/evalieungh/FATES_INCLINE/main/data/ALP4_cosmorea_warmed.zip
```

Unzip the folders into Betzy login node folder fates_incline/ALP4-GSWP3 etc with `unzip`

## Model adjustments to enable custom forcing?

### Changes to manually specify input data location

May need additional changes in CTSM/tools/site_and_regional/default_data_2000.cfg.:

```
[main]
clmforcingindir = /cluster/home/evaler/fates_incline/inputdata

[datm_gswp3]
# dir not changed! see if this works... 
domain = /cluster/home/evaler/fates_incline/inputdata/ALP4-GSWP3/domain.lnd.fv0.9x1.25_gx1v7_ALP4_c221027.nc

[surfdat]
dir = /cluster/home/evaler/fates_incline/inputdata/ALP4-GSWP3
surfdat_16pft = surfdata_0.9x1.25_hist_16pfts_Irrig_CMIP6_simyr2000_ALP4_c221027.nc

[domain]
file = /cluster/home/evaler/fates_incline/inputdata/ALP4-GSWP3/domain.lnd.fv0.9x1.25_gx1v7_ALP4_c221027.nc
```

Also check `CTSM/bld/namelist_files/namelist_defauls_ctsm.xml`. 
The FATES parameter file is set on line 536 (and the CLM parameter file just above on L58). For now I assume that this file is not necessary to change but can be overwritten with namelist changes for specific cases.

## setting up cases and running the model

Create cases (from ~/fates_incline)

Tried making a simple script, ./create_case_DA-GSWP3.sh. Make it executable with `chmod +x <create_case_....sh>`. Next, run ./case.setup to build the namelist

```
cd /cluster/home/evaler/FATES_INCLINE/src/simulation_setup/
./create_case_DA-GSWP3_test.sh

cd /cluster/home/evaler/fates_incline/<casename>
./case.setup
```

Then, add these namelist changes to user_nl_clm (inside case directory):

```
fsurdat = '$CLM_USRDAT_DIR/surfdata_0.9x1.25_hist_16pfts_Irrig_CMIP6_simyr2000_ALP4_c221027.nc'

use_bedrock = .true.

hist_fincl2 = 'FATES_GPP'
hist_nhtfrq = 0,-24
hist_mfilt = 12,30
```

Also, replace the default user_nl_datm_streams with the one from the (modified) LSP data

```
cd /cluster/home/evaler/fates_incline/SKJ1PT_DA-GSWP3_test
mv user_nl_datm_streams user_nl_datm_streams_default
cp /cluster/home/evaler/fates_incline/inputdata/ALP4-GSWP3/user_mods/user_nl_datm_streams user_nl_datm_streams
```

Then we set some simulation settings. Make a short script, fates_incline/SKJ1PT_DA-GSWP3_PTS/xmlchange_DA-GSWP3.sh, with all the xml changes needed. (Took this one out again because there was an error: `./xmlchange VCGSITE=ALP4`)
ESMFMKFILE
```
chmod +x xmlchange_DA-GSWP3.sh
cd /cluster/home/evaler/fates_incline/SKJ1PT_DA-GSWP3_test
./cluster/home/evaler/FATES_INCLINE/src/simulation_setup/xmlchange_DA-GSWP3.sh
```

Then, build the case so it is ready for running, and run a check to see if there are any issues. If the case has already been built before and you need to change something, run `./case.build --clean` first.

```
./case.build
./check_case
```
Build logs, and output from the simulation, will be placed under /cluster/work/users/evaler/noresm/casename. 
Go there and check the logs just in case to see that there are no errors. 

The final step is to submit a job to run the model. See https://documentation.sigma2.no/jobs/submitting.html

```
./case.submit
```

Go to /cluster/work/users/evaler/noresm/ to find the output. Copy/move it back to the home directory if necessary. 

```
cp /cluster/work/users/evaler/noresm/
mv

```

--------------------------
## Useful notes

```
squeue --me
scancel <jobID>

```