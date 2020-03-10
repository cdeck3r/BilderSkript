#!/bin/bash
set -eo pipefail

# this directory is the script directory
SCRIPT_DIR="$( cd "$(dirname "$0")" ; pwd -P )"
cd $SCRIPT_DIR
SCRIPT_NAME=$0

# global vars
LUDWIG_CFG=${SCRIPT_DIR}/ludwig.cfg

# project's root dir
PROJECT_DIR=/bilderskript

# include some common functions
source ${PROJECT_DIR}/scripts/funcs.sh

#########################################
#
# main program
#
#########################################

# runs ludwig predict [options]
# src: https://uber.github.io/ludwig/user_guide/#predict
ludwig_predict() {
   local _DATA_CSV=$1
   local _MODEL_PATH=$2
   local _OUT_DIR=$3
   local _OTHER_PARAMS=$4
   local _LOG_FILE=$5

    ludwig predict --data_csv "${_DATA_CSV}" --model_path "${_MODEL_PATH}" --output_directory "${_OUT_DIR}" ${_OTHER_PARAMS} &>> "${_LOG_FILE}"
}


# read from stdin
read -r line
log_echo "INFO" "Msg. from client: $line"

if [ "$line" = "START" ]; then
		log_echo "INFO" "Server is processing the request."

		# load params
		source ${LUDWIG_CFG}

		# start ludwig
		pushd "$(pwd)" >&2
		ludwig_predict "${DATA_CSV}" "${MODEL_PATH}" "${OUT_DIR}" "${OTHER_PARAMS}" "${LOG_FILE}"
		popd >&2

		log_echo "INFO" "Server successfully processed request."

		# write to stdout, inform the client
		echo "SUCCESS: server app processed data - done."
		exit 0
else
	log_echo "ERROR" "Server does not process request. Abort."
	# write to stdout, inform the client
	echo "FAIL: server app denied access. Abort."
	exit 1
fi

