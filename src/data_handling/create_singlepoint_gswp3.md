# Create singlepoint forcing data from GSWP3

Download and manipulate forcing data.

## 1.1 Create and load conda environment

Create a conda environment with the packages CTSM needs to subset global data. The conda env should be placed in the project folder because it will create very many files that would otherwise make the home folder exceed the max allowed file number. Run the shell script `create_conda_env.sh` which will purge (unload) existing modules, install conda with Miniforge, spefify that packages should be under /cluster/projects/nn9774k/conda/evaler, create and activate the ctsm-env conda environment containing a list of packages listed under CTSM/python.

```
cd /cluster/home/evaler/FATES_INCLINE/src/data_handling
./create_conda_env.sh
```

## 1.2 Define paths to input data files in config file

Look at `CTSM/bld/namelist_files/namelist_defauls_ctsm.xml`

and `CTSM/tools/site_and_regional/default_data_2000.cfg`. Copy and rename this file default_data_2000_default.cfg to keep a backup.

```
cp /cluster/home/evaler/CTSM/tools/site_and_regional/default_data_2000.cfg /cluster/home/evaler/CTSM/tools/site_and_regional/default_data_2000_default.cfg
```

Change the specifies CLM forcing directory to match with data path on Betzy instead, and change the surface data to the :

```
[main]
clmforcingindir = /cluster/shared/noresm/inputdata
```

The surface data can maybe be copied from the old LSP setup? If so, copy my version of it into the shared storage on Betzy before pointing to it in the same file. Trying without this first, but add later when the rest is working:


```
cd /cluster/shared/noresm/inputdata
mkdir evaler
cp /cluster/home/evaler/fates_incline/inputdata/ALP4-COSMO/surfdata_0.9x1.25_hist_16pfts_Irrig_CMIP6_simyr2000_ALP4_c221027.nc evaler/surfdata_0.9x1.25_hist_16pfts_Irrig_CMIP6_simyr2000_ALP4_c221027.nc
```


```
[surfdat]
dir = evaler/
surfdat_16pft = surfdata_0.9x1.25_hist_16pfts_Irrig_CMIP6_simyr2000_ALP4_c221027.nc
```




```


```

