# projects/01_retention_completion_ipeds/analysis/01_ingest_clean.R
# Deterministic ingest/clean of CCCCO Data Mart exports (institution-level).
# Inputs (NOT committed):
#   - projects/01_retention_completion_ipeds/data/transfer_volume.csv
#   - projects/01_retention_completion_ipeds/data/enrollment.csv
# Outputs (can be committed selectively; default is not to):
#   - projects/01_retention_completion_ipeds/outputs/cccco_clean.rds
#   - projects/01_retention_completion_ipeds/outputs/cccco_clean.csv

suppressPackageStartupMessages({
  library(tidyverse)
  library(janitor)
  library(readr)
  library(stringr)
  library(tidyr)
})

project_dir <- "projects/01_retention_completion_ipeds"
data_dir <- file.path(project_dir, "data")
out_dir <- file.path(project_dir, "outputs")

if (!dir.exists(out_dir)) dir.create(out_dir, recursive = TRUE)

transfer_path <- file.path(data_dir, "transfer_volume.csv")
enroll_path   <- file.path(data_dir, "enrollment.csv")

if (!file.exists(transfer_path)) stop("Missing: ", transfer_path, call. = FALSE)
if (!file.exists(enroll_path))   stop("Missing: ", enroll_path, call. = FALSE)

to_num <- function(x) readr::parse_number(as.character(x))

# ---------------------------
# 1) TRANSFER VOLUME (TOTAL)
# ---------------------------
# Line 1: ,,2019-2020,2020-2021,...
transfer_lines <- readLines(transfer_path, warn = FALSE)
transfer_years <- str_split(transfer_lines[1], ",", simplify = TRUE) |>
  as.character() |>
  str_trim()

transfer_years <- transfer_years[transfer_years != ""]
if (length(transfer_years) < 3) {
  stop("Could not parse year headers from transfer_volume.csv line 1.", call. = FALSE)
}

transfer_colnames <- c("college_term", "transfer_category", transfer_years)

transfer_df <- readr::read_csv(
  transfer_path,
  skip = 1,                      # start at line 2
  col_names = transfer_colnames,
  show_col_types = FALSE
) |>
  mutate(
    college_term = na_if(college_term, ""),
    transfer_category = na_if(transfer_category, "")
  ) |>
  tidyr::fill(college_term, .direction = "down") |>
  mutate(
    college_name = str_remove(college_term, "\\s+Total$"),
    transfer_category = replace_na(transfer_category, "Total")
  ) |>
  filter(transfer_category == "Total") |>
  select(college_name, all_of(transfer_years)) |>
  pivot_longer(
    cols = all_of(transfer_years),
    names_to = "academic_year",
    values_to = "transfer_volume"
  ) |>
  mutate(
    academic_year = str_replace_all(academic_year, "-", "_"),
    transfer_volume = to_num(transfer_volume)
  )

# ---------------------------
# 2) ENROLLMENT (HEADCOUNT)
# ---------------------------
# Line 2 contains the academic years prefixed by "Annual ".
enroll_lines <- readLines(enroll_path, warn = FALSE)

enroll_years <- str_split(enroll_lines[2], ",", simplify = TRUE) |>
  as.character() |>
  str_trim()

enroll_years <- enroll_years[enroll_years != ""]
enroll_years <- str_remove(enroll_years, "^Annual\\s+")

if (length(enroll_years) < 3) {
  stop("Could not parse year headers from enrollment.csv line 2.", call. = FALSE)
}

enroll_raw <- readr::read_csv(
  enroll_path,
  skip = 2,                      # header row is line 3
  show_col_types = FALSE,
  name_repair = "minimal"
) |>
  janitor::clean_names()

# Expected: 1 + number of years columns
expected_cols <- 1 + length(enroll_years)
if (ncol(enroll_raw) < expected_cols) {
  stop(
    "Enrollment CSV has fewer columns than expected.\n",
    "Expected >= ", expected_cols, " but found ", ncol(enroll_raw),
    call. = FALSE
  )
}

# Rename deterministically: college_name + student_count_YYYY_YYYY
new_names <- c(
  "college_name",
  paste0("student_count_", str_replace_all(enroll_years, "-", "_"))
)
names(enroll_raw)[seq_along(new_names)] <- new_names

enrollment_df <- enroll_raw |>
  select(all_of(new_names)) |>
  pivot_longer(
    cols = starts_with("student_count_"),
    names_to = "academic_year",
    values_to = "enrollment_total"
  ) |>
  mutate(
    academic_year = str_remove(academic_year, "^student_count_"),
    enrollment_total = to_num(enrollment_total)
  )

# ---------------------------
# 3) MERGE + QA + OUTPUT
# ---------------------------
df <- transfer_df |>
  left_join(enrollment_df, by = c("college_name", "academic_year")) |>
  arrange(college_name, academic_year)

qa <- df |>
  summarise(
    n_rows = n(),
    n_colleges = n_distinct(college_name),
    missing_transfer = sum(is.na(transfer_volume)),
    missing_enrollment = sum(is.na(enrollment_total))
  )

print(qa)

saveRDS(df, file.path(out_dir, "cccco_clean.rds"))
readr::write_csv(df, file.path(out_dir, "cccco_clean.csv"))

message("Saved: ", file.path(out_dir, "cccco_clean.rds"))
