#!/bin/bash

# "experimentwarm" simulation with default GSWP3 forcing modified to add a warming anomaly that mimics the OTC effect

CASE_ROOT=/cluster/work/users/evaler/noresm/FATES_INCLINE/cases
CASE_NAME=experimentwarm2
PROJECT=nn9774k
COMPSET=I2000Clm50Fates
#2000_DATM%GSWP3v1_CLM50%FATES_SICE_SOCN_MOSART_SGLC_SWAV_SESP
UMODS_ROOT=/cluster/shared/noresm/inputdata/evaler/inputdata/skj_pt_gswp3-warm-otc2

cd /cluster/home/evaler/CTSM/cime/scripts/

./create_newcase --case $CASE_ROOT/$CASE_NAME --compset $COMPSET \
--driver nuopc --res CLM_USRDAT --machine betzy --run-unsupported \
--user-mods-dirs $UMODS_ROOT/user_mods --project $PROJECT
