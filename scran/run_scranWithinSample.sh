#!/usr/bin/env bash

# Rscript scranWithinSample.R \
# --counts /home/bay001/projects/codebase/batch_correction/data/counts.tsv \
# --outfile /home/bay001/projects/codebase/batch_correction/data/scranNormedCounts.tsv

cwltool scranWithinSample.cwl scranWithinSample.yaml