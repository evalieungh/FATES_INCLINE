# Workflow notes for setting up spinup and restart simulations in the LSP

The model needs to run for a long time from its arbitrary starting conditions until soil conditions etc. are more realistic and in tune with the climatic forcing. It is normal to first do one or two 'spinup' simulations and use that model output as initial conditions for the main simulations of a model experiment. Normally, a good practice is to first use a preindustrial (pre-1850) simulation from cold/bare-ground/arbitrary starting conditions until soil etc. is in equilibrium. Then, the period from 1850 to 2000 should be simulated once to simulate the real development from then to modern times. Finally, the 'modern' time period can be simulated using initial conditions corresponding to year 2000.

Some modifications are necessary to the Land Sites Platform code in order to change the compset and run type.

TLDR;
- change compset in resources/config/sites.json
- enable accelerated spinup ...
- change RUN_TYPE in resources/config/variables_config.json
- set namelist options to use initial conditions file

## Spinup

To do a spinup simulation, it is necessary to change the [compset](https://noresmhub.github.io/noresm-land-sites-platform/documentation/#component-sets-compsets) from the LSP's default. The compset it defined in the [noresm-land-sites-platform/resources/config/sites.json](https://raw.githubusercontent.com/NorESMhub/noresm-land-sites-platform/main/resources/config/sites.json) file. 

Open sites.json, navigate to the ALP4 site, and change the compset to 1850_DATM%GSWP3v1_CLM51%FATES_SICE_SOCN_MOSART_SGLC_SWAV
```
vi resources/config/sites.json
```

To make spinup faster, it's also good to enable 'accelerated spinup' mode. How to do this? 


## Doing a restart simulation

To use the model output from a spinup simulation, the model run type needs to be changed and a path set to where the spinup files (=initial conditions) are located. 

There are several run types, including 'startup' (LSP default, used for spinup), 'hybrid', and 'branch'. It looks like 'hybrid' is the way to go because ["a hybrid simulation allows you to change the configuration or run-time options, as well as use a different code base than the original case that may have fewer fields on it than a full restart file."](https://escomp.github.io/ctsm-docs/versions/master/html/users_guide/setting-up-and-running-a-case/customizing-the-clm-configuration.html#doing-a-branch-simulation-to-provide-initial-conditions)

In the LSP, the run type is set in [noresm-land-sites-platform/resources/config/variables_config.json](https://github.com/NorESMhub/noresm-land-sites-platform/blob/main/resources/config/variables_config.json). Already, there is 'startup' and 'restart', but it is readonly and set to 'restart'. Make it `"readonly": false,` and choose restart in the GUI when setting up the simulation. The Docker containers probably need to be restarted before this change appears if it was running already. 

To specify which file to use as initial conditions, set a path to it like this in the user_nl_clm file, which should be easy to do by pasting this into the advanced box in the GUI:
```
finidat = '/data/lsp-default/noresm-land-sites-platform/resources/cases/1d39ff320b588d972438e3b41df28487_1850-test/archive/lnd/hist/1d39ff320b588d972438e3b41df28487_1850-test.clm2.h0.1901-12.nc'
use_init_interp = T
```

## new notes 2025
to enable a different compset of tha same site, a hack is to add it as a new site (copying most info from the old but renaming to e.g. ALP-1850.

To add a 'new' site, add it to the main repo resources/config/sites.json 

AND to ctsm-api/data/sites.json. That means making a fork of ctsm-api and changing the docker-compose file (or more?) to point to that fork instead. 