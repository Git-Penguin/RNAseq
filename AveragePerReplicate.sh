#!/bin/bash
for i in $(seq 2 13);
do awk -v column=$i 'BEGIN{sum=0}{sum+=$column}END{print sum / NR}' CountLevelsCombined.txt;
done
