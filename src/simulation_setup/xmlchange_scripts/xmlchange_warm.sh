#!/bin/bash

set -e

cd /cluster/work/users/evaler/noresm/FATES_INCLINE/cases/warm

./xmlchange CLM_USRDAT_NAME=ALP4
./xmlchange CLM_USRDAT_DIR=/cluster/shared/noresm/inputdata/evaler/inputdata/skj_pt_gswp3
./xmlchange PTS_LON=6.41504
./xmlchange PTS_LAT=60.9335

./xmlchange NTASKS=1  
./xmlchange DATM_MODE=CLMGSWP3v1
./xmlchange STOP_N=226
./xmlchange STOP_OPTION=nyears
./xmlchange RUN_STARTDATE=1901-01-01,DATM_YR_START=1901,DATM_YR_END=2014
./xmlchange DATM_YR_ALIGN=1901
./xmlchange JOB_WALLCLOCK_TIME=20:59:00

# namelist changes
echo "fsurdat = '\$CLM_USRDAT_DIR/surfdata_ALP4_hist_2000_16pfts_c250701_modified.nc'" >> user_nl_clm
echo "fates_paramfile='/cluster/home/evaler/CTSM/src/fates/parameter_files/fates_params_grazing_grassonly.nc'" >> user_nl_clm
echo "use_excess_ice = .false." >> user_nl_clm
echo "finidat = '/cluster/work/users/evaler/noresm/spinup/run/spinup.clm2.r.4726-01-01-00000.nc'" >> user_nl_clm

echo Case configured. Namelist changes done.

