#!/bin/bash

# Agent download locations
AGENT_DOWNLOAD=${UA_HOME}/download/monitor/java/${APPD_AGENT_VERSION}/java-${APPD_AGENT_VERSION}.zip
MACHINE_AGENT_DOWNLOAD=${UA_HOME}/download/monitor/machine/${APPD_MACHINE_AGENT_VERSION}/machine-${APPD_MACHINE_AGENT_VERSION}-linux.zip

# Installed Agent locations
AGENT_MONITOR=${UA_HOME}/monitor/java/ver${APPD_AGENT_VERSION}
MACHINE_AGENT_MONITOR=${UA_HOME}/monitor/machine/${APPD_MACHINE_AGENT_VERSION}/machine-agent

# Analytics Monitor location (to configure analytics)
ANALYTICS_AGENT_MONITOR=${MACHINE_AGENT_MONITOR}/monitors/analytics-agent

# Timeout for UA agent downloads
TIMEOUT=60

# Enable Transaction/Log Analytics and configure Controller/ES endpoints
configure-analytics(){
  echo "Configuring Analytics Monitor"
  # Configure analytics-agent.properties
  aaprop=${ANALYTICS_AGENT_MONITOR}/conf/analytics-agent.properties

  if [ "${APPD_CONTR_SSL}" == "true" ]; then CONTROLLER_ENDPOINT="https:\/\/"; else CONTROLLER_ENDPOINT="http:\/\/"; fi
  CONTROLLER_ENDPOINT+="${APPD_CONTR_HOST}:${APPD_CONTR_PORT}"
  echo "Controller Endpoint: ${CONTROLLER_ENDPOINT//\\/}"

  if [ "${APPD_ES_SSL}" == "true" ]; then EVENT_ENDPOINT="https:\/\/"; else EVENT_ENDPOINT="http:\/\/"; fi
  EVENT_ENDPOINT+="${APPD_ES_HOST}:${APPD_ES_PORT}\/v1"
  echo "Events Endpoint: ${EVENT_ENDPOINT//\\/}"

  sed -i "/^ad.controller.url=/c\ad.controller.url=${CONTROLLER_ENDPOINT}" ${aaprop}
  sed -i "/^http.event.endpoint=/c\http.event.endpoint=${EVENT_ENDPOINT}" ${aaprop}
  sed -i "/^http.event.accountName=/c\http.event.accountName=${APPD_GLOBAL_ACCOUNT_NAME}" ${aaprop}
  sed -i "/^http.event.accessKey=/c\http.event.accessKey=${APPD_ACCESS_KEY}" ${aaprop}

  # Configure monitor.xml: turn on analytics monitor
  monxml=${ANALYTICS_AGENT_MONITOR}/monitor.xml

  sed -i 's#<enabled>false</enabled>#<enabled>true</enabled>#g' ${monxml}
  echo "Analytics Monitor Enabled"
}

# Configure and Start the Universal Agent
start-ua(){
  echo "Configuring AppDynamics Universal Agent"
  sed -i "s/     controller_host: HOST/     controller_host: ${APPD_CONTR_HOST}/g" /${UA_HOME}/conf/universalagent.yaml
  sed -i "s/     controller_port: 1234/     controller_port: ${APPD_CONTR_PORT}/g" /${UA_HOME}/conf/universalagent.yaml
  sed -i "s/     account_name: ACCOUNT_NAME/     account_name: ${APPD_ACCOUNT_NAME%%_*}/g" /${UA_HOME}/conf/universalagent.yaml
  sed -i "s/     account_access_key: ACCESS_KEY/     account_access_key: ${APPD_ACCESS_KEY}/g" /${UA_HOME}/conf/universalagent.yaml
  sed -i "s/     global_account_name: GLOBAL_ACCOUNT_NAME/     global_account_name: ${APPD_GLOBAL_ACCOUNT_NAME}/g" /${UA_HOME}/conf/universalagent.yaml

  if [ "${APPD_UA_DEBUG}" == "true" ]; then
    sed -i "s/    level: INFO/    level: DEBUG/g" /${UA_HOME}/conf/logging.yaml
  fi

  echo "Starting AppDynamics Universal Agent"
  ${UA_HOME}/ua --daemon &
}

# Stop the Universal Agent
stop-ua(){
  echo "Stopping AppDynamics Universal Agent"
  ps -ef -ww | grep "ua --daemon" | grep -v "grep" | awk '{print $2}' | xargs kill
}

# Download Java agent
# Zip file is downloaded to $UA_HOME/download dir then installed to $UA_HOME/monitor
download-agent(){
  timeout=${TIMEOUT}
  until [ -e ${AGENT_MONITOR} ]; do
    let timeout=$timeout-1
    if [ $timeout -eq 0 ]; then 
      echo "Agent download timed out"
      exit 1
    fi
    sleep 1;
  done

  timeout=${TIMEOUT}
  while [ "$(lsof ${AGENT_DOWNLOAD})" ]; do
    let timeout=$timeout-1
    if [ $timeout -eq 0 ]; then
      echo "Agent download timed out"
      exit 1
    fi
    sleep 1;
  done
}

# Download Machine Agent
# Zip file is downloaded to $UA_HOME/download dir then installed to $UA_HOME/monitor
download-machine-agent(){
  timeout=${TIMEOUT}
  until [ -e ${MACHINE_AGENT_MONITOR} ]; do
    let timeout=$timeout-1
    if [ $timeout -eq 0 ]; then 
      echo "Agent download timed out"
      exit 1
    fi
    sleep 1;
  done

  timeout=${TIMEOUT}
  while [ "$(lsof "${MACHINE_AGENT_DOWNLOAD}")" ]; do
    let timeout=$timeout-1
    if [ $timeout -eq 0 ]; then
      echo "Agent download timed out"
      exit 1
    fi
    sleep 1;
  done
}

# Use Universal Agent to download App Server and Machine Agents
copy-agents(){
  download-agent
  echo "Downloaded App Server Agent ${APPD_AGENT_VERSION}"

  echo "Copying App Server Agent to volume: ${APPD_DIR}"
  mkdir -p ${APPD_DIR}/java-agent && unzip -o -q ${AGENT_DOWNLOAD} -d ${APPD_DIR}/java-agent

  echo "Copying AppDynamics configuration script to volume: ${APPD_DIR}"
  /bin/cp -f appdynamics.sh ${APPD_DIR}/appdynamics.sh

  download-machine-agent
  echo "Downloaded Machine Agent ${APPD_MACHINE_AGENT_VERSION}"
}

# Configure and start Machine Agent
start-machine-agent(){
  # In this example, environment variables are passed to the container at runtime
  # See the AppDynamics Product Docs (Standalone Machine Agent Configuration Reference)
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

  echo "Starting AppDynamics Machine Agent with properties: ${MA_PROPERTIES}"

  # Set permissions for MA scripts
  chmod +x ${MACHINE_AGENT_MONITOR}/scripts/*

  # Start Machine Agent
  java ${MA_PROPERTIES} -jar ${MACHINE_AGENT_MONITOR}/machineagent.jar
}

# Use Universal Agent to download App Server and Machine Agents
start-ua
copy-agents
stop-ua

# Start Machine Agent (for Docker Host monitoring)
start-machine-agent
