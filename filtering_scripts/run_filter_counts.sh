#!/usr/bin/env bash

python filter_counts.py \
--counts /home/bay001/projects/batch_effect_20170817/data/scnorm/Group8.matrix.txt.formatted2.txt \
--filtered_counts /home/bay001/projects/batch_effect_20170817/data/scnorm/Group8.matrix.txt.formatted2.50.3.txt \
--min_columns 50 \
--min_count 3