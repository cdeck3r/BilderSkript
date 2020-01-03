#!/bin/bash

#
# This script creates an IPC server listening on 
# a UNIX socket and connects it with a server app.
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
SERVER_APP=${SCRIPT_DIR}/server_app.sh

# check for command line parameters
if [ $# = 2 ]; then
	SOCKET_NAME=$1
	SERVER_APP=$2
fi
IPC_SOCKET=${PROJECT_DIR}/ipc/${SOCKET_NAME}


# include some common functions
source ./funcs.sh

#########################################
# Checks
#########################################
if [ ! -f ${SERVER_APP} ] || [ ! -x ${SERVER_APP} ]; then
	log_echo "ERROR" "Server app does not exist or is not executable: $SERVER_APP"
	exit 1
fi

# check docker
# we expect the script to execute within the docker container
check_docker
log_echo "INFO" "Start checks" 

# socat (man page: https://linux.die.net/man/1/socat)
# Source: https://stackoverflow.com/a/677212
command -v socat >/dev/null 2>&1 || { echo >&2 "I require socat, but it's not installed. Abort."; exit 1; }

# ss (man page: https://linux.die.net/man/8/ss)
# Source: https://stackoverflow.com/a/677212
command -v ss >/dev/null 2>&1 || { echo >&2 "I require ss, but it's not installed. Abort."; exit 1; }

log_echo "INFO" "Checks done." 

#########################################
#
# main program
#
#########################################
log_echo "INFO" "IPC server socket started: $IPC_SOCKET"
log_echo "INFO" "Connect socket with app: $SERVER_APP"
socat UNIX-LISTEN:${IPC_SOCKET},fork,max-children=1 SYSTEM:${SERVER_APP}

#sleep 5