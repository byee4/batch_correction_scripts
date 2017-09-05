#!/usr/bin/env bash

python run_combat.py \
--counts /home/bay001/projects/batch_effect_20170817/data/scnorm/group1.matrix.txt.formatted2.50.3.txt \
/home/bay001/projects/batch_effect_20170817/data/scnorm/group2.matrix.txt.formatted2.50.3.txt \
/home/bay001/projects/batch_effect_20170817/data/scnorm/group4.matrix.txt.formatted2.50.3.txt \
/home/bay001/projects/batch_effect_20170817/data/scnorm/Group5.matrix.txt.formatted2.50.3.txt \
/home/bay001/projects/batch_effect_20170817/data/scnorm/Group8.matrix.txt.formatted2.50.3.txt \
--batches xyz \
--outfile corrected.tsv