#-------------------------------------------------------------------
# Project: CIES Workshop Demonstration: Working with MICS FLS Data
#
# Objective: Bonus visualisations of foundational reading and
#            numeracy results for Nigeria using the processed FS file.
#-------------------------------------------------------------------

#-------------------------------------------------------------------
# IMPORTANT: HOW TO RUN THIS SCRIPT
#-------------------------------------------------------------------

# Please open the R project file first:
#   CIES-FLS.Rproj
#
# Then open this script from the Files pane in RStudio.

#-------------------------------------------------------------------
# LOAD PROJECT CONFIGURATION
#-------------------------------------------------------------------

if (!file.exists("profile.R")) {
  stop("Please open the project via CIES-FLS.Rproj")
} else {
  source("profile.R")
}

#-------------------------------------------------------------------
# LOAD PROCESSED NIGERIA DATA
#-------------------------------------------------------------------

fs <- readRDS(file.path(processed_output_data, "NGA_fs_processed.rds"))

#-------------------------------------------------------------------
# BONUS VISUALISATION 1: PROFICIENCY BY SEX
#-------------------------------------------------------------------

sex_summary <- fs %>%
  mutate(sex = ifelse(HL4 == 1, "Male", "Female")) %>%
  group_by(sex) %>%
  summarise(
    reading = weighted.mean(readingSkill, fsweight, na.rm = TRUE),
    numeracy = weighted.mean(numbskill, fsweight, na.rm = TRUE),
    .groups = "drop"
  )

sex_plot_data <- sex_summary %>%
  pivot_longer(
    cols = c(reading, numeracy),
    names_to = "subject",
    values_to = "proficiency"
  )

ggplot(sex_plot_data, aes(x = subject, y = proficiency, fill = sex)) +
  geom_bar(stat = "identity", position = "dodge") +
  scale_y_continuous(labels = label_percent(scale = 1)) +
  scale_x_discrete(labels = c("reading" = "Reading", "numeracy" = "Numeracy")) +
  labs(
    title = "Reading and Numeracy Proficiency by Sex (Nigeria)",
    x = "",
    y = "Proficiency Rate",
    fill = "Sex"
  ) +
  theme_minimal()

#-------------------------------------------------------------------
# BONUS VISUALISATION 2: PROFICIENCY BY WEALTH INDEX
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
    numeracy = weighted.mean(numbskill, fsweight, na.rm = TRUE),
    .groups = "drop"
  )

wealth_plot_data <- wealth_summary %>%
  pivot_longer(
    cols = c(reading, numeracy),
    names_to = "subject",
    values_to = "proficiency"
  )

ggplot(wealth_plot_data, aes(x = wealth, y = proficiency, fill = subject)) +
  geom_bar(stat = "identity", position = "dodge") +
  scale_y_continuous(labels = label_percent(scale = 1)) +
  labs(
    title = "Reading and Numeracy Proficiency by Wealth (Nigeria)",
    x = "Wealth Quintile",
    y = "Proficiency Rate",
    fill = ""
  ) +
  theme_minimal()

#-------------------------------------------------------------------
# BONUS VISUALISATION 3: PROFICIENCY BY AREA
#-------------------------------------------------------------------

area_summary <- fs %>%
  mutate(area = ifelse(HH6 == 1, "Urban", "Rural")) %>%
  group_by(area) %>%
  summarise(
    reading = weighted.mean(readingSkill, fsweight, na.rm = TRUE),
    numeracy = weighted.mean(numbskill, fsweight, na.rm = TRUE),
    .groups = "drop"
  )

area_plot_data <- area_summary %>%
  pivot_longer(
    cols = c(reading, numeracy),
    names_to = "subject",
    values_to = "proficiency"
  )

ggplot(area_plot_data, aes(x = subject, y = proficiency, fill = area)) +
  geom_bar(stat = "identity", position = "dodge") +
  scale_y_continuous(labels = label_percent(scale = 1)) +
  scale_x_discrete(labels = c("reading" = "Reading", "numeracy" = "Numeracy")) +
  labs(
    title = "Reading and Numeracy Proficiency by Area (Nigeria)",
    x = "",
    y = "Proficiency Rate",
    fill = "Area"
  ) +
  theme_minimal()
