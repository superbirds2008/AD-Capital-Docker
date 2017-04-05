#!/bin/bash
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

# Configure analytics-agent.properties
aaprop=${MACHINE_AGENT_HOME}/monitors/analytics-agent/conf/analytics-agent.properties
sed -i "/^ad.agent.name=/c\ad.agent.name=http:\/\/${APP_NAME}-analytics" ${aaprop}
sed -i "/^appdynamics.agent.uniqueHostId=/c\appdynamics.agent.uniqueHostId=${APP_NAME}-host" ${aaprop}
sed -i "/^ad.controller.url=/c\ad.controller.url=http:\/\/${CONTROLLER}:${APPD_PORT}" ${aaprop}
sed -i "/^http.event.endpoint=/c\http.event.endpoint=http:\/\/${EVENT_ENDPOINT}\/v1" ${aaprop}
sed -i "/^http.event.accountName=/c\http.event.accountName=${ACCOUNT_NAME}" ${aaprop}
sed -i "/^http.event.accessKey=/c\http.event.accessKey=${ACCESS_KEY}" ${aaprop}

# Configure monitor.xml
monxml=${MACHINE_AGENT_HOME}/monitors/analytics-agent/monitor.xml
sed -i 's#<enabled>false</enabled>#<enabled>true</enabled>#g' ${monxml}

# Start Machine Agent
echo MACHINE_AGENT_JAVA_OPTS: ${MACHINE_AGENT_JAVA_OPTS}
echo JMX_OPTS: ${JMX_OPTS}
java ${MACHINE_AGENT_JAVA_OPTS} ${SIM_PROPERTIES} -jar ${MACHINE_AGENT_HOME}/machineagent.jar > ${MACHINE_AGENT_HOME}/machine-agent.out 2>&1 &

# Start rsyslog and tail
service rsyslog start
tail -f /var/log/syslog
