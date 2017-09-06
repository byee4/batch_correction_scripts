#!/bin/bash

Rscript scranBatchCorrect.R \
--counts /home/bay001/projects/codebase/batch_correction/data/counts.tsv \
/home/bay001/projects/codebase/batch_correction/data/counts.tsv \
/home/bay001/projects/codebase/batch_correction/data/counts.tsv \
--outdir /home/bay001/projects/codebase/batch_correction/data/scran/
