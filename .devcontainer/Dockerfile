FROM mcr.microsoft.com/devcontainers/universal:2-linux
ARG TERRAFORM_VERSION=1.5.7
USER root
# Install Terraform and Akeyless
RUN wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
mv terraform /usr/bin && \
rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
# Install Akeyless
curl -o akeyless https://akeyless-cli.s3.us-east-2.amazonaws.com/cli/latest/production/cli-linux-amd64 && \
    sudo chmod +x akeyless && \
    sudo mv akeyless /usr/local/bin && \
# Install AWS
pip install --upgrade pip && \
pip install --upgrade awscli
USER codespace