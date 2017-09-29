#!/usr/bin/env Rscript

# Title     : ComBat within group normalization.
# Objective : Adjust for batch effects between two or more samples within the same group.
# Notes     : Assumes matrices are (log) NORMALIZED and FILTERED.
# Created by: brianyee
# Created on: 8/18/17

suppressPackageStartupMessages(library("argparse"))
suppressPackageStartupMessages(library("sva"))
# suppressPackageStartupMessages(library("pamr"))
# suppressPackageStartupMessages(library("limma"))

parser <- ArgumentParser()

parser$add_argument("--counts", type="character", nargs='+')

args <- parser$parse_args()

datas <- list() # list of batches of datasets
batches <- list() # list of batch factors (one per column per dataset)
batch <- 1 # batch number
dims <- list()

for (count in args$counts) {
    countData <- read.table(count, comment.char="#", header=TRUE, row.names=1, sep='\t')
    colnames(countData) <- paste(colnames(countData), batch, sep = "_") # append unique batch ids as to not carry duplicate columns
    datas[[length(datas)+1]] <- countData # add countdata from each batch
    batches <- unlist(c(batches, rep(c(batch), each=length(colnames(countData)))))
    dims <- unlist(c(dims, length(colnames(countData))))
    batch = batch + 1
}

# concatenate all batches into a dataframe; ComBat works on one matrix.
dat <- Reduce(merge, lapply(datas, function(x) data.frame(x, rn = row.names(x)))) # concat (join) multiple batched datasets
rownames(dat) <- dat$rn
dat$rn <- NULL
dat <- as.matrix(dat)

# generate model matrices
df <- data.frame(batches, row.names=colnames(dat))
# mod <- model.matrix(~as.factor(batches), data=df)

modcombat <- model.matrix(~1, data=df)
pdf(paste0(basename(args$counts[b]), "-plotPrior-combat.pdf"))
combatEData <- ComBat(dat=dat, batch=batches, mod=modcombat, par.prior=TRUE, prior.plot=TRUE)
dev.off()

# split matrix into original matrices
counter <- 1
for (b in 1:(batch-1)) {
    subset <- combatEData[,counter:(counter+dims[[b]]-1)]
    write.table(subset, paste0(basename(args$counts[b]), "-normWithinGroup-combat.tsv"), sep="\t", quote=FALSE)
    counter <- counter+dims[b]
}

