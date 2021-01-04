#!/bin/bash

#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=1000M
#SBATCH --time=00:10:00
#SBATCH --job-name=fastQC
#SBATCH --error=/home/mzimmerli/error_readcounts_%j.e

start_time="$(date -u +%s)"	
touch /home/mzimmerli/fastQC_log.txt
READ_DIR=/data/courses/rnaseq/lncRNAs/Project1/fastq/

fastqc -t 2 -o /home/mzimmerli/fastQC_results $READ_DIR$1
fastqc -t 2 -o /home/mzimmerli/fastQC_results $READ_DIR$2

end_time="$(date -u +%s)"
elapsed="$(($end_time-$start_time))"
echo "Total of " $elapsed " seconds elapsed to run fastQC job #" $3  >> /home/mzimmerli/fastQC_log.txt
