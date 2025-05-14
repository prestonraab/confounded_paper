#!/bin/bash

set -e

printf "\033[0;32mDownloading the MNIST dataset\033[0m\n"

raw_csv=/data/mnist_test.csv
tidy_csv=/tmp/pre_noise.csv
batched_csv=/data/mnist/unadjusted.csv

#wget https://web.archive.org/web/20180506082435/https://pjreddie.com/media/files/mnist_test.csv -O $raw_csv

printf "\033[0;32mTidying the MNIST dataset\033[0m\n"

python mnist.py $raw_csv $tidy_csv
python artificial_batch.py $tidy_csv $batched_csv
