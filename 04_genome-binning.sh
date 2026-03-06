cd ..
mkdir poster_Binning
cd poster_Binning

bwa index /mnt/hd/poster_Assembly/coassembly_megahit/final.contigs.fa \
/mnt/hd/poster_removeHost/K1_post_high_R1.final.fastq /mnt/hd/poster_removeHost/K1_post_high_R2.final.fastq > \
K1.sam
samtools view -bu K1.sam > K1.bam
samtools sort K1.bam > K1.sort.bam

bwa index /mnt/hd/poster_Assembly/coassembly_megahit/final.contigs.fa \
/mnt/hd/poster_removeHost/K2_post_high_R1.final.fastq /mnt/hd/poster_removeHost/K2_post_high_R2.final.fastq > \
K2.sam
samtools view -bu K2.sam > K2.bam
samtools sort K2.bam > K2.sort.bam

bwa index /mnt/hd/poster_Assembly/coassembly_megahit/final.contigs.fa \
/mnt/hd/poster_removeHost/K3_pre_low_R1.final.fastq /mnt/hd/poster_removeHost/K3_pre_low_R2.final.fastq > \
K3.sam
samtools view -bu K3.sam > K3.bam
samtools sort K3.bam > K3.sort.bam

bwa index /mnt/hd/poster_Assembly/coassembly_megahit/final.contigs.fa \
/mnt/hd/poster_removeHost/K4_post_low_R1.final.fastq /mnt/hd/poster_removeHost/K4_post_low_R2.final.fastq > \
K4.sam
samtools view -bu K4.sam > K4.bam
samtools sort K4.bam > K4.sort.bam

bwa index /mnt/hd/poster_Assembly/coassembly_megahit/final.contigs.fa \
/mnt/hd/poster_removeHost/K5_pre_low_R1.final.fastq /mnt/hd/poster_removeHost/K5_pre_low_R2.final.fastq > \
K5.sam
samtools view -bu K5.sam > K5.bam
samtools sort K5.bam > K5.sort.bam

bwa index /mnt/hd/poster_Assembly/coassembly_megahit/final.contigs.fa \
/mnt/hd/poster_removeHost/K6_post_low_R1.final.fastq /mnt/hd/poster_removeHost/K6_post_low_R2.final.fastq > \
K6.sam
samtools view -bu K6.sam > K6.bam
samtools sort K6.bam > K6.sort.bam

bwa index /mnt/hd/poster_Assembly/coassembly_megahit/final.contigs.fa \
/mnt/hd/poster_removeHost/K7_pre_low_R1.final.fastq /mnt/hd/poster_removeHost/K7_pre_low_R2.final.fastq > \
K7.sam
samtools view -bu K7.sam > K7.bam
samtools sort K7.bam > K7.sort.bam

bwa index /mnt/hd/poster_Assembly/coassembly_megahit/final.contigs.fa \
/mnt/hd/poster_removeHost/K8_post_low_R1.final.fastq /mnt/hd/poster_removeHost/K8_post_low_R2.final.fastq > \
K8.sam
samtools view -bu K8.sam > K8.bam
samtools sort K8.bam > K8.sort.bam

bwa index /mnt/hd/poster_Assembly/coassembly_megahit/final.contigs.fa \
/mnt/hd/poster_removeHost/K9_pre_high_R1.final.fastq /mnt/hd/poster_removeHost/K9_pre_high_R2.final.fastq > \
K9.sam
samtools view -bu K9.sam > K9.bam
samtools sort K9.bam > K9.sort.bam

bwa index /mnt/hd/poster_Assembly/coassembly_megahit/final.contigs.fa \
/mnt/hd/poster_removeHost/K10_pre_high_R1.final.fastq /mnt/hd/poster_removeHost/K10_pre_high_R2.final.fastq > \
K10.sam
samtools view -bu K10.sam > K10.bam
samtools sort K10.bam > K10.sort.bam

bwa index /mnt/hd/poster_Assembly/coassembly_megahit/final.contigs.fa \
/mnt/hd/poster_removeHost/K11_pre_high_R1.final.fastq /mnt/hd/poster_removeHost/K11_pre_high_R2.final.fastq > \
K11.sam
samtools view -bu K11.sam > K11.bam
samtools sort K11.bam > K11.sort.bam

bwa index /mnt/hd/poster_Assembly/coassembly_megahit/final.contigs.fa \
/mnt/hd/poster_removeHost/K12_post_high_R1.final.fastq /mnt/hd/poster_removeHost/K12_post_high_R2.final.fastq > \
K12.sam
samtools view -bu K12.sam > K12.bam
samtools sort K12.bam > K12.sort.bam

jgi_summarize_bam_contig_depths \
--minContigLength 2500 \
--outputDepth coassembly_2500.depth.txt \
K*.sort.bam

mkdir bins
metabat2 \
--inFile /mnt/hd/poster_Assembly/coassembly_megahit/final.contigs.fa \
--outFile bins/coassembly_bin \
--abdFile coassembly_2500.depth.txt \
--minContig 2500

mamba create -n checkm2 -c bioconda -c conda-forge checkm2
mamba activate checkm2
checkm2 database --download

cd bins
checkm2 predict --threads 8 --input /mnt/hd/poster_Binning/bins -x fa --output-directory /mnt/hd/poster_Binning/checkm_output

cp quality_report.tsv quality_report_copy.tsv

cat quality_report_copy.tsv | tr "\t" "," > quality_report2.csv

echo "Quality" > MAGS_quality.csv

awk -F, 'NR>1 {print $2 - (5 * $3)}' quality_report2.csv >> MAGS_quality.csv
paste -d "," quality_report2.csv MAGS_quality.csv > quality_report2_with_quality.csv
