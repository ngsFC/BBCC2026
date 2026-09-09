FROM rocker/binder:4.4.1
LABEL maintainer='Francesco Cecere'
COPY --chown=${NB_USER} . ${HOME}
USER ${NB_USER}

RUN R -e "options(repos = list(CRAN = 'https://cloud.r-project.org')); \
          install.packages(c('tidyverse', 'broom', 'plotly', 'DT', 'knitr', 'scales', 'rmarkdown'))"
