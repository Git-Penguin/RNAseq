#!/bin/bash
#SBATCH --cpus-per-task=4
#SBATCH --mem-per-cpu=25000M
#SBATCH --time=02:00:00
#SBATCH --job-name=SleuthFilter
#SBATCH --error=/data/courses/rnaseq/lncRNAs/Project1/marc/KallistoCounts/error_sleuthfilter_%j.e
#SBATCH --out=/data/courses/rnaseq/lncRNAs/Project1/marc/KallistoCounts/sleuthfilter_out_%j.o
sed -i 's/"//g' obs_norm_filt.txt

# Calculates the mean of the normalized counts for each transcript under normal and cisplatin growth conditions
# Used to calculate foldchange
tail -n+2 obs_norm_filt.txt | awk '
BEGIN{print "transcript\tA24wt_mean\tD_Pt_mean";A24wt_sum=0;D_Pt_sum=0;A24_div=3;DPt_div=9;}
#Rows 1-3 = Control_samples Rows4-12=Cisplatin_treated_samples
NR % 12 == 1 {transcript=$2}
1 <= NR % 12 && NR % 12 <=3 {A24wt_sum+=$4;A24_div+=1}
4 <= NR % 12 && NR % 12 <=11 {D_Pt_sum+=$4;DPt_div+=1}
NR % 12 == 0 {D_Pt_sum+=$4;DPt_div+=1}
NR % 12 == 0 {print transcript"\t"A24wt_sum/A24_div"\t"D_Pt_sum/DPt_div ;A24wt_sum=0;D_Pt_sum=0;A24_div=0;DPt_div=0}
' > means_per_transcript.txt

#Passed to an Rscript because calculating a logarithm in bash is rather tedious
#This calculation is used so that the up-/ or downregulation can be used for the volcano plot later
module add R/3.6.1;
R --vanilla < extract_logchanges.r


sed -i 's/"//g' log_changes.txt
#removes some unnecessary columns
awk 'NR!=1{print $2"\t"$3}' log_changes.txt > log_changes_redux.txt
#sort in place
sort -o log_changes_redux.txt log_changes_redux.txt
sed 's/"//g' Out.txt | awk 'NR!=1{print $2"\t"$3"\t"$4}' | sort > Out_sorted.txt
join -1 1 -2 1 Out_sorted.txt log_changes_redux.txt > Joint_on_logchange.txt
sed -i 's/\s/\t/g' Joint_on_logchange.txt
rm log_changes.txt
rm log_changes_redux.txt
rm Out_sorted.txt
