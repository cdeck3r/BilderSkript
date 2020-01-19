#!/bin/bash

#
# Creates reports for all pipelines
#
# Author: cdeck3r
#

# this directory is the script directory
SCRIPT_DIR="$( cd "$(dirname "$0")" ; pwd -P )"
cd $SCRIPT_DIR
SCRIPT_NAME=$0


for f in $(ls *.snakefile)
do
    PIPELINE_NAME="${f%.*}"
    PIPELINE_REPORT=${f}.html
    # create the report 
    snakemake ${PIPELINE_NAME} --report ${PIPELINE_REPORT}

done