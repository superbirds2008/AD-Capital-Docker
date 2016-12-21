#!/bin/sh
source /env.sh

. /opt/appdynamics/universal-agent/ua_preload.sh

echo JMX_OPTS: ${JMX_OPTS}
echo LD_PRELOAD: ${LD_PRELOAD}
cd ${CATALINA_HOME}/bin;
export APPDYNAMICS_UA_DEBUG=true

# Start QueueReader app (without javaagent)
java ${JMX_OPTS} -jar ${CLIENT_HOME}/QueueReader.jar &
