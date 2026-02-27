# projects/01_retention_completion_ipeds/analysis/02_model_transfer_enrollment.R
# Purpose: Model institutional transfer volume as a function of enrollment size
# Data: CCCCO Data Mart exports (2019–2020 through 2023–2024), cleaned in 01_ingest_clean.R
# Outputs: tables + figures saved to projects/01_retention_completion_ipeds/outputs/

suppressPackageStartupMessages({
    library(dplyr)
    library(readr)
    library(ggplot2)
    library(broom)
    library(car)
    library(lmtest)
    library(sandwich)
    library(tibble)
})

# ---- Helper: robust coeftest -> tidy df (HC3) ----
robust_coefs_hc3 <- function(model) {
    ct <- lmtest::coeftest(model, vcov. = sandwich::vcovHC(model, type = "HC3"))

    # Ensure we have a plain matrix with the expected 4 columns.
    ct_mat <- as.matrix(ct)
    if (ncol(ct_mat) < 4) {
        stop(
            "Unexpected coeftest() structure: expected >= 4 columns, got ",
            ncol(ct_mat)
        )
    }

    out <- data.frame(
        term = rownames(ct_mat),
        estimate = ct_mat[, 1],
        std_error_hc3 = ct_mat[, 2],
        stat_value = ct_mat[, 3],
        p_value = ct_mat[, 4],
        row.names = NULL,
        stringsAsFactors = FALSE
    )

    # Coerce to numeric in case matrix columns come through as character.
    out$estimate <- as.numeric(out$estimate)
    out$std_error_hc3 <- as.numeric(out$std_error_hc3)
    out$stat_value <- as.numeric(out$stat_value)
    out$p_value <- as.numeric(out$p_value)

    out
}

out_dir <- "projects/01_retention_completion_ipeds/outputs"
dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)

data_path <- file.path(out_dir, "cccco_clean.rds")
stopifnot(file.exists(data_path))

d <- readRDS(data_path)

# ---- Audit / missingness summary (saved as a table) ----
audit <- d %>%
    summarise(
        n_rows = n(),
        n_colleges = n_distinct(college_name),
        years = n_distinct(academic_year),
        missing_enrollment = sum(is.na(enrollment_total)),
        missing_transfer = sum(is.na(transfer_volume))
    )

write_csv(audit, file.path(out_dir, "audit_summary.csv"))

missing_by_year <- d %>%
    group_by(academic_year) %>%
    summarise(
        n = n(),
        miss_enroll = sum(is.na(enrollment_total)),
        miss_transfer = sum(is.na(transfer_volume)),
        .groups = "drop"
    )

write_csv(missing_by_year, file.path(out_dir, "missingness_by_year.csv"))

# ---- Analysis dataset (complete cases for primary model) ----
df <- d %>%
    filter(!is.na(enrollment_total), !is.na(transfer_volume)) %>%
    mutate(
        log_enrollment = log(enrollment_total),
        log_transfer = log(transfer_volume)
    )

write_csv(df, file.path(out_dir, "analysis_dataset_complete_cases.csv"))

# ---- Model 1: levels (transfer volume ~ enrollment) ----
m1 <- lm(transfer_volume ~ enrollment_total, data = df)

# Robust SE (HC3) — standard in applied reporting contexts when heteroskedasticity is plausible
m1_robust <- robust_coefs_hc3(m1)

write_csv(broom::tidy(m1), file.path(out_dir, "model1_tidy.csv"))
write_csv(m1_robust, file.path(out_dir, "model1_robust_hc3.csv"))

# ---- Model 2: log-log (elasticity interpretation) ----
# Interpretation: % change in transfers associated with 1% change in enrollment
m2 <- lm(log_transfer ~ log_enrollment, data = df)
m2_robust <- robust_coefs_hc3(m2)

write_csv(broom::tidy(m2), file.path(out_dir, "model2_loglog_tidy.csv"))
write_csv(m2_robust, file.path(out_dir, "model2_loglog_robust_hc3.csv"))

# ---- Diagnostics + figures ----
# Scatter (levels)
p1 <- ggplot(df, aes(x = enrollment_total, y = transfer_volume)) +
    geom_point(alpha = 0.6) +
    geom_smooth(method = "lm", se = TRUE) +
    labs(
        title = "Transfer Volume vs Enrollment (Levels)",
        x = "Annual Headcount Enrollment (Total)",
        y = "Annual Transfer Volume (Total)"
    )

ggsave(
    filename = file.path(out_dir, "fig_transfer_vs_enrollment_levels.png"),
    plot = p1, width = 8, height = 5, dpi = 300
)

# Scatter (log-log)
p2 <- ggplot(df, aes(x = log_enrollment, y = log_transfer)) +
    geom_point(alpha = 0.6) +
    geom_smooth(method = "lm", se = TRUE) +
    labs(
        title = "Transfer Volume vs Enrollment (Log–Log)",
        x = "log(Enrollment)",
        y = "log(Transfer Volume)"
    )

ggsave(
    filename = file.path(out_dir, "fig_transfer_vs_enrollment_loglog.png"),
    plot = p2, width = 8, height = 5, dpi = 300
)

# Base R diagnostic plots for m2 (log-log is usually the more interpretable)
png(filename = file.path(out_dir, "diag_model2_loglog.png"), width = 1400, height = 1400, res = 200)
par(mfrow = c(2, 2))
plot(m2)
dev.off()

# ---- Executive text summary (printed + saved) ----
n_used <- nrow(df)
yrs <- sort(unique(df$academic_year))
colleges_used <- n_distinct(df$college_name)

summary_lines <- c(
    sprintf("CCCO Clean Dataset: %s colleges, %s years (%s to %s).", colleges_used, length(yrs), yrs[1], yrs[length(yrs)]),
    sprintf("Primary model sample (complete cases): n = %s institution-years.", n_used),
    "Model 1: transfer_volume ~ enrollment_total (with HC3 robust SE saved).",
    "Model 2: log(transfer_volume) ~ log(enrollment_total) (elasticity form; HC3 robust SE saved).",
    sprintf("Outputs written to: %s", out_dir)
)

writeLines(summary_lines, con = file.path(out_dir, "executive_run_summary.txt"))
message(paste(summary_lines, collapse = "\n"))
