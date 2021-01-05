#!/bin/bash

#SBATCH --cpus-per-task=4
#SBATCH --mem-per-cpu=25000M
#SBATCH --time=06:00:00
#SBATCH --job-name=Kallisto
#SBATCH --error=/data/courses/rnaseq/lncRNAs/Project1/marc/KallistoCounts/error_kallistotest_%j.e
#SBATCH --out=/data/courses/rnaseq/lncRNAs/Project1/marc/KallistoCounts/kallistotest_out_%j.o
#SBATCH --array=0-11

module add UHTS/Analysis/kallisto/0.46.0
#EACH SLURM JOB HANDLES 4 FILES SO THE NEXT ONE HAS TO JUMP BY 4 POSITIONS
offset=$(echo "$SLURM_ARRAY_TASK_ID*4+1" | bc)
#Links is a directory containing symbolic links to the fastq files
list=$(ls ./links | tail -n+$offset)
#echo $list
set -- $list
NAME=${1::7}
#echo paired $1 with $2 and $3 with $4 under name $NAME >> pair.txt
mkdir $NAME
#Since the 4 fastq files which belong together share most of their name, they appear in order during the -ls call
# THe internal order is ...L1_R1 ...L1_R2 ...L2_R1 ...L2_R2 so $1&$2 and $3&$4 are pairs of forward and reverse reads  
kallisto quant -i Index/KallistoIndex.idx -o $NAME -b 100 ./links/$1 ./links/$2 ./links/$3 ./links/$4 

