#STEP 1A: Trimming with Trim Galore!
#This involves removing adapters and low-quality base pairs.
#Input: paired-end raw reads (K1-K12) from poster_Raw (see 00_set-up.sh)
#Output: trimmed FastQ files.

mkdir poster_Trimmed
cd poster_Trimmed

#Adapters and low-quality bases were removed from paired-end reads.
trim_galore --paired --quality 20 --stringency 4 \
../poster_Raw/K1_R1.fastq.gz ../poster_Raw/K1_R2.fastq.gz
trim_galore --paired --quality 20 --stringency 4 \
../poster_Raw/K2_R1.fastq.gz ../poster_Raw/K2_R2.fastq.gz
trim_galore --paired --quality 20 --stringency 4 \
../poster_Raw/K3_R1.fastq.gz ../poster_Raw/K3_R2.fastq.gz
trim_galore --paired --quality 20 --stringency 4 \
../poster_Raw/K4_R1.fastq.gz ../poster_Raw/K4_R2.fastq.gz
trim_galore --paired --quality 20 --stringency 4 \
../poster_Raw/K5_R1.fastq.gz ../poster_Raw/K5_R2.fastq.gz
trim_galore --paired --quality 20 --stringency 4 \
../poster_Raw/K6_R1.fastq.gz ../poster_Raw/K6_R2.fastq.gz
trim_galore --paired --quality 20 --stringency 4 \
../poster_Raw/K7_R1.fastq.gz ../poster_Raw/K7_R2.fastq.gz
trim_galore --paired --quality 20 --stringency 4 \
../poster_Raw/K8_R1.fastq.gz ../poster_Raw/K8_R2.fastq.gz
trim_galore --paired --quality 20 --stringency 4 \
../poster_Raw/K9_R1.fastq.gz ../poster_Raw/K9_R2.fastq.gz
trim_galore --paired --quality 20 --stringency 4 \
../poster_Raw/K10_R1.fastq.gz ../poster_Raw/K10_R2.fastq.gz
trim_galore --paired --quality 20 --stringency 4 \
../poster_Raw/K11_R1.fastq.gz ../poster_Raw/K11_R2.fastq.gz
trim_galore --paired --quality 20 --stringency 4 \
../poster_Raw/K12_R2.fastq.gz ../poster_Raw/K12_R2.fastq.gz

#The output files (*_val_1.fq.gz, *_val_1.fq.gz) were renamed to make downstream processing clearer and easier.
mv K1_R1_val_1.fq.gz K1_R1.fq.gz
mv K1_R2_val_2.fq.gz K1_R2.fq.gz
mv K2_R1_val_1.fq.gz K2_R1.fq.gz
mv K2_R2_val_2.fq.gz K2_R2.fq.gz
mv K3_R1_val_1.fq.gz K3_R1.fq.gz
mv K3_R2_val_2.fq.gz K3_R2.fq.gz
mv K4_R1_val_1.fq.gz K4_R1.fq.gz
mv K4_R2_val_2.fq.gz K4_R2.fq.gz
mv K5_R1_val_1.fq.gz K5_R1.fq.gz
mv K5_R2_val_2.fq.gz K5_R2.fq.gz
mv K6_R1_val_1.fq.gz K6_R1.fq.gz
mv K6_R2_val_2.fq.gz K6_R2.fq.gz
mv K7_R1_val_1.fq.gz K7_R1.fq.gz
mv K7_R2_val_2.fq.gz K7_R2.fq.gz
mv K8_R1_val_1.fq.gz K8_R1.fq.gz
mv K8_R2_val_2.fq.gz K8_R2.fq.gz
mv K9_R1_val_1.fq.gz K9_R1.fq.gz
mv K9_R2_val_2.fq.gz K9_R2.fq.gz
mv K10_R1_val_1.fq.gz K10_R1.fq.gz
mv K10_R2_val_2.fq.gz K10_R2.fq.gz
mv K11_R1_val_1.fq.gz K11_R1.fq.gz
mv K11_R2_val_2.fq.gz K11_R2.fq.gz
mv K12_R1_val_1.fq.gz K12_R1.fq.gz
mv K12_R2_val_1.fq.gz K12_R2.fq.gz

#STEP 1B: Visualisation with MultiQC.
#Input: Trimmed paired-end reads.
#Output: MultiQC summary reports (R1 and R2).

#FastQC was performed on all R1 reads using 3 CPU threads.
mkdir R1_fastqc
fastqc -t 3 -o R1_fastqc *R1.fq.gz

#Similarly, FastQC was performed on all R2 reads, also using 3 CPU threads.
mkdir R2_fastqc
fastqc -t 3 -o R2_fastqc *R2.fq.gz

#R1 FastQC reports were summarised using MultiQC.
mkdir R1_fastqc/multiqc
multiqc -o R1_fastqc/multiqc R1_fastqc

#R2 FastQC reports were also summarised using MultiQC.
mkdir R2_fastqc/multiqc
multiqc -o R2_fastqc/multiqc R2_fastqc

#Both MultiQC reports were accessed in browser (Firefox).
firefox R1_fastqc/multiqc/multiqc_report.html \ 
R2_fastqc/multiqc/multiqc_report.html &

#STEP 2: Host removal with Bowtie2
#This involved removing host (human) reads from the dataset by aligning the sequences against a human reference genome.
#Please note regarding the human reference genome: the GRCh38 slice provided in the workshop was used as a placeholder due to limited storage space on the HPC used.
#Input: Trimmed reads of K1-K12 samples from the dataset.
#Output: Host-removed reads used for downstream analysis.

cd ..
mkdir poster_removeHost
cd poster_removeHost
mkdir unmapped

#A human genome slice was downloaded to serve as reference against which host removal could be performed. 
wget -r -np -nH --cut-dirs=3 -A "GRCh38_slice.fasta" https://cgr.liv.ac.uk/454/acdarby/LIFE750/

#Bowtie2 index was established to allow alignment of the trimmed reads against the human reference genome slice.
#samtools was thereafter used to extract reads that did not map to the host genome into the unmapped directory across all 12 samples.
bowtie2-build GRCh38_slice.fasta GRCh38_slice.fasta

bowtie2 -x GRCh38_slice.fasta -1 ../poster_Trimmed/K1_R1.fq.gz -2 ../poster_Trimmed/K1_R2.fq.gz -p 12 2> K1_bowtie_out.log | samtools view -b -S -h > K1_mapped.bam
samtools fastq -f 4 -1 unmapped/K1_R1.u.fq -2 unmapped/K1_R2.u.fq K1_mapped.bam
bowtie2 -x GRCh38_slice.fasta -1 ../poster_Trimmed/K2_R1.fq.gz -2 ../poster_Trimmed/K2_R2.fq.gz -p 12 2> K2_bowtie_out.log | samtools view -b -S -h > K2_mapped.bam
samtools fastq -f 4 -1 unmapped/K2_R1.u.fq -2 unmapped/K2_R2.u.fq K2_mapped.bam
bowtie2 -x GRCh38_slice.fasta -1 ../poster_Trimmed/K3_R1.fq.gz -2 ../poster_Trimmed/K3_R2.fq.gz -p 12 2> K3_bowtie_out.log | samtools view -b -S -h > K3_mapped.bam
samtools fastq -f 4 -1 unmapped/K3_R1.u.fq -2 unmapped/K3_R2.u.fq K3_mapped.bam
bowtie2 -x GRCh38_slice.fasta -1 ../poster_Trimmed/K4_R1.fq.gz -2 ../poster_Trimmed/K4_R2.fq.gz -p 12 2> K4_bowtie_out.log | samtools view -b -S -h > K4_mapped.bam
samtools fastq -f 4 -1 unmapped/K4_R1.u.fq -2 unmapped/K4_R2.u.fq K4_mapped.bam
bowtie2 -x GRCh38_slice.fasta -1 ../poster_Trimmed/K5_R1.fq.gz -2 ../poster_Trimmed/K5_R2.fq.gz -p 12 2> K5_bowtie_out.log | samtools view -b -S -h > K5_mapped.bam
samtools fastq -f 4 -1 unmapped/K5_R1.u.fq -2 unmapped/K5_R2.u.fq K5_mapped.bam
bowtie2 -x GRCh38_slice.fasta -1 ../poster_Trimmed/K6_R1.fq.gz -2 ../poster_Trimmed/K6_R2.fq.gz -p 12 2> K6_bowtie_out.log | samtools view -b -S -h > K6_mapped.bam
samtools fastq -f 4 -1 unmapped/K6_R1.u.fq -2 unmapped/K6_R2.u.fq K6_mapped.bam
bowtie2 -x GRCh38_slice.fasta -1 ../poster_Trimmed/K7_R1.fq.gz -2 ../poster_Trimmed/K7_R2.fq.gz -p 12 2> K7_bowtie_out.log | samtools view -b -S -h > K7_mapped.bam
samtools fastq -f 4 -1 unmapped/K7_R1.u.fq -2 unmapped/K7_R2.u.fq K7_mapped.bam
bowtie2 -x GRCh38_slice.fasta -1 ../poster_Trimmed/K8_R1.fq.gz -2 ../poster_Trimmed/K8_R2.fq.gz -p 12 2> K8_bowtie_out.log | samtools view -b -S -h > K8_mapped.bam
samtools fastq -f 4 -1 unmapped/K8_R1.u.fq -2 unmapped/K8_R2.u.fq K8_mapped.bam
bowtie2 -x GRCh38_slice.fasta -1 ../poster_Trimmed/K9_R1.fq.gz -2 ../poster_Trimmed/K9_R2.fq.gz -p 12 2> K2_bowtie_out.log | samtools view -b -S -h > K9_mapped.bam
samtools fastq -f 4 -1 unmapped/K9_R1.u.fq -2 unmapped/K9_R2.u.fq K9_mapped.bam
bowtie2 -x GRCh38_slice.fasta -1 ../poster_Trimmed/K10_R1.fq.gz -2 ../poster_Trimmed/K10_R2.fq.gz -p 12 2> K2_bowtie_out.log | samtools view -b -S -h > K10_mapped.bam
samtools fastq -f 4 -1 unmapped/K10_R1.u.fq -2 unmapped/K10_R2.u.fq K10_mapped.bam
bowtie2 -x GRCh38_slice.fasta -1 ../poster_Trimmed/K11_R1.fq.gz -2 ../poster_Trimmed/K11_R2.fq.gz -p 12 2> K11_bowtie_out.log | samtools view -b -S -h > K11_mapped.bam
samtools fastq -f 4 -1 unmapped/K11_R1.u.fq -2 unmapped/K11_R2.u.fq K11_mapped.bam
bowtie2 -x GRCh38_slice.fasta -1 ../poster_Trimmed/K12_R1.fq.gz -2 ../poster_Trimmed/K12_R2.fq.gz -p 12 2> K2_bowtie_out.log | samtools view -b -S -h > K12_mapped.bam
samtools fastq -f 4 -1 unmapped/K12_R1.u.fq -2 unmapped/K12_R2.u.fq K12_mapped.bam

#Ultimately, BBTools were used to remove unpaired reads, thus ensuring that downstream analyses will receive appropriately paired reads.
repair.sh \
in1=unmapped/K1_R1.u.fq \
in2=unmapped/K1_R2.u.fq \
out1=K1_R1.final.fastq \
out2=K1_R2.final.fastq \
outs=K1_singletons.fastq
