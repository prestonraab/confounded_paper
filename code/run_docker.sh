#! /bin/bash

set -e

image=srp33/confounded-paper:version1

docker build -t $image .

mkdir -p data/simulated_expression data/mnist data/bladderbatch data/gse37199 data/tcga
mkdir -p $(pwd)/../metrics
mkdir -p $(pwd)/../figures

chmod 777 $(pwd)/../metrics
chmod 777 $(pwd)/../figures

#docker run -i -t --rm \
docker run -i --rm \
  --user $(id -u):$(id -g) \
  -v $(pwd)/data:/data \
  -v $(pwd)/../metrics:/output/metrics \
  -v $(pwd)/../figures:/output/figures \
  $image
