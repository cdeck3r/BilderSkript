#!/bin/bash
set -eo pipefail

#
# This script writes the ludwig.cfg containing the params
# for the ludwig_server_app.sh.
# This script prepares everything for the client to notifying the server app.
#

# this directory is the script directory
SCRIPT_DIR="$(
    cd "$(dirname "$0")" || exit
    pwd -P
)"
cd "$SCRIPT_DIR" || exit
SCRIPT_NAME=$0

# parameters
DATA_CSV=$1
MODEL_PATH=$2
OUT_DIR=$3
LOG_FILE=$4
OTHER_PARAMS="--batch_size 4 --skip_save_unprocessed_output"

# global vars
LUDWIG_CFG=${SCRIPT_DIR}/ludwig.cfg

# project's root dir
PROJECT_DIR=/bilderskript
# main tools installed by docker
SUPPLEMENTAL_DIR=/opt/builder

# include some common functions
# shellcheck source=/dev/null
source ${PROJECT_DIR}/scripts/funcs.sh

#########################################
# Checks
#########################################
log_echo "INFO" "Start checks ..."
# check docker
# we expect the script to execute within the docker container
check_docker
#
# Check other tools
log_echo "INFO" "Checks done."

if [ ! -f "${DATA_CSV}" ]; then
    log_echo "ERROR" "Ludwig data csv file does not exist: ${DATA_CSV}"
    exit 1
fi

if [ ! -d "${MODEL_PATH}" ]; then
    log_echo "ERROR" "Model directory does not exist: ${MODEL_PATH}"
    exit 1
fi

if [ -d "${OUT_DIR}" ]; then
    log_echo "WARN" "Output directory already exists: ${OUT_DIR}"
    log_echo "INFO" "Will delete output directory: ${OUT_DIR}"
    rm -rf "${OUT_DIR}" || {
        log_echo "Error" "Could not delete output directory: ${OUT_DIR}"
        exit 1
    }
fi

#########################################
#
# main program
#
#########################################

# write cfg file; this is read by hugin_server_app.sh
log_echo "INFO" "Write ludwig config file: ${LUDWIG_CFG}"
{
    echo DATA_CSV=\""${DATA_CSV}"\"
    echo MODEL_PATH=\""${MODEL_PATH}"\"
    echo OUT_DIR=\""${OUT_DIR}"\"
    echo OTHER_PARAMS=\""${OTHER_PARAMS}"\"
    # and the logfile
    echo LOG_FILE=\""${LOG_FILE}"\"
} >"$LUDWIG_CFG"

# now notify the server
${PROJECT_DIR}/scripts/ipc_socket_client.sh ludwig.sock "${SCRIPT_DIR}"/ludwig_client_app.sh
