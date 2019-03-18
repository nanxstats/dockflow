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

RUN apt-get update -qq && apt-get install -y --no-install-recommends libgsl-dev ghostscript

RUN Rscript -e "install.packages(c('devtools','knitr','rmarkdown','shiny','RCurl'), repos = 'https://cran.rstudio.com')"

RUN Rscript -e "source('https://cdn.rawgit.com/nanxstats/liftrlib/aa132a2d/install_cran.R');install_cran(c('rmdformats','DT','circlize','c3net','pbapply','ggplot2','ggthemes','readr','downloader'))"

RUN Rscript -e "source('http://bioconductor.org/biocLite.R');biocLite(c('TCGAWorkflowData','TCGAbiolinks','SummarizedExperiment','RTCGAToolbox','gaia','GenomicRanges','ComplexHeatmap','clusterProfiler','minet','rGADEM','BSgenome.Hsapiens.UCSC.hg19','motifStack','MotIV','ChIPseeker','AnnotationHub','ELMER','EDASeq','GO.db','DO.db','MotifDb','biomaRt','GenomeInfoDb'))"

RUN Rscript -e "source('https://cdn.rawgit.com/nanxstats/liftrlib/aa132a2d/install_remotes.R');install_remotes(c('url::https://bioconductor.org/help/workflows/TCGAWorkflow/TCGAWorkflow_0.99.73.tar.gz'))"

RUN mkdir /liftrroot/
WORKDIR /liftrroot/
