#!/bin/sh
source /env.sh

# Kill running Tomcat process (started via sudo -u appdynamics)
PID=`pgrep -f 'sudo.*Bootstrap.*'`
kill ${PID}
sleep 10

# Set environment for UA
#. /opt/appdynamics/universal-agent/ua_preload.sh
export APPDYNAMICS_UA_DEBUG=true

# Start Tomcat (without javaagent)
cd ${CATALINA_HOME}/bin;
java ${JMX_OPTS} -cp ${CATALINA_HOME}/bin/bootstrap.jar:${CATALINA_HOME}/bin/tomcat-juli.jar org.apache.catalina.startup.Bootstrap > tomcat-restart.out 2>&1 &
echo "Started java process: $!"

