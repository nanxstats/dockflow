#' @title Estimate surrogate covariates unmodeled or hidden in the data
#' @description Surrogate variables are covariates constructed directly from 
#' high-dimensional data (like gene expression/RNA sequencing/methylation/brain imaging data)
#' that can be used in subsequent analyses to adjust for unknown, unmodeled, or latent sources of noise.
#' @param expSetobj Expression set object
#' @param blgy_var biological variable of interest
#' @param n.sv number of surrogate variables to be estimated (if no argument
#' provided then the algorithm estimates n.sv for the user)
#' @return sv A n by n.sv matrix where each column is a distinct surrogate 
#' variable (the main quantity of interest)
#' @return pprob.gam   posterior probability that each gene is associated with one or more latent variables
#' @return pprob.b  posterior probability that each gene is associated with the variables of interest b
#' @return n.sv  The number of surrogate variables estimated, Enter if n.sv 
#' known or just dont enter the parameter, the tool will identify the number of surrogate variables on its own 
#' @return expSetobject Modified expression set object with the surrogate 
#' variables added as additional columns to covariate matrix
#' @note The return values of the function can be accessed as <variable>$<parameter>
#' @keywords Surrogate Variable Analysis, SVA
#' @author Karthikeyan  Murugesan <karthikeyanm60 at yahoo.com>
#' @import Biobase limma lme4 matrixStats pvca snm sva vsn
#' @references Leek JT, Johnson WE, Parker HS, Fertig EJ, Jaffe AE and Storey JD.
#' sva: Surrogate Variable Analysis. R package version 3.12.0.
#' @seealso \code{\link{sva}}
#' #@examples surVarAnaly(expSetobj, blgy_var, adj_var)
#' @export

surVarAnaly <- function(expSetobj, blgy_var, n.sv=NULL) 
{
    pheno <- pData(expSetobj)
    expData <- exprs(expSetobj)
    mod  <- model.matrix(~as.factor(pheno[, blgy_var]), data=pheno)
    mod0 <- model.matrix(~1,data=pheno)
    if (is.null(n.sv)) {
            n.sv <- num.sv(expData, mod, method="leek")
        }
    svobj <- sva(expData, mod, mod0, n.sv=n.sv)
    srg_var <- as.data.frame(svobj$sv)
    colnames(srg_var) <- paste("sv", 1:ncol(srg_var), sep="")
    pData(expSetobj) <- cbind(pData(expSetobj), srg_var)
    varMetadata(expSetobj)[colnames(srg_var),] <- colnames(srg_var)
    svobj$expSetobject <- expSetobj
    return(svobj)
}
