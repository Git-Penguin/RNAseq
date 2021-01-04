#!/bin/bash

#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=2500M
#SBATCH --time=01:00:00
#SBATCH --job-name=CPAT
#SBATCH --error=/data/courses/rnaseq/lncRNAs/Project1/marc/CPAT/CPAT_%j.e
#SBATCH --out=/data/courses/rnaseq/lncRNAs/Project1/marc/CPAT/CPAT_%j.o
module add SequenceAnalysis/GenePrediction/cpat/1.2.4;
module add R/3.6.1;
NOVEL_TRANSCRIPTS_FASTA=../KallistoCounts/Index/NovelTranscripts.fa
cpat.py -x Human_Hexamer.tsv -d Human_logitModel.RData -g $NOVEL_TRANSCRIPTS_FASTA -o CPAT_results
echo "confirm CPAT finished" 
#NOTE IN REPORT THAT VERSION 1.2.4 used
