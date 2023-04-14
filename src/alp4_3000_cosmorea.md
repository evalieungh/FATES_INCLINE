# ALP4 3000 year COMSOREA

updated 2023-04-14

- forcing period 1997-2016 to align with leap years
- compset 2000_DATM%COSMOREA_CLM51%FATES_SICE_SOCN_MOSART_SGLC_SWAV

- CLM_USRDAT_DIR=/ctsm-api/resources/data/785b7ea97ac2fc8641ed6ae1ade3949c_alp4-3000-cosmo
- PTS_LON=6.41504
- PTS_LAT=60.9335
- CALENDAR=GREGORIAN,
- DATM_YR_ALIGN=1,
- DATM_YR_END=2016,
- DATM_YR_START=1997,
- DOUT_S_SAVE_INTERIM_RESTART_FILES=True,
- LND_TUNING_MODE=clm5_1_GSWP3v1,
- RUN_STARTDATE=0001-01-01,
- RUN_TYPE=startup,
- STOP_N=3000,
- STOP_OPTION=nyears,
- VCGSITE=ALP4

- see cosmorea_local_setup.ipynb
- changed cosmo datm files' calendar (see change_cosmorea_calendar.ipynb)