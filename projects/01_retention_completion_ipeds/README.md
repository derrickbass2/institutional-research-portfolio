# Retention & Completion Analysis (IPEDS, 2019–2023)

## Project Purpose

This project examines institutional-level variation in first-year retention and completion outcomes across U.S. postsecondary institutions using Integrated Postsecondary Education Data System (IPEDS) data from 2019–2023.

The objective is to evaluate which institutional characteristics are associated with variation in retention and completion metrics while maintaining a transparent, reproducible institutional research workflow.

---

## Research Question

Which institutional characteristics are associated with retention and completion outcomes in U.S. postsecondary education (IPEDS, 2019–2023)?

Sub-questions include:

- How stable are retention and completion outcomes across institutions over time?
- Do institutional size, control, or sector characteristics explain variation in outcomes?
- Are there institutions whose performance deviates meaningfully from model expectations?

---

## Data Source

**Primary Source:** Integrated Postsecondary Education Data System (IPEDS), National Center for Education Statistics (NCES)

Years included:

- 2019
- 2020
- 2021
- 2022
- 2023

Data were obtained via public IPEDS downloads. Raw files are not committed to this repository. Source links are documented in:

`data_sources/dataset_links.md`

---

## Data Preparation

Data preparation includes:

- Deterministic merging of IPEDS component files
- Standardization of institutional identifiers
- Numeric coercion and validation
- Explicit handling of suppressed or missing values
- Construction of institution-level analytic dataset

All transformation steps are script-based and reproducible.

Primary ingest script:

`analysis/analysis.R`

---

## Statistical Approach

Planned primary model:

- Institution-level multiple linear regression
  - Outcomes: Retention rate and/or completion rate
  - Predictors: Institutional characteristics (size, sector, control, etc.)
  - Unit of analysis: Institution-Year

Diagnostics include:

- Residual distribution checks
- Leverage and influence statistics
- Variance inflation factor (VIF) assessment
- Sensitivity analyses

No imputation will be applied without explicit justification.

---

## Reproducibility

1. Install required packages:
   `source("analysis/requirements.R")`

2. Run full analysis:
   `source("analysis/analysis.R")`

All outputs are generated locally and saved to:

`outputs/`

Raw data and derived outputs are excluded via `.gitignore` to maintain repository integrity.

---

## Status

✔ Project structure complete
✔ Data acquisition complete
⬜ Final regression modeling
⬜ Diagnostic review
⬜ Interpretation and reporting

---

**Author:** Derrick Bass
Ph.D. Candidate, Industrial-Organizational Psychology
Institutional Research & Applied Quantitative Methods
