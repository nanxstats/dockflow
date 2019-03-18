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

RUN Rscript -e "source('https://cdn.rawgit.com/nanxstats/liftrlib/aa132a2d/install_cran.R');install_cran(c('rmdformats','knitcitations','bibtex','scatterplot3d','foreach','doParallel','biglm','rmeta','reshape2','ggplot2'))"

RUN Rscript -e "source('http://bioconductor.org/biocLite.R');biocLite(c('GGdata','SNPlocs.Hsapiens.dbSNP144.GRCh37','GenomeInfoDb','S4Vectors','GGtools','yri1kgv','snpStats','lumi','lumiHumanAll.db'))"

RUN mkdir /liftrroot/
WORKDIR /liftrroot/
