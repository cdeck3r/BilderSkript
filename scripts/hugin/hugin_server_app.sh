#!/bin/bash
set -eo pipefail

# this directory is the script directory
SCRIPT_DIR="$( cd "$(dirname "$0")" ; pwd -P )"
cd $SCRIPT_DIR
SCRIPT_NAME=$0

# global vars
HUGIN_CFG=${SCRIPT_DIR}/hugin.cfg

# project's root dir
PROJECT_DIR=/bilderskript

# include some common functions
source ${PROJECT_DIR}/scripts/funcs.sh

#########################################
#
# main program
#
#########################################

hugin() {
   local _IMG_INPUT=$1
   local _PREFIX=$2
   local _PTO=$3

   cd $(dirname "${_IMG_INPUT}")
   # set symlink
   ln -s "$(basename ${_IMG_INPUT})" image.png
   # copy .pto file into IMG_INPUT directory
   cp "${_PTO}" .
   # start hugin
   hugin_executor --stitching --prefix="${_PREFIX}" "$(basename ${_PTO})" >&2
   # clean up
   rm -rf "$(basename ${_PTO})"
   rm -rf ./image.png
}


# read from stdin
read -r line
log_echo "INFO" "Msg. from client: $line"

if [ "$line" = "START" ]; then
		log_echo "INFO" "Server is processing the request."

		# load params
		source ${HUGIN_CFG}

		# start hugin
		pushd "$(pwd)" >&2
		hugin "${IMG_INPUT}" "${PREFIX}" "${PTO}"
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

