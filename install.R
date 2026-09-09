# Packages required across all four tutorial modules.
# repo2docker (used by mybinder.org) installs these automatically at build
# time using the CRAN snapshot pinned in runtime.txt, so every launch gets
# the exact same package versions.
install.packages(c(
  "tidyverse",  # dplyr, ggplot2, tidyr, readr, purrr, tibble, stringr, forcats
  "broom",      # tidy() for converting t.test() output into tidy tibbles (Module 2)
  "plotly",     # interactive versions of all ggplot2 figures
  "DT",         # interactive, downloadable HTML tables
  "knitr",      # kable() for simple inline tables, and Rmd rendering engine
  "scales",     # axis label formatting (e.g. comma-separated counts)
  "rmarkdown"   # knits the .Rmd modules to .html
))
