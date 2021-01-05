#!/bin/bash

#SBATCH --cpus-per-task=4
#SBATCH --mem-per-cpu=25000M
#SBATCH --time=06:00:00
#SBATCH --job-name=Kallisto
#SBATCH --error=/data/courses/rnaseq/lncRNAs/Project1/marc/KallistoCounts/error_Kallisto_%j.e
#SBATCH --out=/data/courses/rnaseq/lncRNAs/Project1/marc/KallistoCounts/Kallisto_out_%j.o

module add UHTS/Analysis/kallisto/0.46.0
module add UHTS/Assembler/cufflinks/2.2.1;

gffread -w metaassembly.fa -g Homo_sapiens.GRCh38.dna.toplevel.fa Metassembly.gtf 
srun kallisto index -i KallistoIndex.idx metaassembly.fa



