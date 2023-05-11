# data folder

This folder contains data for VCG sites for use in the NorESM Land Sites Platform (LSP) or CLM in general for single-site simulations in the Vestland Climate Grid locations.

- Simple site names, e.g. ALP1.zip = land surface file modified, otherwise identical to the LSP input data
- added _cosmorea, e.g. ALP1_cosmorea = land surface file modified, AND datmdata replaced with COSMO reanalysis data subset by Hui Tang
- added _cosmorea_noleap = same as above, but with noleap version of forcing data.
- added _cosmorea_warmed = modified _cosmorea_noleap data where temperature was increased (see notebook in src)

**References/data sources:**

- [LSP data repo](https://github.com/NorESMhub/noresm-lsp-data)
- [Hui Tang's COSMO-REA6 explanation and setup repo](https://github.com/huitang-earth/scripts_ctsm_region/tree/main/atm_forcing/cosmo_rea_6km)
- [COSMO-REA6: Hans-Ertel-Centre for Weather Research](https://data.opendatascience.eu/geonetwork/srv/api/records/4d6f6090-c242-454b-9224-1151f7ae2823)
- [INCLINE observational data repository on OSF (not public yet but coming soon...)](https://osf.io/zhk3m/)
- [GSWP3; Dirmeyer, P. A., Gao, X., Zhao, M., Guo, Z., Oki, T. and Hanasaki, N. (2006) GSWP-2: Multimodel Analysis and Implications for Our Perception of the Land Surface. Bulletin of the American Meteorological Society, 87(10), 1381–98.](https://www.isimip.org/gettingstarted/input-data-bias-adjustment/details/4/)