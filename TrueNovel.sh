
module add UHTS/Analysis/BEDTools/2.29.2;

# Bedtools outputs the entire line of the corresponding gtf file but only transcript_ID needed so gawk match used
# "TrueNovel" = novel with no intersect to known genes
bedtools intersect -v -a NovelTranscripts.gtf -b Transcript_ends_gencode.gtf | gawk '{match($0,/transcript_id "([^"]*)"/,arr); print arr[1]}' > TrueNovel_transcript_ID

# Evaluation of coding & non-coding PLUS extracting the corresponding transcript IDs in separate files

awk '$NF<0.364 {print $1}' CPAT_results > Non_coding_novel_transcript_ID
#Skipping over header
tail -n+2 CPAT_results | awk '$NF>=0.364 {print $1}' > Coding_novel_transcript_ID


# Sorting all files in place so that IDs can later be matched with bash "join" command
sort -o TrueNovel_transcript_ID TrueNovel_transcript_ID
sort -o Coding_novel_transcriptID Coding_novel_transcript_ID
sort -o Non_coding_novel_transcriptID Non_coding_novel_transcript_ID

join TrueNovel_transcript_ID Coding_novel_transcriptID > TrueNovel_coding_transcript_ID
join TrueNovel_transcript_ID Non_coding_novel_transcriptID > TrueNovel_non_coding_transcript_ID

# GENE_LEVEL_ANALYSIS

# Extracting the gene_ids, could also be done the same way as for transcript ids, but since the different transcripts
# are just given the "gene_id.transcriptnumber" identifier, less workload when only running gawk again instead of running both bedtools and gawk
# Note: Only works for "novel" MSTRG identifiers - ensembl transcript identifiers do not alway follow this exact format
# Because some genes have mutliple transcripts, the output has to be checked with uniq to avoid multiple copies of the same ID
gawk '{match($0,/([A-Z]*\.[0-9]*)\.[0-9]/,arr); print arr[1]}' TrueNovel_transcript_ID | sort | uniq > TrueNovel_gene_ID
gawk '{match($0,/([A-Z]*\.[0-9]*)\.[0-9]/,arr); print arr[1]}' Coding_novel_transcript_ID | sort | uniq > Coding_novel_gene_ID
gawk '{match($0,/([A-Z]*\.[0-9]*)\.[0-9]/,arr); print arr[1]}' Non_coding_novel_transcript_ID | sort | uniq > Non_coding_novel_gene_ID

join TrueNovel_gene_ID Coding_novel_gene_ID > TrueNovel_coding_gene_ID
join TrueNovel_gene_ID Non_coding_novel_gene_ID > TrueNovel_non_coding_gene_ID

echo "TrueNovel coding transcripts: " $(wc -l < TrueNovel_coding_transcript_ID)
echo "TrueNovel non-coding transcripts: " $(wc -l < TrueNovel_non_coding_transcript_ID)
echo "TrueNovel coding genes: " $(wc -l < TrueNovel_coding_gene_ID) 
#Subtract the gene IDs found in both files in the count for non-coding since a gene with both coding&non-coding transcripts is still overall considered coding
Non_coding=$(wc -l < TrueNovel_non_coding_gene_ID)
Both=$(join TrueNovel_non_coding_gene_ID TrueNovel_coding_gene_ID | wc -l)
Strictly_non_coding=$(echo "$Non_coding-$Both" | bc)
echo "TrueNovel non-coding genes: " $Strictly_non_coding 
