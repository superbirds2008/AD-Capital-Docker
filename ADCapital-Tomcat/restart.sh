#!/bin/sh
source /env.sh

. /opt/appdynamics/universal-agent/ua_preload.sh

echo JMX_OPTS: ${JMX_OPTS}
echo LD_PRELOAD: ${LD_PRELOAD}
cd ${CATALINA_HOME}/bin;
export APPDYNAMICS_UA_DEBUG=true

# Start Tomcat (without javaagent)
java ${JMX_OPTS} -cp ${CATALINA_HOME}/bin/bootstrap.jar:${CATALINA_HOME}/bin/tomcat-juli.jar org.apache.catalina.startup.Bootstrap > appserver-agent-startup.out 2>&1 &

