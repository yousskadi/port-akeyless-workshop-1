#!/usr/bin/bash

# Akeyless profile configuration
akeyless configure --profile default --access-id "$(jq -r .access_id creds_api_key_auth.json)" --access-key "$(jq -r .access_key creds_api_key_auth.json)"

DYNAMIC_SECRET_TTL="15s"
# Get repository information from git
REPO_URL=$(git config --get remote.origin.url)
REPO_NAME=$(echo $REPO_URL | grep -o 'github.com[:/][^.]*' | sed 's#github.com[:/]##')
GITHUB_USERNAME=$(echo $REPO_NAME | cut -d'/' -f1)
REPO_URL="https://github.com/${REPO_NAME}.git"
# Get AWS credentials from ~/.aws/credentials
AWS_ACCESS_KEY_ID=$(awk -F'=' '/aws_access_key_id/ {gsub(/^[ \t]+|[ \t]+$/, "", $2); print $2}' ~/.aws/credentials)
AWS_SECRET_ACCESS_KEY=$(awk -F'=' '/aws_secret_access_key/ {gsub(/^[ \t]+|[ \t]+$/, "", $2); print $2}' ~/.aws/credentials)
# Get Codespace name and construct Akeyless Gateway URL
CODESPACE_NAME=$(gh codespace list --json name,repository -q ".[] | select(.repository==\"${REPO_NAME}\") | .name")
if [ -z "$CODESPACE_NAME" ]; then
    echo "Error: Could not find codespace for repository ${REPO_NAME}"
    exit 1
fi

CODESPACE_DOMAIN="app.github.dev"
AKEYLESS_GATEWAY_URL="https://${CODESPACE_NAME}-8000.${CODESPACE_DOMAIN}"
echo "${AKEYLESS_GATEWAY_URL}" > akeyless_gateway_url.txt
# Create Akeyless target
echo "Creating Akeyless target..."
akeyless target create aws \
    --name "/Workshops/Akeyless-Port-1/${GITHUB_USERNAME}/AWS" \
    --access-key-id "$AWS_ACCESS_KEY_ID" \
    --access-key "$AWS_SECRET_ACCESS_KEY" \
    --region "us-east-1" || true  # Continue if target already exists

# Create a Rotated AWS Secret
echo "Creating a Rotated AWS Secret..."
echo $GITHUB_USERNAME
akeyless rotated-secret create aws \
    --name "/Workshops/Akeyless-Port-1/${GITHUB_USERNAME}/AWS-Rotated" \
    --target-name "/Workshops/Akeyless-Port-1/${GITHUB_USERNAME}/AWS" \
    --rotation-interval 30 \
    --rotator-type target \
    --auto-rotate true \
    --rotation-hour 10

# Create Akeyless dynamic secret
echo "Creating Akeyless dynamic secret..."
akeyless dynamic-secret create aws \
    --name "/Workshops/Akeyless-Port-1/${GITHUB_USERNAME}/AWS-Dynamic" \
    --target-name "/Workshops/Akeyless-Port-1/${GITHUB_USERNAME}/AWS" \
    --gateway-url "${AKEYLESS_GATEWAY_URL}" \
    --user-ttl "${DYNAMIC_SECRET_TTL}" \
    --aws-access-mode iam_user \
    --aws-user-groups Akeyless-Workshops || true  # Continue if dynamic secret already exists

echo "Configuration completed successfully!"