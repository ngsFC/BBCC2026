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

# --- Fix a known repo2docker/RStudio-on-Binder bug ---
# The RStudio Server .deb package writes /etc/rstudio/rserver.conf with
# `www-user=rstudio-server`. Binder containers run everything as the
# unprivileged notebook user (jovyan), which cannot switch to that system
# account, causing rserver to fail at launch with:
#   "Attempt to run server as user 'rstudio-server' ... without privilege"
# install.R still runs as root at this point in the R buildpack (before the
# Dockerfile switches to the unprivileged user), so this is the one place in
# this repository where /etc/rstudio/rserver.conf can be corrected.
rserver_conf <- "/etc/rstudio/rserver.conf"
if (file.exists(rserver_conf)) {
  conf_lines <- readLines(rserver_conf)
  conf_lines <- conf_lines[!grepl("^www-user=", conf_lines)]
  nb_user <- Sys.getenv("NB_USER", unset = "jovyan")
  conf_lines <- c(conf_lines, paste0("www-user=", nb_user))
  writeLines(conf_lines, rserver_conf)
}
