#!/usr/bin/env Rscript

# Title     : TPM normalization
# Objective : Normalize within a single sample using Arthur's TPM calculations
# Created by: Arthur He
# Created on: 9/22/17

suppressPackageStartupMessages(library("argparse"))

parser <- ArgumentParser()

parser$add_argument("--counts", type="character")
parser$add_argument("--outfile", type="character")

args <- parser$parse_args()

countData <- read.table(
  args$counts,  comment.char="#", header=TRUE, row.names=1, sep='\t'
)

countData <- t(countData) # function uses cells as rows, genes as columns.
normalizedData <- apply(countData,1,function(x){x/sum(x)*10000000})
normalizedData <- t(normalizedData)

write.table(normalizedData, args$outfile, sep="\t")
