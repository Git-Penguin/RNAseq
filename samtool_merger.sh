#!/bin/bash

#SBATCH --cpus-per-task=4
#SBATCH --mem-per-cpu=25000M
#SBATCH --time=06:00:00
#SBATCH --job-name=samtool_merge
#SBATCH --array=0-3
#SBATCH --error=/data/courses/rnaseq/lncRNAs/Project1/marc/error_samtool_merger_%j.e

# Merges sorted bam-files

cd /data/courses/rnaseq/lncRNAs/Project1/marc/hisat_results/
module add UHTS/Analysis/samtools/1.10

Types=('A24wt' 'D_Pt2' 'D_Pt4' 'D_Pt8')	
echo 'Trying to merge' ${Types[$SLURM_ARRAY_TASK_ID]}*_sorted.bam
samtools merge ${Types[$SLURM_ARRAY_TASK_ID]}_merged.bam ${Types[$SLURM_ARRAY_TASK_ID]}*_sorted.bam





