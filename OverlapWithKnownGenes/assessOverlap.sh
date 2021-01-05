#!/bin/bash
sort -k4 -o OverlapGenes OverlapGenes
sort -o NC_lowQ NC_lowQ
join -1 1 -2 4 NC_lowQ  OverlapGenes | sort -g -k2 > NC_lowQ_overlap  
