#!/usr/bin/env Rscript

# Title     : boilerplate for Rscripts
# Objective : use this as a template for argparsing stuff
# Created by: brianyee
# Created on: 9/29/17

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

y <- convertTo(sce, type="DESeq2")

save(y, file="DESEQ2.RData")