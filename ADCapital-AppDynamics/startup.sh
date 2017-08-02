#!/bin/bash

AGENT_DOWNLOAD=$UA_HOME/download/monitor/java/${APPD_AGENT_VERSION}/java-${APPD_AGENT_VERSION}.zip
AGENT_MONITOR=$UA_HOME/monitor/java/ver${APPD_AGENT_VERSION}
MACHINE_AGENT_MONITOR=${UA_HOME}/monitor/machine/${APPD_MACHINE_AGENT_VERSION}/machine-agent
ANALYTICS_AGENT_MONITOR=${MACHINE_AGENT_MONITOR}/monitors/analytics-agent

configure-analytics(){
  # Configure analytics-agent.properties
  aaprop=${ANALYTICS_AGENT_MONITOR}/conf/analytics-agent.properties

  if [ "${APPD_CONTR_SSL}" == "true" ]; then CONTROLLER_ENDPOINT="https:\/\/"; else CONTROLLER_ENDPOINT="http:\/\/"; fi
  CONTROLLER_ENDPOINT+="${APPD_CONTR_HOST}:${APPD_CONTR_PORT}"
  echo "CONTROLLER_ENDPOINT: ${CONTROLLER_ENDPOINT//\\/}"

  if [ "${APPD_ES_SSL}" == "true" ]; then EVENT_ENDPOINT="https:\/\/"; else EVENT_ENDPOINT="http:\/\/"; fi
  EVENT_ENDPOINT+="${APPD_ES_HOST}:${APPD_ES_PORT}\/v1"
  echo "EVENT_ENDPOINT: ${EVENT_ENDPOINT//\\/}"

  sed -i "/^ad.controller.url=/c\ad.controller.url=${CONTROLLER_ENDPOINT}" ${aaprop}
  sed -i "/^http.event.endpoint=/c\http.event.endpoint=${EVENT_ENDPOINT}" ${aaprop}
  sed -i "/^http.event.accountName=/c\http.event.accountName=${APPD_GLOBAL_ACCOUNT_NAME}" ${aaprop}
  sed -i "/^http.event.accessKey=/c\http.event.accessKey=${APPD_ACCESS_KEY}" ${aaprop}

  # Configure monitor.xml: turn on analytics monitor
  monxml=${ANALYTICS_AGENT_MONITOR}/monitor.xml

  sed -i 's#<enabled>false</enabled>#<enabled>true</enabled>#g' ${monxml}
}

echo "Configuring AppDynamics Universal Agent"
sed -i "s/     controller_host: HOST/     controller_host: ${APPD_CONTR_HOST}/g" /${UA_HOME}/conf/universalagent.yaml
sed -i "s/     controller_port: 1234/     controller_port: ${APPD_CONTR_PORT}/g" /${UA_HOME}/conf/universalagent.yaml
sed -i "s/     account_name: ACCOUNT_NAME/     account_name: ${APPD_ACCOUNT_NAME%%_*}/g" /${UA_HOME}/conf/universalagent.yaml
sed -i "s/     account_access_key: ACCESS_KEY/     account_access_key: ${APPD_ACCESS_KEY}/g" /${UA_HOME}/conf/universalagent.yaml
sed -i "s/     global_account_name: GLOBAL_ACCOUNT_NAME/     global_account_name: ${APPD_GLOBAL_ACCOUNT_NAME}/g" /${UA_HOME}/conf/universalagent.yaml

echo "Running AppDynamics Universal Agent"
${UA_HOME}/ua --daemon &

# Configure Universal Agent local rulebook to download required App Server Agent version 
#sed -i "s/VERSION/${APPD_AGENT_VERSION}/g" ${UA_HOME}/rulebook/local.json

# Test for UA to install to monitor folder to ensure zip download is complete
until [ -e $AGENT_MONITOR ]; do sleep 1; done

echo "Copying App Server Agent ${APPD_AGENT_VERSION} to volume: ${APPD_DIR}"
rm -rf ${APPD_DIR}/${APPD_AGENT_VERSION} && mkdir -p ${APPD_DIR}/${APPD_AGENT_VERSION}
unzip -q ${AGENT_DOWNLOAD} -d ${APPD_DIR}/${APPD_AGENT_VERSION}

echo "Copying AppDynamics configuration script to volume: ${APPD_DIR}"
/bin/cp -f appdynamics.sh ${APPD_DIR}/appdynamics.sh

# Test for UA to install to monitor folder to ensure zip download is complete
until [ -e ${ANALYTICS_AGENT_MONITOR}/conf/analytics-agent.properties ]; do sleep 1; done

echo "Downloaded Machine Agent ${APPD_MACHINE_AGENT_VERSION}"

# See the AppDynamics Product Docs (Standalone Machine Agent Configuration Reference)
# In this example, environment variables are passed to the container at runtime
MA_PROPERTIES="-Dappdynamics.controller.hostName=${APPD_CONTR_HOST}"
MA_PROPERTIES+=" -Dappdynamics.controller.port=${APPD_CONTR_PORT}"
MA_PROPERTIES+=" -Dappdynamics.controller.ssl.enabled=${APPD_CONTR_SSL}"
MA_PROPERTIES+=" -Dappdynamics.agent.accountName=${APPD_ACCOUNT_NAME%%_*}" 
MA_PROPERTIES+=" -Dappdynamics.agent.accountAccessKey=${APPD_ACCESS_KEY}" 

# Enable SIM and Docker Monitoring
if [ "${APPD_DOCKER_VISIBILITY}" == "true" ]; then
  MA_PROPERTIES+=" -Dappdynamics.sim.enabled=true -Dappdynamics.docker.enabled=true"
fi

# Enable Analytics
if [ "${APPD_ANALYTICS_MONITOR}" == "true" ]; then
  configure-analytics
fi

echo "MA_PROPERTIES: ${MA_PROPERTIES}"

# Start Machine Agent
chmod +x ${MACHINE_AGENT_MONITOR}/jre/bin/java
chmod +x ${MACHINE_AGENT_MONITOR}/scripts/*
${MACHINE_AGENT_MONITOR}/jre/bin/java ${MA_PROPERTIES} -jar ${MACHINE_AGENT_MONITOR}/machineagent.jar
