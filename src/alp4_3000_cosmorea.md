# ALP4 3000 year COMSOREA

- full forcing period (1995-2018)
- compset 2000_DATM%COSMOREA_CLM51%FATES_SICE_SOCN_MOSART_SGLC_SWAV

dump from replay.sh:

```
./xmlchange --force CLM_USRDAT_DIR=/ctsm-api/resources/data/a78c1ebc19ad8a85c618a854afb9c8cf_alp4-3000-cosmo
./xmlchange --force PTS_LON=6.41504
./xmlchange --force PTS_LAT=60.9335
#[...]
# Created 2023-03-23 10:49:31

CASEDIR="/ctsm-api/resources/cases/a78c1ebc19ad8a85c618a854afb9c8cf_alp4-3000-cosmo"

/ctsm-api/resources/model/cime/scripts/create_newcase --case "${CASEDIR}" --compset 2000_DATM%COSMOREA_CLM51%FATES_SICE_SOCN_MOSART_SGLC_SWAV --driver nuopc --res CLM_USRDAT --machine docker --run-unsupported --handle-preexisting-dirs r --user-mods-dirs /ctsm-api/resources/data/a78c1ebc19ad8a85c618a854afb9c8cf_alp4-3000-cosmo/user_mods

cd "${CASEDIR}"

./case.setup

./xmlchange CALENDAR=GREGORIAN,DATM_YR_ALIGN=1995,DATM_YR_END=2018,DATM_YR_START=1995,DOUT_S_SAVE_INTERIM_RESTART_FILES=True,LND_TUNING_MODE=clm5_1_GSWP3v1,RUN_STARTDATE=1995-01-01,RUN_TYPE=startup,STOP_N=3000,STOP_OPTION=nyears,VCGSITE=ALP4

./case.build

./case.build

./case.submit
```

from user_nl_clm:
fsurdat = '$CLM_USRDAT_DIR/surfdata_0.9x1.25_hist_16pfts_Irrig_CMIP6_simyr2000_ALP4_c221027.nc'
use_bedrock = .true.



### update 2023-03-24, from CaseStatus:

 ---------------------------------------------------
2023-03-23 11:12:46: model execution starting
 ---------------------------------------------------
2023-03-23 18:13:35: model execution error
ERROR: Command: 'mpiexec -n 1 /ctsm-api/resources/cases/a78c1ebc19ad8a85c618a854afb9c8cf_alp4-3000-cosmo/bld/cesm.exe   >> cesm.log.$LID 2>&1 ' failed with error '' from dir '/ctsm-api/resources/cases/a78c1ebc19ad8a85c618a854afb9c8cf_alp4-3000-cosmo/run'
 ---------------------------------------------------
2023-03-23 18:13:35: case.run error
ERROR: RUN FAIL: Command 'mpiexec -n 1 /ctsm-api/resources/cases/a78c1ebc19ad8a85c618a854afb9c8cf_alp4-3000-cosmo/bld/cesm.exe   >> cesm.log.$LID 2>&1 ' failed
See log file for details: /ctsm-api/resources/cases/a78c1ebc19ad8a85c618a854afb9c8cf_alp4-3000-cosmo/run/cesm.log.230323-111245
 ---------------------------------------------------
2023-03-23 18:13:35: st_archive starting
 ---------------------------------------------------
2023-03-23 18:13:35: st_archive success


### dump from top of /archive/logs/cesm.log.230323-111245
(shr_orb_params) ------ Computed Orbital Parameters ------
(shr_orb_params) Eccentricity      =   1.670366E-02
(shr_orb_params) Obliquity (deg)   =   2.343977E+01
(shr_orb_params) Obliquity (rad)   =   4.091011E-01
(shr_orb_params) Long of perh(deg) =   1.028955E+02
(shr_orb_params) Long of perh(rad) =   4.937458E+00
(shr_orb_params) Long at v.e.(rad) =  -3.247250E-02
(shr_orb_params) -----------------------------------------
  max rss=314822656.0 MB
  max rss=314822656.0 MB
  max rss=314822656.0 MB
  max rss=314822656.0 MB
  ... and so on forever, no error message

  ### dump from end of archive/logs/lnd.log.230323-111245
 WARNING:: BalanceCheck, solar radiation balance error (W/m2)
 nstep         =      1843661
 errsol        =   -1.3755169447904336E-007
 WARNING:: BalanceCheck, solar radiation balance error (W/m2)
 nstep         =      1843662
 errsol        =   -1.5147691101446981E-007
 WARNING:: BalanceCheck, solar radiation balance error (W/m2)
 nstep         =      1843663
 errsol        =   -1.4640062317994307E-007
 WARNING:: BalanceCheck, solar radiation balance error (W/m2)
 nstep         =      1843665
 errsol        =   -1.8827449821401387E-007

******************************************************************************************

### new test started 2023-03-27 15:16

26c190b3a0792133a94c1771567bdfca	alp4-3000-cosmo


    DOUT_S_SAVE_INTERIM_RESTART_FILES:true
    VCGSITE:ALP4
    DIN_LOC_ROOT_CLMFORC:-
    CALENDAR:GREGORIAN
    DATM_YR_START:1995
    DATM_YR_ALIGN:1995
    DATM_YR_END:2018
    RUN_STARTDATE:0995-01-01
    STOP_N:3000
    STOP_OPTION:nyears
    STOP_DATE:-
    RUN_TYPE:startup
    LND_TUNING_MODE:clm5_1_GSWP3v1
    co2_ppmv:-
    fates_paramfile:-
    fsurdat:-
    fates_spitfire_mode:-
    use_bedrock:true
    hist_fincl1:-
    hist_fincl2:-
    hist_fincl3:-
    hist_fincl4:-
    hist_fincl5:-
    hist_fincl6:-
    hist_dov2xy:false, false, false, false, false, false
    hist_avgflag_pertape:A, A, A, A, A, A
    hist_nhtfrq:0, 0, 0, 0, 0, 0
    hist_mfilt:1, 0, 0, 0, 0, 0
    pft_index_count:12
    included_pft_indices:1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12
    fates_c2b:2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2
    fates_grperc:0.11, 0.11, 0.11, 0.11, 0.11, 0.11, 0.11, 0.11, 0.11, 0.11, 0.11, 0.11
    fates_leaf_long:1.5, 4, 1, 1.5, 1, 1, 1.5, 1, 1, 1, 1, 1
    fates_leaf_stor_priority:0.8, 0.8, 0.8, 0.8, 0.8, 0.8, 0.8, 0.8, 0.8, 0.8, 0.8, 0.8
    fates_leaf_slatop:0.012, 0.01, 0.024, 0.012, 0.03, 0.03, 0.012, 0.03, 0.03, 0.03, 0.03, 0.03
    fates_leaf_vcmax25top:50, 65, 39, 62, 41, 58, 62, 54, 54, 78, 78, 78
    fates_leaf_xl:0.1, 0.01, 0.01, 0.1, 0.01, 0.25, 0.01, 0.25, 0.25, -0.3, -0.3, -0.3
    fates_mort_bmort:0.014, 0.014, 0.014, 0.014, 0.014, 0.014, 0.014, 0.014, 0.014, 0.014, 0.014, 0.014
    fates_mort_freezetol:2.5, -55, -80, -30, 2.5, -30, -60, -10, -80, -80, -20, 2.5
    fates_mort_hf_sm_threshold:0.000001, 0.000001, 0.000001, 0.000001, 0.000001, 0.000001, 0.000001, 0.000001, 0.000001, 0.000001, 0.000001, 0.000001
    fates_phen_evergreen:1, 1, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0
    fates_phen_season_decid:0, 0, 1, 0, 0, 1, 0, 0, 1, 1, 0, 0
    fates_phen_stress_decid:0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 1, 1
    fates_root_long:1, 2, 1, 1.5, 1, 1, 1.5, 1, 1, 1, 1, 1
    fates_woody:1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0


Again, failed but quicker this time with this error in CaseStatus:

2023-03-27 13:20:44: case.build success
 ---------------------------------------------------
2023-03-27 13:20:46: case.run starting
 ---------------------------------------------------
2023-03-27 13:20:47: model execution starting
 ---------------------------------------------------
2023-03-27 13:29:25: model execution error
ERROR: Command: 'mpiexec -n 1 /ctsm-api/resources/cases/26c190b3a0792133a94c1771567bdfca_alp4-3000-cosmo/bld/cesm.exe   >> cesm.log.$LID 2>&1 ' failed with error '' from dir '/ctsm-api/resources/cases/26c190b3a0792133a94c1771567bdfca_alp4-3000-cosmo/run'
 ---------------------------------------------------
2023-03-27 13:29:25: case.run error
ERROR: RUN FAIL: Command 'mpiexec -n 1 /ctsm-api/resources/cases/26c190b3a0792133a94c1771567bdfca_alp4-3000-cosmo/bld/cesm.exe   >> cesm.log.$LID 2>&1 ' failed
See log file for details: /ctsm-api/resources/cases/26c190b3a0792133a94c1771567bdfca_alp4-3000-cosmo/run/cesm.log.230327-132046
 ---------------------------------------------------
2023-03-27 13:29:25: st_archive starting
 ---------------------------------------------------
2023-03-27 13:29:25: st_archive success
 ---------------------------------------------------
2023-03-27 13:29:25: case.submit starting
 ---------------------------------------------------
2023-03-27 13:29:25: case.submit success
 ---------------------------------------------------

 no solar radiation warnings in archive/logs/lnd.log.230327-132046 this time

 and the same messages in archive/logs/cesm.log.230327-132046
  max rss=315920384.0 MB
  max rss=315920384.0 MB
  max rss=315920384.0 MB
  max rss=315920384.0 MB
  max rss=315920384.0 MB


  could these threads be helpful? 
  https://github.com/ESMCI/cime/issues/2929 
  https://bb.cgd.ucar.edu/cesm/threads/mpi-issues-with-scripts_regression_tests-py-script-file.6122/ 
  



******************************************************************************************
  ### New tests

Turn on debugging with this line in the env_build.xml:
      <entry id="DEBUG" value="FALSE">

I also ran a 1-year simulation and got output with calendar set to NO_LEAP (57f1ca0d279733f9cc1fb2ea11208fbb_alp4-1-calendartest)

Started a 1000-year simulation with as good as I know how settings. 
in the land log, I get solar radiation balance warnings like:
 WARNING:: BalanceCheck, solar radiation balance error (W/m2)
 nstep         =       281931
 errsol        =   -1.5877273540354508E-007
 clm: calling FATES model       281953
 clm: leaving fates model           1           1
 WARNING:: BalanceCheck, solar radiation balance error (W/m2)
 nstep         =       281979
 errsol        =   -1.0059534361062106E-007

