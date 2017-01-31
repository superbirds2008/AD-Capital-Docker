#!/bin/sh
source /env.sh

# Kill running Tomcat process (started via sudo -u appdynamics)
PID=`pgrep -f 'sudo.*QueueReader.*'`
kill ${PID}
sleep 10

# Set environment for UA
#. /opt/appdynamics/universal-agent/ua_preload.sh
#echo LD_PRELOAD: ${LD_PRELOAD}
export APPDYNAMICS_UA_DEBUG=true

# Start QueueReader app (without javaagent)
cd ${CATALINA_HOME}/bin;
java ${JMX_OPTS} -jar ${CLIENT_HOME}/QueueReader.jar > tomcat-startup.out 2>&1
echo "Started java process: $!"
