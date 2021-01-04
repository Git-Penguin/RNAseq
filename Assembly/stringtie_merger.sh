#!/bin/bash

#SBATCH --cpus-per-task=4
#SBATCH --mem-per-cpu=25000M
#SBATCH --time=03:00:00
#SBATCH --job-name=stringtie_merge
#SBATCH --error=/data/courses/rnaseq/lncRNAs/Project1/marc/hisat_results/error_stringtie_merge%j.e



cd /data/courses/rnaseq/lncRNAs/Project1/marc/hisat_results/
module add UHTS/Aligner/stringtie/1.3.3b

stringtie --merge *assembly.gtf -G gencode.v36.annotation.gtf -o Merged_assembly.gtf





