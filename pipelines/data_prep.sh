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

# default values
TEMP_FILES=" " 
# suffix defines the image to crop; requires "keep intermediate files..." -> y
IMG_SUFFIX="flat_pc_resize_mirror"
CROP_SPEC="300x300+80+25"

# read from input line
echo ""
read -t 4 \
     -p "Do you want to keep intermediate files? [y/N]" \
     KEEP_FILES

# define whether to keep temp files or not     
if [ "${KEEP_FILES}" == "y" ]; then
    TEMP_FILES="--notemp"
fi

# calls the data prep pipeline using snakemake
# it calls the default rule [all]
snakemake \
	--snakefile data_prep.snakefile \
	--config imgdir=../images/fulltest outdir=../images/fulltest_output width=500 \
    suffix=$IMG_SUFFIX crop=$CROP_SPEC \
	$TEMP_FILES \
    --latency-wait 20 \
	--cores 1 \
	$@