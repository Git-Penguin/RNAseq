#!/bin/bash

#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=1000M
#SBATCH --time=00:20:00
#SBATCH --job-name=cleanedFastQC
#SBATCH --error=/home/mzimmerli/error_readcounts_%j.e

start_time="$(date -u +%s)"	
touch /home/mzimmerli/fastQC_log.txt
READ_DIR=/data/courses/rnaseq/lncRNAs/Project1/fastq/

fastp -i $READ_DIR$1  | fastqc -t 2 -o /home/mzimmerli/cleanedResultsfastQC

end_time="$(date -u +%s)"
elapsed="$(($end_time-$start_time))"
echo "Total of " $elapsed " seconds elapsed to run fastQC job #" $3  >> /home/mzimmerli/fastQC_log.txt
