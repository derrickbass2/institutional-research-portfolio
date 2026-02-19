# Retention & Completion (IPEDS, 2019–2023)

## Research question
Which institutional characteristics are associated with retention and completion outcomes in U.S. postsecondary education (IPEDS, 2019–2023)?

## Data source
- Source: IPEDS (NCES)
- Years: 2019–2023 (to be finalized based on downloaded extracts)
- Access: Public downloads (links documented in /data_sources/dataset_links.md)
- Note: Raw datasets are not committed to this repo.

## Methods (planned)
- Multiple linear regression (institution-level)
- Diagnostics: residual checks, leverage, VIF
- Transparent limitations and sensitivity checks

## Reproducibility
1. Install packages: `source("analysis/requirements.R")`
2. Run analysis: `source("analysis/analysis.R")`

## Outputs
Generated figures/tables will be saved to `outputs/`.
