#!/usr/bin/env Rscript

# Title     : zscore scaling program
# Objective : Normalize data using a scaling procedure
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
normalizedData <- scale(countData)
normalizedData <- t(normalizedData)

write.table(normalizedData, args$outfile, sep="\t")
