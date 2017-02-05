#! /bin/bash

usage() {
echo "The following environment variables must be set: 
   CONTR_HOST (IP address or FQDN for the AppDynamics Controller: do not add scheme or port) 
   APP_NAME (Application name: e.g AD-Capital) 
   CREDENTIALS (Credentials for REST API calls to AppDynamics controller: e.g. user@account:password) 
"
}

if [ -z "${CONTR_HOST}" ]  || [ -z "${APP_NAME}" ] || [ -z "${CREDENTIALS}" ]; then
  usage; exit
fi

export CREDENTIALS=e2eadmin@customer1:welcome

curl -s -X PUT -u "${CREDENTIALS}" -H 'Content-type: application/json' -H 'Accept:application/json' http://${CONTR_HOST}:8090/controller/universalagent/v1/user/groups/byName/ad-capital-group -d '{"name":"","comments":"AD-Capital UA group"}' | jq

# comment/uncomment to apply desired rulebook
export AD_CAPITAL_RULE=`cat ua-rules.json | jq -c '.'`
#export AD_CAPITAL_RULE=`cat ua-rules1.json | jq -c '.'`

curl -s -X PUT -u "${CREDENTIALS}" -H 'Content-type: application/json' -H 'Accept:application/json' http://${CONTR_HOST}:8090/controller/universalagent/v1/user/rulebooks/byName/ad-capital -d "${AD_CAPITAL_RULE}" | jq

curl -s -X PUT -u "${CREDENTIALS}" -H 'Content-type: application/json' -H 'Accept:application/json' http://${CONTR_HOST}:8090/controller/universalagent/v1/user/agents/groupsMembership/${APP_NAME}-portal -d '[{"groupName":"ad-capital-group"}]' | jq

curl -s -X PUT -u "${CREDENTIALS}" -H 'Content-type: application/json' -H 'Accept:application/json' http://${CONTR_HOST}:8090/controller/universalagent/v1/user/agents/groupsMembership/${APP_NAME}-rest -d '[{"groupName":"ad-capital-group"}]' | jq

curl -s -X PUT -u "${CREDENTIALS}" -H 'Content-type: application/json' -H 'Accept:application/json' http://${CONTR_HOST}:8090/controller/universalagent/v1/user/agents/groupsMembership/${APP_NAME}-verification -d '[{"groupName":"ad-capital-group"}]' | jq

curl -s -X PUT -u "${CREDENTIALS}" -H 'Content-type: application/json' -H 'Accept:application/json' http://${CONTR_HOST}:8090/controller/universalagent/v1/user/agents/groupsMembership/${APP_NAME}-processor -d '[{"groupName":"ad-capital-group"}]' | jq

curl -s -X PUT -u "${CREDENTIALS}" -H 'Content-type: application/json' -H 'Accept:application/json' http://${CONTR_HOST}:8090/controller/universalagent/v1/user/agents/groupsMembership/${APP_NAME}-queuereader -d '[{"groupName":"ad-capital-group"}]' | jq

curl -s -X PUT -u "${CREDENTIALS}" -H 'Content-type: application/json' -H 'Accept:application/json' http://${CONTR_HOST}:8090/controller/universalagent/v1/user/rulebooks/current/ad-capital-group -d '{"ruleBookName":"ad-capital"}' | jq

curl -s -X GET -u "${CREDENTIALS}" -H 'Content-type: application/json' http://${CONTR_HOST}:8090/controller/universalagent/v1/user/agents/summary | jq

curl -s -X GET -u "${CREDENTIALS}" -H 'Content-type: application/json' http://${CONTR_HOST}:8090/controller/universalagent/v1/user/rulebooks | jq

curl -s -X GET -u "${CREDENTIALS}" -H 'Content-type: application/json' http://${CONTR_HOST}:8090/controller/universalagent/v1/user/rulebooks/current/ad-capital-group | jq
