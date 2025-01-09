#!/usr/bin/bash

# Authenticate with Akeyless
akeyless configure --profile default --access-id "$(jq -r .access_id creds_api_key_auth.json)" --access-key "$(jq -r .access_key creds_api_key_auth.json)"

# Get repository information from git
REPO_URL=$(git config --get remote.origin.url)
REPO_NAME=$(echo $REPO_URL | grep -o 'github.com[:/][^.]*' | sed 's#github.com[:/]##')
GITHUB_USERNAME=$(echo $REPO_NAME | cut -d'/' -f1)

# Add GitHub PAT credentials to Akeyless
read -p "Enter your GitHub Personal Access Token: " PAT
if akeyless get-secret-value --name /Workshops/Akeyless-Port-1/$GITHUB_USERNAME/github/pat; then
    akeyless update-secret-val --name /Workshops/Akeyless-Port-1/$GITHUB_USERNAME/github/pat \
        --value "{\"pat\": \"$PAT\"}"
else
    akeyless create-secret --name /Workshops/Akeyless-Port-1/$GITHUB_USERNAME/github/pat \
        --value "{\"pat\": \"$PAT\"}"
fi
