#!/bin/bash
#FILE HAS TO BE PRE-SORTED by qvalue for ranking
#In reality the initial scan for these genes was done manually - during those manual checks, the original reg_expressions raised false hits because other genes contain
#the expression as a substring - since it weren't too many i just adjusted the exclusion sets to only show the ones i wanted
#The only reason this was retroactively put into script form is so that the results can be reproduced quickly
KNOWNGENES=("BRCA1" "BRCA2" "ABCC2" "ERCC1" "BCL2[^LA1]" "MDM2" "EGFR[^\-]" "ERBB2" "PTEN" "AKT1[^S]" "BIRC5")
END_OF_ARRAY=10
GENES_TOTAL=$(wc -l < genelist_cleaned_filtered.txt)
for i in $(seq 0 $END_OF_ARRAY); 
do awk -v gene=${KNOWNGENES[$i]} -v total=$GENES_TOTAL '$0~gene{print "found " gene " at rank " NR " out of " total " \(top " 100 * NR / total " percent\) "}' genelist_cleaned_filtered.txt
done 
		
