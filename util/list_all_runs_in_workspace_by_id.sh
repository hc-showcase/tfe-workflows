#!/bin/sh

curl \
  --header "Authorization: Bearer $TOKEN" \
  --header "Content-Type: application/vnd.api+json" \
  https://app.terraform.io/api/v2/workspaces/$1/runs | jq -jr '.data[]|"id:", " ",.id, "\n"'
