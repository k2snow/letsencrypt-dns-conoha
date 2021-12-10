#!/bin/bash

# -------- #
# VARIABLE #
# -------- #
SCRIPT_PATH=$(dirname $(readlink -f $0))
source ${SCRIPT_PATH}/.env

# -------- #
# FUNCTION #
# -------- #
get_conoha_token(){
  curl -sS https://identity.${CNH_REGION}.conoha.io/v2.0/tokens \
  -X POST \
  -H "Accept: application/json" \
  -d '{ "auth": { "passwordCredentials": { "username": "'${CNH_USERNAME}'", "password": "'${CNH_PASSWORD}'" }, "tenantId": "'${CNH_TENANT_ID}'" } }' \
  | jq -r ".access.token.id"
}

get_conoha_domain_id(){
  curl -sS https://dns-service.${CNH_REGION}.conoha.io/v1/domains \
  -X GET \
  -H "Accept: application/json" \
  -H "Content-Type: application/json" \
  -H "X-Auth-Token: ${CNH_TOKEN}" \
  | jq -r '.domains[] | select(.name == "'${CNH_DNS_DOMAIN_ROOT}'") | .id'
}

create_conoha_dns_record(){
  curl -sS https://dns-service.${CNH_REGION}.conoha.io/v1/domains/${CNH_DOMAIN_ID}/records \
  -X POST \
  -H "Accept: application/json" \
  -H "Content-Type: application/json" \
  -H "X-Auth-Token: ${CNH_TOKEN}" \
  -d '{ "name": "'${CNH_DNS_NAME}'", "type": "'${CNH_DNS_TYPE}'", "data": "'${CNH_DNS_DATA}'", "ttl": 60 }'
}

get_conoha_dns_record_id(){
  curl -sS https://dns-service.${CNH_REGION}.conoha.io/v1/domains/${CNH_DOMAIN_ID}/records \
  -X GET \
  -H "Accept: application/json" \
  -H "Content-Type: application/json" \
  -H "X-Auth-Token: ${CNH_TOKEN}" \
  | jq -r '.records[] | select(.name == "'${CNH_DNS_NAME}'" and .data == "'${CNH_DNS_DATA}'") | .id'
}

delete_conoha_dns_record(){
  local delete_id=$1
  curl -sS https://dns-service.${CNH_REGION}.conoha.io/v1/domains/${CNH_DOMAIN_ID}/records/${delete_id} \
  -X DELETE \
  -H "Accept: application/json" \
  -H "Content-Type: application/json" \
  -H "X-Auth-Token: ${CNH_TOKEN}"
}

# ----------- #
# GET A TOKEN #
# ----------- #
CNH_TOKEN=$(get_conoha_token)

# ----------------- #
# GET THE DOMAIN ID #
# ----------------- #
CNH_DOMAIN_ID=$(get_conoha_domain_id)
