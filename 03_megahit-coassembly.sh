cd ..
mkdir poster_Assembly
cd poster_Assembly

cd ..
cd poster_removeHost
cp *final.fastq /mnt/hd/poster_Assembly

R1_SAMPLES="K1_post_high_R1.final.fastq,K2_post_high_R1.final.fastq,K3_pre_low_R1.final.fastq,K4_post_low_R1.final.fastq,K5_pre_low_R1.final.fastq,K6_post_low_R1.final.fastq,K7_pre_low_R1.final.fastq,K8_post_low_R1.final.fastq,K9_pre_high_R1.final.fastq,K10_pre_high_R1.final.fastq, K11_pre_high_R1.final.fastq,K12_post_high_R1.final.fastq"
R2_SAMPLES="K1_post_high_R2.final.fastq,K2_post_high_R2.final.fastq,K3_pre_low_R2.final.fastq,K4_post_low_R2.final.fastq,K5_pre_low_R2.final.fastq,K6_post_low_R2.final.fastq,K7_pre_low_R2.final.fastq,K8_post_low_R2.final.fastq,K9_pre_high_R2.final.fastq,K10_pre_high_R2.final.fastq, K11_pre_high_R2.final.fastq,K12_post_high_R2.final.fastq"
megahit \
-1 "$R1_SAMPLES" \ 
-2 "$R2_SAMPLES" \
-o coassembly_megahit \
-t 8

mkdir -p quast_coassembly
quast -o quast_coassembly coassembly_megahit/final.contigs.fa

firefox quast_coassembly/report.html
