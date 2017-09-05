#! /bin/bash

# Pick up AppDynamics Agent configuration from shared volume (APPD_DIR)
if [ -e ${APPD_DIR}/java-agent/javaagent.jar ]; then
  export APPD_JAVAAGENT=" -javaagent:${APPD_DIR}/java-agent/javaagent.jar"
  echo "APPD_JAVAAGENT: ${APPD_JAVAAGENT}"
else
  echo "AppDynamics Agent not found"
  exit
fi

# AppDynamics connection paramters set via environment varibles
if [ -z "${APPD_CONTR_HOST}" ]; then echo "APPD_CONTR_HOST not defined" && exit; fi
if [ -z "${APPD_CONTR_PORT}" ]; then echo "APPD_CONTR_PORT not defined" && exit; fi
if [ -z "${APPD_CONTR_SSL}" ]; then echo "APPD_CONTR_SSL not defined" && exit; fi
if [ -z "${APPD_ACCOUNT_NAME}" ]; then echo "APPD_ACCOUNT_NAME not defined" && exit; fi
if [ -z "${APPD_ACCESS_KEY}" ]; then echo "APPD_ACCESS_KEY not defined" && exit; fi
if [ -z "${APPD_APP_NAME}" ]; then echo "APPD_APP_NAME not defined" && exit; fi
if [ -z "${APPD_NODE_NAME}" ]; then echo "APPD_NODE_NAME not defined" && exit; fi
if [ -z "${APPD_TIER_NAME}" ]; then echo "APPD_TIER_NAME not defined" && exit; fi

# Export environment variable with AppDynamics Agent properties
export APPD_PROPERTIES="\
 -Dappdynamics.controller.hostName=${APPD_CONTR_HOST}\
 -Dappdynamics.controller.port=${APPD_CONTR_PORT}\
 -Dappdynamics.controller.ssl.enabled=${APPD_CONTR_SSL}\
 -Dappdynamics.agent.accountName=${APPD_ACCOUNT_NAME%%_*}\
 -Dappdynamics.agent.accountAccessKey=${APPD_ACCESS_KEY}\
 -Dappdynamics.agent.applicationName=${APPD_APP_NAME}\
 -Dappdynamics.agent.tierName=${APPD_TIER_NAME}\
 -Dappdynamics.agent.nodeName=${APPD_NODE_NAME}\
 -Dappdynamics.analytics.agent.url=http://monitor:9090/v2/sinks/bt"
echo "APPD_PROPERTIES: ${APPD_PROPERTIES}"
