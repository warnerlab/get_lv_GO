master <- read.table(file="/Users/warnerj/Documents/Warner_lab/Collabs/Lv_gastrulation/master_annotations.txt", sep = '\t',header=T, fill=T)
spu2GO<- read.table(file = "GO_mappings.txt", sep='\t', quote="", header=T)

#this code chunk matches the GOs to the regen moduels and parses them
spu2GO <- spu2GO[c(1,2)]
colnames(spu2GO) <- c("SPU.ID","GO")

library(plyr)
library(topGO)
meta_GO <- merge(master, spu2GO, by.x = "SPU.ID",by.y = "SPU.ID", all.x = TRUE)

#get just the GO
meta_GO_Bkg <- meta_GO[c(1,81)]
#remove transcripts with no terms:
meta_GO_Bkg[meta_GO_Bkg==""]<-NA
meta_GO_Bkg <- meta_GO_Bkg[complete.cases(meta_GO_Bkg),]

#apparently our python script didn't accomodate the fact that different transripts would have that same SPUIDs 
#this is a work around:
meta_GO_Bkg <- unique(meta_GO_Bkg)


#write it:
write.table(meta_GO_Bkg, file = "meta_GO_Bkg_parsed.txt", sep="\t", quote = F, row.names=F)

#this reads in and parses the GO terms
geneID2GO <- readMappings(file = "meta_GO_Bkg_parsed.txt", IDsep = ";")

#this pulls the gene names from the GO_IDs
geneNames <- names(geneID2GO)
head(geneNames)

#Ok now lets try and loop it
modules = names(table(master$module))
for (m in modules){
  myInterestingGenes <- master[c(which(master$module == m )),]
  myInterestingGenes <- myInterestingGenes$SPU.ID
  
  #this creates a string with 0 to 1 for match to black
  geneList <- factor(as.integer(geneNames %in% myInterestingGenes))
  names(geneList) <- geneNames
  str(geneList)
  
  #populate the list
  GOdata <- new("topGOdata", ontology = "BP", allGenes = geneList,
                annot = annFUN.gene2GO, gene2GO = geneID2GO)
  GOdata
  
  #run the Fisher test
  resultFisher <- runTest(GOdata, algorithm = "classic", statistic = "fisher")
  resultFisher
  
  #output the results
  allRes <- GenTable(GOdata, classicFisher = resultFisher,
                     orderBy = "classicFisher", ranksOf = "classicFisher", topNodes = 500)
  #cutoff the results at 0.05
  allRes <- allRes[c(which(allRes$classicFisher < 0.02)),]
  file = paste("GO_",m,"_TOpGO_fisher_BP.txt",sep="")
  write.table(allRes, file = file, sep='\t', quote=F, row.names = F)
}