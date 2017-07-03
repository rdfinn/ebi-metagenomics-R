warnings()
rm(list=ls())
library(ggplot2)
library(plyr)
library(scales)
# ============================================================
# Tutorial on drawing a heatmap using ggplot2
# by Umer Zeeshan Ijaz (http://userweb.eng.gla.ac.uk/umer.ijaz)
# =============================================================
abund_table<-read.csv("/Users/rdf/Downloads/SPE_pitlatrine.csv",row.names=1,check.names=FALSE)
# Transpose the data to have sample names on rows
abund_table<-t(abund_table)
# Convert to relative frequencies
abund_table <- abund_table/rowSums(abund_table)
library(reshape2)
df<-melt(abund_table)
colnames(df)<-c("Samples","Species","Value")


# We are going to apply transformation to our data to make it
# easier on eyes 

#df<-ddply(df,.(Samples),transform,rescale=scale(Value))
df<-ddply(df,.(Samples),transform,rescale=sqrt(Value))

# Plot heatmap
ggplot(df, aes(Species, Samples)) + 
  geom_tile(aes(fill = rescale),colour = "white") + 
  scale_fill_gradient(low = "white",high = "steelblue")+
  scale_x_discrete(expand = c(0, 0)) +
  scale_y_discrete(expand = c(0, 0)) + theme(legend.position = "none",axis.ticks = element_blank(),axis.text.x = element_text(angle = 90, hjust = 1,size=5),axis.text.y = element_text(size=5))

pdf("Heatmap.pdf")
print(p)


abund_table2<-read.delim("/Users/rdf/Downloads/ERP009703_phylum_taxonomy_abundances_v2.0.tsv", header=1)
require(magrittr); require(tidyr)
# Unite
abund_table2 %<>%
  unite("T", kingdom, phylum, sep=";", remove = TRUE)
rownames(abund_table2) <- abund_table2[,1]
abund_table2 <- abund_table2[, !(colnames(abund_table2) %in% c("T"))]

# Transpose the data to have sample names on rows
abund_table2<-t(abund_table2)
# Convert to relative frequencies
abund_table2<- abund_table2/rowSums(abund_table2)
df<-melt(abund_table2)
colnames(df)<-c("Samples","Taxonomy", "Value")


# We are going to apply transformation to our data to make it
# easier on eyes 
df<-ddply(df,.(Samples),transform,rescale=sqrt(Value))

# Plot heatmap
ggplot(df, aes(Taxonomy, Samples)) + 
  geom_tile(aes(fill = rescale),colour = "white") + 
  scale_fill_gradient(low = "white",high = "lightseagreen")+
  scale_x_discrete(expand = c(0, 0)) +
  scale_y_discrete(expand = c(0, 0)) + theme(legend.position = "none",axis.ticks = element_blank(),axis.text.x = element_text(angle = 90, hjust = 1,size=5),axis.text.y = element_text(size=5))






