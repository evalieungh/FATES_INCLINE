# ER, NEE, GPP over the growing season at Skjellingahaugen
# Controls, inside and outside OTCs
# 2020 and 2022

# Load packages

my_packages <- c(
    "tidyverse",
    "dataDownloader",
    "fluxible"
)
lapply(my_packages, library, character.only = TRUE)

# Load data

get_file(node = "zhk3m",
                  file = "INCLINE_c-flux_2022.csv",
                  path = "data/c-flux",
                  remote_path = "C-Flux")

get_file(node = "zhk3m",
                  file = "INCLINE_metadata.csv",
                  path = "data/c-flux",
                  remote_path = "RawData")
            
get_file(node = "zhk3m",
                  file = "INCLINE_c-flux_2020.csv",
                  path = "data/c-flux",
                  remote_path = "C-Flux")

metadata <- read_csv2("data/c-flux/INCLINE_metadata.csv")
cflux_2020_og <- read_csv("data/c-flux/INCLINE_c-flux_2020.csv")
cflux_2022_og <- read_csv("data/c-flux/INCLINE_c-flux_2022.csv")

str(cflux_2020_og)
str(cflux_2022_og)

cflux_2020 <- cflux_2020_og |>
    select(campaign, replicate, plotID, PAR_ave, type, f_flux, siteID, OTC, treatment) |>
    filter(
        siteID == "Skjellingahaugen"
        & treatment == "C"
    ) |>
    mutate(year = 2020)

distinct(cflux_2020, type)
# we need gpp for 2020

cflux_2020 <- cflux_2020 |>
    flux_diff(
        type_col = type,
        id_cols = c("campaign", "replicate", "plotID"),
        cols_keep = c("PAR_ave", "siteID", "OTC", "treatment", "year"),
        type_a = "NEE",
        type_b = "ER",
        diff_name = "GPP"
    ) |>
    select(!c(campaign, replicate))



cflux_2022 <- cflux_2022_og |>
   left_join(metadata) |>
    #   janitor::clean_names() |>
    select(campaign, PAR_ave, type, f_flux, siteID, OTC, treatment, plotID, par_correction) |>
      filter(
        campaign != 1 # we exclude campaign 1 as it is very different than the rest of the season (was probably too early?) 
        & siteID == "Skjellingahaugen"
        & treatment == "C"
        & type != "LRC"
        & is.na(par_correction)
      ) |>
    mutate(year = 2022) |>
    select(!campaign)


cflux_skj <- bind_rows(cflux_2020, cflux_2022) |>
    mutate(
        f_flux_kg = f_flux * (12.01 / 3600) # from mmol CO2 m-2 h-1 to mg C m-2 s-1
        ) |>
    summarise(
        .by = c("type", "OTC", "year", "treatment"),
        f_flux_ave = mean(f_flux_kg, na.rm = TRUE),
        f_flux_sd = sd(f_flux_kg, na.rm = TRUE),
        f_flux_n = sum(!is.na(f_flux)),
        f_flux_se = ifelse(f_flux_n > 0, f_flux_sd / sqrt(f_flux_n), NA_real_),
        par_ave = mean(PAR_ave, na.rm = TRUE),
        par_sd = sd(PAR_ave, na.rm = TRUE),
        par_n = sum(!is.na(PAR_ave)),
        par_se = ifelse(par_n > 0, par_sd / sqrt(par_n), NA_real_)
    )

# nb of measurements

bind_rows(cflux_2020, cflux_2022) |>
    summarise(
        .by = c("type", "year"),
        n_OTC = sum(OTC == "W"),
        n_control = sum(OTC == "C")
    ) |>
    View()


write_csv(cflux_skj, "data/c-flux/cflux_skj.csv")
