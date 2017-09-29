#!/usr/bin/env Rscript

# Title     : scnormWithinSample
# Objective : Normalize within a single sample with scnorm 0.99.7
# Created by: brianyee
# Created on: 8/18/17

suppressPackageStartupMessages(library("argparse"))
suppressPackageStartupMessages(library("SCnorm"))

parser <- ArgumentParser()

parser$add_argument("--counts", type="character")
parser$add_argument("--ditherCounts", action="store_true")
parser$add_argument("--filterCellNum", type="integer", default=10)

args <- parser$parse_args()

countData <- read.table(
  args$counts,  comment.char="#", header=TRUE, row.names=1, sep='\t'
)

conditions <- rep(c(1), each=length(colnames(countData)))
pdf(paste0(basename(args$counts),"-normalizedData-k-evaluation-scnorm.pdf"))
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

# write the normalized matrix
write.table(normalizedData, paste0(basename(args$counts), "-within-sample-normalization-scnorm.tsv"), sep="\t")

# write other intermediate matrices
write.table(genesNotNormalized, paste0(basename(args$counts),"-genesNotNormalized-scnorm.txt"), sep="\t")
write.table(scaleFactors, paste0(basename(args$counts),"-scaleFactors-scnorm.txt"), sep="\t")

# write the robject
save(dataNorm, file=paste0(basename(args$counts), "-dataNorm-scnorm.Data"))
