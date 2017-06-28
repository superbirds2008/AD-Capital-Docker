#!/bin/bash

if [ -z "${APPD_APP_NAME}" ]; then echo "APPD_APP_NAME not defined"; fi
#if [ -z "${APPD_CONTR_HOST}" ]; then echo "APPD_CONTR_HOST not defined"; fi
#if [ -z "${APPD_CONTR_PORT}" ]; then echo "APPD_CONTR_PORT not defined"; fi
#if [ -z "${APPD_CONTR_SSL}" ]; then echo "APPD_CONTR_SSL not defined"; fi
#if [ -z "${APPD_ES_HOST}" ]; then echo "APPD_ES_HOST not defined"; fi
#if [ -z "${APPD_ES_PORT}" ]; then echo "APPD_ES_PORT not defined"; fi
#if [ -z "${APPD_ES_SSL}" ]; then echo "APPD_ES_SSL not defined"; fi
#if [ -z "${APPD_ACCOUNT_NAME}" ]; then echo "APPD_ACCOUNT_NAME not defined"; fi
#if [ -z "${APPD_ACCESS_KEY}" ]; then echo "APPD_ACCESS_KEY not defined"; fi
if [ -z "${APPD_NODE_NAME}" ]; then echo "APPD_NODE_NAME not defined"; fi
if [ -z "${APPD_TIER_NAME}" ]; then echo "APPD_TIER_NAME not defined"; fi

export UA_CONFIG=${UA_HOME}/conf/universalagent.yaml
export JMX_OPTS="-Dcom.sun.management.jmxremote.port=8888  -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false"
