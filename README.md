# Repository for a manuscript using CLM-FATES to model alpine grasslands under climate warming

This repository contains notebooks and workflow notes for a manuscript in preparation. 

This readme file was generated on [2023-02-27] by Eva Lieungh

## NB! this is a work in progress. The notebooks are not 100% clean and finished, and results may not be reproducible. Some code and notebooks have been heavily inspired by other sources.

Contact:
Eva Lieungh,
https://orcid.org/0000-0003-4009-944X,
Natural History Museum, University of Oslo,
eva.lieungh[at]nhm.uio.no /
evaleriksen[at]gmail.com

## Related resources:

- 

### Contents

This is the folder structure in my local copy of the directory. Most of these folders are listed in `.gitignore` and will not be uploaded to GitHub. See Related resources list above.

| Folder or file name | Description       |
| ------------------- | ----------- |
| data/ | raw and input data |
| data_processed/ | modified data, intermediate files |
| writing | manuscript drafts and backups |
| results | output files, figures etc. |
| resources | external resources not to be uploaded (add to .gitignore) |
| src   | code, notebooks etc for analysis |
| README.md | This file, which creates the repository's basic info on the GitHub page |
| LICENSE | Specifiec this repo's license. MIT template. |

### Funding sources that supported this project

PhD project funded by the Norwegian Ministry of Education and Research, through the Natural History Museum, University of Oslo. Vascular plant community data were collected for the INCLINE project, Research Council of Norway FRIMEDBIO project 274712. PI: Vandvik, Töpper. 2018–2021. 

### Sharing and access

Copy snippets freely, but please refer to this repository if you use large parts of several scripts (that is, if you are doing most of the same analyses and your starting point is a copy of these scripts). See for instance the [ICMJE authorship guidelines (Vancouver convention)](https://www.icmje.org/recommendations/browse/roles-and-responsibilities/defining-the-role-of-authors-and-contributors.html) to help you decide which kind of acknowledgement is appropriate. 

### Help and useful tricks

Questions? Contact me, or post an issue in this repository. 

A neat trick to find the answer to questions like "what script creates and saves the important_data.Rds file?" is to open a terminal in the ´/src´ folder and enter this command to search (grep) inside all files (-e) inside that folder and subfolders (-r): ´grep -r -e "important_data.Rds"´
