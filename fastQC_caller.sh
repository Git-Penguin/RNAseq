#!/bin/bash

#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=1000M
#SBATCH --time=00:30:00
#SBATCH --job-name=fastQC
#SBATCH --error=/home/mzimmerli/error_fastQC_Caller_%j.e
#SBATCH --array=0-23

#assign pairs of two corresponding forward & reverse reads for each replicant

READ_DIR=/data/courses/rnaseq/lncRNAs/Project1/fastq/
CELL_TYPES=("A24wt" "D_Pt2" "D_Pt4" "D_Pt8")
REPLICANTS=("" "1_" "2_" "3_")
PAIR=("R1" "R2")
PAIRS=()
touch /home/mzimmerli/submittedjobs.txt

for i in $(seq 0 3);
	do for j in $(seq 0 3);
		do for k in $(seq 0 1);
			do 	if [ "`ls $READ_DIR | awk /${CELL_TYPES[$i]}_${REPLICANTS[$j]}L[12]_${PAIR[$k]}/`" != "" ];
				#then echo ich sehe file `ls $READ_DIR | awk /${CELL_TYPES[$i]}_${REPLICANTS[$j]}L[12]_${PAIR[$k]}/`;
				then PAIRS+=(`ls $READ_DIR | awk /${CELL_TYPES[$i]}_${REPLICANTS[$j]}L[12]_${PAIR[$k]}/`); 
				fi;
			done;
		done;
	done;

#Call either with or withoutout using fastp for preprocessing 

./fastQC_execute.sh ${PAIRS[`echo "$SLURM_ARRAY_TASK_ID*2" | bc`]} ${PAIRS[`echo "$SLURM_ARRAY_TASK_ID*2+1" | bc`]} $SLURM_ARRAY_TASK_ID
#echo  ${PAIRS[`echo "$SLURM_ARRAY_TASK_ID*2" | bc`]} ${PAIRS[`echo "$SLURM_ARRAY_TASK_ID*2+1" | bc`]} $SLURM_ARRAY_TASK_ID





