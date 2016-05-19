#! /bin/bash

echo "#$VAULT_TOKEN#"
echo "#$VAULT_ADDR#"


ADDR=$(echo $VAULT_ADDR | tr -d '\n')

K=$(echo $KEY | tr -d '\n')

TOKEN=$(echo $VAULT_TOKEN | tr -d '\n')

URL="$VAULT_ADDR/v1/secret/$1"



curl -H "X-Vault-Token: $VAULT_TOKEN" $URL

