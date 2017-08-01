#! /bin/bash

echo "Configuring AppDynamics Universal Agent"
sed -i "s/     controller_host: HOST/     controller_host: ${APPD_CONTR_HOST}/g" /${UA_HOME}/conf/universalagent.yaml
sed -i "s/     controller_port: 1234/     controller_port: ${APPD_CONTR_PORT}/g" /${UA_HOME}/conf/universalagent.yaml
sed -i "s/     account_name: ACCOUNT_NAME/     account_name: ${APPD_ACCOUNT_NAME%%_*}/g" /${UA_HOME}/conf/universalagent.yaml
sed -i "s/     account_access_key: ACCESS_KEY/     account_access_key: ${APPD_ACCESS_KEY}/g" /${UA_HOME}/conf/universalagent.yaml
sed -i "s/     global_account_name: GLOBAL_ACCOUNT_NAME/     global_account_name: ${APPD_GLOBAL_ACCOUNT_NAME}/g" /${UA_HOME}/conf/universalagent.yaml

# Copy AppDynamics configuration script to shared volume
echo "Copying AppDynamics configuration script to ${APPD_DIR}"
/bin/cp -f appdynamics.sh ${APPD_DIR}/appdynamics.sh

echo "Running AppDynamics Universal Agent..."
${UA_HOME}/ua --daemon &

sed -i "s/VERSION/${APPD_AGENT_VERSION}/g" ${UA_HOME}/rulebook/local.json

AGENT_DOWNLOAD=$UA_HOME/download/monitor/java/${APPD_AGENT_VERSION}/java-${APPD_AGENT_VERSION}.zip
AGENT_MONITOR=$UA_HOME/monitor/java/ver${APPD_AGENT_VERSION}

# Test for UA to install to monitor folder to ensure zip download is complete
until [ -e $AGENT_MONITOR ]; do sleep 1; done
echo "Downloaded App Server Agent: ${APPD_AGENT_VERSION}"

rm -rf ${APPD_DIR}/${APPD_AGENT_VERSION} && mkdir -p ${APPD_DIR}/${APPD_AGENT_VERSION}
unzip -q ${AGENT_DOWNLOAD} -d ${APPD_DIR}/${APPD_AGENT_VERSION}
