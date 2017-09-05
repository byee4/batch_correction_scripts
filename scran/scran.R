# Title     : TODO
# Objective : TODO
# Created by: brianyee
# Created on: 8/18/17

suppressPackageStartupMessages(library("argparse"))
suppressPackageStartupMessages(library("scran"))

parser <- ArgumentParser()

parser$add_argument("--counts", type="character", nargs='+')
parser$add_argument("--conditions", type="character", nargs='+')
parser$add_argument("--outdir", type="character")

args <- parser$parse_args()

for (count in args$counts) {
    countData <- read.table(count,  comment.char="#", header=TRUE, row.names=1, sep='\t')
    sce <- newSCESet(countData=countData)
    print(dim(sce))
    # mm.pairs <- readRDS(system.file("exdata", "mouse_cycle_markers.rds", package="scran"))
    # assigned <- cyclone(sce, pairs=mm.pairs)
    # print(head(assigned$scores))
    high.ab <- calcAverage(sce) > 1
    sce <- computeSumFactors(sce, subset.row=high.ab)
    print(summary(sizeFactors(sce)))
    sce <- normalize(sce)
}
