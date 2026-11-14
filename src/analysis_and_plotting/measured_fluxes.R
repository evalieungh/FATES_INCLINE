#'##############################
#'  summarise measured fluxes  #
#'##############################

# started 2026-02-27
# data from INCLINE project provided by J. Gaudard

library(dplyr)

filepath = "../../data/c-flux/cflux_skj.csv"
fluxdata <- read.csv(filepath)
head(fluxdata)

avg <- fluxdata |>
  group_by(type, OTC) |>
  summarise(across(f_flux_ave:par_se, mean))
avg
write.csv(avg, "../../results/cflux_skj_means.csv")
