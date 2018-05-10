## Age in Dim1 (Psychosis)
brain_dim1_model <- gam(dim1 ~ s(age) + sex , data = brain_df, subset = age >= age_censor, method="REML")
plotdata <- visreg(brain_dim1_model,'age',type = "conditional",scale = "linear", plot = FALSE)
smooths <- data.frame(Variable = plotdata$meta$x, 
                      x=plotdata$fit[[plotdata$meta$x]], 
                      smooth=plotdata$fit$visregFit, 
                      lower=plotdata$fit$visregLwr, 
                      upper=plotdata$fit$visregUpr)
predicts <- data.frame(Variable = "dim1", 
                       x=plotdata$res$age,
                       y=plotdata$res$visregRes)

colpal <- c("Purples","Blues","Oranges","Reds")
colkey <- brewer.pal(8,colpal[1])[c(3:8)]
p_text <- paste("p<10^", round(log(age_sex.pval[[1]], base = 10),0)+1,sep="")
age_dim1<-ggplot() +
  geom_point(data = predicts, aes(x, y, colour = x), alpha= 1  ) +
  scale_colour_gradientn(colours = colkey,  name = "") +
  geom_line(data = smooths, aes(x = x, y = smooth), colour = colkey[6],size=1.2) +
  geom_line(data = smooths, aes(x = x, y=lower), linetype="dashed", colour = colkey[6], alpha = 0.9, size = 0.9) + 
  geom_line(data = smooths, aes(x = x, y=upper), linetype="dashed",colour = colkey[6], alpha = 0.9, size = 0.9) +
  annotate("text",x = -Inf, y = Inf, hjust = -0.1,vjust = 1,label = p_text, parse=TRUE,size = 5, colour = "black",fontface ="italic" ) +
  theme(legend.position = "none") +
  labs(x = "Age (years)", y = "Brain Connectivty Score") 

plotname <- paste('~/Google Drive/CEDRIC/PNC_CCA/Figure Resources/','Fig6_','age_dim1','.pdf',sep="")
pdf(file = plotname, width = 4, height = 3,useDingbats=F)
print(age_dim1)
dev.off()