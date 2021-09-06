#!/bin/sh
set -x

cat << EOF > payload_for_create_configuration_version.json
{
  "data": {
    "type": "configuration-versions",
    "attributes": {
      "auto-queue-runs": true
    }
  }
}
EOF

cv=$(curl \
  --header "Authorization: Bearer $TOKEN" \
  --header "Content-Type: application/vnd.api+json" \
  --request POST \
  --data @payload_for_create_configuration_version.json \
  https://app.terraform.io/api/v2/workspaces/$1/configuration-versions)

cv_id=$(echo $cv | jq -r '.data.id')
cv_url=$(echo $cv | jq -r '.data.attributes."upload-url"')


UPLOAD_FILE_NAME="./content-$(date +%s).tar.gz"
tar -zcvf "$UPLOAD_FILE_NAME" -C "content" .

curl \
  --header "Content-Type: application/octet-stream" \
  --request PUT \
  --data-binary @$UPLOAD_FILE_NAME \
  $cv_url

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
      },
      "configuration-version": {
        "data": {
          "type": "configuration-versions",
          "id": "$cv_id"
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
  https://app.terraform.io/api/v2/runs

rm -f payload_for_create_configuration_version.json
rm -f payload_for_execute_run.json
rm -f $UPLOAD_FILE_NAME
