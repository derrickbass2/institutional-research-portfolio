# /projects/01_retention_completion_ipeds/analysis/analysis.R
# Purpose: analysis pipeline (to be completed once IPEDS extract is pulled)

# Load libraries
library(tidyverse)
library(janitor)
library(broom)
library(car)
library(lmtest)
library(sandwich)

# 1) Load data (do not commit raw data to repo)
# Example expected path (you will create locally):
# data_path <- "projects/01_retention_completion_ipeds/data/ipeds_extract.csv"
# df <- readr::read_csv(data_path) |> janitor::clean_names()

# 2) Clean & define variables
# 3) Fit model
# 4) Diagnostics (residuals, leverage, VIF)
# 5) Save outputs to /outputs

message("Project scaffold created. Next: add real IPEDS extract and complete variable definitions.")
