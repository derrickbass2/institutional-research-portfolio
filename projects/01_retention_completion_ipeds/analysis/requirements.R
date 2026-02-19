# /projects/01_retention_completion_ipeds/analysis/requirements.R
# Purpose: install & snapshot packages for reproducibility using renv

if (!requireNamespace("renv", quietly = TRUE)) {
  install.packages("renv")
}

# Initialize renv if not already initialized at repo root
if (!file.exists("renv.lock")) {
  renv::init(bare = TRUE)
}

pkgs <- c(
  "tidyverse",
  "janitor",
  "readr",
  "dplyr",
  "ggplot2",
  "broom",
  "car",
  "lmtest",
  "sandwich"
)

installed <- rownames(installed.packages())
to_install <- setdiff(pkgs, installed)

if (length(to_install) > 0) {
  install.packages(to_install)
}

renv::snapshot(prompt = FALSE)
