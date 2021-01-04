
#Go into directory where all results from Kallisto are stored (one directory per replicate with 3 files each: abundance.h5, abundance.tsv & run_info.json)
cd Kallisto_Results_Separate
#Create file which will store all counts of a transcript from all replicates
# Use ../ adress so that the newly created files won't be target of subsequent iteration which is run on all files/directories detected by ls
touch ../CountLevelsCombined.txt
for i in $(ls); 
	#Collecting info about pseudo-alignment rate
	do echo "Sample = " $i >> ../Kallisto_pseudoaligned.txt;
	awk '/p_pseudoaligned/' $i/run_info.json >> ../Kallisto_pseudoaligned.txt;
	#Extract the transcript_ID & est_counts for each transcript and then join them with CountLevelsCombined.txt 
	#So in the end, this file should store all transcript IDs as well as all est_counts for said transcript from all replicates in one row 
	#These counts will then be summed up so the ones with expression = 0 in all replicates can then be extracted
	tail -n+2 $i/abundance.tsv | sort | cut -f1,4 > ../toJoin.txt;
	#Join doesn't have an built-in output file tag and redirecting with ">" into CountLevelsCombined would delete file before it is read
	#Create new file to store joint output in, then delete old CountLevelsCombined and rename the newly created file to CountLevelsCombined so that it is recognized as such in the next loop iteration
	join -a 1 -a 2 ../CountLevelsCombined.txt ../toJoin.txt > ../Joint_counts.txt
	rm ../CountLevelsCombined.txt
	rename Joint_counts CountLevelsCombined ../Joint_counts.txt	
done;

rm ../toJoin.txt
