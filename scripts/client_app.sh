#!/bin/bash

#
# This script implements a client application. 
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

# lets send a msg.
echo "START"

read -r line
log_echo "INFO" "Server sent: $line"
