#!/bin/bash

# from metaassembly.fa used to build kallisto index
awk -v in_novel="FALSE" ' />/ {in_novel="FALSE"} /^>MSTRG/ {in_novel="TRUE"} {if(in_novel=="TRUE"){print $0}}' metaassembly.fa > NovelTranscripts.fa

