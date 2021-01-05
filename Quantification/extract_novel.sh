#!/bin/bash

# from metaassembly.fa used to build kallisto index extract only the genes with a StringTie identifer (not definitively mapped and thus assmumed novel)
awk -v in_novel="FALSE" ' />/ {in_novel="FALSE"} /^>MSTRG/ {in_novel="TRUE"} {if(in_novel=="TRUE"){print $0}}' metaassembly.fa > NovelTranscripts.fa

