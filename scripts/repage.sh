#!/bin/bash
set -eo pipefail

#
# This script correct the virtual canvas of png images.
# A wrongly defined virtual canvas prohibits correct cropping.
# The script calls imagemagick's tool "convert +repage ... "
# Background info: http://www.imagemagick.org/Usage/crop/
#
# Author: cdeck3r

# this directory is the script directory
SCRIPT_DIR="$(
    cd "$(dirname "$0")" || exit
    pwd -P
)"
cd "$SCRIPT_DIR" || exit
SCRIPT_NAME=$0

# parameters
IMG_DIR=$1

# project's root dir
PROJECT_DIR=/bilderskript

# include some common functions
# shellcheck source=/dev/null
source ${PROJECT_DIR}/scripts/funcs.sh

#
# Help text, usage
#
usage() {
    echo -e "Usage: $0 <image file directory> "
}

#########################################
# Checks
#########################################
log_echo "INFO" "Start checks ..."
# check docker
# we expect the script to execute within the docker container
check_docker
#
# Check other tools
command -v convert >/dev/null 2>&1 || {
    log_echo "ERROR" "I require convert but it's not installed.  Aborting."
    exit 1
}

if [ -z "$IMG_DIR" ]; then
    echo "Too few arguments."
    usage
    exit 1
fi

if [ ! -d "${IMG_DIR}" ]; then
    log_echo "ERROR" "Image directory does not exist: ${IMG_DIR}"
    exit 1
fi

log_echo "INFO" "Checks done."

# loop over all png files in the given directory
while IFS= read -r -d '' imgfile; do
    log_echo "INFO" "Repage file: $imgfile"
    convert +repage "$imgfile" "$imgfile".tmp
    mv "$imgfile".tmp "$imgfile" || log_echo "ERROR" "Could not move file: ${imgfile}.tmp"
done < <(find "$IMG_DIR" -type f -iname "*.png" -print0)
