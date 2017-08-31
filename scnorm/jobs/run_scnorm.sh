#!/bin/bash

Rscript scnorm.R \
--counts /home/bay001/projects/codebase/batch_correction/data/ExampleSimSCData.tsv \
--outdir /home/bay001/projects/codebase/batch_correction/data/ExampleSimSCDataOutputs \
--conditions wt \
--ditherCounts
