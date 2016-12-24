#! /bin/bash
source /env.sh

# Set Universal Agent logging to DEBUG and refresh interval to 60 sec
sed -i "s/    level: INFO/    level: DEBUG/g" /${UA_HOME}/conf/logging.yaml
sed -i "s/#    interval: 300/    interval: 60/g" /${UA_HOME}/conf/universalagent.yaml
service appdynamics-universal-agent restart
