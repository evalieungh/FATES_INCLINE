# Create singlepoint forcing data from GSWP3

Download and manipulate forcing data.

Before running more stuff, activate the conda environment in the terminal you are working in.

```
module purge 
module load Miniforge3/24.1.2-0
conda init
conda activate /cluster/projects/nn9774k/conda/evaler/ctsm-env
```

## 1.2 Define paths to input data files in config file

Make sure GSWP3 is subset instead of CRUJRA. In CTSM/python/ctsm/subset_data.py, change the datm type from datm_crujra to datm_gswp3

Line 579: `datm_type = "datm_gswp3"`

Look at `CTSM/bld/namelist_files/namelist_defauls_ctsm.xml` for the given defaults for the namelist files

and `CTSM/tools/site_and_regional/default_data_2000.cfg`. Copy and rename this file default_data_2000_default.cfg to keep a backup.

```
cp /cluster/home/evaler/CTSM/tools/site_and_regional/default_data_2000.cfg /cluster/home/evaler/CTSM/tools/site_and_regional/default_data_2000_default.cfg
```

Change the specified CLM forcing directory to match with data path on Betzy instead. It should look like this: 

```
[main]
clmforcingindir = /cluster/shared/noresm/inputdata

[datm_crujra]
dir = atm/datm7/atm_forcing.datm7.CRUJRA.0.5d.c20241231/three_stream
domain = domain.crujra_v2.3_0.5x0.5.c220801.nc
solardir = .
precdir = .
tpqwdir = .
solartag = clmforc.CRUJRAv2.5_0.5x0.5.Solr.
prectag = clmforc.CRUJRAv2.5_0.5x0.5.Prec.
tpqwtag = clmforc.CRUJRAv2.5_0.5x0.5.TPQWL.
solarname = CLMCRUJRA2024.Solar
precname = CLMCRUJRA2024.Precip
tpqwname = CLMCRUJRA2024.TPQW

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
mesh_dir = /share/meshes/
mesh_surf = fv0.9x1.25_141008_ESMFmesh.nc

[landuse]
dir = /lnd/clm2/surfdata_esmf/ctsm5.3.0
landuse_16pft = landuse.timeseries_0.9x1.25_SSP2-4.5_1850-2100_78pfts_c240908.nc
landuse_78pft = landuse.timeseries_0.9x1.25_SSP2-4.5_1850-2100_78pfts_c240908.nc

[domain]
file = share/domains/domain.lnd.fv0.9x1.25_tnx0.125v4.20221027.nc
```


In addition, change the default forcing line in `CTSM/python/ctsm/subset_data.py` from CRUJRA to GSWP3 at line 579

```
# from
 datm_type = "datm_crujra"  # also available: datm_type = "datm_gswp3"

# to
 datm_type = "datm_gswp3" 
```


Also, check if line 8 in the Betzy machine specification needs to be overwritten in `CTSM/ccs_config/machines/betzy/config_machines.xml`

```
# from
  <DIN_LOC_ROOT_CLMFORC>/cluster/shared/noresm/inputdata/atm/datm7</DIN_LOC_ROOT_CLMFORC>

# to
  <DIN_LOC_ROOT_CLMFORC>/cluster/shared/noresm/inputdata/evaler/inputdata/skj_pt_gswp3/datmdata</DIN_LOC_ROOT_CLMFORC>
  
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
cd /cluster/work/users/evaler/noresm/FATES_INCLINE/src/data_handling
chmod +x subset_on_queue.sh
./subset_on_queue.sh & > subset_data_output.txt
```

## 1.4 Remove MPI line

By default, there is a line with MPI settings in `shell_commands` created by the subsetting process. This needs to be deleted. Open inputdata/skj_pt_gswp3/user_mods/shell_commands and delete that line!

`./xmlchange MPILIB=mpi-serial`