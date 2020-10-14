#!/bin/bash

export VAULT_ADDR='http://127.0.0.1:8200'

mkdir data

vault server -config=config.hcl &

sleep 10

initResult=$(vault operator init -format=json -key-shares=1 -key-threshold=1)

echo $initResult | jq  > data.json

unsealKey1=$(echo -n $initResult | jq -r '.unseal_keys_b64[0]')
echo $unsealKey1

rootToken1=$(echo -n $initResult | jq -r '.root_token')
echo $rootToken1 > rootToken

echo $(cat data.json | jq -r '.unseal_keys_b64[0]')| xargs -I % vault operator unseal %
