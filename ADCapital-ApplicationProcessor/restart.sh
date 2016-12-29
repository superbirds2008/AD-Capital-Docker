#!/bin/sh
source /env.sh

# Kill running Tomcat process (started via sudo -u appdynamics)
PID=`pgrep -f 'sudo.*Verification.*'`
kill ${PID}
sleep 10

# Set environment for UA
#. /opt/appdynamics/universal-agent/ua_preload.sh
#echo LD_PRELOAD: ${LD_PRELOAD}
export APPDYNAMICS_UA_DEBUG=true

# Start Verification (without javaagent)
cd ${CATALINA_HOME}/bin;
sudo -u appdynamics -b java ${JMX_OPTS} -jar ${CLIENT_HOME}/Verification.jar > java-startup.out 2>&1
echo "Started java process: $!"
