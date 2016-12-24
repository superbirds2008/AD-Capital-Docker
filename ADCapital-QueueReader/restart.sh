#!/bin/sh
source /env.sh

# Kill running Tomcat process
PID=$(pgrep -f '.*QueueReader')
echo "Stopping java process: ${PID}"
kill ${PID}

# Set environment for UA
. /opt/appdynamics/universal-agent/ua_preload.sh
echo JMX_OPTS: ${JMX_OPTS}
echo LD_PRELOAD: ${LD_PRELOAD}
export APPDYNAMICS_UA_DEBUG=true

# Start QueueReader app (without javaagent)
cd ${CATALINA_HOME}/bin;
java ${JMX_OPTS} -jar ${CLIENT_HOME}/QueueReader.jar > QueueReader.out  2>&1 &
echo "Started java process: $!"
