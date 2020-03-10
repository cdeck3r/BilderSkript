#!/bin/bash
set -eo pipefail

#
# Calls the data preparation pipeline
# with the necessary command line options
#
# Author: cdeck3r
#

# this directory is the script directory
SCRIPT_DIR="$( cd "$(dirname "$0")" ; pwd -P )"
cd $SCRIPT_DIR
SCRIPT_NAME=$0

# default values
TEMP_FILES=" " 

# read from input line
# whether to keep intermediate files or not
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
	$TEMP_FILES \
    --latency-wait 20 \
	--cores 1 \
    data_prep \
	$@