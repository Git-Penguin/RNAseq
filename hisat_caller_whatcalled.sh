#!/bin/bash

#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=25000M
#SBATCH --time=02:00:00
#SBATCH --job-name=hisat_whatcall
#SBATCH --error=/data/courses/rnaseq/lncRNAs/Project1/marc/error_hisat_whatcalled_%j.e
#SBATCH --array=0-11

#assign pairs of two corresponding forward & reverse reads for each replicant
module add UHTS/Aligner/hisat/2.2.1
READ_DIR=/data/courses/rnaseq/lncRNAs/Project1/fastq/
CELL_TYPES=("A24wt" "D_Pt2" "D_Pt4" "D_Pt8")
REPLICANTS=("" "1_" "2_" "3_")
PAIR=("R1" "R2")
PAIRS=()

for i in $(seq 0 3);
	do for j in $(seq 0 3);
		do for k in $(seq 0 1);
			do 	if [ "`ls $READ_DIR | awk /${CELL_TYPES[$i]}_${REPLICANTS[$j]}L[12]_${PAIR[$k]}/`" != "" ];
				# to check what arguments were passed
				#then echo ich sehe file `ls $READ_DIR | awk /${CELL_TYPES[$i]}_${REPLICANTS[$j]}L[12]_${PAIR[$k]}/`;
				then PAIRS+=(`ls $READ_DIR | awk /${CELL_TYPES[$i]}_${REPLICANTS[$j]}L[12]_${PAIR[$k]}/`); 
				fi;
			done;
		done;
	done;


FIRST_OF_TYPE="${PAIRS[`echo "$SLURM_ARRAY_TASK_ID*4" | bc`]}"
NAME=`echo $FIRST_OF_TYPE | cut -c1-7`

echo  'passed arguments' ${PAIRS[`echo "$SLURM_ARRAY_TASK_ID*4" | bc`]} ${PAIRS[`echo "$SLURM_ARRAY_TASK_ID*4+1" | bc`]} ${PAIRS[`echo "$SLURM_ARRAY_TASK_ID*4+2" | bc`]} ${PAIRS[`echo "$SLURM_ARRAY_TASK_ID*4+3" | bc`]} $NAME 






