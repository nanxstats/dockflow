workflow_urls = c (
  'sequencing' = 'https://bioconductor.org/help/workflows/sequencing/sequencing_0.99.120890.tar.gz',
  'arrays' = 'https://bioconductor.org/help/workflows/arrays/arrays_0.1.tar.gz',
  'annotation-resources' = 'https://bioconductor.org/help/workflows/annotation/annotation_0.99.129255.tar.gz',
  'annotation-genomic-ranges' = 'https://bioconductor.org/help/workflows/annotation/annotation_0.99.129255.tar.gz',
  'annotation-genomic-variants' = 'https://bioconductor.org/help/workflows/variants/variants_0.99.129254.tar.gz',
  'liftover' = 'https://bioconductor.org/help/workflows/liftOver/liftOver_0.99.129508.tar.gz',
  'high-throughput-assays' = 'https://bioconductor.org/help/workflows/highthroughputassays/highthroughputassays_0.99.120889.tar.gz',
  'rnaseq-gene' = 'https://bioconductor.org/help/workflows/rnaseqGene/rnaseqGene_0.99.130674.tar.gz',
  'proteomics' = 'https://bioconductor.org/help/workflows/proteomics/proteomics_0.99.130294.tar.gz',
  'gene-regulation' = 'https://bioconductor.org/help/workflows/generegulation/generegulation_0.99.120866.tar.gz',
  'eqtl' = 'https://bioconductor.org/help/workflows/eQTL/eQTL_0.99.128835.tar.gz',
  'chipseqdb' = 'https://bioconductor.org/help/workflows/chipseqDB/chipseqDB_0.99.128314.tar.gz',
  'simple-single-cell' = 'https://bioconductor.org/help/workflows/simpleSingleCell/simpleSingleCell_0.99.129200.tar.gz',
  'rnaseq-123' = 'https://bioconductor.org/help/workflows/RNAseq123/RNAseq123_1.0.0.tar.gz',
  'expression-normalization' = 'https://bioconductor.org/help/workflows/ExpressionNormalizationWorkflow/ExpressionNormalizationWorkflow_1.2.0.tar.gz',
  'methylation-array-analysis' = 'https://bioconductor.org/help/workflows/methylationArrayAnalysis/methylationArrayAnalysis_0.99.7.tar.gz',
  'rnaseq-gene-edgerql' = 'https://bioconductor.org/help/workflows/RnaSeqGeneEdgeRQL/RnaSeqGeneEdgeRQL_0.99.18.tar.gz',
  'tcga' = 'https://bioconductor.org/help/workflows/TCGAWorkflow/TCGAWorkflow_0.99.73.tar.gz'
)

workflow_name = names(workflow_urls)

# download tarballs

for (i in workflow_name) dir.create(paste0('workflow/', i))
for (i in 1L:length(workflow_urls))
  download.file(
    workflow_urls[i],
    destfile = paste0('workflow/', workflow_name[i], '/src.tar.gz'))
