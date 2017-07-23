library('liftr')

# use liftr to containerize every single Bioconductor workflow

# use `docker stats`` to track the container resource usage
# to know when R is killed because of OOM

# List:
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

# 01 - sequencing
workflow = 'sequencing'

# - AnnotationHub tries to create a local cache in the container - 'Permission denied'
#   need a patch to change the default caching directory of AnnotationHub
#   setAnnotationHubOption("CACHE", "/liftrroot/")

file.copy(
  from = paste0('config/', workflow, '.yml'),
  to = paste0('workflow/', workflow, '/src/vignettes/_liftr.yml'))

lift(
  paste0('workflow/', workflow, '/src/vignettes/index.Rmd'),
  use_config = TRUE)

render_docker(
  paste0('workflow/', workflow, '/src/vignettes/index.Rmd'),
  tag = workflow, container_name = workflow, purge_info = FALSE)

file.copy(
  from = paste0('workflow/', workflow, '/src/vignettes/index.html'),
  to = paste0('../dockflow-website/workflow/', workflow, '/index.html'))

# 02 - arrays
workflow = 'arrays'

# - tries to install packages on the fly in the Rmd chunks
#   affy::justRMA calls cdfFromBioC which uses install.packages
#   to install hgfocuscdf (not easily determined)

file.copy(
  from = paste0('config/', workflow, '.yml'),
  to = paste0('workflow/', workflow, '/src/vignettes/_liftr.yml'))

lift(
  paste0('workflow/', workflow, '/src/vignettes/index.Rmd'),
  use_config = TRUE)

render_docker(
  paste0('workflow/', workflow, '/src/vignettes/index.Rmd'),
  tag = workflow, container_name = workflow, purge_info = FALSE)

file.copy(
  from = paste0('workflow/', workflow, '/src/vignettes/index.html'),
  to = paste0('../dockflow-website/workflow/', workflow, '/index.html'))

# 03 - annotation-resources
workflow = 'annotation-resources'

# - AnnotationHub cache permission problem

file.copy(
  from = paste0('config/', workflow, '.yml'),
  to = paste0('workflow/', workflow, '/src/vignettes/_liftr.yml'))

lift(
  paste0('workflow/', workflow, '/src/vignettes/index.Rmd'),
  use_config = TRUE)

render_docker(
  paste0('workflow/', workflow, '/src/vignettes/index.Rmd'),
  tag = workflow, container_name = workflow, purge_info = FALSE)

file.copy(
  from = paste0('workflow/', workflow, '/src/vignettes/index.html'),
  to = paste0('../dockflow-website/workflow/', workflow, '/index.html'))

# 04 - annotation-genomic-ranges
workflow = 'annotation-genomic-ranges'

# - AnnotationHub cache permission problem

file.copy(
  from = paste0('config/', workflow, '.yml'),
  to = paste0('workflow/', workflow, '/src/vignettes/_liftr.yml'))

lift(
  paste0('workflow/', workflow, '/src/vignettes/index.Rmd'),
  use_config = TRUE)

render_docker(
  paste0('workflow/', workflow, '/src/vignettes/index.Rmd'),
  tag = workflow, container_name = workflow, purge_info = FALSE)

file.copy(
  from = paste0('workflow/', workflow, '/src/vignettes/index.html'),
  to = paste0('../dockflow-website/workflow/', workflow, '/index.html'))

# 05 - annotation-genomic-variants
workflow = 'annotation-genomic-variants'

file.copy(
  from = paste0('config/', workflow, '.yml'),
  to = paste0('workflow/', workflow, '/src/vignettes/_liftr.yml'))

lift(
  paste0('workflow/', workflow, '/src/vignettes/index.Rmd'),
  use_config = TRUE)

render_docker(
  paste0('workflow/', workflow, '/src/vignettes/index.Rmd'),
  tag = workflow, container_name = workflow, purge_info = FALSE)

file.copy(
  from = paste0('workflow/', workflow, '/src/vignettes/index.html'),
  to = paste0('../dockflow-website/workflow/', workflow, '/index.html'))

# 06 - liftover
workflow = 'liftover'

file.copy(
  from = paste0('config/', workflow, '.yml'),
  to = paste0('workflow/', workflow, '/src/vignettes/_liftr.yml'))

lift(
  paste0('workflow/', workflow, '/src/vignettes/index.Rmd'),
  use_config = TRUE)

render_docker(
  paste0('workflow/', workflow, '/src/vignettes/index.Rmd'),
  tag = workflow, container_name = workflow, purge_info = FALSE)

file.copy(
  from = paste0('workflow/', workflow, '/src/vignettes/index.html'),
  to = paste0('../dockflow-website/workflow/', workflow, '/index.html'))

# 07 - high-throughput-assays
workflow = 'high-throughput-assays'

file.copy(
  from = paste0('config/', workflow, '.yml'),
  to = paste0('workflow/', workflow, '/src/vignettes/_liftr.yml'))

lift(
  paste0('workflow/', workflow, '/src/vignettes/index.Rmd'),
  use_config = TRUE)

render_docker(
  paste0('workflow/', workflow, '/src/vignettes/index.Rmd'),
  tag = workflow, container_name = workflow, purge_info = FALSE)

file.copy(
  from = paste0('workflow/', workflow, '/src/vignettes/index.html'),
  to = paste0('../dockflow-website/workflow/', workflow, '/index.html'))

# 08 - rnaseq-gene
workflow = 'rnaseq-gene'

file.copy(
  from = paste0('config/', workflow, '.yml'),
  to = paste0('workflow/', workflow, '/src/vignettes/_liftr.yml'))

lift(
  paste0('workflow/', workflow, '/src/vignettes/index.Rmd'),
  use_config = TRUE)

render_docker(
  paste0('workflow/', workflow, '/src/vignettes/index.Rmd'),
  tag = workflow, container_name = workflow, purge_info = FALSE)

file.copy(
  from = paste0('workflow/', workflow, '/src/vignettes/index.html'),
  to = paste0('../dockflow-website/workflow/', workflow, '/index.html'))

# 09 - proteomics
workflow = 'proteomics'

# - compilation of mzR requires >2GB peak memory
# - MSGFPlus tries to download Java binary to a temp dir on-the-fly (permission issue)

file.copy(
  from = paste0('config/', workflow, '.yml'),
  to = paste0('workflow/', workflow, '/src/vignettes/_liftr.yml'))

lift(
  paste0('workflow/', workflow, '/src/vignettes/index.Rmd'),
  use_config = TRUE)

render_docker(
  paste0('workflow/', workflow, '/src/vignettes/index.Rmd'),
  tag = workflow, container_name = workflow, purge_info = FALSE)

file.copy(
  from = paste0('workflow/', workflow, '/src/vignettes/index.html'),
  to = paste0('../dockflow-website/workflow/', workflow, '/index.html'))

# 10 - gene-regulation
workflow = 'gene-regulation'

# - tries to install package grImport from source on-the-fly

file.copy(
  from = paste0('config/', workflow, '.yml'),
  to = paste0('workflow/', workflow, '/src/vignettes/_liftr.yml'))

lift(
  paste0('workflow/', workflow, '/src/vignettes/index.Rmd'),
  use_config = TRUE)

render_docker(
  paste0('workflow/', workflow, '/src/vignettes/index.Rmd'),
  tag = workflow, container_name = workflow, purge_info = FALSE)

file.copy(
  from = paste0('workflow/', workflow, '/src/vignettes/index.html'),
  to = paste0('../dockflow-website/workflow/', workflow, '/index.html'))

# 11 - eqtl
workflow = 'eqtl'
# - tries to install package GGdata and SNPlocs.Hsapiens.dbSNP144.GRCh37 on the fly in the Rmd chunks
# - running memory peak ~4.8GB, exceeds Docker for Mac's default VM config (2GB) and causes OOM kill
# - set hard-coded number (2) of cores for parallelization, may cause performance issues for running container with single-core

file.copy(
  from = paste0('config/', workflow, '.yml'),
  to = paste0('workflow/', workflow, '/src/vignettes/_liftr.yml'))

lift(
  paste0('workflow/', workflow, '/src/vignettes/index.Rmd'),
  use_config = TRUE)

render_docker(
  paste0('workflow/', workflow, '/src/vignettes/index.Rmd'),
  tag = workflow, container_name = workflow, purge_info = FALSE)

file.copy(
  from = paste0('workflow/', workflow, '/src/vignettes/index.html'),
  to = paste0('../dockflow-website/workflow/', workflow, '/index.html'))

# 12 - chipseqdb
workflow = 'chipseqdb'

# downloading huge files from AWS

file.copy(
  from = paste0('config/', workflow, '.yml'),
  to = paste0('workflow/', workflow, '/src/vignettes/_liftr.yml'))

lift(
  paste0('workflow/', workflow, '/src/vignettes/index.Rmd'),
  use_config = TRUE)

render_docker(
  paste0('workflow/', workflow, '/src/vignettes/index.Rmd'),
  tag = workflow, container_name = workflow, purge_info = FALSE)

file.copy(
  from = paste0('workflow/', workflow, '/src/vignettes/index.html'),
  to = paste0('../dockflow-website/workflow/', workflow, '/index.html'))

# 13 - simple-single-cell
workflow = 'simple-single-cell'

# - depended package "destiny" has all-platform build error because tries to complie a Jupyter Notebook vignette, need to remove it temporarily
# - running memory peak ~4GB, exceeds Docker for Mac's default VM config (2GB) and causes OOM kill
# - downloading from remote servers may not be stable

file.copy(
  from = paste0('config/', workflow, '.yml'),
  to = paste0('workflow/', workflow, '/src/vignettes/_liftr.yml'))

lift(
  paste0('workflow/', workflow, '/src/vignettes/index.Rmd'),
  use_config = TRUE)

render_docker(
  paste0('workflow/', workflow, '/src/vignettes/index.Rmd'),
  tag = workflow, container_name = workflow, purge_info = FALSE)

file.copy(
  from = paste0('workflow/', workflow, '/src/vignettes/index.html'),
  to = paste0('../dockflow-website/workflow/', workflow, '/index.html'))

# 14 - rnaseq-123
workflow = 'rnaseq-123'

# - uses R.utils but used :: to call the function

file.copy(
  from = paste0('config/', workflow, '.yml'),
  to = paste0('workflow/', workflow, '/src/vignettes/_liftr.yml'))

lift(
  paste0('workflow/', workflow, '/src/vignettes/index.Rmd'),
  use_config = TRUE)

render_docker(
  paste0('workflow/', workflow, '/src/vignettes/index.Rmd'),
  tag = workflow, container_name = workflow, purge_info = FALSE)

file.copy(
  from = paste0('workflow/', workflow, '/src/vignettes/index.html'),
  to = paste0('../dockflow-website/workflow/', workflow, '/index.html'))

# 15 - expression-normalization
workflow = 'expression-normalization'

# - used View() which invovles GUI under X

file.copy(
  from = paste0('config/', workflow, '.yml'),
  to = paste0('workflow/', workflow, '/src/vignettes/_liftr.yml'))

lift(
  paste0('workflow/', workflow, '/src/vignettes/index.Rmd'),
  use_config = TRUE)

render_docker(
  paste0('workflow/', workflow, '/src/vignettes/index.Rmd'),
  tag = workflow, container_name = workflow, purge_info = FALSE)

file.copy(
  from = paste0('workflow/', workflow, '/src/vignettes/index.html'),
  to = paste0('../dockflow-website/workflow/', workflow, '/index.html'))

# 16 - methylation-array-analysis
workflow = 'methylation-array-analysis'

# - inexplicit dependency of the workflow package methylationArrayAnalysis
# - needs 2.5GB memory to install package IlluminaHumanMethylationEPICanno.ilm10b2.hg19
#   for step "moving datasets to lazyload DB"
#   exceeds Docker for Mac's default VM config (2GB) and causes OOM kill
# - running memory peak ~3.6GB
#   exceeds Docker for Mac's default VM config (2GB) and causes OOM kill

file.copy(
  from = paste0('config/', workflow, '.yml'),
  to = paste0('workflow/', workflow, '/src/vignettes/_liftr.yml'))

lift(
  paste0('workflow/', workflow, '/src/vignettes/index.Rmd'),
  use_config = TRUE)

render_docker(
  paste0('workflow/', workflow, '/src/vignettes/index.Rmd'),
  tag = workflow, container_name = workflow, purge_info = FALSE)

file.copy(
  from = paste0('workflow/', workflow, '/src/vignettes/index.html'),
  to = paste0('../dockflow-website/workflow/', workflow, '/index.html'))

# 17 - rnaseq-gene-edgerql
workflow = 'rnaseq-gene-edgerql'

# - inexplicit dependency: statmod package required but is not installed

file.copy(
  from = paste0('config/', workflow, '.yml'),
  to = paste0('workflow/', workflow, '/src/vignettes/_liftr.yml'))

lift(
  paste0('workflow/', workflow, '/src/vignettes/index.Rmd'),
  use_config = TRUE)

render_docker(
  paste0('workflow/', workflow, '/src/vignettes/index.Rmd'),
  tag = workflow, container_name = workflow, purge_info = FALSE)

file.copy(
  from = paste0('workflow/', workflow, '/src/vignettes/index.html'),
  to = paste0('../dockflow-website/workflow/', workflow, '/index.html'))

# 18 - tcga
workflow = 'tcga'

# - pakckage depended (pathview) build error because it uses a == in dependency
# - AnnotationHub cache permission problem
# - dependency stated in workflow package instead of the workflow
# - memory peak >4GB: exceeding Docker for Mac's default VM config (2GB) and causes OOM kill

file.copy(
  from = paste0('config/', workflow, '.yml'),
  to = paste0('workflow/', workflow, '/src/vignettes/_liftr.yml'))

lift(
  paste0('workflow/', workflow, '/src/vignettes/index.Rmd'),
  use_config = TRUE)

render_docker(
  paste0('workflow/', workflow, '/src/vignettes/index.Rmd'),
  tag = workflow, container_name = workflow, purge_info = FALSE)

file.copy(
  from = paste0('workflow/', workflow, '/src/vignettes/index.html'),
  to = paste0('../dockflow-website/workflow/', workflow, '/index.html'))
