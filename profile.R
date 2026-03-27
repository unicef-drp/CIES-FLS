#-------------------------------------------------------------------
# Project: CIES Workshop Demonstration: Working with MICS FLS Data
# Sector: UNICEF Education Data & Analytics
# Objective: Set up the R environment of the repo
# Author: Justin Kleczka & Sakshi Mishra
# Date: March 18, 2026
#-------------------------------------------------------------------

# ============================================================
# 1. Packages
# ============================================================

# Required packages
packages <- c(
  "tidyr", "purrr", "ggplot2", "plotly",
  "dplyr", "readr", "scales", "stringr",
  "jsonlite", "rsdmx", "haven"
)

# Install missing packages
missing_packages <- packages[!packages %in% rownames(installed.packages())]
if (length(missing_packages) > 0) install.packages(missing_packages)

# Load packages
invisible(lapply(packages, library, character.only = TRUE))


# ============================================================
# 2. File paths
# ============================================================

# Project root
project_folder <- getwd()

# Input data (raw FLS processing)
raw_input_data <- file.path(project_folder, "01_process_fls_microdata", "011_data")

# Output data (processed FLS)
processed_output_data <- file.path(project_folder, "01_process_fls_microdata", "013_output")

# Input data (analysis)
analysis_input_data <- file.path(project_folder, "02_learning_gradient_analysis", "021_data")

# Output data (analysis results)
analysis_output <- file.path(project_folder, "02_learning_gradient_analysis", "023_output")