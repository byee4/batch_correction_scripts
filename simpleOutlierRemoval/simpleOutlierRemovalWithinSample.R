#!/usr/bin/env Rscript

# Title     : scranWithinSample
# Objective : Look at all genes, and their distribution.
#             First remove 0 counts.
#             Change any gene whose expression value is greater than 50 fold
#             over the mean expression. Then look at each cell, remove
#             cells with total read count more than 10 fold over
#             the mean of the cell read count.
# Created by: brianyee
# Created on: 8/18/17

suppressPackageStartupMessages(library("argparse"))

parser <- ArgumentParser()

parser$add_argument("--counts", type="character")
args <- parser$parse_args()

countData <- read.table(
  args$counts,  comment.char="#", header=TRUE, row.names=1, sep='\t'
)

ExpressionMat <- t(countData)

#filter the unused gene
ExpressionMat=ExpressionMat[rowSums(ExpressionMat)>2,]

#filter based on UMI
#only the gene that have 1 UMI in more than 1% of cells are counted as valid
ExpressionBinaryMat=ExpressionMat>=1
ExpressionMat=t(ExpressionMat[rowSums(ExpressionBinaryMat)>ncol(ExpressionMat)/100,])
#filter cell that has fewer than 50 UMI
tosave=which(rowSums(ExpressionMat)>50)
ExpressionMat=ExpressionMat[tosave,]
batch=batch[tosave]

rm(ExpressionBinaryMat)

#remove duplicate cells
duplicate_cell=which(duplicated(ExpressionMat))
if(length(duplicate_cell)>0){
    batch=batch[-duplicate_cell]
    ExpressionMat=ExpressionMat[-duplicate_cell,]
}

#remove super high expression cell
cellsize=rowSums(ExpressionMat)
mean_cellsize=mean(cellsize)
sup_cell=which(rowSums(ExpressionMat)>20*mean_cellsize)
if(length(sup_cell)>0){
    batch=batch[-sup_cell]
    ExpressionMat=ExpressionMat[-sup_cell,]
}

#rm abnormal expression for each gene
for(i in 1:ncol(ExpressionMat)){
    tag=ExpressionMat[,i]
    tag=tag[tag!=0]
    demax_mean=(sum(tag)-max(tag))/(length(tag)-1)
    if(max(tag)/demax_mean>50){
        ExpressionMat[ExpressionMat[,i]>demax_mean*50,i]=demax_mean*50
    }
}

write.table(ExpressionMat, paste0(basename(args$counts), "-outlierRemoved-simpleOutlierRemovalWithinSample.tsv"), sep="\t")
