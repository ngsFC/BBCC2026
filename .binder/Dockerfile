FROM rocker/binder:4.4.1
LABEL maintainer='Francesco Cecere'
COPY --chown=${NB_USER} . ${HOME}
USER ${NB_USER}

RUN R -e "options(repos = list(CRAN = 'https://cloud.r-project.org')); \
          install.packages(c('tidyverse', 'plotly', 'DT', 'igraph', 'visNetwork', 'BiocManager', 'knitr', 'scales', 'rmarkdown', 'pheatmap', 'ggrepel', 'UpSetR')); \
          BiocManager::install(c('limma', 'GENIE3'), update = FALSE, ask = FALSE)"
