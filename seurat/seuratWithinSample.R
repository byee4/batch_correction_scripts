#!/usr/bin/env Rscript

# Title     : Seurat log normalization and scaling
# Objective : TODO
# Created by: brianyee
# Created on: 8/17/17

suppressPackageStartupMessages(library("argparse"))
suppressPackageStartupMessages(library("Seurat"))
library('methods')

parser <- ArgumentParser()

parser$add_argument("--counts", type="character")

args <- parser$parse_args()

countData <- read.table(
  args$counts,  comment.char="#", header=TRUE, row.names=1, sep='\t'
)

seuratObject <- CreateSeuratObject(raw.data = countData)
seuratObject <- NormalizeData(object = seuratObject)
seuratObject <- ScaleData(object = seuratObject)

write.table(seuratObject@scale.data, paste0(basename(args$counts), "-normWithinSample-seurat.tsv"), sep="\t", quote=FALSE)
# write.table(seuratObject@data, paste0(args$outfile,'.normed'), sep="\t", quote=FALSE)


# write the robject
save(seuratObject, file=paste0(basename(args$counts), "-seuratObj.Data"))
