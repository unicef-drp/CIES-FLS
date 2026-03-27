#-------------------------------------------------------------------
# Project: CIES Workshop Demonstration: Working with MICS FLS Data
# Sector: UNICEF Education Data & Analytics
# Objective: Demonstrate how to process Bangladesh and Nigeria's
#            MICS Foundational Learning Skills (FLS) data to measure
#            foundational reading and numeracy in the countries.
# Author: Justin Kleczka, Femke van den Bos, & Sakshi Mishra
# Date: March 27, 2026
#
# Description:

# This code demonstrates how to process the MICS Foundational Learning
# Skills (FLS) data for two example countries: Bangladesh and Nigeria.
# The code is structured to loop through each country, load the relevant
# dataset, apply the required population filters, and calculate the
# foundational reading and numeracy indicators.
#
# For reading, the code uses the questionnaire design logic captured by
# the variable "readmthd":
#   - If a country file only contains readmthd values 1 or 2, children
#     were assessed using the single-story reading pathway, and the code
#     uses wd_corr together with the FL22 comprehension items.
#   - If a country file only contains readmthd values 3 or 4, children
#     were assessed using the multi-story / multi-language pathway, and
#     the code uses wd1_corr / wd2_corr together with the FL21B and FL22
#     comprehension items.
#
# This keeps the code simple and readable, because each country is
# expected to follow only one reading structure.
#
# All indicators are coded directly as 0/100 so they can later be
# aggregated into percentages.
#
# Note: This script creates the literacy and numeracy indicators at the child
# level. It does not yet apply survey weights in the calculation of
# summary results. Weights should be applied later when producing tables
# or reporting aggregate estimates.
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
# SELECT COUNTRIES
#-------------------------------------------------------------------

# These are the ISO-3 country codes for the 2 countries used in this example:
# Bangladesh (BGD) and Nigeria (NGA)
country_codes <- c("BGD", "NGA")

#-------------------------------------------------------------------
# PROCESS DATA FOR SELECTED COUNTRIES
#-------------------------------------------------------------------

# Begin loop to process each country one by one
for (countrycode in country_codes) {
  
  # ── Load input data stored in repo ─────────────────────────────────────
  fs <- read_sav(paste0(raw_input_data, "/", countrycode, "_fs.sav"))
  
  # ── Keep children aged 7–14 with a completed module (FL28 == 1) ─
  fs <- fs %>%
    filter(FL28 == 1 & CB3 >= 7 & CB3 <= 14)
  
  # ── Identify which reading structure is present in the country ──
  readmthd_values <- sort(unique(na.omit(fs$readmthd)))
  
  uses_single_reading <- all(readmthd_values %in% c(1, 2))
  uses_multi_reading  <- all(readmthd_values %in% c(3, 4))
  
  # ── Foundational Reading Skills ─────────────────────────────────
  if (uses_single_reading) {
    
    fs <- fs %>%
      mutate(
        # 1) Correctly read at least 90% of words in a story
        readCorrect = case_when(
          wd_corr > 0.9 * st1wnum ~ 100,
          TRUE ~ 0
        ),
        
        # 2) Correctly answer three literal comprehension questions
        # AND Correctly read at least 90% of words in a story
        aLiteral = case_when(
          readCorrect == 100 &
          FL22A == 1 & FL22B == 1 & FL22C == 1 ~ 100,
          TRUE ~ 0
        ),
        
        # 3) Correctly answer two inferential comprehension questions
        # AND Correctly read at least 90% of words in a story
        aInferential = case_when(
          readCorrect == 100 &
          FL22D == 1 & FL22E == 1 ~ 100,
          TRUE ~ 0
        ),
        
        # 4) Demonstrate foundational reading skills
        readingSkill = case_when(
          readCorrect == 100 &
            aLiteral == 100 &
            aInferential == 100 ~ 100,
          TRUE ~ 0
        )
      )
    
  } else if (uses_multi_reading) {
    
    fs <- fs %>%
      mutate(
        # 1) Correctly read at least 90% of words in a story
        readCorrect = case_when(
          (wd1_corr > 0.9 * st1wnum) | (wd2_corr > 0.9 * st2wnum) ~ 100,
          TRUE ~ 0
        ),
        
        # 2) Correctly answer three literal comprehension questions
        # AND Correctly read at least 90% of words in a story
        aLiteral = case_when(
          readCorrect == 100 &
           ((FL21BA == 1 & FL21BB == 1 & FL21BC == 1) |
            (FL22A == 1 & FL22B == 1 & FL22C == 1)) ~ 100,
          TRUE ~ 0
        ),
        
        # 3) Correctly answer two inferential comprehension questions
        # AND Correctly read at least 90% of words in a story
        aInferential = case_when(
          readCorrect == 100 &
          ((FL21BD == 1 & FL21BE == 1) |
            (FL22D == 1 & FL22E == 1)) ~ 100,
          TRUE ~ 0
        ),
        
        # 4) Demonstrate foundational reading skills
        readingSkill = case_when(
          readCorrect == 100 &
            aLiteral == 100 &
            aInferential == 100 ~ 100,
          TRUE ~ 0
        )
      )
    
  } else {
    stop(
      paste0(
        "Country ", countrycode,
        " contains a mix of reading methods. ",
        "This script expects each country to use only one reading structure."
      )
    )
  }
  
  # ── Foundational Numeracy Skills ────────────────────────────────
  fs <- fs %>%
    mutate(
      # 1) Read all 6 numbers correctly
      target_num = rowSums(
        cbind(FL23A, FL23B, FL23C, FL23D, FL23E, FL23F),
        na.rm = FALSE
      ),
      
      number_read = case_when(
        target_num == 6 ~ 100,
        TRUE ~ 0
      ),
      
      # 2) Correctly answer all number discrimination questions
      number_dis = case_when(
        FL24A == 1 & FL24B == 1 & FL24C == 1 & FL24D == 1 & FL24E == 1 ~ 100,
        TRUE ~ 0
      ),
      
      # 3) Correctly answer all addition questions
      number_add = case_when(
        FL25A == 1 & FL25B == 1 & FL25C == 1 & FL25D == 1 & FL25E == 1 ~ 100,
        TRUE ~ 0
      ),
      
      # 4) Correctly answer all pattern recognition questions
      number_patt = case_when(
        FL27A == 1 & FL27B == 1 & FL27C == 1 & FL27D == 1 & FL27E == 1 ~ 100,
        TRUE ~ 0
      ),
      
      # 5) Demonstrate foundational numeracy skills
      numbskill = case_when(
        number_read == 100 &
          number_dis == 100 &
          number_add == 100 &
          number_patt == 100 ~ 100,
        TRUE ~ 0
      )
    )
  
  # ── Save processed data to .rds file ────────────────────────────
  saveRDS(
    fs,
    file = paste0(processed_output_data, "/", countrycode, "_fs_processed.rds")
  )
}
