# workflow for test simulation with COSMOREA forcing and default surfacedata on nrec

started 2023-03-01

Because of a coding mistake, the surfacedata file in https://github.com/evalieungh/FATES_INCLINE/data/ALP1_cosmo.zip is the old default (there were two files; one was modified with dataprep_surfacedata.ipynb, but the other one was chosen in combine_surfdat_cosmorea_input.ipynb). So, before I correct this, I will use ALP1 to test COSMOREA forcing alone before running proper simulations with both COSMOREA forcing and improved surface data. 

Log into NREC VM, switch to local branch cosmorea. 

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
- name: cosmo-test
- calendar: Gregorian
- 1 years
- datm yr start 2000
- datm yr end 2001
- stopn 1
- stop option nyears
- in the CLM namelist advanced box, add VGCSITE=ALP1

When the case is ready, make sure it contains the usermods directory in the case dir. --> it does not. 

FAIL to run with error: 
`err=ERROR(Build::Namelist::_parse_next): expect a F90 constant for a namelist instead got: ALP1`

Trying to remove the CLM namelist advanced box addition, 
and instead open terminal in ctsm-api with `docker-compose exec api bash`
and do ./xmlchange VCGSITE=ALP1 in the case dir. That gives 
`./xmlchange VCGSITE=ALP1`
`ERROR: No machine docker found`

Just discovered that there is a user mods dir under resources/data/caseID, 
containing files `shell_commands` and `user_nl_clm`. Trying the same case setup
again, but manually adding `./xmlchange VCGSITE=ALP1` to the shell commands file before
clicking "run". 


Dump of LSP case variables:

```

```
