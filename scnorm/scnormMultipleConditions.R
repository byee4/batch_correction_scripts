#!/usr/bin/env Rscript

# Title     : scnormMultipleConditions
# Objective : Normalize multiple conditions with scnorm 0.99.7
# Notes     : Assumes matrices need to be normalized
# Created by: brianyee
# Created on: 8/18/17
suppressPackageStartupMessages(library("argparse"))
suppressPackageStartupMessages(library("SCnorm"))

parser <- ArgumentParser()

parser$add_argument("--counts", type="character", nargs='+')
parser$add_argument("--conditions", type="character", nargs='+')
parser$add_argument("--ditherCounts", action="store_true")
parser$add_argument("--filterCellNum", type="integer", default=10)
args <- parser$parse_args()

datas <- list()
conditions <- list()
dims <- list()
batch <- 1
# append each counts table as a separate batch
for (count in 1:length(args$counts)) {

    cond = args$conditions[count]
    # print(paste0("reading in ", args$counts[count]))
    countData <- read.table(
        args$counts[count],
        comment.char="#",
        header=TRUE,
        row.names=1,
        sep='\t'
    )

    colnames(countData) <- paste(
        colnames(countData),
        paste(cond, batch, sep='_'),
        sep = "_"
    )
    datas[[length(datas)+1]] <- countData
    conditions <- c(conditions, rep(c(cond), each=length(colnames(countData))))
    dims <- unlist(c(dims, length(colnames(countData))))
    batch = batch + 1
    # pdf(paste0("check_count-depth_evaluation",batch,".pdf"), height=5, width=7)
    # countDeptEst <- plotCountDepth(  # in latest devel version but not stable
    #     Data = countData, Conditions = rep(c(batch), length(colnames(countData))),
    #     FilterCellProportion = .1, NCores=4
    # )
    # dev.off()
}
dat <- Reduce(merge, lapply(datas, function(x) data.frame(x, rn = row.names(x))))
rownames(dat) <- dat$rn
dat$rn <- NULL
conditions <- unlist(conditions, recursive=FALSE)
# plot the un normalized expression in each batch
pdf(paste0(basename(args$counts),"-normalizedData-k-evaluation-scnorm.pdf"))
par(mfrow=c(2,2))
dataNorm <- SCnorm(Data = dat,
    Conditions = unclass(factor(conditions)),
    PrintProgressPlots = TRUE,
    FilterCellNum = args$filterCellNum,
    NCores=8,
    PropToUse=0.1,
    dither=args$ditherCounts
)

dev.off()

### in stable version but not devel ###

# i <- length(dataNorm)

# for (count in args$counts) {
#     write.table(
#         as.data.frame(dataNorm[i]),
#         paste("normalizedData",i,".txt", sep=''),
#         sep="\t",
#         col.names=TRUE,
#         row.names=TRUE
#     )
#     i = i + 1
# }

### in latest devel version but not stable: ###

normalizedData <- results(dataNorm)
genesNotNormalized <- results(dataNorm, type="GenesFilteredOut")
scaleFactors <- results(dataNorm, type="ScaleFactors")


# split matrix into original matrices
counter <- 1
for (b in 1:(batch-1)) {
    normalizedDataSubset <- normalizedData[,counter:(counter+dims[[b]]-1)]
    write.table(
        normalizedDataSubset,
        paste0(basename(args$counts[b]),"-between-conditions-normalization-scnorm.tsv"),
        sep="\t",
        quote=FALSE
    )
    counter <- counter+dims[b]
}


write.table(
    genesNotNormalized,
    "genesNotNormalized-scnorm.txt",
    sep="\t"
)
write.table(
    scaleFactors,
    "scaleFactors-scnorm.txt",
    sep="\t"
)
