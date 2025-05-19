# notes in transition to new simulations in 2025

New simulation setup including spinup makes all the old simulatinos redundant. The old simulation results are archived in https://doi.org/10.5281/zenodo.8124988. 

Here are notes on the new simulation setup. A lot of it is repetition from NREC_VM_setup.md under /src

The goal is to perform:

* two initial spinup simulations, with deafault (D) or improved (I) surface data. These will use a 1850 compset and cold start.
* five final simulations where the vegetation will reach a new equilibrium and data for the results will be taken from the final 14/16 years. These simulations will be run with a year-2000 compset, and a combination of All/Grass PFTs, GSWP3/COSMO forcing, and deafault/improved surface data. An additional simulation will have use the modified, warmed COSMO forcing. The simulations will be: 
	1. GSWP3 forcing, All PFTs - (DA-GSWP3)
	2. COSMO forcing, All PFTs - (IA-COSMO)
	3. GSWP3 forcing, Grass PFTs - (DG-GSWP3)
	4. COSMO forcing, Grass PFTs - (IG-COSMO)
	5. Warmed COSMO forcing, Grass PFTs, (IG-COSMO-W)
	
## start with fresh copy of repo.


### On NREC 158.39.75.164

`sudo git clone https://github.com/evalieungh/noresm-land-sites-platform.git --config core.autocrlf=input`

`cd noresm-land-sites-platform`

`sudo git switch cosmorea`
 
`sudo usermod -a -G docker $USER`

`vi resources/config/sites.json`, change compset for ALP4: "1850_DATM%COSMOREA_CLM51%FATES_SICE_SOCN_MOSART_SGLC_SWAV" (i/esc,:wq)

`screen -S cosmo-spinup`

`./run_linux.sh`
(Detach (hide/close wihtout quitting) the screen with CTRL+a and CTRL+d, 
The screen should be visible under `screen -list` and can be opened again with `screen -r cosmo-spinup`.)

### Locally in wsl
Open a new local terminal and enable ssh port listening to the relevant NorESM-LSP ports.
`./lspUIs_158-39-75-164.sh`

### in LSP GUI


## start from old copy of repo, on NREC 158.37.63.209 data/noresm-land-sites-platform

Test with ALP3 to start with. If it works, get an overview of what data is used in which copy of the repo on which NREC VM. 

1. check that ALP has the correct 1850, GSWP3 compset in resources/config/sites.json.
2. add Hybrid to possible run types and set readonly=false in resources/config/variables_config.json
3. open screen (21786.warmedcosmo), start container ./run_linux.sh (If changes are made to sites or variables config, update with docker compose pull!)
4. from local terminal (wsl) set up port listening (./lspUIs_2.sh)
5. in GUI (http://localhost:8080/) make case for ALP3: c8fbb543276fd05200572f5a7995ff52-ALP3-spinuptest-5yr

```
Variables
    DOUT_S_SAVE_INTERIM_RESTART_FILES:true
    VCGSITE:ALP3
    DIN_LOC_ROOT_CLMFORC:-
    CALENDAR:NO_LEAP
    DATM_YR_START:1901
    DATM_YR_ALIGN:1901
    DATM_YR_END:1905
    RUN_STARTDATE:1901-01-01
    STOP_N:5
    STOP_OPTION:nyears
    STOP_DATE:-
    RUN_TYPE:startup
```
Run OK!

6. Added a copy of ALP3 in sites.json as ALP-2000 with a 2000-compset, otherwise identical. Closed container, pulled, update with docker compose pull.
7. Find restart file from previous run, add to new setup:
finidat = '/data/noresm-land-sites-platform/resources/cases/c8fbb543276fd05200572f5a7995ff52_alp3-spinuptest-5yr/run/c8fbb543276fd05200572f5a7995ff52_alp3-spinuptest-5yr.clm2.r.1906-01-01-00000.nc'
use_init_interp = T
8. submit hybrid run test:

```
Variables

    DOUT_S_SAVE_INTERIM_RESTART_FILES:true
    VCGSITE:ALP3
    DIN_LOC_ROOT_CLMFORC:-
    CALENDAR:NO_LEAP
    DATM_YR_START:1906
    DATM_YR_ALIGN:1906
    DATM_YR_END:1910
    RUN_STARTDATE:1906-01-01
    STOP_N:5
    STOP_OPTION:nyears
    STOP_DATE:-
    RUN_TYPE:hybrid
    LND_TUNING_MODE:clm5_1_GSWP3v1
[...]
    CLM namelist extra:finidat = '/data/noresm-land-sites-platform/resources/cases/c8fbb543276fd05200572f5a7995ff52_alp3-spinuptest-5yr/run/c8fbb543276fd05200572f5a7995ff52_alp3-spinuptest-5yr.clm2.h0.1905-12.nc' use_init_interp = T
```

9. add the restart file to the run directory of the new case:
`cp resources/cases/c8fbb543276fd05200572f5a7995ff52_alp3-spinuptest-5yr/run/c8fbb543276fd05200572f5a7995ff52_alp3-spinuptest-5yr.clm2.r.1906-01-01-00000.nc `
9. download results from both spinup and hybrid run to check in Panoply:
From local terminal (wsl): 
`scp -r -i .ssh/evaskey ubuntu@158.37.63.209:/data/noresm-land-sites-platform/resources/cases/ /mnt/c/Users/evaler/Downloads`
`scp -r -i .ssh/evaskey ubuntu@158.37.63.209:/data/noresm-land-sites-platform/resources/cases/ /mnt/c/Users/evaler/Downloads`