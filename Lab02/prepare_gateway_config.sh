#!/usr/bin/bash

REPO_URL=$(git config --get remote.origin.url)
REPO_NAME=$(echo $REPO_URL | grep -o 'github.com[:/][^.]*' | sed 's#github.com[:/]##')
GITHUB_USERNAME=$(echo $REPO_NAME | cut -d'/' -f1)

helm repo add akeyless https://akeylesslabs.github.io/helm-charts

helm repo update

kubectl create namespace akeyless

yq -i ".globalConfig.gatewayAuth.gatewayAccessId = \"$(jq -r .access_id creds_api_key_auth.json)\"" values.yaml
yq -i ".globalConfig.clusterName = \"${GITHUB_USERNAME}\"" values.yaml
yq -i ".globalConfig.initialClusterDisplayName = \"${GITHUB_USERNAME}\"" values.yaml
yq -i ".globalConfig.allowedAccessPermissions[0].access_id = \"$(jq -r .access_id creds_api_key_auth.json)\"" values.yaml

kubectl create secret -n akeyless generic access-key \
  --from-literal=gateway-access-key=$(jq -r .access_key creds_api_key_auth.json)