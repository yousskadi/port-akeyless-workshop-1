#! /usr/bin/bash

# Akeyless profile configuration
akeyless configure --profile default --access-id "$(jq -r .access_id creds_api_key_auth.json)" --access-key "$(jq -r .access_key creds_api_key_auth.json)"

# Get repository information from git
REPO_URL=$(git config --get remote.origin.url)
REPO_NAME=$(echo $REPO_URL | grep -o 'github.com[:/][^.]*' | sed 's#github.com[:/]##')
GITHUB_USERNAME=$(echo $REPO_NAME | cut -d'/' -f1)

## 1. Create an OAuth2.0/JWT Authentication Method for GitHub
ACCESS_ID=$(akeyless auth-method create oauth2 \
--name /Workshops/Akeyless-Port-1/${GITHUB_USERNAME}/GitHubAuthWorkshop \
--jwks-uri https://token.actions.githubusercontent.com/.well-known/jwks \
--unique-identifier repository \
--force-sub-claims \
--json | jq -r '.access_id')

echo "Access ID to be used as a GitHub Repository Variable: ${ACCESS_ID}"

## 2. Create an Access Role
ACCESS_ROLE=$(akeyless create-role --name /Workshops/Akeyless-Port-1/${GITHUB_USERNAME}/GitHubRoleWorkshop)

## 3. Associate the Authentication Method with an Access Role
akeyless assoc-role-am --role-name /Workshops/Akeyless-Port-1/${GITHUB_USERNAME}/GitHubRoleWorkshop \
--am-name /Workshops/Akeyless-Port-1/${GITHUB_USERNAME}/GitHubAuthWorkshop  \
--sub-claims repository=${REPO_NAME}

## 4. Set Read permissions for our AWS Dynamic Secret for the Access Role
akeyless set-role-rule --role-name /Workshops/Akeyless-Port-1/${GITHUB_USERNAME}/GitHubRoleWorkshop \
--path /Workshops/Akeyless-Port-1/* \
--capability read
