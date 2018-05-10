##############################################################################
################                                               ###############
################                GAM ROI Wrapper                ###############
################           Angel Garcia de la Garza            ###############
################              angelgar@upenn.edu               ###############
################                 05/02/2017                    ###############
##############################################################################

print("Loading Libraries")

suppressMessages(require(optparse))
suppressMessages(require(ggplot2))
suppressMessages(require(base))
suppressMessages(require(reshape2))
suppressMessages(require(nlme))
suppressMessages(require(lme4))
suppressMessages(require(gamm4))
suppressMessages(require(stats))
suppressMessages(require(knitr))
suppressMessages(require(mgcv))
suppressMessages(require(plyr))
suppressMessages(require(oro.nifti))
suppressMessages(require(parallel))
suppressMessages(require(optparse))
suppressMessages(require(fslr))
suppressMessages(require(voxel))

##############################################################################
################              Declare Variables               ###############
##############################################################################

print("Reading Arguments")

subjDataName <- "/data/jux/BBL/projects/jirsaraieStructuralIrrit/data/n144_Delta_JLF/n141_Demo+STAXI+QA_20180322.rds"
OutDirRoot <- "/data/jux/BBL/projects/jirsaraieStructuralIrrit/output/n144_Delta_JLF"
inputPath <- "/data/jux/BBL/projects/jirsaraieStructuralIrrit/data/n144_Delta_JLF/n144_jlfAntsCTIntersectionCTdiff_20180403.csv"
inclusionName <- "T1exclude"
subjID <- "bblid,scanid"
covsFormula <- "~DeltaAge+traitanger_log+AvgManRating+sex+TP1ageAtScan1"
pAdjustMethod <- "fdr"
ncores <- 5
residualMap <- FALSE

##############################################################################
################         Load covariates data                  ###############
##############################################################################

print("Loading covariates file")
covaData<-readRDS(subjDataName) ##Read Data
subset <- which(covaData[inclusionName] == 1) ##Find subset for analysis
covaData <- covaData[subset, ] #subset data


##############################################################################
################         Load and merge input dataset          ###############
##############################################################################

print("Loading input dataset")
subjID <- unlist(strsplit(subjID, ","))
inputData <- read.csv(inputPath)
dataSubj <- merge(covaData, inputData, by=subjID)


##############################################################################
################    Create Analysis Directory                  ###############
##############################################################################

print("Creating Analysis Directory")

subjDataOut <- strsplit(subjDataName, ".rds")[[1]][[1]]
subjDataOut <- strsplit(subjDataOut, "/")[[1]][[length(subjDataOut <- strsplit(subjDataOut, "/")[[1]])]]

inputPathOut <- strsplit(inputPath, ".csv")[[1]][[1]]
inputPathOut <- strsplit(inputPathOut, "/")[[1]][[length(inputPathOut <- strsplit(inputPathOut, "/")[[1]])]]

OutDir <- paste0(OutDirRoot, "/n",dim(dataSubj)[1],"_rds_",subjDataOut,"_inclusion_",inclusionName,"_ROI_",inputPathOut)
dir.create(OutDir)
setwd(OutDir)


print("Creating output directory")
outName <- gsub("~", "", covsFormula)
outName <- gsub(" ", "", outName)
outName <- gsub("\\+","_",outName)
outName <- gsub("\\(","",outName)
outName <- gsub("\\)","",outName)
outName <- gsub(",","",outName)
outName <- gsub("\\.","",outName)
outName <- gsub("=","",outName)
outName <- gsub("\\*","and",outName)
outName <- gsub(":","and",outName)

outsubDir <- paste0("gam_formula_",outName)
outsubDir<-paste(OutDir,outsubDir,sep="/")

##############################################################################
################         Execute Models on ROI Dataset         ###############
##############################################################################


print("Analyzing Dataset")

model.formula <- mclapply((dim(covaData)[2] + 1):dim(dataSubj)[2], function(x) {
  
  as.formula(paste(paste0(names(dataSubj)[x]), covsFormula, '+ TP1_', paste0(names(dataSubj)[x]), sep=""))
  
}, mc.cores=ncores)

m <- mclapply(model.formula, function(x) {
  
  foo <- gam(formula = x, data=dataSubj, method="REML")
  summary <- summary(foo)
  residuals <- foo$residuals
  missing <- as.numeric(foo$na.action)
  return(list(summary,residuals, missing))
  
}, mc.cores=ncores)

##############################################################################
################           Generate Residual Dataset           ###############
##############################################################################



if (residualMap) {
  
  print("Generating residuals")
  resiData <- dataSubj
  ids.index <- which(names(resiData) == subjID)
  resiData <- resiData[,ids.index]
  
  for (i in 1:length(m)) {
    
    resiData[, dim(resiData)[2] + 1] <- NA
    resiData[-m[[i]][[3]], dim(resiData)[2]] <- m[[i]][[2]] 
    
  }
  
  names(resiData)[(length(ids.index) + 1):dim(resiData)[2]] <- names(inputData)[-which(names(inputData) == subjID)]
  
  write.csv(resiData, paste0(outsubDir, "_residual.csv"), row.names=F)
}



##############################################################################
################           Generate parameter dataset          ###############
##############################################################################


print("Generating parameters")
## Pull only the first object in list of models (only summary)
m <- mclapply(m, function(x) {
  x[[1]]
}, mc.cores=ncores)


## This code generates a table for the p.table object in gam 
length.names.p <- length(rownames(m[[1]]$p.table))                 

output <- as.data.frame(matrix(NA, 
                               nrow = length((dim(covaData)[2] + 1):dim(dataSubj)[2]), 
                               ncol= (1+3*length.names.p)))

names(output)[1] <- "names"

#For each row in the p.table (for each parameter)
for (i in 1:length.names.p) {
  
  dep.val <- rownames(m[[1]]$p.table)[i]
  names(output)[2 + (i-1)*3 ] <- paste0("tval.",dep.val)
  names(output)[3 + (i-1)*3 ] <- paste0("pval.",dep.val)
  names(output)[4 + (i-1)*3 ] <- paste0("pval.",pAdjustMethod,dep.val)
  
  val.tp <- t(mcmapply(function(x) {
    x$p.table[which(rownames(x$p.table) == dep.val), 3:4]
  }, m, mc.cores=ncores))
  
  output[,(2 + (i-1)*3):(3 + (i-1)*3)] <- val.tp
  output[,(4 + (i-1)*3)] <- p.adjust(output[,(3 + (i-1)*3)], pAdjustMethod)
  
}

output$names <- names(dataSubj)[(dim(covaData)[2] + 1):dim(dataSubj)[2]]
p.output <- output

## If there's a s.table then do the same, merge both datasets and output
## Otherwise just output the p.table dataset (there are no splines in model)

if (is.null(m[[1]]$s.table)) {
  
  write.csv(p.output, paste0(outsubDir, "_tp1CT_coefficients.csv"), row.names=F)
  
} else {
  
  length.names.s <- length(rownames(m[[1]]$s.table))
  output <- as.data.frame(matrix(NA, 
                                 nrow = length((dim(covaData)[2] + 1):dim(dataSubj)[2]), 
                                 ncol= (1+2*length.names.s)))
  
  names(output)[1] <- "names"
  
  for (i in 1:length.names.s) {
    
    dep.val <- rownames(m[[1]]$s.table)[i]
    names(output)[2 + (i-1)*2 ] <- paste0("pval.",dep.val)
    names(output)[3 + (i-1)*2 ] <- paste0("pval.",pAdjustMethod,dep.val)
    
    val.tp <- mcmapply(function(x) {
      x$s.table[which(rownames(x$s.table) == dep.val), 4]
    }, m, mc.cores=ncores)
    
    output[,(2 + (i-1)*2)] <- val.tp
    output[,(3 + (i-1)*2)] <- p.adjust(output[,(2 + (i-1)*2)], pAdjustMethod)
    
  }
  
  output$names <- names(dataSubj)[(dim(covaData)[2] + 1):dim(dataSubj)[2]]
  output <- merge(p.output, output, by="names")
  write.csv(output, paste0(outsubDir, "_coefficients.csv"), row.names=F)
  
}

print("Script Ran Succesfully")
