#!/bin/bash

#
# This script writes the hugin.cfg containing the params 
# for the hugin_server_app.sh. Latter runs the 
# hugin application with those parameters. 
#

# this directory is the script directory
SCRIPT_DIR="$( cd "$(dirname "$0")" ; pwd -P )"
cd $SCRIPT_DIR
SCRIPT_NAME=$0

# parameters
PTO_FILE=$1
IMG_INPUT=$2
IMG_OUTPUT=$3

# global vars
HUGIN_CFG=${SCRIPT_DIR}/hugin.cfg

# project's root dir
PROJECT_DIR=/bilderskript
# main tools installed by docker
SUPPLEMENTAL_DIR=/opt/builder

# include some common functions
source ${PROJECT_DIR}/scripts/funcs.sh

#########################################
# Checks
#########################################
# check docker
# we expect the script to execute within the docker container
check_docker
#
# Check other tools
log_echo "INFO" "Start checks ..." 
log_echo "INFO" "Checks done." 

if [ ! -f ${PTO_FILE} ]; then
	log_echo "ERROR" "Hugin pto image does not exist: ${PTO_FILE}"
	exit 1
fi

if [ ! -f ${IMG_INPUT} ]; then
	log_echo "ERROR" "Input image does not exist: ${IMG_INPUT}"
	exit 1
fi

#########################################
#
# main program
#
#########################################

# write cfg file; this is read by hugin_server_app.sh
log_echo "INFO" "Write hugin config file: ${HUGIN_CFG}" 
echo "IMG_INPUT=\"${IMG_INPUT}\"" > "${HUGIN_CFG}"
echo "PREFIX=\"${IMG_OUTPUT}\"" >> "${HUGIN_CFG}"
echo "PTO=\"${PTO_FILE}\"" >> "${HUGIN_CFG}"

# testing
#touch "${IMG_OUTPUT}"

# now notify the server
${PROJECT_DIR}/scripts/ipc_socket_client.sh hugin.sock ${SCRIPT_DIR}/hugin_client_app.sh
