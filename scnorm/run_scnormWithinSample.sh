#!/usr/bin/env bash

# Rscript scnormWithinSample.R \
# --counts /home/bay001/projects/codebase/batch_correction/data/ExampleSimSCData.tsv \
# --outfile /home/bay001/projects/codebase/batch_correction/data/ExampleSimSCDataOutputs/normalizedExampleSimSCData.tsv \
# --ditherCounts

cwltool scnormWithinSample.cwl scnormWithinSample.yaml