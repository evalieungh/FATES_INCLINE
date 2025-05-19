#!/bin/bash

CTSM_ROOT=/cluster/home/evaler/CTSM
CASE_ROOT=/cluster/home/evaler/fates_incline
CASE_NAME=SKJ1PT_DA-GSWP3_test
PROJECT=nn9774k
COMPSET=I2000Clm50Fates
UMODS_ROOT=/cluster/home/evaler/fates_incline/inputdata/

cd [CTSM_ROOT]/cime/scripts/

./create_newcase --case $CASE_ROOT/$CASE_NAME --compset $COMPSET \
--driver nuopc --res CLM_USERDAT --machine betzy --run-unsupported \
--user-mods-dirs $UMODS_ROOT/user_mods --project $PROJECT
