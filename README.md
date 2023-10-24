# Repository for a manuscript using CLM-FATES to model alpine grasslands under climate warming

[![DOI](https://zenodo.org/badge/267775364.svg)](https://zenodo.org/doi/10.5281/zenodo.10036318)

This repository contains data, notebooks, and workflow notes for a manuscript titled "Process-based modelling of experimental warming in alpine vegetation". 

This readme file was generated on [2023-02-27] by Eva Lieungh

Some code and notebooks have been heavily inspired by other sources. These are generally mentioned at the start of relevant files.

Contact:
Eva Lieungh,
https://orcid.org/0000-0003-4009-944X,
Natural History Museum, University of Oslo,
eva.lieungh[at]nhm.uio.no /
evaleriksen[at]gmail.com

## Related resources:

- Lieungh, E. (2023). Simulation output for seven simulations with CLM-FATES in the Land Sites Platform (1.0) [Data set]. Zenodo. https://doi.org/10.5281/zenodo.8124988


### Contents

This is the folder structure in my local copy of the directory. Most of these folders are listed in `.gitignore` and will not be uploaded to GitHub. See Related resources list above.

| Folder or file name | Description       |
| ------------------- | ----------- |
| data/ | raw and original input data |
| data_processed/ | modified data, intermediate files |
| writing | manuscript drafts and text, presentations |
| results | output files, figures etc. |
| resources | external resources not to be uploaded (add to .gitignore) |
| src   | code, notebooks etc for data handling and analysis |
| README.md | This file, which creates the repository's basic info on the GitHub page |
| LICENSE | Specifies this repo's license. MIT template. |

### Funding sources that supported this project

PhD project funded by the Norwegian Ministry of Education and Research, through the Natural History Museum, University of Oslo. Vascular plant community data were collected for the INCLINE project, Research Council of Norway FRIMEDBIO project 274712. PI: Vandvik, Töpper. 2018–2021. 

### Sharing and access

See the license. Copy and use freely, but please cite this repository if you use large parts of several scripts (that is, if you are doing most of the same analyses and your starting point is a copy of these scripts). See for instance the [ICMJE authorship guidelines (Vancouver convention)](https://www.icmje.org/recommendations/browse/roles-and-responsibilities/defining-the-role-of-authors-and-contributors.html) to help you decide which kind of acknowledgement is appropriate. 

### Manuscript data availability

Apart from one data set used in creating “improved” surface data for the simulations, all data sources are openly available and referred to in the manuscript text and reference list. One source, Vandvik et al. (2023; osf.io/zhk3m), is currently restricted but will become publicly available following the publication of a data paper draft in Gya, R. (2022). Disentangling effects and context dependencies of climate change on alpine plants [Doctoral thesis, The University of Bergen]. https://hdl.handle.net/11250/3038854. The derived surface data which incorporates calculated means from these data is available in this repository.

### Help and useful tricks

Questions? Contact me, or post an issue in this repository. 

A neat trick to find the answer to questions like "what script creates and saves the important_data.Rds file?" is to open a terminal in the ´/src´ folder and enter this command to search (grep) inside all files (-e) inside that folder and subfolders (-r): ´grep -r -e "important_data.Rds"´
