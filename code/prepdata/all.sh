#!/bin/bash

set -e

bash simulate_expression.sh
bash mnist.sh
bash bladderbatch.sh
bash gse37199.sh
bash tcga.sh
