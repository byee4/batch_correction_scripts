# Title     : TODO
# Objective : TODO
# Created by: brianyee
# Created on: 9/15/17

library(Seurat)
# cowplot enables side-by-side ggplots
library(cowplot)
library('methods') # for some reason the order of this is off

# load data
seqwell.data <- read.table(file = paste0("/home/bay001/projects/codebase/batch_correction/seurat/data/IntegratedAnalysis_ExpressionMatrices/",
    "pbmc_SeqWell.expressionMatrix.txt"))
tenx.data <- read.table(file = paste0("/home/bay001/projects/codebase/batch_correction/seurat/data/IntegratedAnalysis_ExpressionMatrices/",
    "pbmc_10X.expressionMatrix.txt"))

# setup Seurat objects since both count matrices have already filtered
# cells, we do no additional filtering here

seqwell <- CreateSeuratObject(raw.data = seqwell.data)
seqwell <- NormalizeData(object = seqwell)
seqwell <- ScaleData(object = seqwell)
seqwell <- FindVariableGenes(object = seqwell, do.plot = FALSE)

tenx <- CreateSeuratObject(raw.data = tenx.data)
tenx <- NormalizeData(object = tenx)
tenx <- ScaleData(object = tenx)
tenx <- FindVariableGenes(object = tenx, do.plot = FALSE)

# we will take the union of the top 2k variable genes in each dataset for
# alignment note that we use 1k genes in the manuscript examples, you can
# try this here with negligible changes to the overall results
hvg.seqwell <- rownames(x = head(x = seqwell@hvg.info, n = 2000))
hvg.tenx <- rownames(x = head(x = tenx@hvg.info, n = 2000))
hvg.union <- union(x = hvg.seqwell, y = hvg.tenx)

# lastly, we set the 'protocol' in each dataset for easy identification
# later it will be transferred to the merged object in RunCCA
tenx@meta.data[, "protocol"] <- "10X"
seqwell@meta.data[, "protocol"] <- "SeqWell"


pbmc <- RunCCA(object = tenx, object2 = seqwell, genes.use = hvg.union)

pdf("QCPlotBeforeFilteringTutorial.pdf")
# visualize results of CCA plot CC1 versus CC2 and look at a violin plot
p1 <- DimPlot(object = pbmc, reduction.use = "cca", group.by = "protocol", pt.size = 0.5,
    do.return = TRUE)
p2 <- VlnPlot(object = pbmc, features.plot = "CC1", group.by = "protocol", do.return = TRUE)
plot_grid(p1, p2)
dev.off()

PrintDim(object = pbmc, reduction.type = "cca", dims.print = 1:2, genes.print = 10)

pdf("QCHeatmapCCTutorial.pdf")
DimHeatmap(object = pbmc, reduction.type = "cca", cells.use = 500, dim.use = 1:9,
    do.balanced = TRUE)
dev.off()

pbmc <- CalcVarExpRatio(object = pbmc, reduction.type = "pca", grouping.var = "protocol",
    dims.use = 1:13)

# We discard cells where the variance explained by CCA is <2-fold (ratio <
# 0.5) compared to PCA
pbmc.all.save <- pbmc
pbmc <- SubsetData(object = pbmc, subset.name = "var.ratio.pca", accept.low = 0.5)

pbmc.discard <- SubsetData(object = pbmc.all.save, subset.name = "var.ratio.pca",
    accept.high = 0.5)
median(x = pbmc@meta.data[, "nGene"])

median(x = pbmc.discard@meta.data[, "nGene"])

pdf("QCViolinPlot_PF4.pdf")
VlnPlot(object = pbmc.discard, features.plot = "PF4", group.by = "protocol")
dev.off()

pbmc <- AlignSubspace(object = pbmc, reduction.type = "cca", grouping.var = "protocol",
    dims.align = 1:13)

pdf("QCPlotAfterFiltering.pdf")
p1 <- VlnPlot(object = pbmc, features.plot = "ACC1", group.by = "protocol",
    do.return = TRUE)
p2 <- VlnPlot(object = pbmc, features.plot = "ACC2", group.by = "protocol",
    do.return = TRUE)
plot_grid(p1, p2)
dev.off()