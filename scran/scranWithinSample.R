#!/usr/bin/env Rscript

# Title     : scranWithinSample
# Objective : Normalizes counts matrix using scran 1.4.5
# Created by: brianyee
# Created on: 8/18/17

suppressPackageStartupMessages(library("argparse"))
suppressPackageStartupMessages(library("scran"))

parser <- ArgumentParser()

parser$add_argument("--counts", type="character")
parser$add_argument("--outfile", type="character")
args <- parser$parse_args()

countData <- read.table(
  args$counts,  comment.char="#", header=TRUE, row.names=1, sep='\t'
)

# sce <- SingleCellExperiment(countData=countData)
sce <- newSCESet(countData=countData)
print(dim(sce))
clusters <- quickCluster(sce)
sce <- computeSumFactors(sce, clusters=clusters)

print(summary(sizeFactors(sce)))
sce <- normalize(sce)

write.table(norm_exprs(sce), args$outfile, sep='\t', na = "0", quote = FALSE)
