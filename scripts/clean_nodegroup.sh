#!/bin/bash

export NG_ID=`curl -s -k -X GET https://$(puppet config print certname):4433/classifier-api/v1/groups --cert $(puppet config print hostcert) --key $(puppet config print hostprivkey) --cacert $(puppet config print cacert) -H "Content-Type: application/json" | jq -r -c '.[] | select(.name | contains("Production environment")) | .id'`

curl -k -X POST https://$(puppet config print certname):4433/classifier-api/v1/groups/$NG_ID --cert $(puppet config print hostcert) --key $(puppet config print hostprivkey) --cacert $(puppet config print cacert) -H "Content-Type: application/json" -d '{"rule": null }'

