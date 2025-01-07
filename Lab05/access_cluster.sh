#! /usr/bin/bash

akeyless configure --profile default --access-id "$(jq -r .access_id creds_api_key_auth.json)" --access-key "$(jq -r .access_key creds_api_key_auth.json)"

DYNAMIC_SECRET_TTL="1h"
# Get repository information from git
REPO_URL=$(git config --get remote.origin.url)
REPO_NAME=$(echo $REPO_URL | grep -o 'github.com[:/][^.]*' | sed 's#github.com[:/]##')
GITHUB_USERNAME=$(echo $REPO_NAME | cut -d'/' -f1)

echo ${GITHUB_USERNAME}

# Clear any existing AWS credentials
unset AWS_ACCESS_KEY_ID
unset AWS_SECRET_ACCESS_KEY
unset AWS_SESSION_TOKEN
unset AWS_DEFAULT_REGION

AWS_CREDS=$(akeyless dynamic-secret get-value --name /Workshops/Akeyless-Port-1/${GITHUB_USERNAME}/AWS-Dynamic)
echo "AWS_CREDS: $AWS_CREDS"

# Add quotes to handle special characters in the credentials
export AWS_ACCESS_KEY_ID="$(echo $AWS_CREDS | jq -r '.access_key_id')"
export AWS_SECRET_ACCESS_KEY="$(echo $AWS_CREDS | jq -r '.secret_access_key')"
export AWS_DEFAULT_REGION="us-east-1"

echo "Exported AWS_ACCESS_KEY_ID: $AWS_ACCESS_KEY_ID"
echo "Exported AWS_SECRET_ACCESS_KEY: $AWS_SECRET_ACCESS_KEY"
echo "Exported AWS_DEFAULT_REGION: $AWS_DEFAULT_REGION"

# Test AWS credentials with explicit region
aws sts get-caller-identity --region us-east-1
aws eks update-kubeconfig --region us-east-1 --name myeks-tekanaidtest