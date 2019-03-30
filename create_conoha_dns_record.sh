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
CNH_DNS_NAME='_acme-challenge.'${CNH_DNS_DOMAIN}
CNH_DNS_TYPE="TXT"
CNH_DNS_DATA=${CERTBOT_VALIDATION}

# -------- #
# FUNCTION #
# -------- #
source ${SCRIPT_PATH}/conoha_dns_api.sh

# ----------------- #
# CREATE DNS RECORD # 
# ----------------- #
create_conoha_dns_record
