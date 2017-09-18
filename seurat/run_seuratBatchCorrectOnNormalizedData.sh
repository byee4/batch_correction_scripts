#!/bin/bash

Rscript seuratBatchCorrect.R \
--counts /home/bay001/projects/codebase/batch_correction/seurat/data/IntegratedAnalysis_ExpressionMatrices/pbmc_10X.expressionMatrix.txt.normed.txt \
/home/bay001/projects/codebase/batch_correction/seurat/data/IntegratedAnalysis_ExpressionMatrices/pbmc_SeqWell.expressionMatrix.txt.normed.txt \
--outdir /home/bay001/projects/codebase/batch_correction/data/
