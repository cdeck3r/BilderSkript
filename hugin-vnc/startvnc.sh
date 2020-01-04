#!/bin/bash

#
# This script configures the password for the vnc server 
# and afterwards starts the vnc server
#

# this directory is the script directory
SCRIPT_DIR="$( cd "$(dirname "$0")" ; pwd -P )"
cd $SCRIPT_DIR
SCRIPT_NAME=$0


# check if Xvnc4 runs
SERVICE="Xvnc4"
if pgrep -x "$SERVICE" >/dev/null
then
    echo "$SERVICE already running"
else
    echo "$SERVICE starts"
	
	mkdir -p ~/.vnc
    
    # if there is a vncpasswd, use it,
    # otherwise no password is required
    if [ -f ./vncpasswd ]; then
        cp ./vncpasswd ~/.vnc/passwd
        chmod 600 ~/.vnc/passwd
        vnc4server -geometry 1400x1200 
    else
        touch ~/.vnc/passwd
        chmod 600 ~/.vnc/passwd
        vnc4server -SecurityTypes None -geometry 1400x1200 
    fi
	
	export DISPLAY=$(hostname):1
fi

