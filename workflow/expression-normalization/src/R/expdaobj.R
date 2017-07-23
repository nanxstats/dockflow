#' @title Create a compact ExpressionSet Datatype Object 
#' @description An expression set object can store the expression values and the 
#' meta data associated like the covariate information, annotations and experiment protocol data
#' @param expression  the gene expression value martix with features (probes)  as rows and samples as columns
#' @param covariates  the phenotype (covariate) matrix with samples as rows and the covariates as columns
#' @param cov_desc a list of descriptors for each of the covariates
#' @return exp_datObj ExpressionSet Datatype Object
#' @note The return values of the function can be accessed as variable$parameter
#' @keywords ExpressionSet
#' @author Karthikeyan  Murugesan <karthikeyanm60 at yahoo.com>
#' @import Biobase limma lme4 matrixStats pvca snm sva vsn
#' @references Gentleman RC, Carey VJ, Bates DM and others (2004).
#' “Bioconductor: Open software development for computational biology and bioinformatics.” Genome Biology, 5, pp. R80.
#' #@examples expSetobj(expression, covariates)
#' @export

expSetobj <- function(expression, covariates, cov_desc=NULL)
{
    expression <- as.matrix(expression)
    if(is.null(cov_desc)) {
        cov_desc <- colnames(covariates)
    }
    metadata <- data.frame(labelDescription=cov_desc, 
                           row.names=colnames(covariates))
    phenoData <- new("AnnotatedDataFrame", data=covariates,
                     varMetadata=metadata)
    exp_datObj <- ExpressionSet(assayData=expression, phenoData=phenoData)
    return(exp_datObj)
}
