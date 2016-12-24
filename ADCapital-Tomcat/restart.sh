#!/bin/sh
source /env.sh

# Kill running Tomcat process
PID=$(pgrep -f '.*Bootstrap')
echo "Stopping java process: ${PID}"
kill ${PID}

# Set environment for UA
. /opt/appdynamics/universal-agent/ua_preload.sh
echo JMX_OPTS: ${JMX_OPTS}
echo LD_PRELOAD: ${LD_PRELOAD}
export APPDYNAMICS_UA_DEBUG=true

# Start Tomcat (without javaagent)
cd ${CATALINA_HOME}/bin;
java ${JMX_OPTS} -cp ${CATALINA_HOME}/bin/bootstrap.jar:${CATALINA_HOME}/bin/tomcat-juli.jar org.apache.catalina.startup.Bootstrap > appserver-agent-startup.out 2>&1 &
echo "Started java process: $!"
