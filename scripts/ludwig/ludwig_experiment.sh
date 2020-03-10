#!/bin/bash
set -eo pipefail

#
# runs the ludwig experiments in Docker container
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

# takes the first command line argument
# one of [datacsv|experiment|visualize|shutdown]
RUNMODE=$1

#
# Parameters for the experiment
# All paths reference directories _within_ the docker container
#
EXP_NAME=$2 # takes the value from the command line
PROJECT_DIR=/bilderskript
LUD_SCRIPT_DIR=$PROJECT_DIR/scripts/ludwig
IMG_DIR=$PROJECT_DIR/images
IMG_BASE_PATH=$3 # directory of training images
EXP_DIR=$PROJECT_DIR/ludwig/experiments/$EXP_NAME
DATA_CSV=$EXP_DIR/$(basename "$IMG_BASE_PATH").csv
MDF=$EXP_DIR/model_definition.yaml

# for $EXP_DIR/impure.csv
# DATA_CSV_FNAME=impure
DATA_CSV_FNAME=$(basename -- "$DATA_CSV")
DATA_CSV_EXT="${DATA_CSV_FNAME##*.}"
DATA_CSV_FNAME="${DATA_CSV_FNAME%.*}"

#
# Commands to run within the docker container
#

# Create ludwig's input data file
CREATE_DATACSV="mkdir -p $EXP_DIR && cd $EXP_DIR && python ${LUD_SCRIPT_DIR}/create_datacsv.py $IMG_BASE_PATH -o $DATA_CSV "

# Ludwig commands
#
# ludwig experiment ...
LUDWIG_EXP="mkdir -p $EXP_DIR && cd $EXP_DIR && ludwig experiment --comet --data_csv $DATA_CSV --model_definition_file $MDF && cd $EXP_DIR && python ${LUD_SCRIPT_DIR}/comet_exp_setname.py \"$EXP_DIR\""

# ludwig visualize ...
LUDWIG_VIS="mkdir -p $EXP_DIR && cd $EXP_DIR && ludwig visualize --comet --visualization learning_curves --training_statistics $EXP_DIR/results/experiment_run/training_statistics.json && ludwig visualize --comet --visualization confusion_matrix --test_statistics $EXP_DIR/results/experiment_run/test_statistics.json --ground_truth_metadata $EXP_DIR/results/experiment_run/model/train_set_metadata.json && ludwig visualize --comet --visualization compare_performance --model_names $EXP_NAME --test_statistics $EXP_DIR/results/experiment_run/test_statistics.json && ludwig visualize --comet --visualization compare_classifiers_multiclass_multimetric --model_names $EXP_NAME --test_statistics $EXP_DIR/results/experiment_run/test_statistics.json --ground_truth_metadata $EXP_DIR/results/experiment_run/model/train_set_metadata.json -f class && ludwig visualize --comet --visualization calibration_multiclass --model_names $EXP_NAME --probabilities $EXP_DIR/results/experiment_run/class_probabilities.csv --ground_truth $EXP_DIR/$DATA_CSV_FNAME.hdf5 -f class"

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

COMET_ENV=${BILDERSKRIPT_DIR}/.comet.env
if [ ! -f "$COMET_ENV" ]; then
    log_echo "ERROR" "Comet environment file does not exist: $COMET_ENV"
    exit 1
fi

#
# Docker image
# In the context of this script, use this docker image
# Container from this image follows the convention:
#   <BILDERSKRIPT_DIR>_<IMG_NAME>_1
#
IMG_NAME=ludwig
TARGET=latest
IMAGE="${IMG_NAME}:${TARGET}"

# docker functions require the directory of the docker-compose.yml file
if [ ! -f "$BILDERSKRIPT_DIR"/docker-compose.yml ]; then
    log_echo "ERROR" "Docker compose file not found: $BILDERSKRIPT_DIR/docker-compose.yml"
    exit 1
else
    DOCKER_COMPOSE_DIR="$BILDERSKRIPT_DIR"
fi

# include docker functions
# all docker function use the image and containers defined
# in the context of this script
# shellcheck source=/dev/null
source "$(readlink -f "${SCRIPT_DIR}"/../docker_funcs.sh)"

# need to check for invalid params
PARAMFAIL=1

#
# Help text, usage
#
usage() {
    echo -e "Usage:"
    echo -e "$0 [datacsv|experiment] <experiment name> <training image path> "
    echo -e "$0 [visualize|shutdown] <experiment name>"
    echo ""
    echo -e "Default image: ${IMAGE}"
    exit
}

if [ -z "$RUNMODE" ] || [ -z "$EXP_NAME" ]; then
    echo "Too few arguments."
    usage
    exit 1
fi

if [ "$RUNMODE" = "datacsv" ]; then
    if [ -z "$IMG_BASE_PATH" ]; then
        echo "Too few arguments."
        usage
        exit 1
    fi
    LUDWIG_CMD="$CREATE_DATACSV"
    PARAMFAIL=0
fi

if [ "$RUNMODE" = "experiment" ]; then
    if [ -z "$IMG_BASE_PATH" ]; then
        echo "Too few arguments."
        usage
        exit 1
    fi
    LUDWIG_CMD="$LUDWIG_EXP"
    PARAMFAIL=0
fi

if [ "$RUNMODE" = "visualize" ]; then
    LUDWIG_CMD="$LUDWIG_VIS"
    PARAMFAIL=0
fi

if [ $PARAMFAIL -eq 0 ]; then
    # run ludwig command in container
    run_in_docker "$LUDWIG_CMD"
    PARAMFAIL=0
fi

if [ "$RUNMODE" = "shutdown" ]; then
    shutdown_container
    PARAMFAIL=0
fi

if [ $PARAMFAIL -ne 0 ]; then
    echo "Too few arguments."
    usage
    exit 1
fi
