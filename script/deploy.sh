#!/usr/bin/env bash

# Invoked by the CurateND Jenkins projects
# Setup and run capistrano to deploy the application and workers.
#
# $0 - this script
# $1 - the environment to run this under
#
# This runs on the same host as jenkins
#
# called from Jenkins command
#       Build -> Execute Shell Command ==
#       test -x $WORKSPACE/script/deploy-preproduction.sh && $WORKSPACE/script/deploy-preproduction.sh
echo "=-=-=-=-=-=-=-= start $0 $1"

source $WORKSPACE/script/common-deploy.sh

do_deploy $1
