#-------------------------------------------------------------------
# Project: CIES Workshop Demonstration: Working with MICS FLS Data
# Sector: UNICEF Education Data & Analytics
# Objective: Practice processing MICS FLS data for Suriname and
#            visualizing foundational reading and numeracy results.
# Author: Femke van den Bos, Justin Kleczka, & Sakshi Mishra
# Date: March 27, 2026
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
#   CIES-FLS.Rproj
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
  stop("Please open the project via CIES-FLS.Rproj")
} else {
  source("profile.R")
}

#-------------------------------------------------------------------
# WORKSHOP TASK
#-------------------------------------------------------------------

# In this exercise, you will adapt the example processing script
# (0122_example_BGD_NGA) to process Suriname (ISO-3 code: "SUR").
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
# fs <- read_sav(paste0(raw_input_data, "/", countrycode, "_fs.sav"))

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
