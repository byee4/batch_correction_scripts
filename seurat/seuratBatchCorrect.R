#!/usr/bin/env Rscript

# Title     : seuratBatchCorrect
# Objective : This wraps the 'mnnCorrect' function of seurate 2.0.1, taking
#             multiple expression matrices as separate batches and normalizing
#             based on matching mutual nearest neighbors.
# Website   : http://satijalab.org/seurat/Seurat_AlignmentTutorial.html
# Created by: brianyee
# Created on: 8/18/17

suppressPackageStartupMessages(library("argparse"))
suppressPackageStartupMessages(library("Seurat"))
library('methods') # for some reason the order of this is off
parser <- ArgumentParser()

parser$add_argument("--counts", type="character", nargs='+')
parser$add_argument("--normalize", action="store_true", default=FALSE)
parser$add_argument("--nGenes", type="integer", default=2000)
parser$add_argument("--CCStart", type="integer", default=1)
parser$add_argument("--CCEnd", type="integer", default=13)

args <- parser$parse_args()

# counts = c('/home/bay001/projects/codebase/batch_correction/data/counts.tsv',
# '/home/bay001/projects/codebase/batch_correction/data/counts.tsv')

datas <- list()
hvgs <- list()

batches <- 0

# append each counts table as a separate batch
for (count in 1:length(args$counts)) {
# for (count in 1:length(counts)) {
    batches = batches + 1
    print(paste0("reading in ", args$counts[count]))

    countData <- read.table(args$counts[count],  comment.char="#", header=TRUE, row.names=1, sep='\t')
    # countData <- read.table(counts[count],  comment.char="#", header=TRUE, row.names=1, sep='\t')
    colnames(countData) <- paste(colnames(countData), batches, sep='_')

    print(dim(countData))
    if (args$normalize == TRUE) {
        print("loading, then normalizing and scaling")
        print("Note: FindVariableGenes uses direct input to --counts")
        seuratObj <- CreateSeuratObject(raw.data = countData) # , scale.factor = 1)
        seuratObj <- NormalizeData(object = seuratObj)
        seuratObj <- ScaleData(object = seuratObj)
        seuratObj <- FindVariableGenes(object = seuratObj, do.plot = FALSE)
        seuratObj@meta.data[, "protocol"] <- batches
        # write.table(seuratObj@data, "unnormed.scaled.data.txt")
    }
    else {
        print("loading without normalizationg + scaling")
        print("Note: FindVariableGenes uses direct input to --counts")
        seuratObj <- CreateSeuratObject(
            raw.data = countData,
            normalization.method="DONTDONORMALIZATIONARGH", # doesn't matter what i put here, as long as it's not set to 'logNormalize'
        )
        seuratObj <- ScaleData(object = seuratObj, do.scale=FALSE, do.center=FALSE)
        seuratObj <- FindVariableGenes(object = seuratObj, do.plot = FALSE)
        seuratObj@meta.data[, "protocol"] <- batches
        # write.table(seuratObj@data, "norm.scaled.data.txt")
    }
    # print(seuratObj@var.genes)
    # print(seuratObj@scale.data[1:10,1:10])
    hvg <- rownames(x = head(x = seuratObj@hvg.info, n = args$nGenes))
    datas[[length(datas)+1]] <- seuratObj
    hvgs[[length(hvgs)+1]] <- hvg
}
print("Performing batch correction")
hvg.union <- union(x=hvgs[[1]], y=hvgs[[2]])# Reduce(union, hvgs)  # more than 2 datasets doesn't work anyway.

pbmc <- RunCCA(
  object = datas[[1]],
  object2 = datas[[2]],
  genes.use = hvg.union
)

pdf('QCPlotBeforeFiltering-seurat.pdf')
p1 <- DimPlot(object = pbmc, reduction.use = "cca", group.by = "protocol", pt.size = 0.5,
    do.return = TRUE)

p2 <- VlnPlot(object = pbmc, features.plot = "CC1", group.by = "protocol", do.return = TRUE)
plot_grid(p1, p2)
dev.off()

PrintDim(object = pbmc, reduction.type = "cca", dims.print = 1:2, genes.print = 10)

pdf('QCHeatmapCC-seurat.pdf')
DimHeatmap(object = pbmc, reduction.type = "cca", cells.use = 500, dim.use = 1:20,  #  default viz params
    do.balanced = TRUE)
dev.off()

pbmc <- CalcVarExpRatio(object = pbmc, reduction.type = "pca", grouping.var = "protocol",
    dims.use = args$CCStart:args$CCEnd)

# We discard cells where the variance explained by CCA is <2-fold (ratio < 0.5) compared to PCA

pbmc.all.save <- pbmc

pbmc <- SubsetData(object = pbmc, subset.name = "var.ratio.pca", accept.low = 0.5)  # TODO: add as option?

pbmc.discard <- SubsetData(object = pbmc.all.save, subset.name = "var.ratio.pca",
    accept.high = 0.5)

median(x = pbmc@meta.data[, "nGene"])  # num cells

median(x = pbmc.discard@meta.data[, "nGene"])  # num discarded cells

# batch correct and qcplot with new aligned params
pbmc <- AlignSubspace(object = pbmc, reduction.type = "cca", grouping.var = "protocol",
    dims.align = args$CCStart:args$CCEnd)

pdf("QCPlotAfterFiltering-seurat.pdf")
p1 <- VlnPlot(object = pbmc, features.plot = "ACC1", group.by = "protocol",
    do.return = TRUE)
p2 <- VlnPlot(object = pbmc, features.plot = "ACC2", group.by = "protocol",
    do.return = TRUE)
plot_grid(p1, p2)
dev.off()

print(slotNames(pbmc))

print(attributes(pbmc))

# save the RObject
save(pbmc, file="seuratObj-seurat.Data")
