# Data Dictionary

**Project:** Institutional Characteristics and Student Success Outcomes in California Community Colleges (2019–2024)

---

## Executive Technical Summary

This dataset supports institutional-level panel analysis of transfer outcomes across California Community Colleges from 2019–2024. The analytic design uses institution-year observations to evaluate structural variation in student transfer volume while accounting for institutional scale. All ingestion, cleaning, and transformation procedures are fully scripted in R using `renv` for computational reproducibility. Deterministic joins, explicit missingness diagnostics, and version-controlled workflows ensure auditability. No manual edits or post-hoc manipulation were applied to the analytic dataset. The project is structured to align with institutional research standards for transparency, governance, and methodological accountability.

---

## Project Context and Analytical Framing

The dataset is designed for institutional effectiveness analysis using a longitudinal (panel) structure. Institution-year observations allow evaluation of temporal variation in outcomes while preserving cross-institutional comparability. This structure reflects standard higher education institutional research practice, where aggregated institutional metrics are examined to inform strategic planning, accountability reporting, and student success evaluation.

This document serves as the formal technical specification of the dataset. Broader theoretical framing and scholarly context are documented separately in the project README.

---

## Dataset Structure

**Unit of Analysis:** Institution-year
**Population:** All California Community Colleges reporting to the California Community Colleges Chancellor’s Office (CCCCO) Data Mart
**Time Frame:** Academic years 2019–2020 through 2023–2024
**Data Structure:** Long-format panel dataset

Each row represents one institution observed in a single academic year.

---

## Core Identifiers

### college_name

**Definition:** Official institutional name as reported by CCCCO
**Source:** CCCCO Data Mart
**Data Type:** Character
**Measurement Level:** Nominal
**Analytic Role:** Institutional identifier used for deterministic dataset merging and grouped summaries

**Data Integrity Note:** Institutional naming conventions were harmonized prior to merging to ensure one-to-one alignment across enrollment and transfer source files.

---

### academic_year

**Definition:** Academic year formatted as YYYY_YYYY (e.g., 2019_2020)
**Source:** Derived during ingestion and standardization
**Data Type:** Character
**Measurement Level:** Nominal (temporal categorical)
**Analytic Role:** Time identifier for longitudinal alignment

**Data Integrity Note:** Academic year formatting was standardized to ensure reproducibility of year-level aggregation.

---

## Outcome Variable

### transfer_volume

**Definition:** Total number of students transferring from a California Community College to a four-year institution within the academic year
**Source:** CCCCO Data Mart
**Data Type:** Numeric (integer)
**Measurement Level:** Ratio
**Unit:** Annual count
**Analytic Role:** Primary dependent variable in institutional-level regression modeling

Transfer counts represent annual totals and were not rescaled in the base cleaned dataset.

---

## Institutional Scale Variable

### enrollment_total

**Definition:** Total unduplicated annual headcount enrollment
**Source:** CCCCO Data Mart
**Data Type:** Numeric (integer)
**Measurement Level:** Ratio
**Unit:** Annual count
**Analytic Role:** Institutional size control variable

Enrollment totals capture institutional scale and account for structural size differences across colleges.

---

## Variable Transformations (Modeling Specification)

Transformations are applied within analytic scripts and are not stored in the base dataset to preserve raw-data transparency. Potential modeling specifications include:

- Log transformation of enrollment_total to reduce right-skew and stabilize variance
- Rate-based specification (transfer_volume / enrollment_total) for proportional outcome modeling
- Standardization (z-scoring) of predictors for comparative effect magnitude interpretation

All transformation steps are explicitly documented in the analysis scripts to ensure traceability.

---

## Reproducibility Statement

All data ingestion, cleaning, transformation, and analytic procedures are executed through scripted R workflows located in the `analysis/` directory. The project employs:

- `renv` for dependency management and computational environment reproducibility
- Deterministic joins for dataset merging
- Explicit missingness diagnostics prior to model specification
- Version-controlled scripts to ensure analytical traceability

The finalized cleaned dataset (`cccco_clean.rds`) is generated programmatically from raw CSV inputs and stored in the `outputs/` directory. No manual edits are applied post-generation. Re-executing the ingestion script with identical raw inputs produces an identical analytic dataset.

---

## Data Governance and Integrity

- All variables are aggregated at the institutional level
- Institutional identifiers were harmonized prior to merging
- Academic year formats were standardized during ingestion
- Missing values were quantified before model specification
- No imputation procedures were applied in the base analytic dataset
- The dataset is structured to support institutional research transparency, replicability, and reporting standards

---

## Interview Walkthrough Script (2–3 Minutes)

This project examines institutional-level variation in student transfer outcomes across California Community Colleges using a five-year panel design from 2019 to 2024.

The unit of analysis is institution-year, meaning each row represents one college observed in a single academic year. This structure allows for longitudinal analysis while maintaining cross-institutional comparability, which is consistent with institutional research practice.

The primary outcome variable is annual transfer volume. To contextualize outcome variation, I include total unduplicated headcount enrollment as a structural scale control. Because institutional size distributions are typically right-skewed, modeling specifications may include a log transformation of enrollment to stabilize variance.

All data ingestion and cleaning are fully scripted in R using a renv-managed environment to ensure computational reproducibility. Dataset merging uses deterministic joins, and missingness diagnostics are conducted prior to modeling. The cleaned dataset is generated programmatically and stored as an RDS file with no manual edits.

The project demonstrates institutional-level modeling logic, governance awareness, and reproducible analytical workflow design consistent with higher education institutional research standards.
