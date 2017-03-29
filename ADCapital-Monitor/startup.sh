#!/bin/sh
source /env.sh

# Configure Machine Agent using controller-info.xml
sed -i "s/<controller-host>/<controller-host>${CONTROLLER}/g" /${MACHINE_AGENT_HOME}/conf/controller-info.xml
sed -i "s/<controller-port>/<controller-port>${APPD_PORT}/g" /${MACHINE_AGENT_HOME}/conf/controller-info.xml
sed -i "s/<account-access-key>/<account-access-key>${ACCESS_KEY}/g" /${MACHINE_AGENT_HOME}/conf/controller-info.xml
sed -i "s/<application-name>/<application-name>${APP_NAME}/g" /${MACHINE_AGENT_HOME}/conf/controller-info.xml
sed -i "s/<tier-name>/<tier-name>${TIER_NAME}/g" /${MACHINE_AGENT_HOME}/conf/controller-info.xml
sed -i "s/<node-name>/<node-name>${NODE_NAME}/g" /${MACHINE_AGENT_HOME}/conf/controller-info.xml

# Uncomment for multi-tenant controllers
sed -i "s/<account-name>/<account-name>${ACCOUNT_NAME%%_*}/g" /${MACHINE_AGENT_HOME}/conf/controller-info.xml

# Configure Docker Process Monitoring
sed -i "s/-Dappdynamics/jmxremote/g" ${MACHINE_AGENT_HOME}/extensions/DockerMonitoring/conf/DockerMonitoring.yml

# Enable SIM and Docker Monitoring via system properties
export SIM_PROPERTIES="-Dappdynamics.sim.enabled=true -Dappdynamics.docker.enabled=true"

# Start Machine Agent
echo MACHINE_AGENT_JAVA_OPTS: ${MACHINE_AGENT_JAVA_OPTS}
echo JMX_OPTS: ${JMX_OPTS}
java ${MACHINE_AGENT_JAVA_OPTS} ${SIM_PROPERTIES} -jar ${MACHINE_AGENT_HOME}/machineagent.jar > ${MACHINE_AGENT_HOME}/machine-agent.out 2>&1 &

# Start rsyslog and tail
service rsyslog start
tail -f /var/log/messages
