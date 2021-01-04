#!/bin/bash
awk -v maxLap=0 -v lapStart=0 -v lapStop=0 -v lapGene="" -v qval="" -v qrank="" -v chr="" -v startPos="" -v stopPos="" -v strand="" '
BEGIN{gene_id="";print "GeneID\tqval\tqrank\tchr\tstart\tstop\tstrand\tMostOverlapping\tstart\tstop\tSizeOfOverlap"}
{
if($1!=gene_id){
print gene_id"\t"qval"\t"qrank"\t"chr"\t"startPos"\t"stopPos"\t"strand"\t"lapGene"\t"lapStart"\t"lapStop"\t"maxLap;
gene_id=$1 ; qval=$2; qrank=$3; chr=$4; startPos=$5; stopPos=$6; strand=$7;  lapStart=$14 ; lapStop=$15 ; lapGene=$16; maxLap=$19}
}
{if($19>maxLap){lapStart=$14;lapStop=$15;lapGene=$16;maxLap=$19}}
END{print gene_id"\t"qval"\t"qrank"\t"chr"\t"startPos"\t"stopPos"\t"strand"\t"lapGene"\t"lapStart"\t"lapStop"\t"maxLap;}
' NC_lowQ_overlap | awk '$NF!=0 && NR!=2' > NC_lowQ_overlap_cleaned
