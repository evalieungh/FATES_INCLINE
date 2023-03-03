# workflow for test simulation with COSMOREA forcing and default surfacedata on nrec

2023-03-01

Because of a coding mistake, the surfacedata file in https://github.com/evalieungh/FATES_INCLINE/data/ALP1_cosmo.zip is the old default (there were two files; one was modified with dataprep_surfacedata.ipynb, but the other one was chosen in combine_surfdat_cosmorea_input.ipynb). So, before I correct this, I will use ALP1 to test COSMOREA forcing alone before running proper simulations with both COSMOREA forcing and improved surface data. 

Log into NREC VM, switch to loacl branch cosmorea. 

```
ssh -i .ssh/evaskey ubuntu@158.39.75.164
cd ../../../data/evalieungh-fork/noresm-land-sites-platform
git checkout cosmorea
```
After COSMOREA setup is complete, following cosmorea_local_setup.ipynb, get the LSP up and running

```
docker-compose up
```
CTRL+a and CTRL+d
```
screen -list
```

In a new, local terminal window, get the LSP interfaces up:

```
ssh -i .ssh/evaskey -L 8000:localhost:8000 -N -f ubuntu@158.39.75.164
ssh -i .ssh/evaskey -L 8080:localhost:8080 -N -f ubuntu@158.39.75.164
ssh -i .ssh/evaskey -L 8888:localhost:8888 -N -f ubuntu@158.39.75.164
ssh -i .ssh/evaskey -L 5800:localhost:5800 -N -f ubuntu@158.39.75.164
```

Make a preliminary 1-year test with ALP1:
- name: cosmo-test-2
- 1 years
- datm yr start 2000
- datm yr end 2001
- stopn 1
- stop option nyears

FAIL. The LSP GUI says the run was successful, but there is no output and no logs in the run dir.
There are some warnings in the case bld/lnd.bldlog.230303-103735.gz:
"Warning: Array reference at (1) out of bounds (60 > 30) in loop beginning at (2)
/ctsm-api/resources/model/components/clm/src/fates/biogeochem/EDCanopyStructureMod.F90:1603:50:"
"Warning: Array reference at (1) out of bounds (60 > 30) in loop beginning at (2)
f951: Warning: Nonexistent include directory ‘/ctsm-api/resources/cases/c3c26a5db196f0b59d91c8fbac6dcd7b_cosmorea-test-2/bld/gnu/mpich/nodebug/nothreads/nuopc/finclude’ [-Wmissing-include-dirs]"
etc...



**********************************

Set up a simulation for ALP4: 

- name: ALP1_cosmo_test_500yr
- 500 years
- datm yr start 1995
- datm yr end 2018
- stopn 500
- stop option nyears


Dump of LSP case variables:

```

```
