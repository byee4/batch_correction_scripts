#!/usr/bin/env Rscript

# Title     : scnormWithinSample
# Objective : Normalize within a single sample with scnorm 0.99.7
# Created by: brianyee
# Created on: 8/18/17

suppressPackageStartupMessages(library("argparse"))
suppressPackageStartupMessages(library("SCnorm"))

parser <- ArgumentParser()

parser$add_argument("--counts", type="character")
parser$add_argument("--outfile", type="character")
parser$add_argument("--ditherCounts", action="store_true")
parser$add_argument("--filterCellNum", type="integer", default=10)

args <- parser$parse_args()

countData <- read.table(
  args$counts,  comment.char="#", header=TRUE, row.names=1, sep='\t'
)

conditions <- rep(c(1), each=length(colnames(countData)))
pdf(paste(args$outfile,"MyNormalizedData_k_evaluation.pdf",sep="."))
par(mfrow=c(2,2))
dataNorm <- SCnorm(Data = countData,
    Conditions=conditions,
    PrintProgressPlots = TRUE,
    FilterCellNum = args$filterCellNum,
    NCores=8,
    PropToUse=0.1,
    dither=args$ditherCounts
)

dev.off()

normalizedData <- results(dataNorm)
genesNotNormalized <- results(dataNorm, type="GenesFilteredOut")
scaleFactors <- results(dataNorm, type="ScaleFactors")

write.table(normalizedData, args$outfile, sep="\t")
write.table(genesNotNormalized, paste(args$outfile,"genesNotNormalized.txt",sep="."), sep="\t")
write.table(scaleFactors, paste(args$outfile,"scaleFactors.txt",sep="."), sep="\t")