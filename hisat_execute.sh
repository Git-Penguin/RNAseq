#!/bin/bash

#SBATCH --cpus-per-task=4
#SBATCH --mem-per-cpu=25000M
#SBATCH --time=06:00:00
#SBATCH --job-name=hisat
#SBATCH --error=/data/courses/rnaseq/lncRNAs/Project1/marc/error_hisat_execute_%j.e
module add UHTS/Aligner/hisat/2.2.1
start_time="$(date -u +%s)"	
touch /home/mzimmerli/hisat_log.txt
READ_DIR=/data/courses/rnaseq/lncRNAs/Project1/fastq/

#hisat2 -x genome_snp_tran -1 $READ_DIR$1,$READ_DIR$2 -2 $READ_DIR$3,$READ_DIR$4 -S ${5}.sam
hisat2 -x genome_snp_tran -1 $READ_DIR$1 -2 $READ_DIR$3 -S ${5}part1.sam
echo 'finished hisat for' $READ_DIR$1 'and' $READ_DIR$3 'and saved it under' ${5}'part1.sam' 
hisat2 -x genome_snp_tran -1 $READ_DIR$2 -2 $READ_DIR$4 -S ${5}part2.sam
echo 'finished hisat for' $READ_DIR$2 'and' $READ_DIR$4 'and saved it under' ${5}'part2.sam'
#echo "hisat2 -x genome_snp_tran -1 $READ_DIR$1 -2 $READ_DIR$3 -S ${5}.sam"
#echo "hisat2 -x genome_snp_tran -1 $READ_DIR$2 -2 $READ_DIR$4 -S ${5}.sam"

end_time="$(date -u +%s)"
elapsed="$(($end_time-$start_time))"
echo "Total of " $elapsed " seconds elapsed to run hisat job (four files)#" $3  >> /home/mzimmerli/hisat_log.txt
#good execution example
#hisat2 -x genome -1 /data/courses/rnaseq/lncRNAs/Project1/fastq/A24wt_L1_R1_001_RDviaABMUWPd.fastq.gz -2 /data/courses/rnaseq/lncRNAs/Project1/fastq/A24wt_L1_R2_001_WgZDlT4XFpgi.fastq.gz -S hit
