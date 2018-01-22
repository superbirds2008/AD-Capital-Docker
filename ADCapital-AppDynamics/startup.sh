#! /bin/bash

# Copy AppDynamics Agent to shared volume
echo "Copying App Server Agent to volume: ${APPD_DIR}"
mkdir -p ${APPD_DIR}/java-agent && unzip -o -q ${AGENT_ZIP} -d ${APPD_DIR}/java-agent

# Copy AppDynamics configuration script to shared volume
echo "Copying AppDynamics configuration script to ${APPD_DIR}"
/bin/cp -f appdynamics.sh ${APPD_DIR}/appdynamics.sh
