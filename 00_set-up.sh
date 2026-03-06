conda install -n base -c conda-forge mamba

wget -r -np -nH --cut-dirs=3 -A "shotgun_meta.yml" https://cgr.liv.ac.uk/454/acdarby/LIFE750/
mamba env create -f shotgun_meta.yml
conda activate shotgun_meta

sudoapt install firefox
ktUpdateTaxonomy.sh

mkdir -p /mnt/hd/kraken2_db
cd /mnt/hd/kraken2_db
wget https://genome-idx.s3_amazsonaws.com/kraken/k2_standard_08_GB_20251015.tar.gz
tar -xvzf k2_standard_08_GB_20251015.tar.gz

cd ..
mkdir poster_Raw
cd poster_Raw
wget -O K1_R1.fastq.gz ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR505/ERR505102/ERR505102_1.fastq.gz
wget -O K1_R2.fastq.gz ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR505/ERR505102/ERR505102_2.fastq.gz
wget -O K2_R1.fastq.gz ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR505/ERR505104/ERR505104_1.fastq.gz
wget -O K2_R2.fastq.gz ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR505/ERR505104/ERR505104_2.fastq.gz
wget -O K3_R1.fastq.gz ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR505/ERR505095/ERR505095_1.fastq.gz
wget -O K3_R2.fastq.gz ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR505/ERR505095/ERR505095_2.fastq.gz
wget -O K4_R1.fastq.gz ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR505/ERR505096/ERR505096_1.fastq.gz
wget -O K4_R2.fastq.gz ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR505/ERR505096/ERR505096_2.fastq.gz
wget -O K5_R1.fastq.gz ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR505/ERR505097/ERR505097_1.fastq.gz
wget -O K5_R2.fastq.gz ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR505/ERR505097/ERR505097_2.fastq.gz
wget -O K6_R1.fastq.gz ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR505/ERR505098/ERR505098_1.fastq.gz
wget -O K6_R2.fastq.gz ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR505/ERR505098/ERR505098_2.fastq.gz
wget -O K7_R1.fastq.gz ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR505/ERR505099/ERR505099_1.fastq.gz
wget -O K7_R2.fastq.gz ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR505/ERR505099/ERR505099_2.fastq.gz
wget -O K8_R1.fastq.gz ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR505/ERR505100/ERR505100_1.fastq.gz
wget -O K8_R2.fastq.gz ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR505/ERR505100/ERR505100_2.fastq.gz
wget -O K9_R1.fastq.gz ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR505/ERR505101/ERR505101_1.fastq.gz
wget -O K9_R2.fastq.gz ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR505/ERR505101/ERR505101_2.fastq.gz
wget -O K10_R1.fastq.gz ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR505/ERR505103/ERR505103_1.fastq.gz
wget -O K10_R2.fastq.gz ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR505/ERR505103/ERR505103_2.fastq.gz
wget -O K11_R1.fastq.gz ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR505/ERR505105/ERR505105_1.fastq.gz
wget -O K11_R2.fastq.gz ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR505/ERR505105/ERR505105_2.fastq.gz
wget -O K12_R1.fastq.gz ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR505/ERR505106/ERR505106_1.fastq.gz
