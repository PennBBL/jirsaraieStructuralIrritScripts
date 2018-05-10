###################################################################################################
##########################        GRMPY - Scatterplot Creation           ##########################
##########################               Robert Jirsaraie                ##########################
##########################        rjirsara@pennmedicine.upenn.edu        ##########################
##########################                 05/03/2018                    ##########################
###################################################################################################
#####  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  #####
###################################################################################################
#<<USE

#This Script is used to create the Scatterplots that will be presented on the poster and paper.

#USE
###################################################################################################
#####  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  #####
###################################################################################################

##########################################
#### Load the Libraries Needed Into R ####
##########################################

library(mgcv)
library(visreg)
library(ggplot2)
library(cowplot)
library(RColorBrewer)
library(svglite)

############################################
#### Load the Data And Define the Model ####
############################################

RDS<- readRDS("/data/jux/BBL/projects/jirsaraieStructuralIrrit/data/n141_TP2_NMF/n141_Demo+ARI+QA_20180322.rds")
CSV<-read.csv("/data/jux/BBL/projects/jirsaraieStructuralIrrit/data/n137_Rate_NMF/n137_Nmf24BasesCT_COMBAT_Rate.csv")

data.NMF<-merge(RDS,CSV, by=c("bblid","scanid"))
nmfComponents <- names(data.NMF)[grep("Ct_Nmf24",names(data.NMF))]

#Define Formulas

NmfModels <- lapply(nmfComponents, function(x) {
  gam(substitute(i ~ s(ageatscan,k=4) + sex + rating + ari_log, list(i = as.name(x))), method="REML", data = data.NMF)
})

models <- lapply(NmfModels, summary)

############################################
#### Gather ARI RESULTS To be Published ####
############################################

#Pull p-values# ENSURE IT IS THE CORRECT COVARIATE
p_ari <- sapply(NmfModels, function(v) summary(v)$p.table[4,4])
#Convert to data frame
p_ari <- as.data.frame(p_ari)
#Print original p-values to three decimal places
p_ari_round <- round(p_ari,3)
#FDR correct p-values
p_ari_fdr <- p.adjust(p_ari[,1],method="fdr")
#Convert to data frame
p_ari_fdr <- as.data.frame(p_ari_fdr)
#To print fdr-corrected p-values to three decimal places
p_ari_fdr_round <- round(p_ari_fdr,3)
#List the NMF components that survive FDR correction
Nmf_ARI_fdr <- row.names(p_ari_fdr)[p_ari_fdr<0.05]
#Name of the NMF components that survive FDR correction
Nmf_ARI_fdr_names <- nmfComponents[as.numeric(Nmf_ARI_fdr)]
#To check direction of coefficient estimates
ARI_coeff <- models[as.numeric(Nmf_ARI_fdr)]

################################################
### PLOT ARI as a Predictor of CT Network 18 ### 
################################################

plotdata <- visreg(NmfModels[[18]],'ari_log',type = "conditional",scale = "linear", plot = FALSE)
smooths <- data.frame(Variable = plotdata$meta$x,
                      x=plotdata$fit[[plotdata$meta$x]],
                      smooth=plotdata$fit$visregFit,
                      lower=plotdata$fit$visregLwr,
                      upper=plotdata$fit$visregUpr)
predicts <- data.frame(Variable = "dim1",
                       x=plotdata$res$ari_log,
                       y=plotdata$res$visregRes)

colkey <- "#14c0ff"
lineColor<- "#14c0ff"
p_text <- "p[fdr] == 0.004"

Limbic<-ggplot() +
  geom_point(data = predicts, aes(x, y, colour = x), alpha= 1  ) +
  scale_colour_gradientn(colours = colkey,  name = "") +
  geom_line(data = smooths, aes(x = x, y = smooth), colour = lineColor,size=2) +
  geom_line(data = smooths, aes(x = x, y=lower), linetype="dashed", colour = lineColor, alpha = 0.9, size = 1.5) +
  geom_line(data = smooths, aes(x = x, y=upper), linetype="dashed",colour = lineColor, alpha = 0.9, size = 1.5) +
  annotate("text",x = -Inf, y = Inf, hjust = -0.1,vjust = 1,label = p_text, parse=TRUE,size = 8, colour = "black",fontface ="italic" ) +
  theme(legend.position = "none") +
  labs(x = "Irritability (log(ARI+1))", y = "CT of Network 18 (mm)") +
  theme(axis.title=element_text(size=32,face="bold"), axis.text=element_text(size=14), axis.title.x=element_text(color = "black"), axis.title.y=element_text(color = "black"))
  
### Save Scatterplot ###

ggsave(file="/data/jux/BBL/projects/jirsaraieStructuralIrrit/output/NMFfigures/TP2_COMBAT_NMF/ScatterPlot_ctTP2_Network18.png")

###############################################
### PLOT ARI as a Predictor of CT Network 1 ### 
###############################################

plotdata <- visreg(NmfModels[[1]],'ari_log',type = "conditional",scale = "linear", plot = FALSE)
smooths <- data.frame(Variable = plotdata$meta$x,
                      x=plotdata$fit[[plotdata$meta$x]],
                      smooth=plotdata$fit$visregFit,
                      lower=plotdata$fit$visregLwr,
                      upper=plotdata$fit$visregUpr)
predicts <- data.frame(Variable = "dim1",
                       x=plotdata$res$ari_log,
                       y=plotdata$res$visregRes)

colkey <- "#1ad0dd"
lineColor<- "#1ad0dd"
p_text <- "p[fdr] == 0.002"

Limbic<-ggplot() +
  geom_point(data = predicts, aes(x, y, colour = x), alpha= 1  ) +
  scale_colour_gradientn(colours = colkey,  name = "") +
  geom_line(data = smooths, aes(x = x, y = smooth), colour = lineColor,size=2) +
  geom_line(data = smooths, aes(x = x, y=lower), linetype="dashed", colour = lineColor, alpha = 0.9, size = 1.5) +
  geom_line(data = smooths, aes(x = x, y=upper), linetype="dashed",colour = lineColor, alpha = 0.9, size = 1.5) +
  annotate("text",x = -Inf, y = Inf, hjust = -0.1,vjust = 1,label = p_text, parse=TRUE,size = 8, colour = "black",fontface ="italic" ) +
  theme(legend.position = "none") +
  labs(x = "Irritability (log(ARI+1))", y = "CT of Network 1 (mm)") +
  theme(axis.title=element_text(size=32,face="bold"), axis.text=element_text(size=14), axis.title.x=element_text(color = "black"), axis.title.y=element_text(color = "black"))

### Save Scatterplot ###

ggsave(file="/data/jux/BBL/projects/jirsaraieStructuralIrrit/output/NMFfigures/TP2_COMBAT_NMF/ScatterPlot_ctTP2_Network1.png")

###################################################################################################
#####  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  #####
###################################################################################################
