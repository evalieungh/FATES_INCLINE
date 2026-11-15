###############################################
# compare GSWP3 precipitation to observations #
###############################################

# started 2026-11-15
# Eva Lieungh + ChatGPT starting from older jupyter notebook

library(ncdf4)
library(CFtime)
library(dplyr)
library(readr)
library(ggplot2)

# paths -----------------------------------------------------------
site_code = "ALP4"
obs_site = "Skjelingahaugen"
gswp3_path = file.path("../../data/ALP4/datmdata/")
obs_path = file.path(
  "../../data/VCG/climate",
  "VCG_clean_gridded_daily_precipitation_SKJ_2008-2022.csv"
)

plot_path <- "../../results/figures"

# read and transform observational data -----------------------------
obs <- read_csv(
  obs_path,
  show_col_types = FALSE
) %>%
  filter(
    siteID == obs_site,
    variable == "precipitation"
  ) %>%
  transmute(
    date = as.Date(date),
    obs_mm = as.numeric(value)
  )

head(obs)

# read and transform gswp3 data -------------------------------------
# Find all monthly GSWP3 precipitation files
gswp3_files <- list.files(
  gswp3_path,
  pattern = paste0(
    "^clmforc.*Prec\\.", site_code,
    "\\.[0-9]{4}-[0-9]{2}\\.nc$"
  ),
  full.names = TRUE
)
head(gswp3_files)

# Extract year-month from filenames
file_month <- as.Date(
  paste0(
    sub(
      ".*\\.([0-9]{4}-[0-9]{2})\\.nc$",
      "\\1",
      basename(gswp3_files)
    ),
    "-01"
  )
)
head(file_month)

# Keep January 2008 onwards (2008 is when observational data starts)
keep <- file_month >= as.Date("2008-01-01")

gswp3_files <- gswp3_files[keep]
file_month <- file_month[keep]

cat("Number of monthly files:", length(gswp3_files), "\n")
cat("First file:", basename(gswp3_files[1]), "\n")
cat("Last file:", basename(gswp3_files[length(gswp3_files)]), "\n")

# Function to read one NetCDF file (works for single gridcell)
read_gswp3_file <- function(file) {
  nc <- nc_open(file)
  on.exit(nc_close(nc))
  # Read time coordinate and its CF metadata
  time_values <- ncvar_get(nc, "time")
  time_units <- ncatt_get(nc, "time", "units")$value
  calendar_att <- ncatt_get(nc, "time", "calendar")
  calendar <- if (isTRUE(calendar_att$hasatt)) {
    calendar_att$value
  } else {
    "standard"
  }
  # Convert CF time values to dates, respecting no-leap calendar
  cf_time <- CFtime(
    definition = time_units,
    calendar = calendar,
    offsets = time_values
  )
  time_strings <- as_timestamp(cf_time, format = "timestamp")
  dates <- as.Date(substr(time_strings, 1, 10))
  # Read precipitation rate
  precip_rate <- as.vector(
    ncvar_get(nc, "PRECTmms", collapse_degen = FALSE)
  )
  # # This assumes the forcing file contains one grid cell
  # if (length(precip_rate) != length(dates)) {
  #   stop(
  #     "PRECTmms contains more than one grid cell in: ",
  #     basename(file),
  #     ". Select the desired grid cell before extracting."
  #   )
  # }
  # Convert mm/s to mm per 3-hour interval
  precip_mm_3h <- precip_rate * 10800
  data.frame(
    date = dates,
    precip_mm_3h = precip_mm_3h
  )
}

# Read and combine all monthly files
gswp3_3hourly <- bind_rows(
  lapply(gswp3_files, read_gswp3_file)
) %>%
  arrange(date)

# Inspect
head(gswp3_3hourly)

# Check the number of 3-hourly records per day
gswp3_3hourly %>%
  count(date) %>%
  count(n)

## Calculate daily precipitation totals ------
gswp3_daily <- gswp3_3hourly %>%
  group_by(date) %>%
  summarise(
    gswp3_mm = sum(precip_mm_3h),
    n_steps = n(),
    .groups = "drop"
  ) %>%
  filter(n_steps == 8) %>%
  select(date, gswp3_mm)

# inspect
head(gswp3_daily)


# placeholder date comparison
# Combine only dates available in both datasets
precip_compare <- inner_join(
  obs,
  gswp3_daily,
  by = "date"
) %>%
  filter(
    !is.na(obs_mm),
    !is.na(gswp3_mm)
  )


# Inspect overlapping period
range(precip_compare$date)
nrow(precip_compare)
head(precip_compare)

# plot data together ---------------------------------------------------
# Determine date range covered by both datasets
overlap_start <- max(
  min(gswp3_daily$date, na.rm = TRUE),
  min(obs$date, na.rm = TRUE)
)

overlap_end <- min(
  max(gswp3_daily$date, na.rm = TRUE),
  max(obs$date, na.rm = TRUE)
)

cat("Plotting period:", overlap_start, "to", overlap_end, "\n")

# Filter both datasets
gswp3_plot <- gswp3_daily %>%
  filter(date >= overlap_start, date <= overlap_end)

obs_plot <- obs %>%
  filter(date >= overlap_start, date <= overlap_end)

# Mean daily precipitation
mean_gswp3 <- mean(gswp3_plot$gswp3_mm, na.rm = TRUE)
mean_obs <- mean(obs_plot$obs_mm, na.rm = TRUE)

# Plot
p1 <- ggplot() +
  geom_line(
    data = gswp3_plot,
    aes(x = date, y = gswp3_mm, colour = "GSWP3"),
    linewidth = 0.5
  ) +
  geom_line(
    data = obs_plot,
    aes(x = date, y = obs_mm, colour = "VCG observations"),
    linewidth = 0.5,
    linetype = "dotted"
  ) +
  # Mean precipitation lines
  geom_hline(
    yintercept = mean_gswp3,
    colour = "navy",
    linetype = "dashed",
    linewidth = 0.7
  ) +
  geom_hline(
    yintercept = mean_obs,
    colour = "red",
    linetype = "dashed",
    linewidth = 0.7
  ) +
  # set colours
  scale_colour_manual(
    values = c(
      "GSWP3" = "navy",
      "VCG observations" = "red"
    )
  ) +
  scale_x_date(
    limits = c(overlap_start, overlap_end)
  ) +
  labs(
    title = "Daily precipitation: GSWP3 vs. observations",
    x = "Date",
    y = "Precipitation (mm/day)",
    colour = NULL
  ) +
  theme_classic(
  ) +
  theme(legend.position = c(0.8, 0.85))

print(p1)

ggsave(
  filename = file.path(plot_path, "gswp3_vcg_precipitation_daily.png"),
  plot = p1,
  width = 20,
  height = 10,
  units = "cm",
  dpi = 300
)

# stats -------------------------------------------------------------------
# Linear regression
lm_fit <- lm(
  gswp3_mm ~ obs_mm,
  data = precip_compare
)

# Calculate statistics
rmse <- sqrt(mean(
  (precip_compare$gswp3_mm - precip_compare$obs_mm)^2
))

r_squared <- summary(lm_fit)$r.squared

cat("Number of paired days:", nrow(precip_compare), "\n")
cat("RMSE:", round(rmse, 2), "mm/day\n")
cat("R-squared:", round(r_squared, 3), "\n")

summary(lm_fit)


# scatter plots --------------------------------------------------------
p2 <- ggplot(
  precip_compare,
  aes(x = obs_mm, y = gswp3_mm)
) +
  geom_point(
    alpha = 0.3,
    size = 1
  ) +
  # 1:1 line
  geom_abline(
    intercept = 0,
    slope = 1,
    colour = "red",
    linetype = "dashed"
  ) +
  # Linear regression
  geom_smooth(
    method = "lm",
    se = FALSE,
    colour = "black"
  ) +
  labs(
    title = "GSWP3 vs. VCG daily precipitation",
    subtitle = paste0(
      "RMSE = ", round(rmse, 2), " mm/day; ",
      "R-squared = ", round(r_squared, 3)
    ),
    x = "Observed precipitation (mm/day)",
    y = "GSWP3 precipitation (mm/day)"
  ) +
  theme_classic()
p2
print(p2)

ggsave(
  filename = file.path(plot_path, "gswp3_vcg_precipitation_scatter.png"),
  plot = p2,
  width = 9.5,
  height = 7,
  units = "cm",
  dpi = 200
)

