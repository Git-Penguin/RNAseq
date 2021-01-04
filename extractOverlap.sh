module add UHTS/Analysis/BEDTools/2.29.2;
#reorder genePositions.txt to bedtool-compatible order
awk '
{chr=$2;start=$3;stop=$4;name=$1;strand=$5;$1=chr;$2=start;$3=stop;$4=name;$5="NA";$6=strand;print $0}
' genePositions.txt > genePositions_ordered.txt
sed -i 's/\s/\t/g' genePositions_ordered.txt
#Already ordered for gencode-gene postions
bedtools intersect -s -v -a genePositions_ordered.txt -b genePositions_gencode.txt > UniqueGenes
bedtools intersect -s -wao -a genePositions_ordered.txt -b genePositions_gencode.txt > OverlapGenes
rm genePositions_ordered.txt
