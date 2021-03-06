#!/usr/bin/env Rscript

# Title     : scranWithinSample
# Objective : Normalizes counts matrix using scran 1.4.5 (using scater::normalize)
# Created by: brianyee
# Created on: 8/18/17

suppressPackageStartupMessages(library("argparse"))
suppressPackageStartupMessages(library("scran"))

parser <- ArgumentParser()

parser$add_argument("--counts", type="character")
args <- parser$parse_args()

countData <- read.table(
  args$counts,  comment.char="#", header=TRUE, row.names=1, sep='\t'
)

sce <- newSCESet(countData=countData)
clusters <- quickCluster(sce)
sce <- computeSumFactors(sce, clusters=clusters)

print(summary(sizeFactors(sce)))
sce <- normalize(sce)

# save the normalized counts
write.table(
    norm_exprs(sce),
    file=paste0(basename(args$counts), "-normWithinSample-scran.tsv"),
    sep='\t', na="0", quote=FALSE, row.names=TRUE, col.names=NA
)

# save the Robject
save(sce, file=paste0(basename(args$counts), "-sce-scran.Data"))
