#!/usr/bin/env Rscript

# Title     : scranBatchCorrect
# Objective : This wraps the 'mnnCorrect' function of scran 1.4.5, taking
#             multiple expression matrices as separate batches and normalizing
#             based on matching mutual nearest neighbors.
# Article   : http://www.biorxiv.org/content/biorxiv/early/2017/07/18/165118.full.pdf
# Created by: brianyee
# Created on: 8/18/17

suppressPackageStartupMessages(library("argparse"))
suppressPackageStartupMessages(library("scran"))

parser <- ArgumentParser()

parser$add_argument("--counts", type="character", nargs='+')
parser$add_argument("--outdir", type="character")
args <- parser$parse_args()

datas <- list()
genes <- list()
# batches <- list()

batches <- 0
# append each counts table as a separate batch
for (count in 1:length(args$counts)) {
    batches = batches + 1
    print(paste0("reading in ", args$counts[count]))
    countData <- read.table(args$counts[count],  comment.char="#", header=TRUE, row.names=1, sep='\t')
    datas[[length(datas)+1]] <- countData
    genes[[length(genes)+1]] <- rownames(countData)
}

intersectingGenes <- Reduce(intersect, genes)

for (i in 1:length(datas)) {
    datas[[i]] <- datas[[i]][intersectingGenes, ]
}

print("Performing batch correction using mnnCorrect.")
corrected <- do.call(mnnCorrect, datas)
print("Writing to outdir.")
for (count in 1:length(args$counts)) {
    write.table(corrected$corrected[count], paste(args$outdir,paste0(basename(args$counts[count]),".corrected2"), sep="/"))
}