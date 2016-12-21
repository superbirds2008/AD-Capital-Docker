#! /bin/bash

#curl -s -X PUT -u 'e2eadmin@customer1:welcome' -H 'Content-type: application/json' -H 'Accept:application/json' http://master-saas-controller.e2e.appd-test.com:8090/controller/universalagent/v1/user/groups/byName/rest-group -d '{"name":"","comments":"AD-Capital rest group"}' | jq
#curl -s -X PUT -u 'e2eadmin@customer1:welcome' -H 'Content-type: application/json' -H 'Accept:application/json' http://master-saas-controller.e2e.appd-test.com:8090/controller/universalagent/v1/user/groups/byName/portal-group -d '{"name":"","comments":"AD-Capital portal group"}' | jq
#curl -s -X PUT -u 'e2eadmin@customer1:welcome' -H 'Content-type: application/json' -H 'Accept:application/json' http://master-saas-controller.e2e.appd-test.com:8090/controller/universalagent/v1/user/groups/byName/verification-group -d '{"name":"","comments":"AD-Capital verification group"}' | jq
#curl -s -X PUT -u 'e2eadmin@customer1:welcome' -H 'Content-type: application/json' -H 'Accept:application/json' http://master-saas-controller.e2e.appd-test.com:8090/controller/universalagent/v1/user/groups/byName/processor-group -d '{"name":"","comments":"AD-Capital processor group"}' | jq
#curl -s -X PUT -u 'e2eadmin@customer1:welcome' -H 'Content-type: application/json' -H 'Accept:application/json' http://master-saas-controller.e2e.appd-test.com:8090/controller/universalagent/v1/user/groups/byName/queuereader-group -d '{"name":"","comments":"AD-Capital queuereader group"}' | jq

export PORTAL_RULE=`cat ua-portal.json | jq -c '.'`
export REST_RULE=`cat ua-rest.json | jq -c '.'`
export PROCESSOR_RULE=`cat ua-processor.json | jq -c '.'`
export VERIFICATION_RULE=`cat ua-verification.json | jq -c '.'`
export QUEUEREADER_RULE=`cat ua-queuereader.json | jq -c '.'`

curl -s -X PUT -u 'e2eadmin@customer1:welcome' -H 'Content-type: application/json' -H 'Accept:application/json' http://master-saas-controller.e2e.appd-test.com:8090/controller/universalagent/v1/user/rulebooks/byName/portal -d "${PORTAL_RULE}" | jq

curl -s -X PUT -u 'e2eadmin@customer1:welcome' -H 'Content-type: application/json' -H 'Accept:application/json' http://master-saas-controller.e2e.appd-test.com:8090/controller/universalagent/v1/user/rulebooks/byName/rest -d "${REST_RULE}" | jq

curl -s -X PUT -u 'e2eadmin@customer1:welcome' -H 'Content-type: application/json' -H 'Accept:application/json' http://master-saas-controller.e2e.appd-test.com:8090/controller/universalagent/v1/user/rulebooks/byName/verification -d "${VERIFICATION_RULE}" | jq

curl -s -X PUT -u 'e2eadmin@customer1:welcome' -H 'Content-type: application/json' -H 'Accept:application/json' http://master-saas-controller.e2e.appd-test.com:8090/controller/universalagent/v1/user/rulebooks/byName/processor -d "${PROCESSOR_RULE}" | jq

curl -s -X PUT -u 'e2eadmin@customer1:welcome' -H 'Content-type: application/json' -H 'Accept:application/json' http://master-saas-controller.e2e.appd-test.com:8090/controller/universalagent/v1/user/rulebooks/byName/queuereader -d "${QUEUEREADER_RULE}" | jq

curl -s -X PUT -u 'e2eadmin@customer1:welcome' -H 'Content-type: application/json' -H 'Accept:application/json' http://master-saas-controller.e2e.appd-test.com:8090/controller/universalagent/v1/user/agents/groupsMembership/AD-Capital-portal -d '[{"groupName":"portal-group"}]' | jq
curl -s -X PUT -u 'e2eadmin@customer1:welcome' -H 'Content-type: application/json' -H 'Accept:application/json' http://master-saas-controller.e2e.appd-test.com:8090/controller/universalagent/v1/user/rulebooks/current/portal-group -d '{"ruleBookName":"portal"}' | jq

curl -s -X PUT -u 'e2eadmin@customer1:welcome' -H 'Content-type: application/json' -H 'Accept:application/json' http://master-saas-controller.e2e.appd-test.com:8090/controller/universalagent/v1/user/agents/groupsMembership/AD-Capital-rest -d '[{"groupName":"rest-group"}]' | jq
curl -s -X PUT -u 'e2eadmin@customer1:welcome' -H 'Content-type: application/json' -H 'Accept:application/json' http://master-saas-controller.e2e.appd-test.com:8090/controller/universalagent/v1/user/rulebooks/current/rest-group -d '{"ruleBookName":"rest"}' | jq

curl -s -X PUT -u 'e2eadmin@customer1:welcome' -H 'Content-type: application/json' -H 'Accept:application/json' http://master-saas-controller.e2e.appd-test.com:8090/controller/universalagent/v1/user/agents/groupsMembership/AD-Capital-verification -d '[{"groupName":"verification-group"}]' | jq
curl -s -X PUT -u 'e2eadmin@customer1:welcome' -H 'Content-type: application/json' -H 'Accept:application/json' http://master-saas-controller.e2e.appd-test.com:8090/controller/universalagent/v1/user/rulebooks/current/verification-group -d '{"ruleBookName":"verification"}' | jq

curl -s -X PUT -u 'e2eadmin@customer1:welcome' -H 'Content-type: application/json' -H 'Accept:application/json' http://master-saas-controller.e2e.appd-test.com:8090/controller/universalagent/v1/user/agents/groupsMembership/AD-Capital-processor -d '[{"groupName":"processor-group"}]' | jq
curl -s -X PUT -u 'e2eadmin@customer1:welcome' -H 'Content-type: application/json' -H 'Accept:application/json' http://master-saas-controller.e2e.appd-test.com:8090/controller/universalagent/v1/user/rulebooks/current/processor-group -d '{"ruleBookName":"processor"}' | jq

curl -s -X PUT -u 'e2eadmin@customer1:welcome' -H 'Content-type: application/json' -H 'Accept:application/json' http://master-saas-controller.e2e.appd-test.com:8090/controller/universalagent/v1/user/agents/groupsMembership/AD-Capital-queuereader -d '[{"groupName":"queuereader-group"}]' | jq
curl -s -X PUT -u 'e2eadmin@customer1:welcome' -H 'Content-type: application/json' -H 'Accept:application/json' http://master-saas-controller.e2e.appd-test.com:8090/controller/universalagent/v1/user/rulebooks/current/queuereader-group -d '{"ruleBookName":"queuereader"}' | jq

curl -s -X GET -u 'e2eadmin@customer1:welcome' -H 'Content-type: application/json' http://master-saas-controller.e2e.appd-test.com:8090/controller/universalagent/v1/user/rulebooks/current/portal-group | jq
curl -s -X GET -u 'e2eadmin@customer1:welcome' -H 'Content-type: application/json' http://master-saas-controller.e2e.appd-test.com:8090/controller/universalagent/v1/user/rulebooks/current/rest-group | jq
curl -s -X GET -u 'e2eadmin@customer1:welcome' -H 'Content-type: application/json' http://master-saas-controller.e2e.appd-test.com:8090/controller/universalagent/v1/user/rulebooks/current/verification-group | jq
curl -s -X GET -u 'e2eadmin@customer1:welcome' -H 'Content-type: application/json' http://master-saas-controller.e2e.appd-test.com:8090/controller/universalagent/v1/user/rulebooks/current/processor-group | jq
curl -s -X GET -u 'e2eadmin@customer1:welcome' -H 'Content-type: application/json' http://master-saas-controller.e2e.appd-test.com:8090/controller/universalagent/v1/user/rulebooks/current/queuereader-group | jq

curl -s -X GET -u 'e2eadmin@customer1:welcome' -H 'Content-type: application/json' http://master-saas-controller.e2e.appd-test.com:8090/controller/universalagent/v1/user/rulebooks | jq

curl -s -X GET -u 'e2eadmin@customer1:welcome' -H 'Content-type: application/json' http://master-saas-controller.e2e.appd-test.com:8090/controller/universalagent/v1/user/agents/summary | jq
