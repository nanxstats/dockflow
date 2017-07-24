library('liftr')

# use liftr to containerize every single Bioconductor workflow

# use `docker stats`` to track the container resource usage
# to know when R is killed because of OOM

# Issues:
#
# - some functions in the code chunks tries to install packages on the fly
# - some workflows tries to install packages on the fly in the Rmd chunks
# - quoting workflow packages but not available via BiocInstall.
#   Need to install them from source (at least 2).
#   This creates issues because the dependencies (particularly BioC packages)
#   declared in that source package cannot be automatically parsed and
#   installed, which equals to missing dependency.
# - Uses :: to call the function but not library() or require() to call that package
# - Uses View() which starts GUI instead of having text outputs. May use DT instead.
# - Hits resource constraints: Docker memory and CPU limits see this:
#   https://docs.docker.com/engine/admin/resource_constraints/
#   If using Mac, need to increase the Virtual Machine's resource limit:
#   Docker Icon -> Preferences -> Advanced ->
#   change # of CPUs (default is 2) Memory (default is 2.0 GB)

dockflow = function (workflow) {

  # copy liftr configuration file to workflow directory
  file.copy(
    from = paste0('config/', workflow, '.yml'),
    to = paste0('workflow/', workflow, '/src/vignettes/_liftr.yml'))

  # generate Dockerfile with lift()
  lift(
    paste0('workflow/', workflow, '/src/vignettes/index.Rmd'),
    use_config = TRUE)

  # build Docker image and render workflow Rmd
  render_docker(
    paste0('workflow/', workflow, '/src/vignettes/index.Rmd'),
    tag = workflow, container_name = workflow, purge_info = FALSE)

  # copy rendered HTML to website
  file.copy(
    from = paste0('workflow/', workflow, '/src/vignettes/index.html'),
    to = paste0('../dockflow-website/workflow/', workflow, '/index.html'))

}

# 01 - sequencing

# - AnnotationHub tries to create a local cache in the container - 'Permission denied'
#   need a patch to change the default caching directory of AnnotationHub
#   setAnnotationHubOption("CACHE", "/liftrroot/")

dockflow('sequencing')

# 02 - arrays

# - tries to install packages on the fly in the Rmd chunks
#   affy::justRMA calls cdfFromBioC which uses install.packages
#   to install hgfocuscdf (not easily determined)

dockflow('arrays')

# 03 - annotation-resources

# - AnnotationHub cache permission problem

dockflow('annotation-resources')

# 04 - annotation-genomic-ranges

# - AnnotationHub cache permission problem

dockflow('annotation-genomic-ranges')

# 05 - annotation-genomic-variants

dockflow('annotation-genomic-variants')

# 06 - liftover

dockflow('liftover')

# 07 - high-throughput-assays

dockflow('high-throughput-assays')

# 08 - rnaseq-gene

dockflow('rnaseq-gene')

# 09 - proteomics

# - compilation of mzR requires >2GB peak memory
# - MSGFPlus tries to download Java binary to a temp dir on-the-fly (permission issue)

dockflow('proteomics')

# 10 - gene-regulation

# - tries to install package grImport from source on-the-fly

dockflow('gene-regulation')

# 11 - eqtl

# - tries to install package GGdata and SNPlocs.Hsapiens.dbSNP144.GRCh37 on the fly in the Rmd chunks
# - running memory peak ~4.8GB, exceeds Docker for Mac's default VM config (2GB) and causes OOM kill
# - set hard-coded number (2) of cores for parallelization, may cause performance issues for running container with single-core

dockflow('eqtl')

# 12 - chipseqdb

# downloading huge files from AWS

dockflow('chipseqdb')

# 13 - simple-single-cell

# - depended package "destiny" has all-platform build error because tries to complie a Jupyter Notebook vignette, need to remove it temporarily
# - running memory peak ~4GB, exceeds Docker for Mac's default VM config (2GB) and causes OOM kill
# - downloading from remote servers may not be stable

dockflow('simple-single-cell')

# 14 - rnaseq-123

# - uses R.utils but used :: to call the function

dockflow('rnaseq-123')

# 15 - expression-normalization

# - used View() which invovles GUI under X

dockflow('expression-normalization')

# 16 - methylation-array-analysis

# - inexplicit dependency of the workflow package methylationArrayAnalysis
# - needs 2.5GB memory to install package IlluminaHumanMethylationEPICanno.ilm10b2.hg19
#   for step "moving datasets to lazyload DB"
#   exceeds Docker for Mac's default VM config (2GB) and causes OOM kill
# - running memory peak ~3.6GB
#   exceeds Docker for Mac's default VM config (2GB) and causes OOM kill

dockflow('methylation-array-analysis')

# 17 - rnaseq-gene-edgerql

# - inexplicit dependency: statmod package required but is not installed

dockflow('rnaseq-gene-edgerql')

# 18 - tcga

# - pakckage depended (pathview) build error because it uses a == in dependency
# - AnnotationHub cache permission problem
# - dependency stated in workflow package instead of the workflow
# - memory peak >4GB: exceeding Docker for Mac's default VM config (2GB) and causes OOM kill

dockflow('tcga')
