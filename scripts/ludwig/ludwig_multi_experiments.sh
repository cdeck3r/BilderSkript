#!/bin/bash

#
# Runs multiple ludwig experiments
#
# Author: Christian Decker (cdeck3r)
#

# this directory is the script directory
SCRIPT_DIR="$(
    cd "$(dirname "$0")" || exit
    pwd -P
)"
cd "$SCRIPT_DIR" || exit
SCRIPT_NAME=$0

# include some common functions
# shellcheck source=/dev/null
source "$(readlink -f "${SCRIPT_DIR}"/../funcs.sh)"

#
# Parameters for the experiment
# All paths reference directories _within_ the docker container
EXP_ROOT_NAME=$1 # takes the value from the command line
PROJECT_DIR=/bilderskript

# place of training images
IMG_DIR=$PROJECT_DIR/images
IMG_TRAIN_BASE=$IMG_DIR/train/impure
IMG_TRAIN_DIR=$IMG_DIR/train

# the default model file used in each experiment
MODEL_DIR=$PROJECT_DIR/ludwig/models
MDF=$MODEL_DIR/model_definition.yaml

# for export; not yet implemented
MODELS_CSV=$PROJECT_DIR/pipeline/models.csv

#################################################
# Do not edit below
#################################################

#
# HOST_DIR - the directory mounted into the image
#            should be the BilderSkript project dir
#
# Note that when using the vbox under Windows not every directory
# can be used as shared folder. In this case, the host directory
# specified in `-v <host dir>:<container dir>` must be a subdir of
# `C:\Users\<username>\`.
#
BILDERSKRIPT_DIR=$(readlink -f "$SCRIPT_DIR"/../..)
if [ ! -d "$BILDERSKRIPT_DIR" ]; then
    log_echo "Error" "Host directory does not exist: $HOST_DIR"
    exit 1
fi
# docker functions require the directory of the docker-compose.yml file
if [ ! -f "$BILDERSKRIPT_DIR"/docker-compose.yml ]; then
    log_echo "ERROR" "Docker compose file not found: ""$BILDERSKRIPT_DIR""/docker-compose.yml"
    exit 1
else
    DOCKER_COMPOSE_DIR="$BILDERSKRIPT_DIR"
fi

#
# Image parameter initialization
# contains: ImageMagick convert tool
IMG_NAME=builder
TARGET=latest
IMAGE="${IMG_NAME}:${TARGET}"

# include docker functions
# shellcheck source=/dev/null
source "$(readlink -f "${SCRIPT_DIR}"/../docker_funcs.sh)"

#
# Help text, usage
#
usage() {
    echo -e "Usage : $0 <experiment root name>"
    echo ""
    echo -e "Default image: ${IMAGE}"
    exit
}

#
# check command line parameters
if [ -z "$EXP_ROOT_NAME" ]; then
    echo "Too few arguments."
    usage
    exit 1
fi

#
# Main experiment loop
#
# looping through array with accompanying indices
# Source: https://stackoverflow.com/a/51794732
EXP_PARAM=(
    "-posterize 2 -resize 128x128!"
    "-posterize 3 -resize 128x128!"
    "-posterize 4 -resize 128x128!"
    "-posterize 5 -resize 128x128!"
    "-posterize 2 -resize 256x256!"
    "-posterize 3 -resize 256x256!"
    "-posterize 4 -resize 256x256!"
    "-posterize 5 -resize 256x256!"
    "-posterize 2 -resize 300x300!"
    "-posterize 3 -resize 300x300!"
    "-posterize 4 -resize 300x300!"
    "-posterize 5 -resize 300x300!"
    "-posterize 2 -resize 512x512!"
    "-posterize 3 -resize 512x512!"
    "-posterize 4 -resize 512x512!"
    "-posterize 5 -resize 512x512!"
)

for EXP_NO in "${!EXP_PARAM[@]}"; do

    # 1. setup the experiment
    log_echo "INFO" "Setup Ludwig experiment No. $EXP_NO"

    # Experiment specific variables
    EXP_NAME="exp${EXP_NO}_${EXP_ROOT_NAME}"
    EXP_DIR=$PROJECT_DIR/ludwig/experiments/$EXP_NAME
    EXP_CFG=$BILDERSKRIPT_DIR/ludwig/experiments/$EXP_NAME/exp.cfg

    # create training images
    IMG_TRAIN_PATH=$IMG_TRAIN_DIR/$EXP_NAME
    log_echo "INFO" "Create training images: $IMG_TRAIN_PATH "
    CONVERT_PARAM="${EXP_PARAM[$EXP_NO]}"
    EXEC_CMD="$PROJECT_DIR/scripts/ludwig/filter_images.sh \"$IMG_TRAIN_BASE\" \"$IMG_TRAIN_PATH\" \"$CONVERT_PARAM\""
    run_in_docker "$EXEC_CMD"

    # Prepare experiment: create EXP_DIR and cp MDF template in EXP_DIR
    # by convention, the name is model_definition.yaml
    log_echo "INFO" "Prepare Ludwig experiment with name: $EXP_NAME"
    EXEC_CMD="mkdir -p $EXP_DIR && cp $MDF $EXP_DIR/model_definition.yaml"
    run_in_docker "$EXEC_CMD"

    log_echo "INFO" "Start Ludwig experiment No. $EXP_NO"
    # 2. create the datacsv set
    cd "$SCRIPT_DIR" && ./ludwig_experiment.sh datacsv "$EXP_NAME" "$IMG_TRAIN_PATH"
    # 3. run the experiment
    cd "$SCRIPT_DIR" && ./ludwig_experiment.sh experiment "$EXP_NAME" "$IMG_TRAIN_PATH"
    cd "$SCRIPT_DIR" && ./ludwig_experiment.sh visualize "$EXP_NAME"
    log_echo "INFO" "End Ludwig experiment No. $EXP_NO"

    # log the experiment's loop parameters
    # Note: this does not run in docker container
    log_echo "INFO" "Store experiment loop parameters: $EXP_CFG"
    echo >"$EXP_CFG"
    for var in MDF IMG_TRAIN_BASE IMG_TRAIN_PATH CONVERT_PARAM; do
        declare -p $var | cut -d ' ' -f 3- >>"$EXP_CFG"
    done

done

log_echo "INFO" "Shutdown and cleanup all docker containers"
cd "$SCRIPT_DIR" && ./ludwig_experiment.sh shutdown "$EXP_NAME"
# shutdown this container
shutdown_container
# remove ipc volume, otherwise the socket is blocked
log_echo "INFO" "Remove ipc volume to cleanup UNIX socket"
docker volume rm "$(basename "$DOCKER_COMPOSE_DIR" | tr '[:upper:]' '[:lower:]')_ipc"
