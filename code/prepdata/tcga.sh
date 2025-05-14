#!/bin/bash

set -e

printf "\033[0;32mDownloading the TCGA dataset\033[0m\n"

full="/data/tcga/unadjusted.csv"
medium="/data/tcga_medium/unadjusted.csv"
small="/data/tcga_small/unadjusted.csv"
rnaseq="/tmp/rnaseq.tsv.gz"
mutations="/tmp/mutations.tsv.gz"
labels="/tmp/labels.tsv.gz"

## This gets the TCGA RNA-Seq dataset
if [ ! -f "/tmp/rnaseq.tsv.gz" ]; then
    wget -O "/tmp/GSE62944_RAW.tar" "https://www.ncbi.nlm.nih.gov/geo/download/?acc=GSE62944&format=file"

    cd "/tmp"
    tar -xvf GSE62944_RAW.tar
    rm GSE62944_RAW.tar
    mv GSM1536837_06_01_15_TCGA_24.tumor_Rsubread_TPM.txt.gz rnaseq.tsv.gz

    printf "\033[0;32mTransposing rnaseq.tsv.gz into rnaseq2.tsv.gz\033[0m\n"
    python "/transpose_matrix.py" rnaseq.tsv.gz rnaseq2.tsv.gz

    printf "\033[0;32mRunning tcga_expression.py on rnaseq2.tsv.gz\033[0m\n"
    python "/tcga_expression.py" rnaseq2.tsv.gz $rnaseq
    cd /prepdata
fi

cd /prepdata

printf "\033[0;32mDownloading more of the TCGA dataset\033[0m\n"
if [ ! -f "$mutations" ]; then
    wget https://osf.io/na3rp/download -O "$mutations"
fi
if [ ! -f "$labels" ]; then
    wget https://osf.io/frxv6/download -O "$labels"
fi

printf "\033[0;32mTidying the TCGA dataset\033[0m\n"

Rscript --vanilla tcga.R $rnaseq $mutations $labels $full


# Do the subsampling stuff
printf "\033[0;32mDo the subsampling stuff\033[0m\n"
mkdir -p "/data/tcga_medium"
mkdir -p "/data/tcga_small"

Rscript tcga_sampling.R
