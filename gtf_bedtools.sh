#!/bin/bash
##
## retrieves a human GTF from UCSC (hg19) and annotates a bedfile using bedtools
##
## 10th dec 2018
## Izaskun Mallona

wget http://hgdownload.cse.ucsc.edu/goldenPath/hg19/database/refGene.txt.gz

## mind this is already compiled and only runs @ linux 64 bits!
wget http://hgdownload.cse.ucsc.edu/admin/exe/linux.x86_64/genePredToGtf
chmod a+x genePredToGtf 
gzip -d refGene.txt.gz
cut -f 2- refGene.txt > refGene.input
./genePredToGtf file refGene.input hg19refGene.gtf
wc -l hg19refGene.gtf

## generating a random bedfile to annotate the intervals, just to exemplify the process

cat << EOF > random.bed
chr1,778752,779028
chr1,869869,869987
chr1,904737,904848
chr1,912878,913154
chr1,921093,921369
chr1,923128,923404
chr1,928866,929142
chr1,939180,939456
EOF

sed -i 's/,/\t/g' random.bed

bedtools intersect -a random.bed \
         -b hg19refGene.gtf \
         -wa -wb > random_annotated.bed

wc -l random.bed
wc -l random_annotated.bed ## beware! some are dupe, please read the GTF documentation
## and the bedtools closest as well
