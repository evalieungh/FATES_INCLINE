#!/bin/bash

set -o errexit  # Exit the script on any error

module --quiet purge  # Reset the modules to the system default
module load Miniforge3/24.1.2-0
source ${EBROOTMINIFORGE3}/bin/activate
export CONDA_PKGS_DIRS=/cluster/projects/nn9774k/conda/evaler/package-cache
export CONDA_ENV_SRC=/cluster/projects/nn9774k/conda/evaler

conda activate $CONDA_ENV_SRC/ctsm-env

# save a copy of the default parameterfile
cd /cluster/home/evaler/CTSM/src/fates/parameter_files
cp fates_params_default.cdl fates_params_default_unchanged.cdl

# change the default cdl file to NetCDF
ncgen -o fates_params_default.nc fates_params_default.cdl

# modify SLA of the grass PFTs (arctic_c3_grass,cool_c3_grass,c4_grass)
# for one PFT at a time
cd /cluster/home/evaler/CTSM/src/fates/tools

echo Set SLA to 0.0376 for all grass PFTs

./modify_fates_paramfile.py --input ../parameter_files/fates_params_default.nc \
--output ../parameter_files/fates_params_default.nc --overwrite \
--variable fates_leaf_slatop \
--PFT 12 \
--value 0.0376

./modify_fates_paramfile.py --input ../parameter_files/fates_params_default.nc \
--output ../parameter_files/fates_params_default.nc --overwrite \
--variable fates_leaf_slatop \
--PFT 13 \
--value 0.0376

echo Make new parameter file with grasses only

# Use the IndexSwapper to make a new parameter file with grasses only
PARAMETERFILE=/cluster/home/evaler/CTSM/src/fates/parameter_files/fates_params_default.nc
PARAMETERFILE_GRASS=/cluster/home/evaler/CTSM/src/fates/parameter_files/fates_params_grassonly.nc
GRASSINDICES=12,13

./FatesPFTIndexSwapper.py --fin=$PARAMETERFILE \
    --fout=$PARAMETERFILE_GRASS \
    --pft-indices=$GRASSINDICES

# change the modified files back to cdl format
cd /cluster/home/evaler/CTSM/src/fates/parameter_files
ncdump fates_params_default.nc > fates_params_default.cdl
ncdump fates_params_grassonly.nc > fates_params_grassonly.cdl
