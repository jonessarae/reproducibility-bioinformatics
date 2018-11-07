#!/bin/bash

### Script to make genome indices and run 2-pass mapping using STAR version 2.4.1b ###

## Note: SRR2989969 has max read length of 50 ##

export TMPDIR=/lscratch/$SLURM_JOB_ID
export FASTA=/data/jonesse3/ucsc.hg19.fasta
#export GTF=/data/jonesse3/gencode.v19.annotation.gtf
#export GTF=/data/jonesse3/h19.annotation
export GTF=/data/jonesse3/gencode.v19.chr_patch_hapl_scaff.annotation.gtf
export READS="/data/jonesse3/SRR2989969_1.fastq /data/jonesse3/SRR2989969_2.fastq"
export STAR=/data/jonesse3/star2.4.1b.simg

#load singularity
module load singularity

#make directory to hold genome indices
mkdir $TMPDIR/Genome

#go to directory
cd $TMPDIR/Genome

#make genome indices
singularity exec --bind /data/jonesse3,$TMPDIR $STAR STAR \
      --runThreadN $SLURM_CPUS_PER_TASK \
      --runMode genomeGenerate \
      --genomeDir $TMPDIR/Genome \
      --genomeFastaFiles $FASTA \
      --sjdbGTFfile $GTF \
      --sjdbOverhang 100 #default

cd ..

#make directory to hold files 2-pass mode
mkdir $TMPDIR/2pass

#go to directory
cd $TMPDIR/2pass

#run 2pass
singularity exec --bind /data/jonesse3,$TMPDIR $STAR STAR \
      --runThreadN $SLURM_CPUS_PER_TASK \
      --genomeDir $TMPDIR/Genome \
      --readFilesIn $READS \
      --outSAMtype BAM SortedByCoordinate \
      --genomeLoad NoSharedMemory \
      --outFileNamePrefix 2.4.1b_100_ \
      --sjdbGTFfile $GTF \
      --twopassMode Basic

#copy log and bam files to my directory
cp *.bam /data/jonesse3
mkdir -p /data/jonesse3/logs/2.4.1b_100
cp *Log.out *Log.final.out /data/jonesse3/logs/2.4.1b_100


