#!/usr/bin/env bash

# Rscript seuratWithinSample.R \
# --counts /home/bay001/projects/codebase/batch_correction/data/IntegratedAnalysis_ExpressionMatrices/pbmc_SeqWell.expressionMatrix.txt \
# --outfile /home/bay001/projects/codebase/batch_correction/data/IntegratedAnalysis_ExpressionMatrices/pbmc_SeqWell.expressionMatrix.txt.normed.txt;

# Rscript seuratWithinSample.R \
# --counts /home/bay001/projects/codebase/batch_correction/data/IntegratedAnalysis_ExpressionMatrices/pbmc_10X.expressionMatrix.txt \
# --outfile /home/bay001/projects/codebase/batch_correction/data/IntegratedAnalysis_ExpressionMatrices/pbmc_10X.expressionMatrix.txt.normed.txt;

cwltool seuratWithinSample.cwl seuratWithinSample.yaml