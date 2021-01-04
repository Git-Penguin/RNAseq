#!/bin/bash

#SBATCH --cpus-per-task=4
#SBATCH --mem-per-cpu=25000M
#SBATCH --time=00:30:00
#SBATCH --job-name=genelist_cleanup
#SBATCH --error=/data/courses/rnaseq/lncRNAs/Project1/marc/KallistoCounts/genelist_cleanup_%j.e
#SBATCH --out=/data/courses/rnaseq/lncRNAs/Project1/marc/KallistoCounts/genelist_cleanup_%j.o
READFILE="genelist_filtered.txt"
sed -i 's/"//g' $READFILE
tail -n+2 $READFILE | awk '
BEGIN{gene_id="";print "gene_id\tgene_names\tref_gene_ids\taggregated_transcripts\tsum_mean_obs_counts\tpval\tqval";}
{if($2!=gene_id){print gene_id"\t["gene_names[gene_id]"]\t["ref_gene_id[gene_id]"]\t"aggregated_transcripts[gene_id]"\t"sum_mean_obs_counts[gene_id]"\t"pval[gene_id]"\t"qval[gene_id]; 
gene_id=$2; gene_names[gene_id]=$3; ref_gene_id[gene_id]=$4; aggregated_transcripts[gene_id]=$5; sum_mean_obs_counts[gene_id]=$6; pval[gene_id]=$7;qval[gene_id]=$8}
else{gene_names[gene_id]=gene_names[gene_id] " " $3;ref_gene_id[gene_id]=ref_gene_id[gene_id] " " $4;}}
END{print gene_id"\t["gene_names[gene_id]"]\t["ref_gene_id[gene_id]"]\t"aggregated_transcripts[gene_id]"\t"sum_mean_obs_counts[gene_id]"\t"pval[gene_id]"\t"qval[gene_id]"\t";}
' > genelist_cleaned.txt
