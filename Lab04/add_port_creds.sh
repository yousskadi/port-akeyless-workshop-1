#!/usr/bin/bash

# Authenticate with Akeyless
akeyless configure --profile default --access-id "$(jq -r .access_id creds_api_key_auth.json)" --access-key "$(jq -r .access_key creds_api_key_auth.json)"

# Get repository information from git
REPO_URL=$(git config --get remote.origin.url)
REPO_NAME=$(echo $REPO_URL | grep -o 'github.com[:/][^.]*' | sed 's#github.com[:/]##')
GITHUB_USERNAME=$(echo $REPO_NAME | cut -d'/' -f1)

# Add Port credentials to Akeyless

# ask user for client_id and client_secret
read -p "Enter your Port Client ID: " CLIENT_ID
read -p "Enter your Port Client Secret: " CLIENT_SECRET

# first check if the secret already exists and if it does, update it
if akeyless get-secret-value --name /Workshops/Akeyless-Port-1/$GITHUB_USERNAME/port/creds; then
    akeyless update-secret-val --name /Workshops/Akeyless-Port-1/$GITHUB_USERNAME/port/creds \
        --value "{\"client_id\": \"$CLIENT_ID\", \"client_secret\": \"$CLIENT_SECRET\"}"
else
    akeyless create-secret --name /Workshops/Akeyless-Port-1/$GITHUB_USERNAME/port/creds \
        --value "{\"client_id\": \"$CLIENT_ID\", \"client_secret\": \"$CLIENT_SECRET\"}"
fi