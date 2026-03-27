#-------------------------------------------------------------------
# Project: CIES Workshop Demonstration: Working with MICS FLS Data
# Sector: UNICEF Education Data & Analytics
# Objective: Demonstrate how to use processed MICS FLS data to
#            reproduce foundational learning gradient charts.
# Author: Justin Kleczka & Sakshi Mishra
# Date: March 18, 2026
#
# Description:
# This script demonstrates how to use processed MICS Foundational
# Learning Skills (FLS) data for multiple countries.
#
# The script starts from analysis-ready files saved in the repo and
# uses them to reproduce selected charts from the UNICEF learning
# gradient analysis published here:
# https://data.unicef.org/resources/education-learning-gradient-explore-the-data/
#-------------------------------------------------------------------

#-------------------------------------------------------------------
# IMPORTANT: HOW TO RUN THIS SCRIPT
#-------------------------------------------------------------------

# Please open the R project file:
#   CIES_Workshop_MICS_FLS.Rproj
#
# Then open this script from the bottom-right "Files" pane in RStudio.
#
# This ensures:
# - The working directory is set to the project root
# - The profile.R file can be found and sourced correctly
#
# If you do not do this, file paths may not work.

#-------------------------------------------------------------------
# LOAD PROJECT CONFIGURATION (profile.R)
#-------------------------------------------------------------------

if (!file.exists("profile.R")) {
  stop("Please open the project via CIES_Workshop_MICS_FLS.Rproj")
} else {
  source("profile.R")
}

#-------------------------------------------------------------------
# LOAD INPUT DATA
#-------------------------------------------------------------------

output_grade <- read_csv(
  file.path(analysis_input_data, "output_grade.csv"),
  show_col_types = FALSE
)

output_grade_band <- read_csv(
  file.path(analysis_input_data, "output_grade_band.csv"),
  show_col_types = FALSE
)

#-------------------------------------------------------------------
# SET SHARED PARAMETERS
#-------------------------------------------------------------------

# Chart 1 filters
MIN_OBS <- 25
MISSING_GRADES_TOL <- 8

# Benchmark colours
BENCH_AFRICA_LABEL <- "MICS6 Africa Countries"
BENCH_AFRICA_COLOR <- "#1CABE2"
BENCH_NON_AFRICA_LABEL <- "MICS6 Rest of the world countries"
BENCH_NON_AFRICA_COLOR <- "#2D2926"

# Country background colours
COUNTRY_AFRICA_COLOR <- "#d1e4e6"
COUNTRY_NON_AFRICA_COLOR <- "#f1e9e0"

# Wealth colours
WEALTH_CATEGORIES <- c("All", "Poorest", "Second", "Middle", "Fourth", "Richest")
WEALTH_COLORS <- c(
  "All" = "#1CABE2",
  "Poorest" = "#F26A21",
  "Second" = "#FFC20E",
  "Middle" = "#77777A",
  "Fourth" = "#80BD41",
  "Richest" = "#00833D"
)

# Grade bands and panel labels
GRADE_BANDS <- c(
  "Early Primary (1-3)",
  "End of Primary (4-6)",
  "Lower Secondary (7-9)"
)

PANEL_ALL_LABEL <- "All Countries"
PANEL_AFRICA_LABEL <- "MICS6 Africa Countries"
PANEL_ROW_LABEL <- "MICS6 Rest of the world countries"

# Chart 2 filters
MIN_OBS_BAND <- 25
MISSING_COMB_TOL <- 15

# Shared theme for Chart 2
theme_chart2 <- theme_minimal() +
  theme(
    legend.position = "bottom",
    legend.title = element_text(face = "bold", size = 10),
    legend.text = element_text(size = 10),
    panel.grid.major.x = element_blank(),
    panel.grid.minor.x = element_blank(),
    panel.grid.major.y = element_line(color = "#E5E5E5"),
    panel.grid.minor.y = element_blank(),
    plot.title = element_text(face = "bold", size = 14),
    plot.subtitle = element_text(size = 11),
    strip.text = element_text(face = "bold", size = 11),
    axis.text.x = element_text(angle = 0, hjust = 0.5)
  )

message("Parameters set.")

#-------------------------------------------------------------------
# PREPARE SHARED DATA FOR CHART 2
#-------------------------------------------------------------------

chart2_base <- output_grade_band %>%
  filter(subject == "reading", grade_band %in% GRADE_BANDS) %>%
  filter(!is.na(pct_weighted_loess_span1)) %>%
  filter(n_weighted >= MIN_OBS_BAND)

# Drop countries with too many missing wealth x grade-band combinations
quintile_cats <- c("Poorest", "Second", "Middle", "Fourth", "Richest")
expected_combos <- length(GRADE_BANDS) * length(quintile_cats)

valid_countries_2 <- chart2_base %>%
  filter(category %in% quintile_cats) %>%
  group_by(iso3) %>%
  summarise(
    n_combinations = n_distinct(paste(category, grade_band)),
    .groups = "drop"
  ) %>%
  filter((expected_combos - n_combinations) <= (MISSING_COMB_TOL - 1)) %>%
  pull(iso3)

chart2_base <- chart2_base %>%
  filter(iso3 %in% valid_countries_2) %>%
  mutate(
    grade_band = factor(grade_band, levels = GRADE_BANDS, ordered = TRUE),
    category = factor(category, levels = WEALTH_CATEGORIES, ordered = TRUE)
  )

message("Chart 2 base data ready. Countries retained: ", n_distinct(chart2_base$iso3))

#-------------------------------------------------------------------
# CHART 1A: COUNTRY BY GRADE (READING)
#-------------------------------------------------------------------

chart1_reading <- output_grade %>%
  filter(subject == "reading", category == "All") %>%
  filter(!is.na(pct_weighted_loess_span1)) %>%
  filter(grade >= 1, grade <= 8) %>%
  filter(n_weighted >= MIN_OBS)

# Drop countries with too many missing grades
grade_counts <- chart1_reading %>%
  group_by(iso3) %>%
  summarise(n_grades = n_distinct(grade), .groups = "drop") %>%
  filter(n_grades >= (8 - (MISSING_GRADES_TOL - 1)))

chart1_reading <- chart1_reading %>%
  filter(iso3 %in% grade_counts$iso3) %>%
  mutate(country_group = ifelse(is_africa, "Africa_BG", "Non_Africa_BG"))

# Benchmark averages
bench1_reading <- chart1_reading %>%
  group_by(grade, is_africa) %>%
  summarise(
    pct_weighted_loess_span1 = mean(pct_weighted_loess_span1, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  mutate(
    benchmark_label = ifelse(is_africa, BENCH_AFRICA_LABEL, BENCH_NON_AFRICA_LABEL)
  )

# Plot
p1a <- ggplot() +
  geom_smooth(
    data = chart1_reading,
    aes(x = grade, y = pct_weighted_loess_span1, group = iso3, color = country_group),
    method = "loess", se = FALSE, alpha = 0.4, linewidth = 0.5, span = 1
  ) +
  geom_point(
    data = chart1_reading,
    aes(x = grade, y = pct_weighted_loess_span1, color = country_group),
    alpha = 0.6, size = 1.5
  ) +
  geom_smooth(
    data = bench1_reading,
    aes(x = grade, y = pct_weighted_loess_span1, color = benchmark_label, group = benchmark_label),
    method = "loess", se = FALSE, linewidth = 1.5, span = 1
  ) +
  geom_point(
    data = bench1_reading,
    aes(x = grade, y = pct_weighted_loess_span1, color = benchmark_label),
    size = 3
  ) +
  geom_text(
    data = bench1_reading %>% filter(is_africa),
    aes(x = grade, y = pct_weighted_loess_span1, label = sprintf("%.1f%%", pct_weighted_loess_span1)),
    color = BENCH_AFRICA_COLOR, vjust = 2.5, size = 3
  ) +
  geom_text(
    data = bench1_reading %>% filter(!is_africa),
    aes(x = grade, y = pct_weighted_loess_span1, label = sprintf("%.1f%%", pct_weighted_loess_span1)),
    color = BENCH_NON_AFRICA_COLOR, vjust = -1.0, size = 3
  ) +
  scale_color_manual(
    values = c(
      setNames(
        c(BENCH_AFRICA_COLOR, BENCH_NON_AFRICA_COLOR),
        c(BENCH_AFRICA_LABEL, BENCH_NON_AFRICA_LABEL)
      ),
      "Africa_BG" = COUNTRY_AFRICA_COLOR,
      "Non_Africa_BG" = COUNTRY_NON_AFRICA_COLOR
    ),
    breaks = c(BENCH_AFRICA_LABEL, BENCH_NON_AFRICA_LABEL),
    name = NULL
  ) +
  scale_x_continuous(
    name = "Grade",
    breaks = 1:8,
    limits = c(0.5, 8.5)
  ) +
  scale_y_continuous(
    name = "Reading proficiency (%)",
    limits = c(0, 100),
    breaks = seq(0, 100, 20)
  ) +
  labs(
    title = "Foundational Reading",
    subtitle = "Mean reading proficiency by grade (LOESS smoothed)"
  ) +
  theme_minimal() +
  theme(
    legend.position = "bottom",
    legend.text = element_text(size = 10),
    panel.grid.major.x = element_blank(),
    panel.grid.minor.x = element_blank(),
    panel.grid.major.y = element_line(color = "grey90"),
    panel.grid.minor.y = element_line(color = "grey95"),
    plot.title = element_text(face = "bold", size = 14),
    plot.subtitle = element_text(size = 11)
  )

print(p1a)

ggsave(
  file.path(analysis_output, "country_by_grade_reading.png"),
  plot = p1a, width = 10, height = 7, dpi = 300, units = "in"
)

#-------------------------------------------------------------------
# CHART 1B: COUNTRY BY GRADE (NUMERACY)
#-------------------------------------------------------------------

chart1_numeracy <- output_grade %>%
  filter(subject == "numeracy", category == "All") %>%
  filter(!is.na(pct_weighted_loess_span1)) %>%
  filter(grade >= 1, grade <= 8) %>%
  filter(n_weighted >= MIN_OBS)

# Drop countries with too many missing grades
grade_counts_n <- chart1_numeracy %>%
  group_by(iso3) %>%
  summarise(n_grades = n_distinct(grade), .groups = "drop") %>%
  filter(n_grades >= (8 - (MISSING_GRADES_TOL - 1)))

chart1_numeracy <- chart1_numeracy %>%
  filter(iso3 %in% grade_counts_n$iso3) %>%
  mutate(country_group = ifelse(is_africa, "Africa_BG", "Non_Africa_BG"))

# Benchmark averages
bench1_numeracy <- chart1_numeracy %>%
  group_by(grade, is_africa) %>%
  summarise(
    pct_weighted_loess_span1 = mean(pct_weighted_loess_span1, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  mutate(
    benchmark_label = ifelse(is_africa, BENCH_AFRICA_LABEL, BENCH_NON_AFRICA_LABEL)
  )

# Plot
p1b <- ggplot() +
  geom_smooth(
    data = chart1_numeracy,
    aes(x = grade, y = pct_weighted_loess_span1, group = iso3, color = country_group),
    method = "loess", se = FALSE, alpha = 0.4, linewidth = 0.5, span = 1
  ) +
  geom_point(
    data = chart1_numeracy,
    aes(x = grade, y = pct_weighted_loess_span1, color = country_group),
    alpha = 0.6, size = 1.5
  ) +
  geom_smooth(
    data = bench1_numeracy,
    aes(x = grade, y = pct_weighted_loess_span1, color = benchmark_label, group = benchmark_label),
    method = "loess", se = FALSE, linewidth = 1.5, span = 1
  ) +
  geom_point(
    data = bench1_numeracy,
    aes(x = grade, y = pct_weighted_loess_span1, color = benchmark_label),
    size = 3
  ) +
  geom_text(
    data = bench1_numeracy %>% filter(is_africa),
    aes(x = grade, y = pct_weighted_loess_span1, label = sprintf("%.1f%%", pct_weighted_loess_span1)),
    color = BENCH_AFRICA_COLOR, vjust = 2.5, size = 3
  ) +
  geom_text(
    data = bench1_numeracy %>% filter(!is_africa),
    aes(x = grade, y = pct_weighted_loess_span1, label = sprintf("%.1f%%", pct_weighted_loess_span1)),
    color = BENCH_NON_AFRICA_COLOR, vjust = -1.0, size = 3
  ) +
  scale_color_manual(
    values = c(
      setNames(
        c(BENCH_AFRICA_COLOR, BENCH_NON_AFRICA_COLOR),
        c(BENCH_AFRICA_LABEL, BENCH_NON_AFRICA_LABEL)
      ),
      "Africa_BG" = COUNTRY_AFRICA_COLOR,
      "Non_Africa_BG" = COUNTRY_NON_AFRICA_COLOR
    ),
    breaks = c(BENCH_AFRICA_LABEL, BENCH_NON_AFRICA_LABEL),
    name = NULL
  ) +
  scale_x_continuous(
    name = "Grade",
    breaks = 1:8,
    limits = c(0.5, 8.5)
  ) +
  scale_y_continuous(
    name = "Numeracy proficiency (%)",
    limits = c(0, 100),
    breaks = seq(0, 100, 20)
  ) +
  labs(
    title = "Foundational Numeracy",
    subtitle = "Mean numeracy proficiency by grade (LOESS smoothed)"
  ) +
  theme_minimal() +
  theme(
    legend.position = "bottom",
    legend.text = element_text(size = 10),
    panel.grid.major.x = element_blank(),
    panel.grid.minor.x = element_blank(),
    panel.grid.major.y = element_line(color = "grey90"),
    panel.grid.minor.y = element_line(color = "grey95"),
    plot.title = element_text(face = "bold", size = 14),
    plot.subtitle = element_text(size = 11)
  )

print(p1b)

ggsave(
  file.path(analysis_output, "country_by_grade_numeracy.png"),
  plot = p1b, width = 10, height = 7, dpi = 300, units = "in"
)

#-------------------------------------------------------------------
# CHART 2A: WEALTH BY GRADE BAND (ALL COUNTRIES)
#-------------------------------------------------------------------

agg_2a <- chart2_base %>%
  mutate(panel = PANEL_ALL_LABEL) %>%
  group_by(panel, category, grade_band) %>%
  summarise(
    pct_weighted_loess_span1 = mean(pct_weighted_loess_span1, na.rm = TRUE),
    .groups = "drop"
  )

p2a <- ggplot() +
  geom_line(
    data = agg_2a %>% filter(category != "All"),
    aes(x = grade_band, y = pct_weighted_loess_span1, color = category, group = category),
    alpha = 0.4, linewidth = 0.8
  ) +
  geom_point(
    data = agg_2a %>% filter(category != "All"),
    aes(x = grade_band, y = pct_weighted_loess_span1, color = category),
    alpha = 0.4, size = 2
  ) +
  geom_line(
    data = agg_2a %>% filter(category == "All"),
    aes(x = grade_band, y = pct_weighted_loess_span1, color = category, group = category),
    linewidth = 1.4
  ) +
  geom_point(
    data = agg_2a %>% filter(category == "All"),
    aes(x = grade_band, y = pct_weighted_loess_span1, color = category),
    size = 3
  ) +
  geom_text(
    data = agg_2a %>% filter(category == "All"),
    aes(x = grade_band, y = pct_weighted_loess_span1, label = sprintf("%.1f%%", pct_weighted_loess_span1)),
    color = WEALTH_COLORS["All"], vjust = -1.2, hjust = 1.2, size = 3
  ) +
  facet_wrap(~panel, nrow = 1) +
  scale_color_manual(
    values = WEALTH_COLORS,
    breaks = WEALTH_CATEGORIES,
    name = "Wealth Group"
  ) +
  scale_y_continuous(
    name = "Reading - % with foundational skills",
    limits = c(0, 100),
    breaks = seq(0, 100, 20)
  ) +
  scale_x_discrete(name = NULL) +
  labs(
    title = "Foundational Reading",
    subtitle = "Mean proficiency by wealth and grade band (LOESS smoothed)"
  ) +
  theme_chart2 +
  guides(color = guide_legend(nrow = 1))

print(p2a)

ggsave(
  file.path(analysis_output, "wealth_by_grade_band_all_reading.png"),
  plot = p2a, width = 7, height = 7, dpi = 300, units = "in"
)

#-------------------------------------------------------------------
# CHART 2B: WEALTH BY GRADE BAND
#           (ALL COUNTRIES, AFRICA, REST OF WORLD)
#-------------------------------------------------------------------

agg_2c <- bind_rows(
  chart2_base %>% mutate(panel = PANEL_ALL_LABEL),
  chart2_base %>% filter(is_africa) %>% mutate(panel = PANEL_AFRICA_LABEL),
  chart2_base %>% filter(!is_africa) %>% mutate(panel = PANEL_ROW_LABEL)
) %>%
  mutate(
    panel = factor(
      panel,
      levels = c(PANEL_ALL_LABEL, PANEL_AFRICA_LABEL, PANEL_ROW_LABEL)
    )
  ) %>%
  group_by(panel, category, grade_band) %>%
  summarise(
    pct_weighted_loess_span1 = mean(pct_weighted_loess_span1, na.rm = TRUE),
    .groups = "drop"
  )

p2c <- ggplot() +
  geom_line(
    data = agg_2c %>% filter(category != "All"),
    aes(x = grade_band, y = pct_weighted_loess_span1, color = category, group = category),
    alpha = 0.4, linewidth = 0.8
  ) +
  geom_point(
    data = agg_2c %>% filter(category != "All"),
    aes(x = grade_band, y = pct_weighted_loess_span1, color = category),
    alpha = 0.4, size = 2
  ) +
  geom_line(
    data = agg_2c %>% filter(category == "All"),
    aes(x = grade_band, y = pct_weighted_loess_span1, color = category, group = category),
    linewidth = 1.4
  ) +
  geom_point(
    data = agg_2c %>% filter(category == "All"),
    aes(x = grade_band, y = pct_weighted_loess_span1, color = category),
    size = 3
  ) +
  geom_text(
    data = agg_2c %>% filter(category == "All"),
    aes(x = grade_band, y = pct_weighted_loess_span1, label = sprintf("%.1f%%", pct_weighted_loess_span1)),
    color = WEALTH_COLORS["All"], vjust = -1.2, hjust = 1.2, size = 3
  ) +
  facet_wrap(~panel, nrow = 1) +
  scale_color_manual(
    values = WEALTH_COLORS,
    breaks = WEALTH_CATEGORIES,
    name = "Wealth Group"
  ) +
  scale_y_continuous(
    name = "Reading - % with foundational skills",
    limits = c(0, 100),
    breaks = seq(0, 100, 20)
  ) +
  scale_x_discrete(name = NULL) +
  labs(
    title = "Foundational Reading",
    subtitle = "Mean proficiency by wealth and grade band (LOESS smoothed)"
  ) +
  theme_chart2 +
  guides(color = guide_legend(nrow = 1))

print(p2c)

ggsave(
  file.path(analysis_output, "wealth_by_grade_band_side_by_side_reading.png"),
  plot = p2c, width = 21, height = 7, dpi = 300, units = "in"
)