
Given that COSMO can be used after all, the notes below may or may not be necessary to enable using it.

### Changes to enable COSMOREA6
Some instructions from Hui Tang's repo https://github.com/huitang-earth/scripts_ctsm_region.git. 

To use COSMOREA data, replace the following files with the files provided in "huitang-earth/scripts_ctsm_region/atm_forcing/cosmo_rea_6km/ctsm_config_reg" (works for both regional and any single site simulations). Rename the model defaults to keep them for comparison just in case. 

```
cd ~
git clone https://github.com/huitang-earth/scripts_ctsm_region.git

mv CTSM/components/cdeps/datm/cime_config/namelist_definition_datm.xml CTSM/components/cdeps/datm/cime_config/namelist_definition_datm_default.xml
mv CTSM/components/cdeps/datm/cime_config/stream_definition_datm.xml CTSM/components/cdeps/datm/cime_config/stream_definition_datm_default.xml
mv CTSM/components/cdeps/datm/cime_config/config_component.xml CTSM/components/cdeps/datm/cime_config/config_component_default.xml

cp scripts_ctsm_region/atm_forcing/cosmo_rea_6km/ctsm_config_VCG/namelist_definition_datm.xml CTSM/components/cdeps/datm/cime_config/namelist_definition_datm.xml
cp scripts_ctsm_region/atm_forcing/cosmo_rea_6km/ctsm_config_VCG/stream_definition_datm.xml CTSM/components/cdeps/datm/cime_config/stream_definition_datm.xml
cp scripts_ctsm_region/atm_forcing/cosmo_rea_6km/ctsm_config_VCG/config_component.xml CTSM/components/cdeps/datm/cime_config/config_component.xml

```

Last, make changes to the stream_definition_datm.xml file for all three COSMOREA variables, to point to a different path than Hui and Elin used. The changes look e.g. like this:

```
  <stream_entry name="COSMOREA.Precip">
    <stream_meshfile>
      <meshfile>none</meshfile>
    </stream_meshfile>
    <stream_datafiles>
      <file first_year="1995" last_year="2018">$CLM_USRDAT_DIR/datmdata/clm1pt_${VCGSITE}_%ym.nc</file>
```

For the NREC/LSP setup, the VCGSITE variable Elin added was needed to complete the datm data path, which whould look like `$CLM_USRDAT_DIR/datmdata/clm1pt_${VCGSITE}_%ym.nc`. I'm not sure if it is still needed, so let's skip it for now.

The compset for COSMOREA should be `2000_DATM%COSMOREA_CLM51%FATES_SICE_SOCN_MOSART_SGLC_SWAV`