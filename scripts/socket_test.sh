#!/bin/bash


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
SOCKET_NAME=hugin.sock
CLIENT_APP=${SCRIPT_DIR}/client_app.sh

# check for command line parameters
if [ $# = 2 ]; then
	SOCKET_NAME=$1
	CLIENT_APP=$2
fi
IPC_SOCKET=${PROJECT_DIR}/ipc/${SOCKET_NAME}

# include some common functions
source ./funcs.sh

# does not work when socket is on shared volume
if [ -f ${IPC_SOCKET} ]; then
	log_echo "ERROR" "IPC server socket not found: ${IPC_SOCKET}" 
	log_echo "ERROR" "File does not exist. Abort." 
	exit 1
fi

FILE=/bilderskript/scripts/socket_test.sh
FILE=${IPC_SOCKET}
if [ -S "${FILE}" ]; then
    echo "File exists."
	exit 1
fi

# check for listening socket
check_ipc_server() {
	# Src: https://stackoverflow.com/a/20012536
	ss -l | grep ${SOCKET_NAME} > /dev/null
	echo "$?"
}

# does not work when socket is on shared volume
if [ "$(check_ipc_server)" -ne "0" ]; then
	log_echo "ERROR" "IPC server socket not found: ${IPC_SOCKET}" 
	log_echo "ERROR" "Server socket not found. Abort." 
	exit 1
fi