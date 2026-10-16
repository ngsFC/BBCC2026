# BBCC2026 — From Biobanking Metadata to Clinically Meaningful Biomarkers

[![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/ngsFC/BBCC2026/HEAD?urlpath=rstudio)

> This tutorial offers a hands-on introduction to how biological and clinical data are organized, analyzed, and turned into clinically meaningful findings. Starting from the organization of metadata and biobanking, participants follow a real pediatric cancer dataset (TARGET-WT, Wilms tumor) through an expression analysis to identify candidate biomarkers, then infer and compare gene regulatory networks between two real clinical histology subgroups. Each module is connected back to rare disease and cancer biology from a pediatric point of view, highlighting what makes them challenging to analyze.



## Launching the Tutorial

Click the **Binder badge** above. It builds a container from this repository (via `.binder/Dockerfile`) and opens **RStudio Server** directly in your browser — no local R installation needed. From RStudio, open any of the four `.Rmd` files and click **Knit** to run it top to bottom.

The first launch can take several minutes while the environment is built; subsequent launches from the same commit are much faster thanks to Binder's build cache.

## Workshop Schedule (beginner-friendly, 4h00 including breaks)

This tutorial is designed to be run live as a **4-hour workshop for R/bioinformatics beginners** (no prior experience with differential expression or survival analysis assumed). Each module is self-paced on Binder, but the timings below are what a facilitator should expect when running it as a group session, breaks included. Each `.Rmd` also carries its own **Session plan** line and a facilitator time-budget note at the end of each Part, so a facilitator can see at a glance whether the group is on pace.

| Time | Block | Duration |
|------|-------|----------|
| 0:00 – 0:50 | Module 0 — Metadata & Biobanking | 50 min |
| 0:50 – 1:00 | Break | 10 min |
| 1:00 – 1:35 | Module 1 — Exploratory Analysis & QC | 35 min |
| 1:35 – 1:45 | Break | 10 min |
| 1:45 – 2:45 | Module 2 — Expression Analysis & Biomarker Discovery | 60 min |
| 2:45 – 2:55 | Break | 10 min |
| 2:55 – 3:50 | Module 3 — Gene Regulatory Networks | 55 min |
| 3:50 – 4:00 | Wrap-up & Q&A | 10 min |

## Modules

Run the modules **in order** the first time — each one reads a file produced by the previous one, which is itself part of the lesson (a reproducible pipeline leaves traceable intermediate artifacts instead of hidden in-memory state).

| # | File | Title | What it covers |
|---|------|-------|-----------------|
| 0 | `00_metadata_and_biobanking.Rmd` | From Raw Files to a Biobank-Grade Sample Sheet | Loading and verifying the real TARGET-WT expression matrix, joining it to a real GDC clinical sheet by case ID (with the join explicitly verified), parsing the real TARGET barcode structure, and discussing biobanking principles for rare pediatric cohorts. |
| 1 | `01_exploratory_qc.Rmd` | Exploratory Analysis and Quality Control | TPM-sum sanity checks, expression distributions, PCA, and sample-sample correlation — checking whether the data can be trusted before testing anything. |
| 2 | `02_differential_expression_biomarkers.Rmd` | Expression Analysis and Candidate Biomarker Discovery | Gene filtering and per-gene statistical testing: favorable vs. unfavorable/anaplastic histology, plus — using 6 real matched-normal samples as a negative control — favorable vs. control and unfavorable vs. control, each with a volcano/heatmap or ranked table. |
| 3 | `03_gene_regulatory_networks.Rmd` | From Biomarkers to Gene Regulatory Networks | Infers a gene regulatory network (GENIE3 + igraph + visNetwork) for Favorable, Unfavorable, **and** a 6-sample control baseline, over a shared panel built from Module 2's vs-control candidate genes, then compares top-edge overlap and hub genes of each tumor network against the control baseline (an explicit, flagged-as-unreliable-at-n=6 third network) — everything in this module is real data, nothing simulated. |

Each module knits to a self-contained, interactive `.html` report (downloadable tables, interactive plots). Pre-rendered copies are committed under `html/` so the finished reports can be browsed without running anything — open any file in `html/` directly in a browser. These are a snapshot from the last render: if you edit an `.Rmd` and re-knit, regenerate the matching file in `html/` the same way (see below) so the two stay in sync.

## Data

- **Source**: **TARGET-WT** (Wilms tumor), from the NCI's TARGET program via the [GDC Data Portal](https://portal.gdc.cancer.gov/projects/TARGET-WT) — real RNA-seq (GDC's STAR-Counts pipeline, TPM-normalized), open-access tier (no login required).
- `data/TARGET_WT_gene_expression_tpm.csv` — 19,938 protein-coding genes x 124 **tumor** samples (82 **Favorable** / 42 **Unfavorable**/anaplastic histology), from the Children's Oncology Group's NWTS-5 trial.
- `data/TARGET_WT_clinical_raw.csv` — the real clinical/demographic sheet for those 124 tumor samples (histologic subtype, age at diagnosis, sex, vital status, race, ethnicity).
- `data/TARGET_WT_control_gene_expression_tpm.csv` / `data/TARGET_WT_control_clinical_raw.csv` — 19,938 genes x **6 real matched-normal ("Solid Tissue Normal") samples**, used in Module 2 as a negative control. This is the entire open-access normal-tissue pool for TARGET-WT (no more exist), and all 6 happen to come from Favorable-histology patients, which is itself discussed in Module 2.
- All four files were assembled once by `data-prep/build_target_wt_data.R` (manifest query → download each sample's gene-count file → parse `gene_name`/`tpm_unstranded` → join into one matrix) rather than downloaded live during the workshop, so Binder sessions need no GDC-specific setup. That script is not run by the tutorial itself — it is included only so the data can be audited or rebuilt from scratch. `data/sample_metadata.csv` (the join of the two tumor-sample files above, verified) is generated by Module 0; everything under `results/` is generated by Modules 2 and 3 — both are included so later modules can also be explored on their own without re-running earlier ones.

## Repository Structure

```
.
├── 00_metadata_and_biobanking.Rmd
├── 01_exploratory_qc.Rmd
├── 02_differential_expression_biomarkers.Rmd
├── 03_gene_regulatory_networks.Rmd
├── data/
│   ├── TARGET_WT_gene_expression_tpm.csv             # raw input: real TPM expression matrix, 124 tumor samples
│   ├── TARGET_WT_clinical_raw.csv                    # raw input: real GDC clinical sheet, 124 tumor samples
│   ├── TARGET_WT_control_gene_expression_tpm.csv     # raw input: real TPM matrix, 6 matched-normal samples
│   ├── TARGET_WT_control_clinical_raw.csv            # raw input: real GDC clinical sheet, 6 matched-normal samples
│   └── sample_metadata.csv                           # produced by Module 0 (verified join of the two tumor-sample files above)
├── results/
│   ├── differential_expression_results.csv                      # produced by Module 2 (Favorable vs Unfavorable)
│   ├── differential_expression_favorable_vs_control.csv          # produced by Module 2
│   ├── differential_expression_unfavorable_vs_control.csv        # produced by Module 2
│   ├── gene_network_favorable_edges.csv              # produced by Module 3
│   ├── gene_network_unfavorable_edges.csv            # produced by Module 3
│   ├── gene_network_control_edges.csv                # produced by Module 3 (6-sample baseline network)
│   └── gene_network_hub_comparison.csv               # produced by Module 3
├── html/
│   ├── 00_metadata_and_biobanking.html                        # pre-rendered Module 0
│   ├── 01_exploratory_qc.html                                 # pre-rendered Module 1
│   ├── 02_differential_expression_biomarkers.html             # pre-rendered Module 2
│   └── 03_gene_regulatory_networks.html                              # pre-rendered Module 3
├── data-prep/
│   └── build_target_wt_data.R                        # one-off script that built data/TARGET_WT_*.csv (not run by the tutorial)
├── .binder/
│   └── Dockerfile     # defines the Binder build environment (see below)
└── README.md
```

### Regenerating `html/`

Knitting each `.Rmd` with RStudio's **Knit** button (or `rmarkdown::render("00_metadata_and_biobanking.Rmd")`) writes the HTML next to the `.Rmd`, not into `html/`. To regenerate the committed copies in place, from the repository root:

```r
for (f in c("00_metadata_and_biobanking", "01_exploratory_qc",
            "02_differential_expression_biomarkers", "03_gene_regulatory_networks")) {
  rmarkdown::render(paste0(f, ".Rmd"), output_dir = "html")
}
```

Modules must be rendered **in order** (0 → 1 → 2 → 3) the first time, since each reads a file the previous one writes (see "Modules" above).

## Environment

This repository is built by [repo2docker](https://repo2docker.readthedocs.io/) (the engine behind mybinder.org) from `.binder/Dockerfile`, which starts `FROM rocker/binder:4.4.1` — a base image that already ships RStudio Server correctly configured for Binder's unprivileged container user — and installs the packages required across all four modules (`tidyverse`, `broom`, `plotly`, `DT`, `crosstalk`, `igraph`, `visNetwork`, `knitr`, `scales`, `rmarkdown`, plus the Bioconductor package `GENIE3` via `BiocManager`) on top of it.

An earlier version of this repository used repo2docker's own `runtime.txt` / `install.R` R-buildpack convention instead. That path builds RStudio Server through a different mechanism than `rocker/binder`, and on the current mybinder.org infrastructure it produced a broken `/etc/rstudio/rserver.conf` (`www-user=rstudio-server`), which the unprivileged `jovyan` container user has no permission to satisfy — causing every launch to fail with "could not start rstudio in time" / `Attempt to run server as user 'rstudio-server' ... without privilege`. Building from `rocker/binder` directly sidesteps that broken code path entirely, since RStudio is already correctly configured in the base image before this repository's own build steps ever run.
