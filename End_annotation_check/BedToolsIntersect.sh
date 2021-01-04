#!/bin/bash

#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=2500M
#SBATCH --time=01:00:00
#SBATCH --job-name=Bedtools_Intersect
#SBATCH --error=/data/courses/rnaseq/lncRNAs/Project1/marc/END_ANNOT/Bedtools_Intersect%j.e
#SBATCH --out=/data/courses/rnaseq/lncRNAs/Project1/marc/END_ANNOT/Bedtools_Intersect_%j.o
module add UHTS/Analysis/BEDTools/2.29.2;


CAGE_FILE=hg38_liftover+new_CAGE_peaks_phase1and2.bed
POLYA_FILE=atlas.clusters.2.0.GRCh38.96.bed
TRANSCR_ENDS=TranscriptEnds.gtf
WINDOW_MARGIN=50


#get the TSS from the CAGE files
#Though bedtools offers some flexibility in regards to input format, using only chromosome, startPos, endPos & strand
#did not work, so the two NA values were added so that the 4 types of information are in the columns they would be in
#in a bed file
awk '{print $1,$7,$8,"NA","NA",$6}' $CAGE_FILE > CAGE_5ENDS.bed
sed -i -e 's/chr//' CAGE_5ENDS.bed
sed -i -e 's/M/MT/' CAGE_5ENDS.bed
sed -i -e 's/\s/\t/g' CAGE_5ENDS.bed 

#get polyA sites from polyA_atlas ; no polyA-sites for mt chromosome so no need to handle that case
awk '{print $1,$2,$3,$4,$5,$6}' $POLYA_FILE > POLYA_3ENDS.bed
sed -i -e 's/\s/\t/g' POLYA_3ENDS.bed

#get 5'END from transcripts as mapped by hisat
#Here, gene_ID and transcript id are included in columns 4&5 as they will be used later so might as well
#use them to fill the gap previously filled by "NA"
#Check if window would extend into negative first since this throws off bedtools
gawk -v WINDOW_MARGIN=$WINDOW_MARGIN '
{match($0,/gene_id "([^"]*)"/,gene);match($0,/transcript_id "([^"]*)"/,transcr);
if($4>WINDOW_MARGIN){print $1,$4-WINDOW_MARGIN,$4+WINDOW_MARGIN,gene[1],transcr[1],$7}
else{print $1,$4,$4+WINDOW_MARGIN,"NA","NA",$7}}
' $TRANSCR_ENDS | sort -g -k2 | uniq > MAPPED_5ENDS.bed
sed -i -e 's/\s/\t/g' MAPPED_5ENDS.bed

#get 3'END from transcripts as mapped by hisat
gawk -v WINDOW_MARGIN=$WINDOW_MARGIN '
{match($0,/gene_id "([^"]*)"/,gene);match($0,/transcript_id "([^"]*)"/,transcr);
print $1,$5-WINDOW_MARGIN,$5+WINDOW_MARGIN,gene[1],transcr[1],$7}' $TRANSCR_ENDS | sort -g -k2 | uniq > MAPPED_3ENDS.bed
sed -i -e 's/\s/\t/g' MAPPED_3ENDS.bed

bedtools intersect -s -u -a MAPPED_5ENDS.bed -b CAGE_5ENDS.bed > Intersect_5END
INTERSECTING_5END=$(wc -l < Intersect_5END)
TOTAL_5END=$(wc -l < MAPPED_5ENDS.bed)
echo $INTERSECTING_5END "intersecting 5' ends" >> IntersectLog.txt 
echo "out of the total " $TOTAL_5END " 5' ends"   >> IntersectLog.txt
INTERSECT_PERCENTAGE=$(echo "$INTERSECTING_5END * 100 / $TOTAL_5END" | bc)
echo "Intersected $INTERSECT_PERCENTAGE percent of mapped 5'ENDs" >> IntersectLog.txt
bedtools intersect -s -u -a MAPPED_3ENDS.bed -b POLYA_3ENDS.bed > Intersect_3END
INTERSECTING_3END=$(wc -l < Intersect_3END)
TOTAL_3END=$(wc -l < MAPPED_3ENDS.bed)
echo $INTERSECTING_3END "intersecting 3' ends" >> IntersectLog.txt
echo "out of the total " $TOTAL_3END " 3' ends" >> IntersectLog.txt
INTERSECT_PERCENTAGE=$(echo "$INTERSECTING_3END * 100 / $TOTAL_3END" | bc)
echo "Intersected $INTERSECT_PERCENTAGE percent of mapped 3'ENDs" >> IntersectLog.txt
echo "confirm BedTools finished" >> IntersectLog.txt
rm MAPPED_5ENDS.bed
rm MAPPED_3ENDS.bed
rm CAGE_5ENDS.bed
rm POLYA_3ENDS.bed

