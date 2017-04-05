#!/bin/bash

if [ -n "${create_schema}" ]; then export CREATE_SCHEMA=false; fi

if [ -z "${APP_NAME}" ]; then export APP_NAME="AD-Capital"; fi
if [ -z "${CONTROLLER}" ]; then echo "CONTROLLER not defined"; fi
if [ -z "${APPD_PORT}" ]; then echo "APPD_PORT not defined"; fi
if [ -z "${EVENT_ENDPOINT}" ]; then echo "EVENT_ENDPOINT not defined"; fi
if [ -z "${ACCOUNT_NAME}" ]; then echo "ACCOUNT_NAME not defined"; fi
if [ -z "${ACCESS_KEY}" ]; then echo "ACCESS_KEY not defined"; fi
if [ -z "${NODE_NAME}" ]; then echo "NODE_NAME not defined"; fi
if [ -z "${TIER_NAME}" ]; then echo "TIER_NAME not defined"; fi

# Set in Dockerfile based on installed App Server Agent version: _VERSION_STRING will be replaced during build
export VERSION_STRING="_VERSION_STRING"

export UA_CONFIG=${UA_HOME}/conf/universalagent.yaml
#export JAVA_OPTS="-Xmx512m -XX:MaxPermSize=256m"
#export APPD_JAVA_OPTS="${JAVA_OPTS} -Dappdynamics.controller.hostName=${CONTROLLER} -Dappdynamics.controller.port=${APPD_PORT} -Dappdynamics.agent.applicationName=${APP_NAME} -Dappdynamics.agent.tierName=${TIER_NAME} -Dappdynamics.agent.nodeName=${NODE_NAME}";
export MACHINE_AGENT_JAVA_OPTS="${JAVA_OPTS} ${APPD_JAVA_OPTS}"
#export APP_AGENT_JAVA_OPTS="${JAVA_OPTS} ${APPD_JAVA_OPTS} -DjvmRoute=${JVM_ROUTE} -Djava.util.logging.manager=org.apache.juli.ClassLoaderLogManager -Dappdynamics.agent.accountName=${ACCOUNT_NAME%%_*} -Dappdynamics.agent.accountAccessKey=${ACCESS_KEY}";
export JMX_OPTS="-Dcom.sun.management.jmxremote.port=8888  -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false"
