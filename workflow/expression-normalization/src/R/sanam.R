#' @title Supervized Normalization of Microarrays
#' @description This function implements the  Supervised Normalization of Microarrays
#'  on an  expression matrix. The SNM technique tries to enhance our ability to detect 
#' the underlying biological signals by removing the effects of  the adjustment variables 
#' which are usaully the causes of unwanted biases in the expression data #' It requires a 
#' set of biological covariates of interest and at least one probe-specific or intensity-dependent 
#' adjustment variable.
#' Biological, Adjustment and the Intensity dependent adjustment variables are user defined
#' @param exprs the gene expression value martix with features (probes)  as rows and samples as columns
#' @param cov the phenotype (covariate) matrix with samples as rows and the covariates as columns
#' @param bv biological variable 
#' @param av adjustment variables whose effect on the expression has to be removed
#' @param iv intenstity variables
#' @param adj TRUE or FALSE value, default value is TRUE, If set to FALSE, then 
#' only the intensity dependent effects have been removed from the normalized data,
#' implying the effects from the adjustment variables are still present. If TRUE, then
#'  the adjustment variables effects and the intensity dependent effects are both removed from 
#'  the expression data
#' @return norm.dat The matrix of normalized data
#' @return pvalues A vector of p-values testing the association of the biological variables 
#' with each probe. These p-values are obtained from an ANOVA comparing 
#' models where the full model contains both the probe-specific biological and adjustment variables 
#' versus a reduced model that just contains the probe-specific adjustment variables. The data used 
#' for this comparison has the intensity-dependent variables removed. These returned p-values are 
#' calculated after the final iteration of the algorithm.
#' @return pi0  The estimated proportion of true null probes pi_0, calculated after the final 
#' iteration of the algorithm
#' @return iter.pi0s A vector of length equal to num.iter containing the estimated pi_0 values at each 
#' iteration of the snm algorithm. These values should converge and any non-convergence suggests 
#' a problem with the data, the assumed model, or both
#' @return nulls A vector indexing the probes utilized in estimating the intensity-dependent effects 
#' on the final iteration.
#' @return bio.var The processed version of the same input variable
#' @return adj.var The processed version of the same input variable
#' @return int.var The processed version of the same input variable
#' @return df0  Degrees of freedom of the adjustment variable
#' @return df1 Degrees of freedom of the full model matrix, which includes the biological variables 
#' and the adjustment variables.
#' @note The return values of the function can be accessed as <variable>$<parameter>
#' @keywords SNM, Supervised, Normalization, Microarray, Adjustment, Batch Effect
#' @author Karthikeyan  Murugesan <karthikeyanm60 at yahoo.com>
#' @import Biobase limma lme4 matrixStats pvca snm sva vsn
#' @references Mecham BH, Nelson PS, Storey JD (2010) Supervised normalization of 
#' microarrays.Bioinformatics, 26: 1308-1315, Brig Mecham and John D. Storey<jstorey at princeton.edu>
#' @seealso \code{\link{snm}}
#' #@examples snmAnaly(expression_matrix, covariate_matrix)
#' @export

snmAnaly <- function(exprs, cov, bv, av, iv, adj=TRUE)
{
    kar_rawdata <- exprs
    kar_bio.var <- as.data.frame(cov[,bv])
    kar_adj.var <- as.data.frame(cov[,av])
    rownames(kar_adj.var) <- rownames(cov)
    colnames(kar_adj.var) <- av
    kar_int.var <- as.data.frame(cov[,iv])
    colnames(kar_int.var) <- iv
    int.var <- kar_int.var
    int.var$Array <- as.factor(int.var$Array)
    adj.var <- model.matrix(~., kar_adj.var)
    bio.var <- model.matrix(~., kar_bio.var)
    raw.data <- as.matrix(kar_rawdata)
    snm.obj <- snm(raw.data, bio.var, adj.var, int.var, rm.adj=adj, num.iter=5)
    write.table(snm.obj$norm.dat, file="snm_normalized_data.csv", 
                sep=",", col.names=NA)
    return(snm.obj)
}
