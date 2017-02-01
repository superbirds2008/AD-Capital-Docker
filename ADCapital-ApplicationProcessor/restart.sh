#!/bin/sh
source /env.sh

# Kill running Tomcat process
PID=`pgrep -f '.*Verification.*'`
kill ${PID}
sleep 10

# Set environment for UA
#. /opt/appdynamics/universal-agent/ua_preload.sh
#echo LD_PRELOAD: ${LD_PRELOAD}
export APPDYNAMICS_UA_DEBUG=true

# Start Verification (without javaagent)
cd ${CATALINA_HOME}/bin;
java ${JMX_OPTS} -jar ${CLIENT_HOME}/Verification.jar > java-startup.out 2>&1 &
echo "Started java process: $!"
