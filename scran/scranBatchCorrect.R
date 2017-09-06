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
# batches <- list()

batches <- 1
# append each counts table as a separate batch
for (count in 1:length(args$counts)) {
    batches = batches + 1
    print(paste0("reading in ", args$counts[count]))
    countData <- read.table(args$counts[count],  comment.char="#", header=TRUE, row.names=1, sep='\t')

    # colnames(countData) <- paste(colnames(countData), paste(batches, sep='_'), sep = "_")
    # print(dim(countData))
    datas[[length(datas)+1]] <- countData
    # datas <- c(datas, countData)
}
print("Performing batch correction using mnnCorrect.")
corrected <- do.call(mnnCorrect, datas)
print("Writing to outdir.")
for (batch in 1:(batches-1)) {
    print(paste0(basename(args$counts[batch]),".corrected"))
    print(paste(args$outdir,paste0(basename(args$counts[batch]),".corrected"), sep="/"))
    write.table(corrected$corrected[batch], paste(args$outdir,paste0(basename(args$counts[batch]),".corrected"), sep="/"))
}