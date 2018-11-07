#!/bin/bash

#run STAR 2.4.1b with 100 for sjdbOverhang
sbatch --cpus-per-task=12 \
       --mem=40g \
       --time=04:00:00 \
       --gres=lscratch:100 \
       --mail-type=END \
       2.4.1b_100.sh


