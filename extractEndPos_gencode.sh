#!/bin/bash

gawk -v startpos="" -v endpos="" -v chr="" -v gene_current="" -v strand="" -F $'\t' '
{match($0,/gene_id "([^"]*)"/,gene);
if(gene_current!=gene[1]){print gene_current"\t"chr"\t"startpos"\t"endpos"\t"strand ; startpos=5000000000 ; endpos=0; gene_current=gene[1] ; chr=$1; strand=$7};
if($4<startpos){startpos=$4};
if($5>endpos){endpos=$5}; }
END{print gene_current"\t"chr"\t"startpos"\t"endpos"\t"strand;}
' gencode.v36.annotation.gtf | tail -n+2 > genePositions_gencode.txt

#initial assumption that all entries for same gene are in uninterrupted was wrong --> merge split entries
sort -o genePositions_gencode.txt genePositions_gencode.txt
#now they should be
awk -v startpos="" -v endpos="" -v chr="" -v gene_current="" -v strand="" -F $'\t' '
{if(gene_current!=$1){print chr"\t"startpos"\t"endpos"\t"gene_current"\tNA\t"strand ; startpos=5000000000 ; endpos=0; gene_current=$1 ; chr=$2; strand=$5};
if($3<startpos){startpos=$3};
if($4>endpos){endpos=$4};}
END{print chr"\t"startpos"\t"endpos"\t"gene_current"\tNA\t"strand ;}
' genePositions_gencode.txt | tail -n+2 > temp
rm genePositions_gencode.txt
rename temp genePositions_gencode.txt temp
