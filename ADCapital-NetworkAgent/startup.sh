#!/bin/bash

# Add AppDynamics Agent properties if shared volume is mounted
# APPD_JAVAAGENT and APPD_PROPERTIES environment variables will be set
if [ -e ${APPD_DIR}/appdynamics.sh ]; then
  . ${APPD_DIR}/appdynamics.sh
fi
cd /netviz-agent
./bin/appd-netagent -c ./conf -l ./logs -r ./run
