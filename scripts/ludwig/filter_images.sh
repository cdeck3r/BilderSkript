#!/bin/bash
set -eo pipefail

#
# runs the Docker image
#
# Author: Christian Decker (cdeck3r)
#

# this directory is the script directory
SCRIPT_DIR="$(
    cd "$(dirname "$0")" || exit
    pwd -P
)"
cd "$SCRIPT_DIR" || exit

#
# Parameters
#
# Source: IMG_TRAIN_BASE
# Target: IMG_TRAIN_PATH
IMG_TRAIN_BASE=$1
IMG_TRAIN_PATH=$2
CONVERT_PARAMS=$3
# create target dir
mkdir -p "$IMG_TRAIN_PATH"

#################################################
# Do not edit below
#################################################

# The use of find in for loops is fragile because of globbing
# if a file name contains a spaces and other chars.
# The code below avoids these problems.
# See: https://github.com/koalaman/shellcheck/wiki/SC2044#correct-code
#
while IFS= read -r -d '' img; do
    CLS_NAME=$(basename "$(dirname "$img")")
    IMG_FILTER=$IMG_TRAIN_PATH/"$CLS_NAME"/$(basename "$img")

    echo "input: $img"
    echo "output: $IMG_FILTER"
    mkdir -p "$(dirname "$IMG_FILTER")"
    #convert -negate -normalize "$img" "$IMG_FILTER"
    #convert -posterize 4 -normalize "$img" "$IMG_FILTER"
    convert "$CONVERT_PARAMS" "$img" "$IMG_FILTER"
done < <(find "$IMG_TRAIN_BASE" -type f -print0)
