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

There is a user mods dir under resources/data/caseID, 
containing files `shell_commands` and `user_nl_clm`. Trying the same case setup
again, but manually adding `./xmlchange VCGSITE=ALP1` to the shell commands file before
clicking "run". 

The GUI says the run was successful, but again there is no output and no info in the log files, 
except resources/cases/caseID/archive/logs/cesm.log... which says
```
Abort with message No such file or directory in file /ctsm-api/resources/model/libraries/parallelio/src/clib/pioc_support.c at line 2830
Obtained 10 stack frames.
/ctsm-api/resources/cases/d3a874304132542cbdeafc4bc7bac2c0_cosmorea-test4/bld/cesm.exe(+0x8503c4) [0x5594450fe3c4]
/ctsm-api/resources/cases/d3a874304132542cbdeafc4bc7bac2c0_cosmorea-test4/bld/cesm.exe(+0x850474) [0x5594450fe474]
/ctsm-api/resources/cases/d3a874304132542cbdeafc4bc7bac2c0_cosmorea-test4/bld/cesm.exe(+0x85058a) [0x5594450fe58a]
/ctsm-api/resources/cases/d3a874304132542cbdeafc4bc7bac2c0_cosmorea-test4/bld/cesm.exe(+0x853fcf) [0x559445101fcf]
/ctsm-api/resources/cases/d3a874304132542cbdeafc4bc7bac2c0_cosmorea-test4/bld/cesm.exe(+0x84f6d4) [0x5594450fd6d4]
/ctsm-api/resources/cases/d3a874304132542cbdeafc4bc7bac2c0_cosmorea-test4/bld/cesm.exe(+0x81ed46) [0x5594450ccd46]
/ctsm-api/resources/cases/d3a874304132542cbdeafc4bc7bac2c0_cosmorea-test4/bld/cesm.exe(+0x703139) [0x559444fb1139]
/ctsm-api/resources/cases/d3a874304132542cbdeafc4bc7bac2c0_cosmorea-test4/bld/cesm.exe(+0x70dad2) [0x559444fbbad2]
/ctsm-api/resources/cases/d3a874304132542cbdeafc4bc7bac2c0_cosmorea-test4/bld/cesm.exe(+0x6fca7c) [0x559444faaa7c]
/ctsm-api/resources/cases/d3a874304132542cbdeafc4bc7bac2c0_cosmorea-test4/bld/cesm.exe(+0x113d58) [0x5594449c1d58]
application called MPI_Abort(MPI_COMM_WORLD, -1) - process 0
```

There is also some info in resources/cases/caseID/CaseStatus:
```
2023-03-21 09:32:35: case.run starting
---------------------------------------------------
2023-03-21 09:32:36: model execution starting
---------------------------------------------------
2023-03-21 09:32:37: model execution error
ERROR: Command: 'mpiexec -n 1 /ctsm-api/resources/cases/d3a874304132542cbdeafc4bc7bac2c0_cosmorea-test4/bld/cesm.exe   >> cesm.log.$LID 2>&1 ' failed with error '' from dir '/ctsm-api/resources/cases/d3a874304132542cbdeafc4bc7bac2c0_cosmorea-test4/run'
---------------------------------------------------
2023-03-21 09:32:37: case.run error
ERROR: RUN FAIL: Command 'mpiexec -n 1 /ctsm-api/resources/cases/d3a874304132542cbdeafc4bc7bac2c0_cosmorea-test4/bld/cesm.exe   >> cesm.log.$LID 2>&1 ' failed
See log file for details: /ctsm-api/resources/cases/d3a874304132542cbdeafc4bc7bac2c0_cosmorea-test4/run/cesm.log.230321-093235
```

Furthermore, one that error ir fixed the next test will likely fail because these 
variables are "unset" in the caseID/run/datm.streams.xml, meaning the model doesn't find what should be there:
```
<file>UNSET//clm1pt__2000-01.nc</file>
<file>UNSET//clm1pt__2000-02.nc</file>
```
etc... 


in the case folder, replay.sh summarises the case like this:

```
./xmlchange --force CLM_USRDAT_DIR=/ctsm-api/resources/data/d3a874304132542cbdeafc4bc7bac2c0_cosmorea-test4

./xmlchange --force PTS_LON=8.12343

./xmlchange --force PTS_LAT=61.0243

#!/bin/bash

set -e

# Created 2023-03-21 08:44:43

CASEDIR="/ctsm-api/resources/cases/d3a874304132542cbdeafc4bc7bac2c0_cosmorea-test4"

/ctsm-api/resources/model/cime/scripts/create_newcase --case "${CASEDIR}" --compset 2000_DATM%COSMOREA_CLM51%FATES_SICE_SOCN_MOSART_SGLC_SWAV --driver nuopc --res CLM_USRDAT --machine docker --run-unsupported --handle-preexisting-dirs r --user-mods-dirs /ctsm-api/resources/data/d3a874304132542cbdeafc4bc7bac2c0_cosmorea-test4/user_mods

cd "${CASEDIR}"

./case.setup

./xmlchange CALENDAR=GREGORIAN,DATM_YR_ALIGN=2000,DATM_YR_END=2001,DATM_YR_START=2000,DOUT_S_SAVE_INTERIM_RESTART_FILES=True,LND_TUNING_MODE=clm5_1_GSWP3v1,RUN_STARTDATE=2000-01-01,RUN_TYPE=startup,STOP_N=1,STOP_OPTION=nyears

./xmlchange VCGSITE=ALP1

./case.build

./case.build

./case.submit
```