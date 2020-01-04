#!/bin/bash

#
# Calls the data preparation pipeline
# with all required parameters for the snakemake file.
#
# Author: cdeck3r
#

# this directory is the script directory
SCRIPT_DIR="$( cd "$(dirname "$0")" ; pwd -P )"
cd $SCRIPT_DIR
SCRIPT_NAME=$0

# calls the data prep pipeline using snakemake
snakemake all \
	--snakefile data_prep.snakefile \
	--config imgdir=../images/fulltest outdir=../images/fulltest_output \
	--latency-wait 20 \
	--cores 1 \
	$@