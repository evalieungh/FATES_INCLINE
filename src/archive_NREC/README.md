# Archive for old versions (used in PhD thesis and first submission of manuscript)

This folder servea as an archive of notes, notebooks etc that were created for the first version of this manuscript. They are relevant for (re)producing the first set of results, published on Zenodo (https://doi.org/10.5281/zenodo.8124988). 

This setup included simulations run on virtual machines on NREC, and using the NorESM Land Sites Platform. 

---------------------------------------

# Code, jupyter notebooks etc for analysis


NB! Several files are heavily inspired, or copied and modified, from other online sources like the NorESM Land Sites Platform, github.com/huitang-earth, CTSM tutorials, and other sources. 

This directory contains jupyter notebooks, scripts, and notes used to document workflows, modify atmospheric forcing and surface data, and create plots, amongst other things. 

## Conda environment for jupyter notebooks run in Vscode

Prerequisites: Vscode, Anaconda3

To recreate the conda environment I used to run notebooks, enter this in an anaconda prompt:
```
conda create --name vscode python
conda activate vscode
conda install xarray
conda install ipykernel
conda install matplotlib
conda install -c conda-forge netCDF4
conda install -c conda-forge nco
conda install -c conda-forge dask
conda install -c conda-forge nc-time-axis
conda install -c conda-forge scipy
```

A dump of the environment (incl. all packages required by the above) with specific versions is stored in a separate text file conda_env.txt. 