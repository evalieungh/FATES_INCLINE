#!/bin/bash
#SBATCH --account=nn9774k
#SBATCH --cpus-per-task=10
#SBATCH --ntasks=1
#SBATCH --job-name=subsetpt
#SBATCH --mem-per-cpu=16G
#SBATCH --nodes=1
#SBATCH --time=12:00:00

# This shell script runs CTSM's subset_data.py script as a batch job. 

set -o errexit  # Exit the script on any error

module --quiet purge  # Reset the modules to the system default
module load Miniforge3/24.1.2-0
source ${EBROOTMINIFORGE3}/bin/activate
export CONDA_PKGS_DIRS=/cluster/projects/nn9774k/conda/evaler/package-cache
export CONDA_ENV_SRC=/cluster/projects/nn9774k/conda/evaler

conda activate $CONDA_ENV_SRC/ctsm-api

# Path to output dir
SUBSET_OUT_DIR=/cluster/home/evaler/fates_incline/inputdata/skj_pt_gswp3
SITE_NAME=ALP4

# run subset_data script:
cd /cluster/home/evaler/CTSM/tools/site_and_regional
./subset_data point --site $SITE_NAME --lat 60.9335 --lon 6.41504 --create-surface \
--create-domain --create-user-mods --create-datm --overwrite --verbose --outdir $SUBSET_OUT_DIR \
--cfg-file /cluster/home/evaler/CTSM/tools/site_and_regional/default_data_2000.cfg
