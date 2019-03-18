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

RUN Rscript -e "source('https://cdn.rawgit.com/nanxstats/liftrlib/aa132a2d/install_cran.R');install_cran(c('rmdformats','knitr','RColorBrewer','gplots','R.utils'))"

RUN Rscript -e "source('http://bioconductor.org/biocLite.R');biocLite(c('BiocStyle','limma','Glimma','edgeR','Mus.musculus'))"

RUN Rscript -e "source('https://cdn.rawgit.com/nanxstats/liftrlib/aa132a2d/install_remotes.R');install_remotes(c('url::https://www.bioconductor.org/help/workflows/RNAseq123/RNAseq123_1.0.0.tar.gz'))"

RUN mkdir /liftrroot/
WORKDIR /liftrroot/
