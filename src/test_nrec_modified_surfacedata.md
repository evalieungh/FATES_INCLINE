# workflow for test simulation with modified surfacedata (and LSP default GSWP3 forcing) on nrec

Log into NREC VM, on branch https://github.com/evalieungh/noresm-land-sites-platform/tree/FATES_INCLINE:

```
ssh -i .ssh/evaskey ubuntu@158.39.75.164
cd ../../../data
cd incline/noresm-land-sites-platform
```

Go to /resources/config/sites.json and manually replace "data_url" with modified versions from https://github.com/evalieungh/FATES_INCLINE/tree/main/data, for example replace `https://raw.githubusercontent.com/NorESMhub/noresm-lsp-data/main/sites/ALP1.zip` with `https://raw.githubusercontent.com/evalieungh/FATES_INCLINE/main/data/ALP1.zip`. (i for insert, esc to stop editing, :wq write quit)

```
vi /resources/config/sites.json
i
esc
:wq
```

Then get the LSP up an running

```
docker-compose up
```

Set up a simulation for ALP4: 

- name: ALP4_surfdat_mod_2000yr
- 2000 years
- datm yr start 1901
- datm yr end 2014
- stopn 2000
- stop option nyears


Dump of LSP case variables:

```
    DOUT_S_SAVE_INTERIM_RESTART_FILES:true
    DIN_LOC_ROOT_CLMFORC:-
    CALENDAR:NO_LEAP
    DATM_YR_START:1901
    DATM_YR_ALIGN:1901
    DATM_YR_END:2014
    RUN_STARTDATE:0001-01-01
    STOP_N:2000
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
```

Says it's successful in the GUI, but .case_submit finishes in 12 seconds and creates no log files in the case run directory! No error in the terminal that I can see. Next: Make 100% sure I'm not using the weird grazing branch, and try again. 
