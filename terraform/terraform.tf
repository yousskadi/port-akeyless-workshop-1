terraform {
  backend "s3" {
    bucket = "tekanaid-terraform-state-workshop"
    # key            = "workshop-port-akeyless-1-tekanaidtest/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    kms_key_id     = "alias/terraform-bucket-key"
    dynamodb_table = "terraform-state"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.7.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.5.1"
    }

    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0.4"
    }

    cloudinit = {
      source  = "hashicorp/cloudinit"
      version = "~> 2.3.2"
    }
    port = {
      source  = "port-labs/port-labs"
      version = "2.0.0"
    }
    kubectl = {
      source = "gavinbunney/kubectl"
      version = ">= 1.17.0"
    }
  }

  required_version = "~> 1.3"
}


