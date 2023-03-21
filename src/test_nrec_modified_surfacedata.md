# workflow for test simulation with modified surfacedata (and LSP default GSWP3 forcing) on nrec

Log into NREC VM, on branch https://github.com/evalieungh/noresm-land-sites-platform/tree/FATES_INCLINE:

```
ssh -i .ssh/evaskey ubuntu@158.39.75.164
cd ../../../data
cd evalieungh-fork/noresm-land-sites-platform
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

Set up a test simulation for ALP2: 

- name: ALP2_surfdat_mod_test
- 1 years
- datm yr start 1901
- datm yr end 1902
- stopn 1
- stop option nyears

FAIL. In the GUI the run builds and runs "successfully" but there is no output and no logs in the case run directory. 

I ran a 1-year test with ALP3 with default LSP data, and it ran fine and produced output. So it seems unproblematic to have Hui's modified files in resources/model/components/cdeps/datm/cime_config/. Maybe the problem is the surface data file since the modified-surfacedata-only and COSMO-forcing tests both seemed to fail the same way.


### Second, run a longer test simulation for ALP4

- name: ALP4_surfdat_mod_2000yr
- 2000 years
- datm yr start 1901
- datm yr end 2014
- stopn 2000
- stop option nyears


Dump of LSP case variables:

```

```
