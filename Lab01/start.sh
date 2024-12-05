#!/usr/bin/bash

# Set the Akeyless access ID and access key
export AKEYLESS_ACCESS_ID=
export AKEYLESS_ACCESS_KEY=

# Check if the Akeyless access ID and access key are set
if [ -z "$AKEYLESS_ACCESS_ID" ] || [ -z "$AKEYLESS_ACCESS_KEY" ]; then
    echo "Error: AKEYLESS_ACCESS_ID and AKEYLESS_ACCESS_KEY must be set."
    echo "Please export AKEYLESS_ACCESS_ID and AKEYLESS_ACCESS_KEY with the appropriate values and try again."
    exit 1
fi

# Initialize Akeyless and configure the profile
akeyless --init
akeyless configure --profile initial --access-id ${AKEYLESS_ACCESS_ID} --access-key ${AKEYLESS_ACCESS_KEY}

# Get the AWS credentials from Akeyless and store in a temporary file
akeyless dynamic-secret get-value -n /Clouds/Workshops/AWS_Lab0 --profile initial > /tmp/aws-credentials

# Print the credentials to the screen
echo "Retrieved AWS Credentials:"
cat /tmp/aws-credentials

echo -e "\nCredentials can be found in the file /tmp/aws-credentials"

# Parse the JSON and extract the access key and secret key
AWS_ACCESS_KEY_ID=$(jq -r '.access_key_id' /tmp/aws-credentials)
AWS_SECRET_ACCESS_KEY=$(jq -r '.secret_access_key' /tmp/aws-credentials)

# Create the AWS credentials file if it does not exist
mkdir -p ~/.aws
touch ~/.aws/credentials

# Write the credentials to the AWS credentials file
cat <<EOL > ~/.aws/credentials
[default]
aws_access_key_id = $AWS_ACCESS_KEY_ID
aws_secret_access_key = $AWS_SECRET_ACCESS_KEY
region = us-east-1
EOL

echo -e "\nAWS credentials have been configured and written to ~/.aws/credentials."
