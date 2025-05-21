#!/bin/bash

module purge
module load Miniforge3/24.1.2-0
source ${EBROOTMINIFORGE3}/bin/activate
export CONDA_PKGS_DIRS=/cluster/projects/nn9774k/conda/evaler/package-cache
export CONDA_ENV_SRC=/cluster/projects/nn9774k/conda/evaler

cd /cluster/home/evaler/CTSM/python
conda create -p $CONDA_ENV_SRC/ctsm-env
conda install -p /cluster/projects/nn9774k/conda/evaler/ctsm-env --file conda_env_ctsm_py_latest.txt
conda activate /cluster/projects/nn9774k/conda/evaler/ctsm-env
