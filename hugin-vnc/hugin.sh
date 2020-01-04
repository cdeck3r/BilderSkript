#!/bin/bash


#
# This script configures the password for the vnc server 
# and afterwards starts the vnc server
#

#
# This script starts hugin and exports 
# its GUI via VNC
#
# 1. start this script in docker container
# 2. start VNC viewer on host
# 3. go to localhost:5901
# 4. type in password: hugin-vnc
#

# this directory is the script directory
SCRIPT_DIR="$( cd "$(dirname "$0")" ; pwd -P )"
cd $SCRIPT_DIR
SCRIPT_NAME=$0


# start vnc
source ./startvnc.sh
hugin



