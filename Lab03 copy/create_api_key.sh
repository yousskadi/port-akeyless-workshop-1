#!/bin/bash
set -e

REPO_URL=$(git config --get remote.origin.url)
REPO_NAME=$(echo $REPO_URL | grep -o 'github.com[:/][^.]*' | sed 's#github.com[:/]##')
GITHUB_USERNAME=$(echo $REPO_NAME | cut -d'/' -f1)
AUTH_METHOD_NAME="/Workshops/Workshop2/$GITHUB_USERNAME/APIkey"

echo "Please enter your oidc token:"
read oidc_token
echo "Saving your oidc token into the file token_oidc_auth.txt..."
echo $oidc_token > token_oidc_auth.txt

# Read token from token.txt
token=$(cat token_oidc_auth.txt)

# Check if auth method exists
echo "Checking if auth method exists..."
AUTH_METHOD_EXISTS=$(akeyless auth-method list --token "$token" | jq -r ".auth_methods[] | select(.auth_method_name == \"$AUTH_METHOD_NAME\") | .auth_method_name")

if [ -n "$AUTH_METHOD_EXISTS" ]; then
    echo "Auth method $AUTH_METHOD_NAME already exists. Resetting access key..."
    ACCESS_KEY=$(akeyless reset-access-key --name "$AUTH_METHOD_NAME" --token "$token" --json | jq -r .access_key)
    # Format JSON output consistently
    jq -n \
        --arg name "$AUTH_METHOD_NAME" \
        --arg access_id "$(akeyless auth-method list --token "$token" | jq -r ".auth_methods[] | select(.auth_method_name == \"$AUTH_METHOD_NAME\") | .auth_method_access_id")" \
        --arg access_key "$ACCESS_KEY" \
        '{name: $name, access_id: $access_id, access_key: $access_key}' > creds_api_key_auth.json
else
    echo "Creating an API key with the name $AUTH_METHOD_NAME..."
    akeyless auth-method create api-key --name "$AUTH_METHOD_NAME" --token "$token" --json > creds_api_key_auth.json
fi

echo "Writing your API key credentials into the file creds_api_key_auth.json"
echo "You will need these API key credentials when authenticating into the gateway later"

# Check if role association exists
echo "Checking role association..."
ROLE_ASSOC_EXISTS=$(akeyless auth-method list --token "$token" | \
    jq -r ".auth_methods[] | select(.auth_method_name == \"$AUTH_METHOD_NAME\") | .auth_method_roles_assoc[]? | select(.role_name == \"/Workshops/Workshop2\") | .role_name")

if [ -z "$ROLE_ASSOC_EXISTS" ]; then
    echo "Attempting to associate API key with access role..."
    if ! akeyless assoc-role-am --am-name "$AUTH_METHOD_NAME" --role-name "/Workshops/Workshop2" --token "$token" 2>&1 | grep -q "Status 409 Conflict"; then
        echo "Role association created"
    else
        echo "Role association already exists"
    fi
else
    echo "Role association already exists"
fi