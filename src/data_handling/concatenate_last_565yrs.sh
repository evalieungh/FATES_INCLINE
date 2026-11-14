#!/bin/bash

set -o errexit  # Exit the script on any error

# load environment
module purge  # Reset the modules to the system default
module load Miniforge3/24.1.2-0
#source ${EBROOTMINIFORGE3}/bin/activate
source ${EBROOTMINIFORGE3}/etc/profile.d/conda.sh
conda activate /cluster/projects/nn9774k/conda/evaler/ctsm-env

# Get the case name from the first command-line argument
CASENAME="$1"

# make a new directory to store copies of the last 5 cycles x 113 forcing years x 12 months = 6780 monthly files.
mkdir /cluster/work/users/evaler/archive/spinup/lnd/hist_subset

# copy the last 6780 files by making an array a of file names,
a=(/cluster/work/users/evaler/archive/spinup/lnd/hist/*)
# and copying the last ones to the new directory
cp -- "${a[@]: -6780}" /cluster/work/users/evaler/archive/spinup/lnd/hist_subset

# concatenate history files
ncrcat /cluster/work/users/evaler/archive/$CASENAME/lnd/hist_subset/$CASENAME.clm2.h0*.nc \
       /cluster/work/users/evaler/noresm/FATES_INCLINE/cases/$CASENAME/${CASENAME}.h0.concatenated.nc

# make a copy in older version (4) of netCDF for inspection in Panoply
nccopy -k 'netCDF-4' /cluster/work/users/evaler/noresm/FATES_INCLINE/cases/$CASENAME/${CASENAME}.h0.concatenated.nc /cluster/work/users/evaler/noresm/FATES_INCLINE/cases/$CASENAME/${CASENAME}.h0.concatenated_nc4.nc
