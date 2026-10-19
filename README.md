# BBCC2026 — From Biobanking Metadata to Clinically Meaningful Biomarkers

[![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/ngsFC/BBCC2026/HEAD?urlpath=rstudio)

> A hands-on introduction to organizing biological/clinical data and turning it into clinically meaningful findings. Starting from biobanking metadata, participants follow a real pediatric cancer dataset (TARGET-WT, Wilms tumor) through expression analysis to candidate biomarkers, then infer and compare gene regulatory networks between histology subgroups checking along the way whether any candidate is actually druggable.

**Authors:** Francesco Cecere (Senior Bioinformatic Researcher) · Eva Luna Tarallo (Junior Bioinformatic Researcher) · AORN Santobono-Pausilipon IRCCS

The conference program in detail can be looked at https://www.bbcc-meetings.it/bbcc2026/.

## Workshop Schedule (21st October 9:00am to 1:00 pm)

| Time | Block | Duration |
|------|-------|----------|
| 9:00 - 9:30   | Workshop presentation !
| 9:30 – 10:30  | Module 0 — Metadata & Biobanking
| 10:30 – 10:45 | Break and Q&A
| 10:45 – 11:15 | Module 1 — Exploratory Analysis & QC
| 11:15 – 11:25 | Break and Q&A
| 11:25 – 12:00 | Module 2 — Diffenretially Expression Analysis
| 12:00 – 12:10 | Break and Q&A
| 12:10 – 12:45 | Module 3 — Gene Regulatory Networks
| 12:45 – 1:00  | Wrap-up

## Data

- **Source**: **TARGET-WT** (Wilms tumor), NCI TARGET program via the [GDC Data Portal](https://portal.gdc.cancer.gov/projects/TARGET-WT) — real RNA-seq (TPM), open-access.
- `data/TARGET_WT_gene_expression_tpm.csv` / `TARGET_WT_clinical_raw.csv` — 19,938 genes × 124 tumor samples (82 Favorable / 42 Unfavorable) + real clinical sheet.
- `data/TARGET_WT_control_gene_expression_tpm.csv` / `TARGET_WT_control_clinical_raw.csv` — the same 19,938 genes × the only 6 real matched-normal samples that exist for this project (negative control, Module 2).
- `data/human_transcription_factors_Lambert2018.txt` — 1,639 curated human TFs (Lambert et al., *Cell* 2018), restricts Module 3's network regulators to real TFs.
- All built once by `data-prep/build_target_wt_data.R` (not run by the tutorial — included for audit/rebuild). `data/sample_metadata.csv` is Module 0's output; `results/` is Modules 2–3's output.

## Environment

Built by [repo2docker](https://repo2docker.readthedocs.io/) from `.binder/Dockerfile` (`FROM rocker/binder:4.4.1`), installing `tidyverse`, `plotly`, `DT`, `igraph`, `visNetwork`, `knitr`, `scales`, `rmarkdown`, `pheatmap`, `ggrepel`, `UpSetR`, `ggpubr`, `httr`, plus Bioconductor's `limma` and `GENIE3`.

Module 3 makes one live network call (to [DGIdb](https://dgidb.org), checking drug-gene interactions) that needs normal outbound internet, which a standard Binder session has.
