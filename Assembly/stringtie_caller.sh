#!/bin/bash

#SBATCH --cpus-per-task=4
#SBATCH --mem-per-cpu=25000M
#SBATCH --time=06:00:00
#SBATCH --job-name=stringtie_merge
#SBATCH --array=0-3
#SBATCH --error=/data/courses/rnaseq/lncRNAs/Project1/marc/hisat_results/error_stringtie_%j.e
#SBATCH --out=/data/courses/rnaseq/lncRNAs/Project1/marc/hisat_results/out_stringtie_%j.o


cd /data/courses/rnaseq/lncRNAs/Project1/marc/hisat_results/
module add UHTS/Aligner/stringtie/1.3.3b

Types=('A24wt' 'D_Pt2' 'D_Pt4' 'D_Pt8')	
echo 'Trying to assemble transcriptome for' ${Types[$SLURM_ARRAY_TASK_ID]}_merged.bam
#Tested again with modified naming in the annotation file (chr1 --> 1 )
stringtie ${Types[$SLURM_ARRAY_TASK_ID]}_merged.bam -G gencode.v36.annotation.gtf -o ${Types[$SLURM_ARRAY_TASK_ID]}_assembly.gtf
echo 'Assembled' ${Types[$SLURM_ARRAY_TASK_ID]}





