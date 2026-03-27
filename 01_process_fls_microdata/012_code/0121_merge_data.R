#-------------------------------------------------------------------
# Project: CIES Workshop Demonstration: Working with MICS FLS Data
# Sector: UNICEF Education Data & Analytics
# Objective: Set up the R environment to process MICS FLS microdata and
# conduct learning gradient analysis
# 
# Author: Justin Kleczka & Sakshi Mishra
# Date: March 18, 2026
#
# Description:
# This script demonstrates how to merge MICS6 modules.
# Merging modules enables analysis across domains (learning, health, wealth, etc.).
# In this example, we merge:
#   - Household Module (HH)
#   - Children Age 5–17 Module (FS)
# See the 00_documentation folder for more details on MICS merging.
#
# Data source:
# https://mics.unicef.org/surveys
#-------------------------------------------------------------------

# ============================================================
# IMPORTANT: How to run this script
# ============================================================

# Please open the R project file:
#   CIES_Workshop_MICS_FLS.Rproj
#
# Then open this script from the bottom-right "Files" pane in RStudio.
#
# This ensures:
# - The working directory is set to the project root
# - The profile.R file is found and loaded correctly
#
# If you do not do this, file paths may not work.

# ============================================================
# Load project configuration (profile.R)
# ============================================================

if (!file.exists("profile.R")) {
  stop("Please open the project via CIES_Workshop_MICS_FLS.Rproj")
} else {
  source("profile.R")
}

# ============================================================
# PREPARE BANGLADESH DATA
# ============================================================

# FS module (child-level data)
bangladesh_fs_path <- file.path(
  project_folder,
  "01_process_fls_microdata", "011_data",
  "Bangladesh MICS6 SPSS Datasets", "fs.sav"
)
bangladesh_fs_data <- read_sav(bangladesh_fs_path)

# HH module (household-level data)
bangladesh_hh_path <- file.path(
  project_folder,
  "01_process_fls_microdata", "011_data",
  "Bangladesh MICS6 SPSS Datasets", "hh.sav"
)
bangladesh_hh_data <- read_sav(bangladesh_hh_path)

# Merge HH into FS (FS = base file for learning analysis)
# Keys:
# - HH1: Cluster
# - HH2: Household
merged_bangladesh_data <- bangladesh_fs_data %>%
  left_join(bangladesh_hh_data, by = c("HH1", "HH2"))