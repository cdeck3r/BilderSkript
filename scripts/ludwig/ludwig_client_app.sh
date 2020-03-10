#!/bin/bash
set -eo pipefail

#
# This script implements a client application. 
#

# this directory is the script directory
SCRIPT_DIR="$( cd "$(dirname "$0")" ; pwd -P )"
cd $SCRIPT_DIR
SCRIPT_NAME=$0

# project's root dir
PROJECT_DIR=/bilderskript
# main tools installed by docker
SUPPLEMENTAL_DIR=/opt/builder

# include some common functions
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

#########################################
#
# main program
#
#########################################

# lets send a msg.
log_echo "INFO" "Client send commdand: START" 
echo "START"

read -r line
log_echo "INFO" "Server sent: $line"
