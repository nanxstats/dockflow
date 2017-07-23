#' @title Convert continuous values to categorical/discrete values
#' @description This function calculates the quantiles for the list of input values and assigns a quantile group to every data point
#' @param covariates samples x covariates matrix containing the continous covariates which need to be discretized
#' @param var_names a list of the continuous variables that need to be discretized
#' @note the function returns a modified  samples x covariates matrix with the categorized variables appended to 
#' the end as another column
#' @keywords categorize, quantile, discretize
#' @author Karthikeyan Murugesan<karthikeyanm60 at yahoo.com>
#' #@examples conTocat(covariates, var_names)
#' @export

conTocat <- function(covariates, var_names)
{
    var <- covariates[,var_names]
    len <- dim(var)[2]
    for (i in 1:len) {
        temp <- as.numeric(with(var, cut(var[,i], breaks=
                          quantile(var[,i], probs=seq(0, 1, by=0.25)), 
                                                  include.lowest=TRUE)))
        covariates <- cbind(covariates, temp)
        colnames(covariates)[ncol(covariates)] <- 
                           paste(var_names[i], "_cat", sep="")
    }
    return(covariates)
}
