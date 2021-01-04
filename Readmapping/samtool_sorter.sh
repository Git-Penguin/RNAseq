#!/bin/bash

#SBATCH --cpus-per-task=4
#SBATCH --mem-per-cpu=25000M
#SBATCH --time=06:00:00
#SBATCH --job-name=samtool_sort
#SBATCH --array=0-23
#SBATCH --error=/data/courses/rnaseq/lncRNAs/Project1/marc/error_samtool_sorter_%j.e

# Sorts sam files so that they can then be merged for further processing

cd /data/courses/rnaseq/lncRNAs/Project1/marc/hisat_results/
module add UHTS/Analysis/samtools/1.10

samlist=($(ls *.sam))
samtools sort -o ${samlist[$SLURM_ARRAY_TASK_ID]}_sorted.bam ${samlist[$SLURM_ARRAY_TASK_ID]}
echo 'finished sorting' ${samlist[$SLURM_ARRAY_TASK_ID]}	





