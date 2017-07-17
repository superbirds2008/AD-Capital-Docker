#! /bin/bash

# Get agent version from zip file
mkdir -p ${APPD_TMP}/appdynamics
unzip -q ${AGENT_ZIP} -d ${APPD_TMP}/appdynamics

APPD_VERSION=$(basename $(find ${APPD_TMP} -maxdepth 2 -type d -name "ver*")) 
echo "App Server Agent Version: ${APPD_VERSION#ver}"

# Create or replace per-version install directory
rm -rf ${APPD_DIR}/${APPD_VERSION#ver} && mkdir -p ${APPD_DIR}/${APPD_VERSION#ver}
cp -r ${APPD_TMP}/appdynamics/. ${APPD_DIR}/${APPD_VERSION#ver}/
rm -rf ${APPD_TMP}/appdynamics

# Copy AppDynamics configuration script to shared volume
echo "Copying AppDynamics configuration script to ${APPD_DIR}"
/bin/cp -f appdynamics.sh ${APPD_DIR}/appdynamics.sh
