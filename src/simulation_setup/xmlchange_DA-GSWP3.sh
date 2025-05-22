#!/bin/bash

./xmlchange NTASKS=1  
./xmlchange DATM_MODE=CLMGSWP3v1
./xmlchange STOP_N=5 
./xmlchange STOP_OPTION=nyears
./xmlchange RUN_STARTDATE=2000-01-01,DATM_YR_START=2000,DATM_YR_END=2005
./xmlchange DATM_YR_ALIGN=2000

./xmlchange CLM_USRDAT_DIR=/cluster/home/evaler/fates_incline/inputdata/skj_pt_gswp3
./xmlchange PTS_LON=6.41504
./xmlchange PTS_LAT=60.9335
./xmlchange MPILIB=mpi-serial

./xmlchange JOB_WALLCLOCK_TIME=03:59:00
./xmlchange CLM_FORCE_COLDSTART=on
