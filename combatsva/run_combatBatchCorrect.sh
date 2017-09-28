#!/bin/bash

# Rscript combatBatchCorrect.R \
# --counts /home/bay001/projects/codebase/batch_correction/data/bladderEsetBatch1.txt \
# /home/bay001/projects/codebase/batch_correction/data/bladderEsetBatch2.txt \
# /home/bay001/projects/codebase/batch_correction/data/bladderEsetBatch3.txt \
# /home/bay001/projects/codebase/batch_correction/data/bladderEsetBatch4.txt \
# /home/bay001/projects/codebase/batch_correction/data/bladderEsetBatch5.txt \
# --outdir /home/bay001/projects/codebase/batch_correction/combatsva/data/

cwltool combatBatchCorrect.cwl combatBatchCorrect.yaml