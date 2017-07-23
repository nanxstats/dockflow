# extract tarballs
for (i in workflow_name)
  untar(tarfile = paste0('workflow/', i, '/src.tar.gz'),
        exdir = paste0('workflow/', i, '/src'),
        extras = '--strip 1')  # without top directory

# remove outliers
unlink('workflow/annotation-genomic-ranges/src/vignettes/Annotation_Resources.Rmd')
unlink('workflow/annotation-resources/src/vignettes/Annotating_Genomic_Ranges.Rmd')
unlink(paste0('workflow/', workflow_name, '/src/inst'), recursive = TRUE)

# prepare R Markdown files for liftr
rmd_path = paste0(
  'workflow/', list.files(
    path = 'workflow/', pattern = '.Rmd',
    recursive = TRUE, include.dirs = FALSE))

# get directory of the files
file_dir = function(x) dirname(normalizePath(x))
rmd_dir = file_dir(rmd_path)
for (i in 1:length(rmd_path))
  file.rename(normalizePath(rmd_path[i]), paste0(rmd_dir[i], '/index.Rmd'))
