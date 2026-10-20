FROM rocker/binder:4.4.1
LABEL maintainer='Francesco Cecere'
COPY --chown=${NB_USER} . ${HOME}
USER ${NB_USER}

RUN R -e "options(repos = list(CRAN = 'https://packagemanager.posit.co/cran/__linux__/jammy/latest')); \
          pkgs <- c('tidyverse', 'plotly', 'DT', 'igraph', 'visNetwork', 'BiocManager', 'knitr', 'scales', 'rmarkdown', 'pheatmap', 'ggrepel', 'UpSetR', 'ggpubr', 'httr'); \
          install.packages(pkgs); \
          missing <- pkgs[!sapply(pkgs, requireNamespace, quietly = TRUE)]; \
          if (length(missing) > 0) stop('Failed to install: ', paste(missing, collapse = ', ')); \
          BiocManager::install(c('limma', 'GENIE3'), update = FALSE, ask = FALSE)"
