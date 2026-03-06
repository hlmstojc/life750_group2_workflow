#STEP 3: Taxonomic profiling with Kraken2 and Bracken
#This involved assigning taxonomy to the trimmed, host-removed reads.
#Input: Paired-end reads following trimming and host removal.   
#Output: Krona sunburst-style pie chart (Kraken2), stacked bar plot of relative abundance per sample (Bracken/R), principle coordinate analysis (PCoA) using Bray-Curtis dissimilarity for beta-diversity (Bracken/R), permutational multivariate analysis of variance (PERMANOVA; Bracken/R)

cd ..
mkdir poster_Taxonomy
cd poster_Taxonomy

#Classifying the host-removed, paired-end reads against a Kraken2 database using 8 CPU threads (maximum).
#Please note, due to limited storage space on the HPC used, the Kraken2 database provided in the workshop was made use of here.
kraken2 --paired \
--db /mnt/hd/kraken2_db \
--threads 8 \
--output K1.kraken \
--report K1.kreport2 \
/mnt/hd/poster_removeHost/K1_post_high_R1.final.fastq \
/mnt/hd/poster_removeHost/K1_post_high_R2.final.fastq
kraken2 --paired \
--db /mnt/hd/kraken2_db \
--threads 8 \
--output K2.kraken \
--report K2.kreport2 \
/mnt/hd/poster_removeHost/K2_post_high_R1.final.fastq \
/mnt/hd/poster_removeHost/K2_post_high_R2.final.fastq
kraken2 --paired \
--db /mnt/hd/kraken2_db \
--threads 8 \
--output K3.kraken \
--report K3.kreport2 \
/mnt/hd/poster_removeHost/K3_pre_low_R1.final.fastq \
/mnt/hd/poster_removeHost/K3_pre_low_R2.final.fastq
kraken2 --paired \
--db /mnt/hd/kraken2_db \
--threads 8 \
--output K4.kraken \
--report K4.kreport2 \
/mnt/hd/poster_removeHost/K4_post_low_R1.final.fastq \
/mnt/hd/poster_removeHost/K4_post_low_R2.final.fastq
kraken2 --paired \
--db /mnt/hd/kraken2_db \
--threads 8 \
--output K5.kraken \
--report K5.kreport2 \
/mnt/hd/poster_removeHost/K5_pre_low_R1.final.fastq \
/mnt/hd/poster_removeHost/K5_pre_low_R2.final.fastq
kraken2 --paired \
--db /mnt/hd/kraken2_db \
--threads 8 \
--output K6.kraken \
--report K6.kreport2 \
/mnt/hd/poster_removeHost/K6_post_low_R1.final.fastq \
/mnt/hd/poster_removeHost/K6_post_low_R2.final.fastq
kraken2 --paired \
--db /mnt/hd/kraken2_db \
--threads 8 \
--output K7.kraken \
--report K7.kreport2 \
/mnt/hd/poster_removeHost/K7_pre_low_R1.final.fastq \
/mnt/hd/poster_removeHost/K7_pre_low_R2.final.fastq
kraken2 --paired \
--db /mnt/hd/kraken2_db \
--threads 8 \
--output K8.kraken \
--report K8.kreport2 \
/mnt/hd/poster_removeHost/K8_post_low_R1.final.fastq \
/mnt/hd/poster_removeHost/K8_post_low_R2.final.fastq
kraken2 --paired \
--db /mnt/hd/kraken2_db \
--threads 8 \
--output K9.kraken \
--report K9.kreport2 \
/mnt/hd/poster_removeHost/K9_pre_high_R1.final.fastq \
/mnt/hd/poster_removeHost/K9_pre_high_R2.final.fastq
kraken2 --paired \
--db /mnt/hd/kraken2_db \
--threads 8 \
--output K10.kraken \
--report K10.kreport2 \
/mnt/hd/poster_removeHost/K10_pre_high_R1.final.fastq \
/mnt/hd/poster_removeHost/K10_pre_high_R2.final.fastq
kraken2 --paired \
--db /mnt/hd/kraken2_db \
--threads 8 \
--output K11.kraken \
--report K11.kreport2 \
/mnt/hd/poster_removeHost/K11_pre_high_R1.final.fastq \
/mnt/hd/poster_removeHost/K11_pre_high_R2.final.fastq
kraken2 --paired \
--db /mnt/hd/kraken2_db \
--threads 8 \
--output K12.kraken \
--report K12.kreport2 \
/mnt/hd/poster_removeHost/K12_post_high_R1.final.fastq \
/mnt/hd/poster_removeHost/K12_post_high_R2.final.fastq

#Kraken2 output (*kreport2) was visualised with Krona and accessed in browser (Firefox).
ktImportTaxonomy -o kraken2.krona.html *.kreport2

firefox kraken2.krona.html &

#Estimate abundances of taxa were determined by performing Bracken, which uses taxonomy labels assigned previously with Kraken2.
#Read length was set at 100 (-100) in accordance with the read length which was used during Kraken2 classification.
#Abundances were estimated at the genus level to provide clearer visualisation later (in terms of stacked bar plot).
#Further, at the genus level, the group is well-defined; at the species level, the level of genetic similarity is high and might contribute to genetic overlaps.
bracken -d /mnt/hd/kraken2_db/ \
-i K1_post_high.kreport2 \
-o K1_post_high_genus.bracken \
-w K1_post_high.breport2 \
-r 100 \
-l G \
-t 5
bracken -d /mnt/hd/kraken2_db/ \
-i K2_post_high.kreport2 \
-o K2_post_high_genus.bracken \
-w K2_post_high.breport2 \
-r 100 \
-l G \
-t 5
bracken -d /mnt/hd/kraken2_db/ \
-i K3_pre_low.kreport2 \
-o K3_pre_low_genus.bracken \
-w K3_pre_low.breport2 \
-r 100 \
-l G \
-t 5
bracken -d /mnt/hd/kraken2_db/ \
-i K4_post_low.kreport2 \
-o K4_post_low_genus.bracken \
-w K4_post_low.breport2 \
-r 100 \
-l G \
-t 5
bracken -d /mnt/hd/kraken2_db/ \
-i K5_pre_low.kreport2 \
-o K5_pre_low_genus.bracken \
-w K5_pre_low.breport2 \
-r 100 \
-l G \
-t 5
bracken -d /mnt/hd/kraken2_db/ \
-i K6_post_low.kreport2 \
-o K6_post_low_genus.bracken \
-w K6_post_low.breport2 \
-r 100 \
-l G \
-t 5
bracken -d /mnt/hd/kraken2_db/ \
-i K7_pre_low.kreport2 \
-o K7_pre_low_genus.bracken \
-w K7_pre_low.breport2 \
-r 100 \
-l G \
-t 5
bracken -d /mnt/hd/kraken2_db/ \
-i K8_post_low.kreport2 \
-o K8_post_low_genus.bracken \
-w K8_post_low.breport2 \
-r 100 \
-l G \
-t 5
bracken -d /mnt/hd/kraken2_db/ \
-i K9_pre_high.kreport2 \
-o K9_pre_high_genus.bracken \
-w K9_pre_high.breport2 \
-r 100 \
-l G \
-t 5
bracken -d /mnt/hd/kraken2_db/ \
-i K10_pre_high.kreport2 \
-o K10_pre_high_genus.bracken \
-w K10_pre_high.breport2 \
-r 100 \
-l G \
-t 5
bracken -d /mnt/hd/kraken2_db/ \
-i K11_pre_high.kreport2 \
-o K11_pre_high_genus.bracken \
-w K11_pre_high.breport2 \
-r 100 \
-l G \
-t 5
bracken -d /mnt/hd/kraken2_db/ \
-i K12_post_high.kreport2 \
-o K12_post_high_genus.bracken \
-w K12_post_high.breport2 \
-r 100 \
-l G \
-t 5

#Bracken outputs across the 12 samples (at the genus level) were merged into a single output.
combine_bracken_outputs.py --files *_genus.bracken -o all_genus.bracken

#Taxon name (1) and abundance count (4, 6, 8...26) columns were extracted.
cut -f1,4,6,8,10,12,14,16,18,20,22,24,26 all_genus.bracken > all_genus_num.bracken
