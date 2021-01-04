#!/bin/bash
#SBATCH --cpus-per-task=4
#SBATCH --mem-per-cpu=25000M
#SBATCH --time=01:00:00
#SBATCH --job-name=Genelv_nofilter
#SBATCH --error=/data/courses/rnaseq/lncRNAs/Project1/marc/KallistoCounts/Genelv_nofilter_%j.e
#SBATCH --out=/data/courses/rnaseq/lncRNAs/Project1/marc/KallistoCounts/Genelv_nofilter__out_%j.o
module add R/3.6.1;
R --vanilla < Rexecute_gene_filtered.r

