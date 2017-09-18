#!/usr/bin/env bash

# Rscript seuratBatchCorrect.R \
# --counts /home/bay001/projects/codebase/batch_correction/data/IntegratedAnalysis_ExpressionMatrices/pbmc_10X.expressionMatrix.txt \
# /home/bay001/projects/codebase/batch_correction/data/IntegratedAnalysis_ExpressionMatrices/pbmc_SeqWell.expressionMatrix.txt \
# --outdir /home/bay001/projects/codebase/batch_correction/seurat/data/ \
# --normalize

cwltool seuratBatchCorrect.cwl seuratBatchCorrect.yaml