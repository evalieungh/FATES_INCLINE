#'##############################
#'  summarise measured fluxes  #
#'##############################

# started 2026-02-27
# Eva Lieungh + chatGPT conversion of jupyter notebook
# data from INCLINE project provided by J. Gaudard

library(ncdf4)
library(CFtime)
library(dplyr)
library(tidyr)
library(ggplot2)

# read observational data ------------------------------------------------
filepath = "../../data/c-flux/cflux_skj.csv"
fluxdata <- read.csv(filepath)
head(fluxdata)

# save averages
avg <- fluxdata |>
  group_by(type, OTC) |>
  summarise(across(f_flux_ave:par_se, mean))
avg
write.csv(avg, "../../results/cflux_skj_means.csv")

## unit conversion of observed data to fit model output ----------
data_obs <- read.csv(filepath,
  stringsAsFactors = FALSE
) %>%
  mutate(
    f_flux_ave_kg = f_flux_ave / 1e6,
    f_flux_sd_kg  = f_flux_sd  / 1e6,
    f_flux_se_kg  = f_flux_se  / 1e6
  )

# read and subset model data ----------------------------------------------
# This mapping follows the active file_paths dictionary in notebook cell 8.
simulation_paths <- c(
  cold   = "../../results/cold.h0.concatenated_nc4.nc",
  exp_c1 = "../../results/experiment.h0.concatenated_nc4.nc",
  exp_c2 = "../../results/experiment2.h0.concatenated_nc4.nc",
  warm   = "../../results/warm.h0.concatenated_nc4.nc",
  exp_w1 = "../../results/experimentwarm.h0.concatenated_nc4.nc",
  exp_w2 = "../../results/experimentwarm2.h0.concatenated_nc4.nc"
)

simulations <- names(simulation_paths)
simulation_titles <- c(
  "cold", "cold +1", "cold +2",
  "warm", "warm +1", "warm +2"
)

read_simulation_fluxes <- function(path, n_years = 14) {
  nc <- nc_open(path)
  on.exit(nc_close(nc))
  
  # Read the CF time coordinate and its metadata.
  time_values <- ncvar_get(nc, "time")
  time_units <- ncatt_get(nc, "time", "units")$value
  calendar_att <- ncatt_get(nc, "time", "calendar")
  calendar <- if (isTRUE(calendar_att$hasatt)) {
    calendar_att$value
  } else {
    "standard"
  }
  
  if (is.null(time_units) || length(time_units) != 1L || is.na(time_units)) {
    stop("Could not read CF time units from: ", path)
  }

  # CFtime handles the calendar declared by the NetCDF file, including
  # non-standard climate-model calendars.
  cf_time <- CFtime(
    definition = time_units,
    calendar = calendar,
    offsets = time_values
  )
  
  year  <- as.integer(format(cf_time, "%Y"))
  month <- as.integer(format(cf_time, "%m"))
  hour  <- as.integer(format(cf_time, "%H"))
  
  # These variables have time and singleton lndgrid dimensions in the notebook.
  # collapse_degen=TRUE removes that singleton dimension.
  fates_gpp <- as.numeric(ncvar_get(nc, "FATES_GPP", collapse_degen = TRUE))
  fates_nep <- as.numeric(ncvar_get(nc, "FATES_NEP", collapse_degen = TRUE))
  
  if (length(fates_gpp) != length(time_values) ||
      length(fates_nep) != length(time_values)) {
    stop(
      "Expected FATES_GPP and FATES_NEP to contain one value per time step. ",
      "Check the lndgrid dimension in: ", path
    )
  }
  
  # Match the notebook: retain July daytime records, then average within year.
  # The notebook's timestamps are at 12:00, so they pass the 06:00-18:00 test.
  annual_fluxes <- tibble(
    year = year,
    month = month,
    hour = hour,
    FATES_GPP = fates_gpp,
    FATES_NEP = fates_nep
  ) %>%
    filter(month == 7L, hour >= 6L, hour <= 18L) %>%
    group_by(year) %>%
    summarise(
      FATES_GPP = mean(FATES_GPP, na.rm = TRUE),
      FATES_NEP = mean(FATES_NEP, na.rm = TRUE),
      .groups = "drop"
    ) %>%
    arrange(year) %>%
    slice_tail(n = n_years) %>%
    mutate(
      GPP = FATES_GPP,
      NEE = -FATES_NEP,
      ER = FATES_GPP - FATES_NEP
    ) %>%
    select(year, GPP, NEE, ER)
  
  if (nrow(annual_fluxes) != n_years) {
    warning(
      "Expected ", n_years, " annual July values, but found ",
      nrow(annual_fluxes), " in ", path
    )
  }
  
  annual_fluxes
}
  
# A named list equivalent to the notebook's dfs dictionary.
dfs <- lapply(simulation_paths, read_simulation_fluxes)

# Plot modelled vs observed fluxes ------------------------------------------
## Prepare model values for comparison plot ---------
var_names <- c("GPP", "NEE", "ER")
panel_labels <- c("(a) GPP", "(b) NEE", "(c) ER")

model_plot_data <- bind_rows(lapply(simulations, function(sim) {
  dfs[[sim]] %>%
    pivot_longer(
      cols = all_of(var_names),
      names_to = "variable",
      values_to = "value"
    ) %>%
    mutate(
      simulation = sim,
      simulation_idx = match(sim, simulations),
      variable_panel = factor(
        variable,
        levels = var_names,
        labels = panel_labels
      )
    )
}))  

## Prepare observed means and SD bars --------
# The notebook places the same observed values alongside both the cold and
# warm simulation groups. The small x offsets separate the 2020 and 2022
# observations within each group.
obs_positions <- tibble(
  year = c(2020, 2022, 2020, 2022, 2020, 2022, 2020, 2022),
  OTC  = c("C", "C", "W", "W", "C", "C", "W", "W"),
  x    = c(0.9, 1.1, 1.9, 2.1, 3.9, 4.1, 4.9, 5.1)
)

obs_plot_data <- data_obs %>%
  filter(
    type %in% var_names,
    year %in% c(2020, 2022),
    OTC %in% c("C", "W")
  ) %>%
  inner_join(obs_positions, by = c("year", "OTC")) %>%
  mutate(
    variable_panel = factor(
      type,
      levels = var_names,
      labels = panel_labels
    ),
    lower = f_flux_ave_kg - f_flux_sd_kg,
    upper = f_flux_ave_kg + f_flux_sd_kg
  )

## plot -------
comparison_plot <- ggplot() +
  geom_boxplot(
    data = model_plot_data,
    aes(x = simulation_idx, y = value, group = simulation_idx),
    width = 0.6,
    fill = "#F85332",
    colour = "black",
    linewidth = 0.5
  ) +
  geom_errorbar(
    data = obs_plot_data,
    aes(x = x, ymin = lower, ymax = upper, colour = OTC),
    width = 0.1,
    linewidth = 0.5,
    show.legend = FALSE
  ) +
  geom_point(
    data = obs_plot_data,
    aes(x = x, y = f_flux_ave_kg, colour = OTC),
    size = 1.6,
    show.legend = FALSE
  ) +
  facet_wrap(~variable_panel, nrow = 1, scales = "free_y") +
  scale_x_continuous(
    breaks = seq_along(simulation_titles),
    labels = simulation_titles,
    limits = c(0.5, 6.5),
    expand = expansion(mult = 0)
  ) +
  scale_colour_manual(values = c(C = "black", W = "red")) +
  labs(
    x = NULL,
    y = expression(kg~m^{-2}~s^{-1})
  ) +
  theme_classic(base_size = 12) +
  theme(
    panel.border = element_rect(colour = "black", fill=NA, linewidth=1),
    strip.background = element_blank(),
    strip.text = element_text(size = 16, face = "bold", 
                              hjust = 0, vjust = 0.85),
    axis.text.x = element_text(size = 13),
    axis.title.y = element_text(size = 14)
  )

print(comparison_plot)

## save plot ---------
ggsave(
  "../../results/figures/Figure_5.png",
  plot = comparison_plot,
  width = 16,
  height = 3,
  dpi = 500
)

# end
