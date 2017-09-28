#!/usr/bin/env Rscript

# Title     : combatWithinSample
# Objective : Normalize within a single sample with ComBat within SVA package.
#             Expects an expression dataset (raw counts may not be okay).
# Created by: brianyee
# Created on: 8/18/17

suppressPackageStartupMessages(library("argparse"))
suppressPackageStartupMessages(library("svaseq"))

parser <- ArgumentParser()

parser$add_argument("--counts", type="character")
parser$add_argument("--outfile", type="character")

args <- parser$parse_args()

eData <- read.table(
  args$counts,  comment.char="#", header=TRUE, row.names=1, sep='\t'
)

modcombat <- model.matrix(~1, data=pheno)
combat_edata <- ComBat(dat=eData, batch=batch, mod=modcombat, par.prior=TRUE, prior.plot=TRUE)

normalizedData <- results(dataNorm)
genesNotNormalized <- results(dataNorm, type="GenesFilteredOut")
scaleFactors <- results(dataNorm, type="ScaleFactors")

write.table(normalizedData, args$outfile, sep="\t")
write.table(genesNotNormalized, paste(args$outfile,"genesNotNormalized.txt",sep="."), sep="\t")
write.table(scaleFactors, paste(args$outfile,"scaleFactors.txt",sep="."), sep="\t")