#! /bin/bash

echo "#$VAULT_TOKEN#"
echo "#$VAULT_ADDR#"
echo "#$KEY#"

ADDR=$(echo $VAULT_ADDR | tr -d '\n')

K=$(echo $KEY | tr -d '\n')

TOKEN=$(echo $VAULT_TOKEN | tr -d '\n')

URL="http://$ADDR/v1/secret/$K"

mkdir -p /credentials

curl -H "X-Vault-Token: $TOKEN" $URL > /credentials/app.json

count=0;
while true;
    do echo hello $count;
    (( count++ )) ;
    sleep 10;
done
