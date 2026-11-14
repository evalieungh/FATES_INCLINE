#!/bin/bash
#SBATCH --account=nn9774k
#SBATCH --cpus-per-task=10
#SBATCH --ntasks=1
#SBATCH --job-name=subsetpt
#SBATCH --mem-per-cpu=16G
#SBATCH --nodes=1
#SBATCH --time=12:00:00

# This shell script modifies cold-adjusted GSWP3 forcing to mimic warming treatment using open-top chambers (OTC)

set -o errexit  # Exit the script on any error
module --quiet purge  # Reset the modules to the system default
module load Miniforge3/24.1.2-0
source ${EBROOTMINIFORGE3}/bin/activate
export CONDA_PKGS_DIRS=/cluster/projects/nn9774k/conda/evaler/package-cache
export CONDA_ENV_SRC=/cluster/projects/nn9774k/conda/evaler
conda activate $CONDA_ENV_SRC/ctsm-env

# make a copy of the cold GSWP3 data to start from - change here depending on cold/warm baseline and 1 or 2 degrees OTC effect
cd /cluster/shared/noresm/inputdata/evaler/inputdata
cp -r skj_pt_gswp3-warm-otc skj_pt_gswp3-warm-otc2

echo --- forcing data copied, start applying anomaly to copy ---

# Set path to atmospheric forcing to be modified - NB! change dir here for cold/warm GSWP3 originals and 1 or 2 degrees
OTC_DATM_DIR=/cluster/shared/noresm/inputdata/evaler/inputdata/skj_pt_gswp3-warm-otc2/datmdata

# define summer months (when OTCs are up in the snowfree season)
SUMMER="06 07 08 09"

# loop over summer months
for month in $SUMMER; do
    echo "$month"
    # loop over files
    for f in "$OTC_DATM_DIR"/*TPQWL*-"$month".nc; do
    echo "$f"
    cp "$f" copy_"$(basename "$f")"
    # add 1 degree to TBOT where time stamps match daytime decimals
    ncap2 -O -s 'where((time%1==0.3125)||(time%1==0.4375)||(time%1==0.5625)||(time%1==0.6875)||(time%1==0.8125)) TBOT=TBOT+1;' "$f" "$f.tmp"
    echo "$f.tmp"
    mv "$f.tmp" "$f"
    done
done

echo Done
