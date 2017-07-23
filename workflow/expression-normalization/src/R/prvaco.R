#' @title Principal variance Component Analysis
#' @description  PVCA estimates the variance in the expression dataset  due to 
#' each of the given covariates and attributes the remaining fraction to residual.
#' It efficiently combines principal component analysis
#` (PCA) to reduce the feature space and variance components analysis (VCA) which
#` fits a mixed linear model using factors of interest as random effects to estimate
#` and partition the total variability.
#' @param exp_datObj  an expression set class object 
#' @param pct_threshold PVCA Threshold Value (a value between 0 and 1) is the percentile
#'  value of the minimum amount of the variabilities that the selected principal components need to explain 
#' @param batch_factors a list of covariates whose effect size on the expression data  is to be determined
#' @return dat A numerical vector that contains the percentile of sources of batch effect for each covariate term
#' @return label A character vector containing the name for each covariate term 
#' @note The return values of the function can be accessed as <variable>$<parameter>
#' @keywords Variance Component Analysis, VCA, Principal Component Analysis, PCA
#' @author Karthikeyan  Murugesan <karthikeyanm60 at yahoo.com>
#' @import Biobase limma lme4 matrixStats pvca snm sva vsn
#' @references Bushel P (2013). pvca: Principal Variance Component Analysis (PVCA).R package version 1.6.0.
#' @seealso \code{\link{pvcaBatchAssess}}
#' #@examples
#' pvcAnaly(exp_datObj, pct_threshold, batch_factors)
#' @export

pvcAnaly <- function(exp_datObj, pct_threshold, batch_factors)
{
    pvcaObj <- pvcaBatchAssess(exp_datObj,batch_factors,pct_threshold)
    bp <- barplot(pvcaObj$dat,
                  ylab=expression(bold("Weighted Average Proportion Variance")),
                ylim=c(0,1.1), col=c("navy"), las=2, font=2,
                main="Principal Variant Component Analysis Estimation")

    axis(1,at=bp,labels=pvcaObj$label,cex.axis=0.6,las=2,font=2)
    values <- pvcaObj$dat
    new_values <- round(values,3)
    text(bp,pvcaObj$dat,labels=new_values,pos=3,cex=0.8,font=2)
    return(pvcaObj)
}


## PVCA by Pierre R.Bushel and Jianying Li
pvcaBatchAssess <- function (abatch, batch_factors, threshold)
{
    theDataMatrix <- exprs(vsn2(abatch, verbose=FALSE))
    dataRowN <- nrow(theDataMatrix)
    dataColN <- ncol(theDataMatrix)
    theDataMatrixCentered <- matrix(data=0, nrow=dataRowN,
                                    ncol=dataColN)
    theDataMatrixCentered_transposed <- apply(theDataMatrix, 1,
                                             scale, center=TRUE, scale=FALSE)
    theDataMatrixCentered <- t(theDataMatrixCentered_transposed)
    theDataCor <- cor(theDataMatrixCentered)
    eigenData <- eigen(theDataCor)
    eigenValues <- eigenData$values
    ev_n <- length(eigenValues)
    eigenVectorsMatrix <- eigenData$vectors
    eigenValuesSum <- sum(eigenValues)
    percents_PCs <- eigenValues / eigenValuesSum
    expInfo <- pData(abatch)[, batch_factors]
    exp_design <- as.data.frame(expInfo)
    expDesignRowN <- nrow(exp_design)
    expDesignColN <- ncol(exp_design)
    my_counter_2 <- 0
    my_sum_2 <- 1
    for (i in ev_n:1) {
        my_sum_2 <- my_sum_2 - percents_PCs[i]
        if ( (my_sum_2) <= threshold) {
            my_counter_2 <- my_counter_2 + 1
        }
    }
    if (my_counter_2 < 3) {
        pc_n <- 3
    }
    else {
        pc_n <- my_counter_2
    }
    pc_data_matrix <- matrix(data=0, nrow= (expDesignRowN *
                                                   pc_n), ncol=1)
    mycounter <- 0
    for (i in 1:pc_n) {
        for (j in 1:expDesignRowN) {
            mycounter <- mycounter + 1
            pc_data_matrix[mycounter, 1] <- eigenVectorsMatrix[j,i]
        }
    }
    AAA <- exp_design[rep(1:expDesignRowN, pc_n), ]
    Data <- cbind(AAA, pc_data_matrix)
    variables <- c(colnames(exp_design))
    for (i in 1:length(variables)) {
        Data$variables[i] <- as.factor(Data$variables[i])
    }
    op <- options(warn= (-1))
    effects_n <- expDesignColN + 1  
    randomEffectsMatrix <- matrix(data=0, nrow=pc_n, ncol=effects_n)
    model.func <- c()
    index <- 1
    for (i in 1:length(variables)) {
        mod <- paste("(1|", variables[i], ")", sep="")
        model.func[index] <- mod
        index <- index + 1
    }
    function.mods <- paste(model.func, collapse=" + ")
    for (i in 1:pc_n) {
        y <- (((i - 1) * expDesignRowN) + 1)
        funct <- paste("pc_data_matrix", function.mods, sep=" ~ ")
        Rm1ML <- lmer(funct, Data[y: ( ( (i - 1) * expDesignRowN) +
                     expDesignRowN), ], REML=TRUE, verbose=FALSE,
                            na.action=na.omit)
        randomEffects <- Rm1ML
        randomEffectsMatrix[i, ] <- c(unlist(VarCorr(Rm1ML)),
                                      resid=sigma(Rm1ML)^2)
    }
    effectsNames <- c(names(getME(Rm1ML, "cnms")), "resid")
    randomEffectsMatrixStdze <- matrix(data=0, nrow=pc_n,
                                       ncol=effects_n)
    for (i in 1:pc_n) {
        mySum <- sum(randomEffectsMatrix[i, ])
        for (j in 1:effects_n) {
            randomEffectsMatrixStdze[i, j] <- randomEffectsMatrix[i,
                                                                 j] / mySum
        }
    }
    randomEffectsMatrixWtProp <- matrix(data=0, nrow=pc_n,
                                        ncol=effects_n)
    for (i in 1:pc_n) {
        weight <- eigenValues[i] / eigenValuesSum
        for (j in 1:effects_n) {
            randomEffectsMatrixWtProp[i, j] <- randomEffectsMatrixStdze[i,j] * weight
        }
    }
    randomEffectsSums <- matrix(data=0, nrow=1, ncol=effects_n)
    randomEffectsSums <- colSums(randomEffectsMatrixWtProp)
    totalSum <- sum(randomEffectsSums)
    randomEffectsMatrixWtAveProp <- matrix(data=0, nrow=1,
                                           ncol=effects_n)
    for (j in 1:effects_n) {
        randomEffectsMatrixWtAveProp[j] <- randomEffectsSums[j] / totalSum
    }
    return(list(dat=randomEffectsMatrixWtAveProp, label=effectsNames))
}
