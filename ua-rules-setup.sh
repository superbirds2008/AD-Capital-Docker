#! /bin/bash

export CONTROLLER=field-test-controller.e2e.appd-test.com
export APPLICATION=AD-Capital

curl -s -X PUT -u 'e2eadmin@customer1:welcome' -H 'Content-type: application/json' -H 'Accept:application/json' http://${CONTROLLER}:8090/controller/universalagent/v1/user/groups/byName/ad-capital-group -d '{"name":"","comments":"AD-Capital UA group"}' | jq

export AD_CAPITAL_RULE=`cat ua-rules.json | jq -c '.'`

curl -s -X PUT -u 'e2eadmin@customer1:welcome' -H 'Content-type: application/json' -H 'Accept:application/json' http://${CONTROLLER}:8090/controller/universalagent/v1/user/rulebooks/byName/ad-capital -d "${AD_CAPITAL_RULE}" | jq

curl -s -X PUT -u 'e2eadmin@customer1:welcome' -H 'Content-type: application/json' -H 'Accept:application/json' http://${CONTROLLER}:8090/controller/universalagent/v1/user/agents/groupsMembership/${APPLICATION}-portal -d '[{"groupName":"ad-capital-group"}]' | jq

curl -s -X PUT -u 'e2eadmin@customer1:welcome' -H 'Content-type: application/json' -H 'Accept:application/json' http://${CONTROLLER}:8090/controller/universalagent/v1/user/agents/groupsMembership/${APPLICATION}-rest -d '[{"groupName":"ad-capital-group"}]' | jq

curl -s -X PUT -u 'e2eadmin@customer1:welcome' -H 'Content-type: application/json' -H 'Accept:application/json' http://${CONTROLLER}:8090/controller/universalagent/v1/user/agents/groupsMembership/${APPLICATION}-verification -d '[{"groupName":"ad-capital-group"}]' | jq

curl -s -X PUT -u 'e2eadmin@customer1:welcome' -H 'Content-type: application/json' -H 'Accept:application/json' http://${CONTROLLER}:8090/controller/universalagent/v1/user/agents/groupsMembership/${APPLICATION}-processor -d '[{"groupName":"ad-capital-group"}]' | jq

curl -s -X PUT -u 'e2eadmin@customer1:welcome' -H 'Content-type: application/json' -H 'Accept:application/json' http://${CONTROLLER}:8090/controller/universalagent/v1/user/agents/groupsMembership/${APPLICATION}-queuereader -d '[{"groupName":"ad-capital-group"}]' | jq

curl -s -X PUT -u 'e2eadmin@customer1:welcome' -H 'Content-type: application/json' -H 'Accept:application/json' http://${CONTROLLER}:8090/controller/universalagent/v1/user/rulebooks/current/ad-capital-group -d '{"ruleBookName":"ad-capital"}' | jq

curl -s -X GET -u 'e2eadmin@customer1:welcome' -H 'Content-type: application/json' http://${CONTROLLER}:8090/controller/universalagent/v1/user/agents/summary | jq

curl -s -X GET -u 'e2eadmin@customer1:welcome' -H 'Content-type: application/json' http://${CONTROLLER}:8090/controller/universalagent/v1/user/rulebooks | jq

curl -s -X GET -u 'e2eadmin@customer1:welcome' -H 'Content-type: application/json' http://${CONTROLLER}:8090/controller/universalagent/v1/user/rulebooks/current/ad-capital-group | jq
