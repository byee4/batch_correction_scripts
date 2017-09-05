#!/bin/bash

Rscript scnorm.R \
--counts /home/bay001/projects/batch_effect_20170817/data/scnorm/group1.matrix.txt.formatted2.txt \
/home/bay001/projects/batch_effect_20170817/data/scnorm/group2.matrix.txt.formatted2.txt \
--conditions 1 1 \
--outdir /home/bay001/projects/batch_effect_20170817/data/scnorm/outputs \
--ditherCounts
