# Title     : TODO
# Objective : TODO
# Created by: brianyee
# Created on: 8/18/17

suppressPackageStartupMessages(library("argparse"))
suppressPackageStartupMessages(library("Scran"))

parser <- ArgumentParser()

parser$add_argument("--counts", type="character", nargs=Inf)

args <- parser$parse_args()

for (count in args$counts) {
    countData <- read.table(count,  comment.char="#", header=TRUE, row.names=1, sep='\t')
    print(countData[1:10,1:10])
}

