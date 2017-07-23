FROM rocker/tidyverse:latest

MAINTAINER Nan Xiao <me@nanx.me>

# System dependencies for required R packages
RUN  rm -f /var/lib/dpkg/available \
  && rm -rf  /var/cache/apt/* \
  && apt-get update -qq \
  && apt-get install -y --no-install-recommends \
    ca-certificates \
    libssl-dev \
    libcurl4-openssl-dev \
    libxml2-dev \
    git

RUN Rscript -e "install.packages(c('devtools','knitr','rmarkdown','shiny','RCurl'), repos = 'https://cran.rstudio.com')"

RUN Rscript -e "source('https://cdn.rawgit.com/road2stat/liftrlib/aa132a2d/install_cran.R');install_cran(c('rmdformats'))"

RUN Rscript -e "source('http://bioconductor.org/biocLite.R');biocLite(c('limma','affy','hgfocuscdf'))"

RUN Rscript -e "source('https://cdn.rawgit.com/road2stat/liftrlib/aa132a2d/install_remotes.R');install_remotes(c('url::https://bioconductor.org/help/workflows/arrays/arrays_0.1.tar.gz'))"

RUN mkdir /liftrroot/
WORKDIR /liftrroot/
