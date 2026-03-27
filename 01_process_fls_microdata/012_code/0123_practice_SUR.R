#-------------------------------------------------------------------
# Project: CIES Workshop Demonstration: Working with MICS FLS Data
# Sector: UNICEF Education Data & Analytics
# Objective: Practice processing MICS FLS data for Suriname and
#            visualizing foundational reading and numeracy results.
# Author: Justin Kleczka & Sakshi Mishra
# Date: March 25, 2026
#
# Description:
# This script is a workshop exercise. Participants will practice
# processing MICS Foundational Learning Skills (FLS) data for
# Suriname (ISO-3 code: "SUR").
#
# To complete this exercise, open the example script:
#   0122_example_BGD_NGA
#
# Then copy the relevant code sections from that script into the
# template below. The goal is to help participants understand the
# main processing steps, rather than simply running a finished script.
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
# WORKSHOP TASK
#-------------------------------------------------------------------

# In this exercise, you will adapt the example processing script
# (0122_example_BGD_NGA) to process Suriname.
#
# Copy the relevant code for each section below:
# 1. Load the data
# 2. Filter the target population
# 3. Detect the reading structure
# 4. Create foundational reading indicators
# 5. Create foundational numeracy indicators
# 6. Save the processed output

#-------------------------------------------------------------------
# LOAD DATA
#-------------------------------------------------------------------

# Copy the relevant line(s) from 0122_example_BGD_NGA
# Example structure:
# fs <- readRDS(file.path(raw_output_data, paste0(countrycode, "_fs.rds")))

#-------------------------------------------------------------------
# FILTER TARGET POPULATION
#-------------------------------------------------------------------

# Copy the relevant filter step from 0122_example_BGD_NGA
# Keep children aged 7–14 with a completed module

#-------------------------------------------------------------------
# IDENTIFY READING STRUCTURE
#-------------------------------------------------------------------

# Copy the relevant logic from 0122_example_BGD_NGA

#-------------------------------------------------------------------
# FOUNDATIONAL READING SKILLS
#-------------------------------------------------------------------

if (uses_single_reading) {
  
  # Copy the single-reading processing code from 0122_example_BGD_NGA
  
} else if (uses_multi_reading) {
  
  # Copy the multi-reading processing code from 0122_example_BGD_NGA
  
} else {
  stop(
    paste0(
      "Country ", countrycode,
      " contains a mix of reading methods. ",
      "This script expects each country to use only one reading structure."
    )
  )
}

#-------------------------------------------------------------------
# FOUNDATIONAL NUMERACY SKILLS
#-------------------------------------------------------------------

# Copy the numeracy processing code from 0122_example_BGD_NGA

#-------------------------------------------------------------------
# SAVE OUTPUT
#-------------------------------------------------------------------

# Copy the save step from 0122_example_BGD_NGA
# Example structure:
# saveRDS(fs, file.path(processed_output_data, paste0(countrycode, "_fs_processed.rds")))

#-------------------------------------------------------------------
# LOAD PROCESSED SURINAME DATA
#-------------------------------------------------------------------

# Once you have completed the processing step above, load the
# processed Suriname file here for the visualisation exercises.

fs <- readRDS(file.path(processed_output_data, "SUR_fs_processed.rds"))

#-------------------------------------------------------------------
# VISUALIZE SURINAME FLS DATA
#-------------------------------------------------------------------

# Now that you have processed the data, you can explore the results.
# The examples below show how foundational reading and numeracy vary
# by sex, wealth, and area.

# EXERCISE: If you have additional time, try to make the graph prettier
# Remember: AI is your friend in coding

#-------------------------------------------------------------------
# PROFICIENCY BY SEX
#-------------------------------------------------------------------

sex_summary <- fs %>%
  mutate(sex = ifelse(HL4 == 1, "Male", "Female")) %>%
  group_by(sex) %>%
  summarise(
    reading = weighted.mean(readingSkill, fsweight, na.rm = TRUE),
    numeracy = weighted.mean(numbskill, fsweight, na.rm = TRUE)
  )

sex_plot_data <- sex_summary %>%
  pivot_longer(
    cols = c(reading, numeracy),
    names_to = "subject",
    values_to = "proficiency"
  )

ggplot(sex_plot_data, aes(x = subject, y = proficiency, fill = sex)) +
  geom_bar(stat = "identity", position = "dodge") +
  scale_y_continuous(labels = scales::label_percent(scale = 1)) +
  scale_x_discrete(labels = c("reading" = "Reading", "numeracy" = "Numeracy")) +
  labs(
    title = "Reading and Numeracy Proficiency by Sex (Suriname)",
    x = "",
    y = "Proficiency Rate",
    fill = "Sex"
  ) +
  theme_minimal()

#-------------------------------------------------------------------
# PROFICIENCY BY WEALTH INDEX
#-------------------------------------------------------------------

wealth_summary <- fs %>%
  mutate(
    wealth = factor(
      windex5,
      levels = 1:5,
      labels = c("Poorest", "Poorer", "Middle", "Richer", "Richest")
    )
  ) %>%
  group_by(wealth) %>%
  summarise(
    reading = weighted.mean(readingSkill, fsweight, na.rm = TRUE),
    numeracy = weighted.mean(numbskill, fsweight, na.rm = TRUE)
  )

wealth_plot_data <- wealth_summary %>%
  pivot_longer(
    cols = c(reading, numeracy),
    names_to = "subject",
    values_to = "proficiency"
  )

ggplot(wealth_plot_data, aes(x = wealth, y = proficiency, fill = subject)) +
  geom_bar(stat = "identity", position = "dodge") +
  scale_y_continuous(labels = scales::label_percent(scale = 1)) +
  labs(
    title = "Reading and Numeracy Proficiency by Wealth (Suriname)",
    x = "Wealth Quintile",
    y = "Proficiency Rate",
    fill = ""
  ) +
  theme_minimal()

#-------------------------------------------------------------------
# PROFICIENCY BY AREA (URBAN / RURAL)
#-------------------------------------------------------------------

area_summary <- fs %>%
  mutate(area = ifelse(HH6 == 1, "Urban", "Rural")) %>%
  group_by(area) %>%
  summarise(
    reading = weighted.mean(readingSkill, fsweight, na.rm = TRUE),
    numeracy = weighted.mean(numbskill, fsweight, na.rm = TRUE)
  )

area_plot_data <- area_summary %>%
  pivot_longer(
    cols = c(reading, numeracy),
    names_to = "subject",
    values_to = "proficiency"
  )

ggplot(area_plot_data, aes(x = subject, y = proficiency, fill = area)) +
  geom_bar(stat = "identity", position = "dodge") +
  scale_y_continuous(labels = scales::label_percent(scale = 1)) +
  scale_x_discrete(labels = c("reading" = "Reading", "numeracy" = "Numeracy")) +
  labs(
    title = "Reading and Numeracy Proficiency by Area (Suriname)",
    x = "",
    y = "Proficiency Rate",
    fill = "Area"
  ) +
  theme_minimal()
