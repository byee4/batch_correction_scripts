#!/usr/bin/env Rscript

# Title     : zscore scaling program
# Objective : Normalize data using a zscore scaling procedure
# Env:      : Use R 3.4.1 from scnorm 0.99.7 module
# Created by: Arthur He
# Created on: 9/22/17

suppressPackageStartupMessages(library("argparse"))

parser <- ArgumentParser()

parser$add_argument("--counts", type="character")

args <- parser$parse_args()

countData <- read.table(
  args$counts,  comment.char="#", header=TRUE, row.names=1, sep='\t'
)

countData <- t(countData) # function uses cells as rows, genes as columns.
normalizedData <- scale(countData)
normalizedData <- t(normalizedData)

write.table(normalizedData, paste0(basename(args$counts), "-normWithinSample-zscore.tsv"), sep="\t")
