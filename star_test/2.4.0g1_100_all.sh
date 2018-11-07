#!/bin/bash

#run 1st pass of STAR 2.4.0g1 with 100 as sjdbOverhang
jid1=$(sbatch --cpus-per-task=12 \
       --mem=40g \
       --time=04:00:00 \
       --gres=lscratch:100 \
       --mail-type=END \
       2.4.0g1_100_1st.sh)

#run 2nd pass of STAR 2.4.0g1 with 100 as sjdbOverhang
jid2=$(sbatch --cpus-per-task=12 \
       --mem=40g \
       --time=04:00:00 \
       --gres=lscratch:100 \
       --mail-type=END \
       --dependency=afterok:$jid1 \
       2.4.0g1_100_2nd.sh)
