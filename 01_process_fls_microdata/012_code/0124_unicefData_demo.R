#-------------------------------------------------------------------
# Project: CIES Workshop – Using unicefData in R
#-------------------------------------------------------------------
# Objective:
# Demonstrate how to directly access UNICEF education indicators
# in R using the unicefData package.
#
# Key idea:
# We do NOT need to manually download data from the MICS website.
# Instead, we query UNICEF data directly from within R.
#
# Countries:
# - Bangladesh (BGD)
# - Nigeria (NGA)
# - Suriname (SUR)
#-------------------------------------------------------------------

#-------------------------------------------------------------------
# IMPORTANT: HOW TO RUN THIS SCRIPT
#-------------------------------------------------------------------

# 1. Open the R project (.Rproj)
# 2. Open this script via the Files pane (bottom-right in RStudio)
# 3. Run step by step

#-------------------------------------------------------------------
# LOAD PROJECT SETUP
#-------------------------------------------------------------------

# profile.R loads all required packages EXCEPT unicefData
if (file.exists("profile.R")) {
  source("profile.R")
}

#-------------------------------------------------------------------
# INSTALL + LOAD ONLY unicefData
#-------------------------------------------------------------------

if (!"unicefData" %in% installed.packages()[, "Package"]) {
  install.packages("unicefData")
}

library(unicefData)

message("=== UNICEF Data Workshop: Start ===")

#-------------------------------------------------------------------
# STEP 1: SEARCH FOR INDICATORS
#-------------------------------------------------------------------

message("Searching for education indicators...")

reading_indicators    <- list_indicators(name_contains = "reading")
numeracy_indicators   <- list_indicators(name_contains = "numeracy")
foundational_indicators <- list_indicators(name_contains = "foundational")

reading_indicators
numeracy_indicators
foundational_indicators

#-------------------------------------------------------------------
# EXERCISE 1
#-------------------------------------------------------------------

# Find:
# - Foundational Reading Skills → ED_FLS_READ
# - Foundational Numeracy Skills → ED_FLS_NUM

#-------------------------------------------------------------------
# STEP 2: DEFINE COUNTRIES + INDICATORS
#-------------------------------------------------------------------

countries <- c("BGD", "NGA", "SUR")

indicators <- c(
  "ED_FLS_READ",
  "ED_FLS_NUM"
)

#-------------------------------------------------------------------
# STEP 3: DOWNLOAD DATA (NO MANUAL FILES!)
#-------------------------------------------------------------------

message("Downloading data directly from UNICEF...")

fls_data <- unicefData(
  indicator = indicators,
  countries = countries,
  cache = TRUE
)

message("Rows downloaded: ", nrow(fls_data))

#-------------------------------------------------------------------
# STEP 4: INSPECT DATA
#-------------------------------------------------------------------

glimpse(fls_data)
names(fls_data)
head(fls_data)

#-------------------------------------------------------------------
# EXERCISE 2
#-------------------------------------------------------------------

# Identify:
# - country column
# - year column
# - value column
# - indicator column

#-------------------------------------------------------------------
# STEP 5: SIMPLE SUMMARY TABLE
#-------------------------------------------------------------------

summary_table <- fls_data %>%
  select(
    any_of(c("iso3", "country")),
    any_of(c("indicator")),
    any_of(c("period", "year")),
    any_of(c("value", "obs_value"))
  )

summary_table

#-------------------------------------------------------------------
# EXERCISE 3
#-------------------------------------------------------------------

# Look at the table:
#
# 1. Do all countries have the same years?
# 2. Are there missing values?

#-------------------------------------------------------------------
# STEP 6: QUICK VISUALISATION
#-------------------------------------------------------------------

ggplot(fls_data,
       aes(x = iso3, y = value, fill = iso3)) +
  geom_col() +
  facet_wrap(~indicator) +
  labs(
    title = "Foundational Learning Outcomes",
    subtitle = "BGD, NGA, SUR",
    x = "Country",
    y = "Value"
  ) +
  theme_minimal()

#-------------------------------------------------------------------
# EXERCISE 4
#-------------------------------------------------------------------

# Questions:
#
# 1. Which country has the highest value for reading?
# 2. Which country has the highest value for numeracy?
# 3. Which country has the lowest value for each indicator?
# 4. Is the ranking of countries the same for reading and numeracy?

#-------------------------------------------------------------------
# STEP 7: TRY YOUR OWN INDICATOR
#-------------------------------------------------------------------

# Example:
# list_indicators(name_contains = "attendance")

# Then:
# my_data <- unicefData(
#   indicator = "YOUR_CODE",
#   countries = countries
# )

#-------------------------------------------------------------------
# EXERCISE 5
#-------------------------------------------------------------------

# Try:
# - "attendance"
# - "completion"
# - "out-of-school"
#
# Then:
# - download one indicator
# - inspect it
# - plot it

#-------------------------------------------------------------------
# NOTE ON INTERPRETATION
#-------------------------------------------------------------------

# The values obtained through unicefData() may differ slightly
# (by a few percentage points) from results calculated directly
# from MICS microdata.
#
# This is expected and can be due to:
# - Updates in indicator definitions or methodology
# - Revisions in underlying data or weights
#
# Therefore, small differences should not be interpreted as errors,
# but rather as reflecting updated official estimates.

#-------------------------------------------------------------------
# KEY MESSAGE
#-------------------------------------------------------------------

# ✔ No manual download from MICS website
# ✔ Direct access to UNICEF data in R
# ✔ Easy comparison across countries

