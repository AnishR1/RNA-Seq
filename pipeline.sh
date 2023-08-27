#! /usr/bin/env bash

# Get data using SRA toolkit
fasterq-dump SRR7889560 --split-3 -O /home/anish/omics/meso/meso_sample3
echo "Got Data"

# Using trimmomatic to trim the data
java -jar /usr/share/java/trimmomatic-0.39.jar  PE \
-threads 32 -phred33 \
/home/anish/omics/meso/meso_sample3/SRR7889560_1.fastq \
/home/anish/omics/meso/meso_sample3/SRR7889560_2.fastq \
/home/anish/omics/meso/meso_sample3/trimmed/SRR7889560_paired_1.fastq \
/home/anish/omics/meso/meso_sample3/untrimmed/SRR7889560_unpaired_1.fastq \
/home/anish/omics/meso/meso_sample3/trimmed/SRR7889560_paired_2.fastq \
/home/anish/omics/meso/meso_sample3/untrimmed/SRR7889560_unpaired_2.fastq \
HEADCROP:0 \
ILLUMINACLIP:/usr/share/trimmomatic/TruSeq3-PE.fa:2:30:10 \
LEADING:20 TRAILING:20 SLIDINGWINDOW:4:30 MINLEN:36

echo "Trimming Complete"

# Setting ulimit for STAR
ulimit -n 1000000

# Aligning the reads to a reference genome
STAR \
--runThreadN 32 \
--genomeDir /home/anish/omics/ref/output \
--readFilesIn /home/anish/omics/meso/meso_sample3/trimmed/SRR7889560_paired_1.fastq /home/anish/omics/meso/meso_sample3/trimmed/SRR7889560_paired_2.fastq \
--outSAMtype BAM SortedByCoordinate \
--outFileNamePrefix /home/anish/omics/meso/meso_sample3/aligned/ME_SA3


echo "Alignment Complete"
