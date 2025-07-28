#!/bin/bash

###############

# athor: mahantesh
# date: 24/07/2025
#
# this script outputs the node health
#
# version: v1
#####################
set -x #debug mode
set -e #exit the script when there is an error
set -o pipefail
##   echo "print the disk space"

df -h 

##   echo "print the memory"

free -g

##   echo "print the cpu"
   
nproc

ps -ef | grep amazon |awk -F " " '{print $2}'

