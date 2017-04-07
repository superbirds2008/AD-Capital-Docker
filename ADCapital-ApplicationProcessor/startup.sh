#!/bin/sh
source /env.sh

MACHINE_NAME=ADCapital-ApplicationProcessor

echo "export APP_NAME="${APP_NAME} > /etc/sysconfig/appdynamics-universal-agent
echo "export NODE_NAME="${NODE_NAME} >> /etc/sysconfig/appdynamics-universal-agent
echo "export TIER_NAME="${TIER_NAME} >> /etc/sysconfig/appdynamics-universal-agent

# Handle version string in UA install path
UA_VER=$(cd ${UA_INSTALL}; ls -d ua*)

# Install Universal Agent
# Commandline flag format changed between 4.3 and 4.4
if [[ ${UA_VER} =~ ua4\.4.* ]]; then
  ${UA_INSTALL}/${UA_VER}/bin/install.sh \
    --controller_host ${CONTROLLER} --controller_port ${APPD_PORT} \
    --account_name ${ACCOUNT_NAME%%_*} --account_access_key ${ACCESS_KEY}
elif [[ ${UA_VER} =~ ua4\.3.* ]]; then
  ${UA_INSTALL}/${UA_VER}/bin/install.sh \
    -controller_host ${CONTROLLER} -controller_port ${APPD_PORT} \
    -account_name ${ACCOUNT_NAME%%_*} -account_access_key ${ACCESS_KEY}
fi

# Set LD_PRELOAD and add jre/lib/ext/tools.jar before starting agent JVMs
#/opt/appdynamics/universal-agent/ua --enable-ldpreload
#. /opt/appdynamics/universal-agent/ua_preload.sh
cp ${JAVA_HOME}/lib/tools.jar ${JAVA_HOME}/jre/lib/ext/tools.jar

# Start Tomcat Server
cd ${CATALINA_HOME}/bin;
echo JMX_OPTS: ${JMX_OPTS}
java ${JMX_OPTS} -jar ${CLIENT_HOME}/Verification.jar > java-startup.out 2>&1 &

# Start rsyslog and tail
service rsyslog start
tail -f /var/log/messages
