#!/bin/bash

set -o errexit  # Exit the script on any error

module --quiet purge  # Reset the modules to the system default
module load Miniforge3/24.1.2-0
source ${EBROOTMINIFORGE3}/bin/activate
export CONDA_PKGS_DIRS=/cluster/projects/nn9774k/conda/evaler/package-cache
export CONDA_ENV_SRC=/cluster/projects/nn9774k/conda/evaler

conda activate $CONDA_ENV_SRC/ctsm-env

# copy the grass-only parameterfile (which has been modified before)
cd /cluster/home/evaler/CTSM/src/fates/parameter_files
cp fates_params_grassonly.nc fates_params_grazing_grassonly.nc

# modify parameters
cd /cluster/home/evaler/CTSM/src/fates/tools

./modify_fates_paramfile.py --input ../parameter_files/fates_params_grazing_grassonly.nc \
--output ../parameter_files/fates_params_grazing_grassonly.nc --overwrite \
--variable fates_landuse_grazing_palatability \
--allpfts \
--value 1

./modify_fates_paramfile.py --input ../parameter_files/fates_params_grazing_grassonly.nc \
--output ../parameter_files/fates_params_grazing_grassonly.nc --overwrite \
--variable fates_landuse_grazing_maxheight \
--value 1.5 \
--all

./modify_fates_paramfile.py --input ../parameter_files/fates_params_grazing_grassonly.nc \
--output ../parameter_files/fates_params_grazing_grassonly.nc --overwrite \
--variable fates_landuse_grazing_rate \
--value 0.05,0.05,0.05,0.05,0.05 \
--all

# change the file back to cdl
cd /cluster/home/evaler/CTSM/src/fates/parameter_files
ncdump fates_params_grazing_grassonly.nc > fates_params_grazing_grassonly.cdl
