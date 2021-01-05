#!/bin/bash
#FILE HAS TO BE PRE-SORTED by qvalue for ranking
KNOWNGENES=("BRCA1" "BRCA2" "ABCC2" "ERCC1" "BCL2[^LA1]" "MDM2" "EGFR[^\-]" "ERBB2" "PTEN" "AKT1[^S]" "BIRC5")
END_OF_ARRAY=10
GENES_TOTAL=$(wc -l < genelist_cleaned_filtered.txt)
for i in $(seq 0 $END_OF_ARRAY); 
do awk -v gene=${KNOWNGENES[$i]} -v total=$GENES_TOTAL '$0~gene{print "found " gene " at rank " NR " out of " total " \(top " 100 * NR / total " percent\) "}' genelist_cleaned_filtered.txt
done 
		
