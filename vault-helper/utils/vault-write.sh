#! /bin/bash

DATA=$(cat $2)

curl \
    -H "X-Vault-Token: $VAULT_TOKEN" \
    -H "Content-Type: application/json" \
    -X POST \
    -d "$DATA" \
    $VAULT_ADDR/v1/secret/$1
