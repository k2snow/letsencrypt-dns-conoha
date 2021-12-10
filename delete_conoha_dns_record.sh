#!/bin/bash

# -------- #
# VARIABLE #
# -------- #
# ----- certbot ----- #
# CERTBOT_DOMAIN
# CERTBOT_VALIDATION

# ----- script ----- # 
SCRIPT_NAME=$(basename $0)
SCRIPT_PATH=$(dirname $(readlink -f $0))

# ----- conoha_dns_api.sh  ----- #
CNH_DNS_DOMAIN=${CERTBOT_DOMAIN}'.'
CNH_DNS_DOMAIN_ROOT=`echo ${CNH_DNS_DOMAIN} | sed -r 's/^.*?\.([a-zA-Z0-9]+\.[a-zA-Z0-9]+)/\1/g'`
CNH_DNS_NAME='_acme-challenge.'${CNH_DNS_DOMAIN}
CNH_DNS_TYPE="TXT"
CNH_DNS_DATA=${CERTBOT_VALIDATION}

# -------- #
# FUNCTION #
# -------- #
source ${SCRIPT_PATH}/conoha_dns_api.sh

# ------------- #
# GET RECORD ID #
# ------------- #
CNH_RECORD_ID=$(get_conoha_dns_record_id)

# ----------------- #
# DELETE DNS RECORD #
# ----------------- #
delete_conoha_dns_record ${CNH_RECORD_ID}
