# Builds data/TARGET_WT_gene_expression_tpm.csv and data/TARGET_WT_clinical_raw.csv
# from the public GDC Data Portal (https://portal.gdc.cancer.gov/projects/TARGET-WT).
#
# This script is NOT run during the workshop -- it was run once to produce the
# two files already committed under data/, so that Binder sessions need no
# live GDC download. It is included here purely for transparency and so the
# data can be reproduced or refreshed from scratch if needed.
#
# Requires: tidyverse, httr, jsonlite (not needed to run the tutorial itself).

library(tidyverse)
library(httr)
library(jsonlite)

raw_dir <- "data-prep/raw_downloads"
dir.create(raw_dir, showWarnings = FALSE, recursive = TRUE)

# ---- 1. Query the GDC API for every open-access RNA-Seq gene-count file ----
# for primary tumor samples in TARGET-WT, plus the clinical/demographic
# fields needed for the sample sheet.
filters <- list(
  op = "and",
  content = list(
    list(op = "=", content = list(field = "cases.project.project_id", value = "TARGET-WT")),
    list(op = "=", content = list(field = "files.experimental_strategy", value = "RNA-Seq")),
    list(op = "=", content = list(field = "files.access", value = "open")),
    list(op = "=", content = list(field = "files.data_type", value = "Gene Expression Quantification")),
    list(op = "=", content = list(field = "cases.samples.sample_type", value = "Primary Tumor"))
  )
)
fields <- paste(c(
  "file_id",
  "cases.submitter_id",
  "cases.diagnoses.wilms_tumor_histologic_subtype",
  "cases.diagnoses.age_at_diagnosis",
  "cases.demographic.sex_at_birth",
  "cases.demographic.vital_status",
  "cases.demographic.race",
  "cases.demographic.ethnicity"
), collapse = ",")

resp <- GET(
  "https://api.gdc.cancer.gov/files",
  query = list(filters = toJSON(filters, auto_unbox = TRUE), fields = fields, size = 200, format = "JSON")
)
hits <- fromJSON(content(resp, as = "text", encoding = "UTF-8"), simplifyVector = FALSE)$data$hits
cat("Files in manifest:", length(hits), "\n")

manifest <- map_dfr(hits, function(h) {
  cs <- h$cases[[1]]
  dx <- cs$diagnoses[[1]]
  dem <- cs$demographic
  tibble(
    file_id               = h$file_id,
    case_submitter_id     = cs$submitter_id,
    histologic_subtype    = dx$wilms_tumor_histologic_subtype %||% NA_character_,
    age_at_diagnosis_days = as.numeric(dx$age_at_diagnosis %||% NA),
    sex_at_birth          = dem$sex_at_birth %||% NA_character_,
    vital_status          = dem$vital_status %||% NA_character_,
    race                  = dem$race %||% NA_character_,
    ethnicity             = dem$ethnicity %||% NA_character_
  )
})
cat("Manifest rows:", nrow(manifest), "\n")
cat("Histology counts:\n"); print(count(manifest, histologic_subtype))

# ---- 2. Download each gene-count TSV (skip if already present) ----
for (i in seq_len(nrow(manifest))) {
  fid <- manifest$file_id[i]
  dest <- file.path(raw_dir, paste0(fid, ".tsv"))
  if (file.exists(dest) && file.size(dest) > 1e6) next
  tryCatch(
    download.file(paste0("https://api.gdc.cancer.gov/data/", fid), dest, quiet = TRUE, mode = "wb"),
    error = function(e) cat("FAILED:", fid, "-- retry manually\n")
  )
  if (i %% 10 == 0) cat("Downloaded", i, "/", nrow(manifest), "\n")
}

# ---- 3. Parse each file: gene_name + TPM, protein-coding genes only ----
# GDC's STAR-Counts "augmented" format has a comment line, then a header,
# then 4 non-gene QC rows (N_unmapped etc.) before the real gene rows.
parse_one <- function(file_id, case_id) {
  path <- file.path(raw_dir, paste0(file_id, ".tsv"))
  read_tsv(path, skip = 1, show_col_types = FALSE) %>%
    filter(
      !gene_id %in% c("N_unmapped", "N_multimapping", "N_noFeature", "N_ambiguous"),
      gene_type == "protein_coding"
    ) %>%
    select(gene_name, tpm_unstranded) %>%
    group_by(gene_name) %>%
    summarise(tpm_unstranded = sum(tpm_unstranded), .groups = "drop") %>%
    rename(!!case_id := tpm_unstranded)
}

cat("Parsing", nrow(manifest), "files...\n")
parsed_list <- map2(manifest$file_id, manifest$case_submitter_id, parse_one)
expr_matrix <- reduce(parsed_list, full_join, by = "gene_name")

cat("Final matrix:", nrow(expr_matrix), "genes x", ncol(expr_matrix) - 1, "samples\n")
cat("Any NA after join (should be 0):", sum(is.na(expr_matrix)), "\n")
cat("Any duplicated gene_name (should be 0):", sum(duplicated(expr_matrix$gene_name)), "\n")

# ---- 4. Write the two files the tutorial actually reads from data/ ----
dir.create("data", showWarnings = FALSE)
write_csv(expr_matrix, "data/TARGET_WT_gene_expression_tpm.csv")
write_csv(manifest %>% select(-file_id), "data/TARGET_WT_clinical_raw.csv")
cat("Wrote data/TARGET_WT_gene_expression_tpm.csv and data/TARGET_WT_clinical_raw.csv\n")
