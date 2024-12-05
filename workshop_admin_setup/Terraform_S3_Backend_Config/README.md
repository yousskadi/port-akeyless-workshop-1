# Overview

This folder is used to create an S3 backend with DynamoDB for Terraform remote state.

## Steps

1. You run Terraform without the backend block. This will create a local state file.
2. Once everything is set-up, you add the backend S3 block as shown below:
```hcl
  backend "s3" {
    bucket         = "terraform-state-backend-prod-mueller"
    key            = "mainstate/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    kms_key_id     = "alias/terraform-bucket-key"
    dynamodb_table = "terraform-state"
  }
```
3. Run `terraform init`
4. Remove the local state file and the state file backup.

## Useful links
- https://spacelift.io/blog/terraform-s3-backend
- https://developer.hashicorp.com/terraform/language/settings/backends/s3