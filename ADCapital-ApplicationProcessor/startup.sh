#!/bin/sh
source /env.sh

MACHINE_NAME=ADCapital-ApplicationProcessor

# Configure App Server Agent using controller-info.xml
#sed -i "s/<controller-host>/<controller-host>${CONTROLLER}/g" /${CATALINA_HOME}/appagent/conf/controller-info.xml
#sed -i "s/<controller-port>/<controller-port>${APPD_PORT}/g" /${CATALINA_HOME}/appagent/conf/controller-info.xml
#sed -i "s/<account-access-key>/<account-access-key>${ACCESS_KEY}/g" /${CATALINA_HOME}/appagent/conf/controller-info.xml
#sed -i "s/<application-name>/<application-name>${APP_NAME}/g" /${CATALINA_HOME}/appagent/conf/controller-info.xml
#sed -i "s/<tier-name>/<tier-name>${TIER_NAME}/g" /${CATALINA_HOME}/appagent/conf/controller-info.xml
#sed -i "s/<node-name>/<node-name>${NODE_NAME}/g" /${CATALINA_HOME}/appagent/conf/controller-info.xml
# Uncomment for multi-tenant controllers
# sed -i "s/<account-name>/<account-name>${ACCOUNT_NAME%%_*}/g" /${CATALINA_HOME}/appagent/conf/controller-info.xml

# Configure Machine Agent using controller-info.xml
#sed -i "s/<controller-host>/<controller-host>${CONTROLLER}/g" /${MACHINE_AGENT_HOME}/conf/controller-info.xml
#sed -i "s/<controller-port>/<controller-port>${APPD_PORT}/g" /${MACHINE_AGENT_HOME}/conf/controller-info.xml
#sed -i "s/<account-access-key>/<account-access-key>${ACCESS_KEY}/g" /${MACHINE_AGENT_HOME}/conf/controller-info.xml
#sed -i "s/<application-name>/<application-name>${APP_NAME}/g" /${MACHINE_AGENT_HOME}/conf/controller-info.xml
#sed -i "s/<tier-name>/<tier-name>${TIER_NAME}/g" /${MACHINE_AGENT_HOME}/conf/controller-info.xml
#sed -i "s/<node-name>/<node-name>${NODE_NAME}/g" /${MACHINE_AGENT_HOME}/conf/controller-info.xml
#sed -i "s/<machine-path>/<machine-path>${MACHINE_PATH_1}|${MACHINE_PATH_2}|${MACHINE_NAME}/g" ${MACHINE_AGENT_HOME}/conf/controller-info.xml
# Uncomment for multi-tenant controllers
# sed -i "s/<account-name>/<account-name>${ACCOUNT_NAME%%_*}/g" /${MACHINE_AGENT_HOME}/conf/controller-info.xml

# Enable Analytics
#start-analytics

echo "export APP_NAME="${APP_NAME} > /etc/sysconfig/appdynamics-universal-agent
echo "export NODE_NAME="${NODE_NAME} >> /etc/sysconfig/appdynamics-universal-agent
echo "export TIER_NAME="${TIER_NAME} >> /etc/sysconfig/appdynamics-universal-agent

# Install Universal Agent
${UA_INSTALL}/ua4.3.0.0/bin/install.sh -controller_host ${CONTROLLER} -controller_port ${APPD_PORT} -account_name ${ACCOUNT_NAME%%_*} -account_access_key ${ACCESS_KEY}

# Set LD_PRELOAD and add jre/lib/ext/tools.jar before starting agent JVMs
#/opt/appdynamics/universal-agent/ua --enable-ldpreload
#. /opt/appdynamics/universal-agent/ua_preload.sh
cp ${JAVA_HOME}/lib/tools.jar ${JAVA_HOME}/jre/lib/ext/tools.jar

# Start Machine Agent
#echo MACHINE_AGENT_JAVA_OPTS: ${MACHINE_AGENT_JAVA_OPTS}
#echo JMX_OPTS: ${JMX_OPTS}
#java ${MACHINE_AGENT_JAVA_OPTS} -jar ${MACHINE_AGENT_HOME}/machineagent.jar > ${MACHINE_AGENT_HOME}/machine-agent.out 2>&1 &

# Start Tomcat Server
cd ${CATALINA_HOME}/bin;
echo JMX_OPTS: ${JMX_OPTS}
java ${JMX_OPTS} -jar ${CLIENT_HOME}/Verification.jar > java-startup.out 2>&1 &

# Start Tomcat with App Server Agent
#echo APP_AGENT_JAVA_OPTS: ${APP_AGENT_JAVA_OPTS};
#java -javaagent:${CATALINA_HOME}/appagent/javaagent.jar ${APP_AGENT_JAVA_OPTS} ${JMX_OPTS} -jar ${CLIENT_HOME}/Verification.jar > java-startup.out 2&>1 &

# Start rsyslog and tail
service rsyslog start
tail -f /var/log/messages
