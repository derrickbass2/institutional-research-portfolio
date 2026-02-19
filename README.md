# Institutional Research Portfolio (APA 7 Compliant)

A reproducible institutional research portfolio built using publicly available postsecondary datasets (e.g., IPEDS, California Community Colleges Data Mart, and other state/system portals). All analyses are conducted in R with transparent statistical workflows and APA 7–formatted reporting.

This repository is designed to demonstrate applied institutional research competencies, including multivariate modeling, survey analysis, compliance-oriented reporting, reproducibility, and ethical data stewardship.

---

## Portfolio Purpose

This portfolio showcases:

- Institutional-level quantitative research using real, verifiable datasets (2019–present when available)
- Transparent data cleaning, validation, and assumption testing
- Regression modeling and diagnostic evaluation
- APA 7–formatted manuscripts with peer-reviewed citations
- Reproducible workflows using `renv` for package version control

All projects prioritize methodological rigor, interpretability, and institutional decision-support relevance.

---

## Repository Structure

```
institutional-research-portfolio/
│
├── projects/
│   └── retention-completion-cccs/
│       ├── analysis/
│       │   ├── requirements.R
│       │   └── analysis.R
│       ├── data_sources/
│       │   └── data_dictionary.md
│       └── paper/
│           ├── manuscript.md
│           └── references.bib
│
├── templates/
├── renv/
├── renv.lock
└── README.md
```

---

## Current Project

### 1. Institutional Characteristics and Student Success Outcomes
**Dataset:** California Community Colleges (2019–2023)
**Outcome Variable:** Fall-to-Fall Persistence
**Design:** Cross-sectional institutional-level regression modeling

**Primary Research Question:**
Which institutional-level characteristics are associated with variation in first-year retention rates across California community colleges?

**Predictors (Institution-Level):**
- Percentage of Pell recipients
- Enrollment size
- Percentage of part-time students
- Student-faculty ratio
- Full-time equivalent faculty
- Expenditures per FTE (if available)

Models include assumption testing (normality, homoscedasticity, multicollinearity), diagnostic evaluation, and transparent limitations.

---

## Reproducibility

This repository uses `renv` for environment management.

To reproduce analyses locally:

```bash
R
renv::restore()
```

Each project includes:

- `analysis/requirements.R` — package dependencies
- `analysis/analysis.R` — full workflow script
- `paper/manuscript.md` — APA 7 manuscript draft
- `paper/references.bib` — peer-reviewed references

---

## Data Policy

Raw datasets are **not stored** in this repository.

Each project provides:

- Official data source links
- Download instructions
- Data dictionaries
- Variable construction documentation

All datasets used are publicly available and verifiable.

---

## Methodological Standards

All analyses adhere to:

- APA 7th edition reporting standards
- Transparent statistical reporting (effect sizes, diagnostics, assumptions)
- Ethical data stewardship principles
- Peer-reviewed theoretical grounding where applicable

---

## Licensing

- **Code:** MIT License (see `LICENSE`)
- **Written Materials (papers, figures, documentation):** CC BY 4.0 (see `LICENSE-DOCS`)

---

## Contact

Derrick Bass
derrick.bass2@gmail.com
LinkedIn: linkedin.com/in/derrickbass2
