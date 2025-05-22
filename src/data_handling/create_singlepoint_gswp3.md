# Create singlepoint forcing data from GSWP3

Download and manipulate forcing data.

## 1.1 Create and load conda environment

Create a conda environment with the packages CTSM needs to subset global data. The conda env should be placed in the project folder because it will create very many files that would otherwise make the home folder exceed the max allowed file number. Run the shell script `create_conda_env.sh` which will purge (unload) existing modules, install conda with Miniforge, spefify that packages should be under /cluster/projects/nn9774k/conda/evaler, create and activate the ctsm-env conda environment containing a list of packages listed under CTSM/python.

```
cd /cluster/home/evaler/FATES_INCLINE/src/data_handling
./create_conda_env.sh
```

(alternative add this with my name to ~/.bashrc:
    load_conda () {
      module --quiet purge
      module load Miniforge3/24.1.2-0
      source ${EBROOTMINIFORGE3}/bin/activate
      export CONDA_PKGS_DIRS=/cluster/projects/nn9774k/conda/lassetk/package-cache
      export CONDA_ENV_SRC=/cluster/projects/nn9774k/conda/lassetk

      echo "Source directory for conda envs stored in var CONDA_ENV_SRC"
    }
)

## 1.2 Define paths to input data files in config file

Make sure GSWP3 is subset instead of CRUJRA. In CTSM/python/ctsm/subset_data.py, change the datm type from datm_crujra to datm_gswp3

Line 579: `datm_type = "datm_gswp3"`

Look at `CTSM/bld/namelist_files/namelist_defauls_ctsm.xml` for the given defaults for the namelist files

and `CTSM/tools/site_and_regional/default_data_2000.cfg`. Copy and rename this file default_data_2000_default.cfg to keep a backup.

```
cp /cluster/home/evaler/CTSM/tools/site_and_regional/default_data_2000.cfg /cluster/home/evaler/CTSM/tools/site_and_regional/default_data_2000_default.cfg
```

Change the specifies CLM forcing directory to match with data path on Betzy instead, and delete the whole CRUJRA block. It should look like this: 

```
[main]
clmforcingindir = /cluster/shared/noresm/inputdata

[datm_gswp3]
dir = atm/datm7/atm_forcing.datm7.GSWP3.0.5d.v1.c170516
domain = domain.lnd.360x720_gswp3.0v1.c170606.nc
solardir = Solar
precdir = Precip
tpqwdir = TPHWL
solartag = clmforc.GSWP3.c2011.0.5x0.5.Solr.
prectag = clmforc.GSWP3.c2011.0.5x0.5.Prec.
tpqwtag = clmforc.GSWP3.c2011.0.5x0.5.TPQWL.
solarname = CLMGSWP3v1.Solar
precname = CLMGSWP3v1.Precip
tpqwname = CLMGSWP3v1.TPQW

[surfdat]
dir = lnd/clm2/surfdata_esmf/ctsm5.3.0
surfdat_16pft = surfdata_0.9x1.25_hist_2000_16pfts_c240908.nc
surfdat_78pft = surfdata_0.9x1.25_hist_2000_78pfts_c240908.nc
mesh_dir = share/meshes/
mesh_surf = fv0.9x1.25_141008_ESMFmesh.nc

[landuse]
dir = lnd/clm2/surfdata_esmf/ctsm5.3.0
landuse_16pft = landuse.timeseries_0.9x1.25_SSP2-4.5_1850-2100_78pfts_c240908.nc
landuse_78pft = landuse.timeseries_0.9x1.25_SSP2-4.5_1850-2100_78pfts_c240908.nc

[domain]
file = share/domains/domain.lnd.fv0.9x1.25_gx1v7.151020.nc
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

## 1.3 Run subset_data script

Following Lasse's notes following https://github.com/NorESMhub/ctsm-api/blob/main/data/create_data.py. 

```
cd /cluster/home/evaler/FATES_INCLINE/src/data_handling
chmod +x subset_point_data.sh
./subset_point_data.sh
```

## 1.4 Remove MPI line

By default, there is a line with MPI settings in `shell_commands` created by the subsetting process. This needs to be deleted. Open fates_incline/inputdata/skj_pt_gswp3/user_mods/shell_commands and delete that line!

`./xmlchange MPILIB=mpi-serial`