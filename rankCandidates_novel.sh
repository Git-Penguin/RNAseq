#!/bin/bash

# extract top 10% according to q-value
One_tenth=$(echo "$(wc -l < genelist_cleaned_filtered.txt)/10" | bc)
head -n$One_tenth genelist_cleaned_filtered.txt | awk -F $'\t' '{print $1"\t"$7"\t"NR}' > lowQ
sort -o lowQ lowQ
# technically there are 4 genes in the TrueNovel_non_coding_gene_ID which are actually coding 
# --> They have both coding & non-coding transcripts
# However, since it's only four genes i just checked manually whether or not any of them are included in the output here and they were not, so no need to handle this exception for now (time constraints)

join TrueNovel_non_coding_gene_ID lowQ  > TN_NC_lowQ
sort -k4 -o Intersect_5END Intersect_5END
sort -k4 -o Intersect_3END Intersect_3END
join -1 1 -2 4 TN_NC_lowQ Intersect_5END > TN_NC_lowQ_5END
join -1 1 -2 4 TN_NC_lowQ Intersect_3END > TN_NC_lowQ_3END
sort -o genePositions.txt genePositions.txt
join TN_NC_lowQ genePositions.txt > temp
rm TN_NC_lowQ
rename temp TN_NC_lowQ temp
sort -g -k2 -o TN_NC_lowQ TN_NC_lowQ

sort -o Non_coding_novel_gene_ID Non_coding_novel_gene_ID
join Non_coding_novel_gene_ID lowQ > NC_lowQ
join NC_lowQ genePositions.txt > temp
rm NC_lowQ
rename temp NC_lowQ temp
sort -g -k2 -o NC_lowQ NC_lowQ 
#join -1 1 -2 4 NC_lowQ Intersect_5END > NC_lowQ_5END
#join -1 1 -2 4 NC_lowQ Intersect_3END > NC_lowQ_3END
#join NC_lowQ_5END NC_lowQ_3END > NC_lowQ_doubleEnd
#join NC_lowQ_doubleEnd genePositions.txt > temp
#rm NC_lowQ_doubleEnd
#rename temp NC_lowQ_doubleEnd temp
#sort -g -k2 -o NC_lowQ_doubleEnd NC_lowQ_doubleEnd

