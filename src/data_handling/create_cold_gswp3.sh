#!/bin/bash
#SBATCH --account=nn9774k
#SBATCH --cpus-per-task=10
#SBATCH --ntasks=1
#SBATCH --job-name=subsetpt
#SBATCH --mem-per-cpu=16G
#SBATCH --nodes=1
#SBATCH --time=12:00:00

# This shell script performs a simplistic bias correction of the default GSWP3 forcing.

set -o errexit  # Exit the script on any error
module --quiet purge  # Reset the modules to the system default
module load Miniforge3/24.1.2-0
source ${EBROOTMINIFORGE3}/bin/activate
export CONDA_PKGS_DIRS=/cluster/projects/nn9774k/conda/evaler/package-cache
export CONDA_ENV_SRC=/cluster/projects/nn9774k/conda/evaler
conda activate $CONDA_ENV_SRC/ctsm-env

# make a copy of the default GSWP3 data to start from
cd /cluster/shared/noresm/inputdata/evaler/inputdata
cp -r skj_pt_gswp3 skj_pt_gswp3-cold

echo copied default forcing to new directory /skj_pt_gswp3-cold

# Set path to atmospheric forcing to be modified
COLD_DATM_DIR=/cluster/shared/noresm/inputdata/evaler/inputdata/skj_pt_gswp3-cold/datmdata

echo ---- starting cold adjustment ----

# Loop over all monthly NetCDF files
for infile in "$COLD_DATM_DIR"/*TPQWL*.nc; do
    # Extract date (YYYY-MM) from filename
    filename=$(basename "$infile")
    year_month=$(echo "$filename" | grep -oE '[0-9]{4}-[0-9]{2}')

    echo "Processing month: $year_month"

    # subtract bias correction factor from temperature. Difference in temperature means =  2.73593073812696
    # TBOT is temperature, but note that the file contains other variables too (QBOT, FLDS, WIND ...)
    
    # Create a temporary output file
    tmpfile="${infile%.nc}_tmp.nc"

    # Subtract bias correction factor from TBOT 
    ncap2 -O -s 'TBOT=TBOT-2.73593073812696' "$infile" "$tmpfile"

    # Replace original file with modified one
    mv "$tmpfile" "$infile"
done    
