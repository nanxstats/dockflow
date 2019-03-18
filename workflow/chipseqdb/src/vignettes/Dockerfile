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

RUN apt-get update -qq && apt-get install -y --no-install-recommends samtools autoconf

RUN Rscript -e "install.packages(c('devtools','knitr','rmarkdown','shiny','RCurl'), repos = 'https://cran.rstudio.com')"

RUN Rscript -e "source('https://cdn.rawgit.com/nanxstats/liftrlib/aa132a2d/install_cran.R');install_cran(c('rmdformats','statmod','locfit','KernSmooth'))"

RUN Rscript -e "source('http://bioconductor.org/biocLite.R');biocLite(c('Rsubread','Rsamtools','rtracklayer','csaw','edgeR','org.Mm.eg.db','TxDb.Mmusculus.UCSC.mm10.knownGene','ChIPpeakAnno','Gviz','BiocStyle'))"

RUN mkdir /liftrroot/
WORKDIR /liftrroot/
