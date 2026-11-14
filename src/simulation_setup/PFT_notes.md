# Acrtic and Cool C3 grasses - PFT comparison notes

Comparison made from visual inspection of parameter file (`../model_modifications/FATES_parameterfiles/fates_params_grazing_grassonly.cdl`). The table below lists only parameters vith different values - all other parameters are equal between the two PFTs.

| Note | Parameter values (Arctic/Cool)             | Long name (unit)                       | 
| ---- | ------------------------------------------ | -------------------------------------- |
| 1  | fates_alloc_store_priority_frac = 0.6, 0.8 ; | for high-priority organs, the fraction of their turnover demand that is gauranteed to be replaced, and if need-be by storage |
| 2  | fates_allom_d2bl1 = 0.05, 0.04 ;            | Parameter 1 for d2bl allometry | 
| 3  | fates_allom_l2fr = 2, 4 ;                   | Allocation parameter: fine root C per leaf C |
| 4  | fates_frag_seed_decay_rate = 0.35, 0.51 ;   | fraction of seeds that decay per year |
| 5  | fates_grperc = 0.16, 0.11 ;                 | Growth respiration factor |
| 6  | fates_history_coageclass_bin_edges = 0, 5 ; | Lower edges for cohort age class bins used in cohort age resolved history output (years) |
| 7  | fates_history_damage_bin_edges = 0, 80 ;    | Lower edges for damage class bins used in cohort history output (% crown loss) |
| 8  | fates_leaf_stomatal_intercept = 1624.209, 313709.616 ; | Minimum unstressed stomatal conductance for Ball-Berry model and Medlyn model (umol H2O/m**2/s) |
| 9  | fates_leaf_stomatal_slope_medlyn = 2.423, 5.799 ; | stomatal slope parameter, as per Medlyn (KPa**0.5) |
| 10 | fates_maintresp_leaf_atkin2017_baserate = 2.079, 2.0749 ;| Leaf maintenance respiration base rate parameter (r0) per Atkin et al 2017 (umol CO2/m^2/s) |
| 11 | fates_mort_freezetol = -89, -20 ;           | minimum temperature tolerance (degrees C) |
| 12 | fates_mort_scalar_coldstress = 2.3, 3 ;     | maximum mortality rate from cold stress (1/yr) |
| 13 | fates_nonhydro_smpsc = -317882.916, -200123.906 ;| Soil water potential at full stomatal closure (mm) |
| 14 | fates_nonhydro_smpso = -96187.704, -35291.509 ;| Soil water potential at full stomatal opening (mm) |
| 15 | fates_phen_evergreen = 0, 1 ;               | Binary flag for evergreen leaf habit |
| 16 | fates_phen_season_decid = 1, 0 ;            | Binary flag for seasonal-deciduous leaf habit |
| 17 | fates_recruit_height_min = 0.11, 0.2 ;      | the minimum height (ie starting height) of a newly recruited plant (m) |
| 18 | fates_recruit_seed_germination_rate = 0.29, 0.5 ;| fraction of seeds that germinate per year (yr-1) |
| 19 | fates_turnover_fnrt = 1, 0.5 ;              | root longevity (alternatively, turnover time) (yr) |
| 20 | fates_voc_pftindex = 12, 13 ;               | integer index for MEGAN PFT definitions |
| 21 | fates_leaf_vcmax25top = 39.168, 64 ;        | maximum carboxylation rate of Rub. at 25C, canopy top (umol CO2/m^2/s) |
| 22 | fates_turnover_leaf_canopy = 0.5, 0.15 ;    | Leaf longevity (ie turnover timescale) of canopy plants. For drought-deciduous PFTs, this also indicates the maximum length of the growing (i.e., leaves on) season. (yr) |
| 23 | fates_turnover_leaf_ustory = 1, 0.15 ;      | Leaf longevity (ie turnover timescale) of understory plants. (yr) |

1. Cool has higher retention of 'high-priority organs'(?)
2.  d2bl allometry ?
3. Cool has twice as much fine root C per leaf C - more biomass allocation to roots
4. Cool's seeds decay faster
5. ?
6. Cool has bigger minimal size class?
7. Minimum stomatal conductance higher for Cool
8. 
9.
10.
11.
12.
13.
14.
15. Cool evergreen
16. Arctic seasonal-deciduous
17. Cool gets recruited at bigger size
18.
19. Arctic has twice as long root longevity
20.
21.
22.
23.