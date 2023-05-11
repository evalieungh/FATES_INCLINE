# Code, jupyter notebooks etc for analysis

**under construction**

NB! Several files are heavily inspired, or copied and modified, from other online sources like the NorESM Land Sites Platform, huitang-earth, CTSM tutorials, and other sources. 

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