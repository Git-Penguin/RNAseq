#!/bin/bash

#SBATCH --cpus-per-task=4
#SBATCH --mem-per-cpu=25000M
#SBATCH --time=06:00:00
#SBATCH --job-name=Kallisto
#SBATCH --error=/data/courses/rnaseq/lncRNAs/Project1/marc/KallistoCounts/error_kallistotest_%j.e
#SBATCH --out=/data/courses/rnaseq/lncRNAs/Project1/marc/KallistoCounts/kallistotest_out_%j.o
#SBATCH --array=0-11
module add UHTS/Analysis/kallisto/0.46.0
offset=$(echo "$SLURM_ARRAY_TASK_ID*4+1" | bc)
#echo $offset
list=$(ls ./links | tail -n+$offset)
#echo $list
set -- $list
NAME=${1::7}
#echo paired $1 with $2 and $3 with $4 under name $NAME >> pair.txt
mkdir $NAME
kallisto quant -i Index/KallistoIndex.idx -o $NAME -b 100 ./links/$1 ./links/$2 ./links/$3 ./links/$4 

