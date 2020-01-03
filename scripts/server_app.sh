#!/bin/bash

#
# This script implements a server application. 
#

# this directory is the script directory
SCRIPT_DIR="$( cd "$(dirname "$0")" ; pwd -P )"
cd $SCRIPT_DIR
SCRIPT_NAME=$0

# project's root dir
PROJECT_DIR=${SCRIPT_DIR}/..
# main tools installed by docker
SUPPLEMENTAL_DIR=/opt/builder

# include some common functions
source ./funcs.sh

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

#########################################
#
# main program
#
#########################################

# read from stdin
read -r line
log_echo "INFO" "Client sent: $line"

if [ "$line" = "START" ]; then
	log_echo "INFO" "Server is processing."
	sleep 3
	# write to stdout
	echo "server app successfully processed data. Done."
	exit 0
else
	# write to stdout
	echo "server app denied access. Abort."
	exit 1
fi
