#!/bin/bash

#
# This script creates an IPC client which connects 
# a UNIX socket starts a client app.
#

# this directory is the script directory
SCRIPT_DIR="$( cd "$(dirname "$0")" ; pwd -P )"
cd $SCRIPT_DIR
SCRIPT_NAME=$0

# project's root dir
PROJECT_DIR=${SCRIPT_DIR}/..
# main tools installed by docker
SUPPLEMENTAL_DIR=/opt/builder

#
# important global variables
#
SOCKET_NAME=test.sock
CLIENT_APP=${SCRIPT_DIR}/client_app.sh

# check for command line parameters
if [ $# = 2 ]; then
	SOCKET_NAME=$1
	CLIENT_APP=$2
fi
IPC_SOCKET=${PROJECT_DIR}/ipc/${SOCKET_NAME}

# include some common functions
source ./funcs.sh

#########################################
# Checks
#########################################
if [ ! -f ${CLIENT_APP} ] || [ ! -x ${CLIENT_APP} ]; then
	log_echo "ERROR" "Client app does not exist or is not executable: $CLIENT_APP"
	exit 1
fi

# check docker
# we expect the script to execute within the docker container
check_docker
log_echo "INFO" "Start checks ..."

# git version control
# Source: https://stackoverflow.com/a/677212
command -v socat >/dev/null 2>&1 || { echo >&2 "I require socat, but it's not installed. Abort."; exit 1; }

# Hugo static website generator
# Source: https://stackoverflow.com/a/677212
command -v ss >/dev/null 2>&1 || { echo >&2 "I require ss, but it's not installed. Abort."; exit 1; }

log_echo "INFO" "Checks done." 

#########################################
#
# main program
#
#########################################

# check for listening socket
check_ipc_server() {
	# Src: https://stackoverflow.com/a/20012536
	ss -l | grep ${SOCKET_NAME} > /dev/null
	echo "$?"
}
# does not work when socket is on shared volume
if [ "$(check_ipc_server)" -ne "0" ] && [ ! -S ${IPC_SOCKET} ]; then
	log_echo "ERROR" "IPC server socket not found: ${IPC_SOCKET}" 
	log_echo "ERROR" "Abort." 
	exit 1
fi

log_echo "INFO" "IPC client socket started: $IPC_SOCKET"
log_echo "INFO" "Connect socket with app: $CLIENT_APP"
socat UNIX-CONNECT:${IPC_SOCKET} SYSTEM:${CLIENT_APP}

# echo "Start sending test sequence..."
# echo "TEST SEQUENCE: 0101010 sent from IPC client" | socat UNIX-CONNECT:${IPC_SOCKET} -
# if [ $? -eq 0 ]; then
	# echo "Test sequence successfully sent."
	# echo "Done."
# else
	# echo "ERROR sending test sequences."
	# echo "Abort."
	# exit 1
# fi