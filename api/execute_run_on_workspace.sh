#!/bin/sh


cat << EOF > payload_for_execute_run.json
{
  "data": {
    "attributes": {
      "message": "Custom message"
    },
    "type":"runs",
    "relationships": {
      "workspace": {
        "data": {
          "type": "workspaces",
          "id": "$1"
        }
      }
    }
  }
}
EOF

curl \
  --header "Authorization: Bearer $TOKEN" \
  --header "Content-Type: application/vnd.api+json" \
  --request POST \
  --data @payload_for_execute_run.json \
  https://app.terraform.io/api/v2/runs | jq .

rm -f payload_for_execute_run.json
