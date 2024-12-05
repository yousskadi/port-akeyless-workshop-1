terraform {
  backend "s3" {
    bucket         = "tekanaid-terraform-state-workshop"
    key            = "main-iam/terraform.tfstate"
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
  }
}

provider "aws" {
  region = "us-east-1"
}

import {
  to = aws_iam_policy.akeyless_access_for_dynamic_secrets
  id = "arn:aws:iam::047709130171:policy/Akeyless_Access_for_Dynamic_Secrets"
}

import {
  to = aws_iam_policy.eks_for_workshops
  id = "arn:aws:iam::047709130171:policy/EKS_for_Workshops"
}


import {
  to = aws_iam_policy.S3-DynamoDB-for-Terraform-Backend
  id = "arn:aws:iam::047709130171:policy/S3-DynamoDB-for-Terraform-Backend"
}

import {
  to = aws_iam_group.akeyless-workshops
  id = "Akeyless-Workshops"
}
# Attach policies to the group
import {
  to = aws_iam_group_policy_attachment.akeyless_access_for_dynamic_secrets
  id = "Akeyless-Workshops/arn:aws:iam::047709130171:policy/Akeyless_Access_for_Dynamic_Secrets"
}

import {
  to = aws_iam_group_policy_attachment.eks_for_workshops
  id = "Akeyless-Workshops/arn:aws:iam::047709130171:policy/EKS_for_Workshops"
}

import {
  to = aws_iam_group_policy_attachment.s3_dynamodb_for_terraform_backend
  id = "Akeyless-Workshops/arn:aws:iam::047709130171:policy/S3-DynamoDB-for-Terraform-Backend"
}

import {
  to = aws_iam_group_policy_attachment.ec2_full_access
  id = "Akeyless-Workshops/arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

import {
  to = aws_iam_user.akeyless
  id = "akeyless"
}

import {
  to = aws_iam_user_policy_attachment.akeyless
  id = "akeyless/arn:aws:iam::047709130171:policy/Akeyless_Access_for_Dynamic_Secrets"
}

resource "aws_iam_policy" "akeyless_access_for_dynamic_secrets" {
  description = "Policy to allow Akeyless to generate AWS dynamic secrets in iam_user mode"
  name        = "Akeyless_Access_for_Dynamic_Secrets"
  path        = "/"
  policy      = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Sid": "VisualEditor0",
        "Effect": "Allow",
        "Action": [
          "iam:DeleteAccessKey",
          "iam:DeletePolicy",
          "iam:AttachRolePolicy",
          "iam:PutRolePolicy",
          "iam:CreateUser",
          "iam:GetGroup",
          "iam:CreateAccessKey",
          "iam:CreateLoginProfile",
          "iam:AddUserToGroup",
          "iam:RemoveUserFromGroup",
          "iam:DetachRolePolicy",
          "iam:DeleteRolePolicy",
          "iam:ListAttachedUserPolicies",
          "iam:DetachGroupPolicy",
          "iam:DetachUserPolicy",
          "iam:DeleteLoginProfile",
          "iam:PutGroupPolicy",
          "iam:ListAccessKeys",
          "iam:ListPolicies",
          "iam:ListGroupPolicies",
          "iam:DeleteUserPolicy",
          "iam:AttachUserPolicy",
          "iam:ListRoles",
          "iam:DeleteUser",
          "iam:ListUserPolicies",
          "iam:TagPolicy",
          "iam:TagUser",
          "iam:ListGroupsForUser",
          "iam:AttachGroupPolicy",
          "iam:PutUserPolicy",
          "iam:UntagPolicy",
          "iam:ListUsers",
          "iam:ListGroups",
          "iam:GetGroupPolicy",
          "iam:DeleteGroupPolicy",
          "iam:GetLoginProfile",
          "iam:ListUserTags"
        ],
        "Resource": "*"
      }
    ]
  })
}

resource "aws_iam_policy" "eks_for_workshops" {
  description = null
  name        = "EKS_for_Workshops"
  path        = "/"
  policy      = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Sid": "VisualEditor0",
        "Effect": "Allow",
        "Action": [
          "eks:*",
          "kms:*",
          "logs:*",
          "iam:CreateOpenIDConnectProvider",
          "iam:TagOpenIDConnectProvider",
          "iam:DeleteOpenIDConnectProvider",
          "iam:DeletePolicyVersion",
          "iam:DeleteRolePolicy",
          "iam:DeletePolicy",
          "iam:DeleteRole",
          "iam:DetachRolePolicy",
          "iam:CreatePolicy",
          "iam:PutRolePolicy",
          "iam:AttachRolePolicy",
          "iam:CreateRole",
          "iam:GetPolicyVersion",
          "iam:GetAccountPasswordPolicy",
          "iam:ListRoleTags",
          "iam:GetMFADevice",
          "iam:ListServerCertificates",
          "iam:GenerateServiceLastAccessedDetails",
          "iam:ListServiceSpecificCredentials",
          "iam:ListSigningCertificates",
          "iam:ListVirtualMFADevices",
          "iam:ListSSHPublicKeys",
          "iam:SimulateCustomPolicy",
          "iam:SimulatePrincipalPolicy",
          "iam:GetAccountEmailAddress",
          "iam:ListAttachedRolePolicies",
          "iam:ListOpenIDConnectProviderTags",
          "iam:ListSAMLProviderTags",
          "iam:ListRolePolicies",
          "iam:GetAccountAuthorizationDetails",
          "iam:GetCredentialReport",
          "iam:ListPolicies",
          "iam:GetServerCertificate",
          "iam:GetRole",
          "iam:ListSAMLProviders",
          "iam:GetPolicy",
          "iam:GetAccessKeyLastUsed",
          "iam:ListEntitiesForPolicy",
          "iam:GetUserPolicy",
          "iam:ListGroupsForUser",
          "iam:GetAccountName",
          "iam:GetGroupPolicy",
          "iam:GetOpenIDConnectProvider",
          "iam:ListSTSRegionalEndpointsStatus",
          "iam:GetRolePolicy",
          "iam:GetAccountSummary",
          "iam:GenerateCredentialReport",
          "iam:GetServiceLastAccessedDetailsWithEntities",
          "iam:ListPoliciesGrantingServiceAccess",
          "iam:ListInstanceProfileTags",
          "iam:ListMFADevices",
          "iam:GetServiceLastAccessedDetails",
          "iam:GetGroup",
          "iam:GetContextKeysForPrincipalPolicy",
          "iam:GetOrganizationsAccessReport",
          "iam:GetServiceLinkedRoleDeletionStatus",
          "iam:ListInstanceProfilesForRole",
          "iam:GenerateOrganizationsAccessReport",
          "iam:GetCloudFrontPublicKey",
          "iam:ListAttachedUserPolicies",
          "iam:ListAttachedGroupPolicies",
          "iam:ListPolicyTags",
          "iam:GetSAMLProvider",
          "iam:ListAccessKeys",
          "iam:GetInstanceProfile",
          "iam:ListGroupPolicies",
          "iam:ListCloudFrontPublicKeys",
          "iam:GetSSHPublicKey",
          "iam:ListRoles",
          "iam:ListUserPolicies",
          "iam:ListInstanceProfiles",
          "iam:GetContextKeysForCustomPolicy",
          "iam:ListPolicyVersions",
          "iam:ListOpenIDConnectProviders",
          "iam:ListServerCertificateTags",
          "iam:ListAccountAliases",
          "iam:ListUsers",
          "iam:GetUser",
          "iam:ListGroups",
          "iam:ListMFADeviceTags",
          "iam:GetLoginProfile",
          "iam:ListUserTags",
          "iam:CreatePolicyVersion"
        ],
        "Resource": "*"
      },
      {
        "Effect": "Allow",
        "Action": [
          "ec2:*"
        ],
        "Resource": [
          "arn:aws:ec2:us-east-1:047709130171:*"
        ]
      },
      {
        "Sid": "Statement1",
        "Effect": "Allow",
        "Action": "iam:PassRole",
        "Resource": [
          "arn:aws:iam::047709130171:role/*"
        ]
      },
      {
        "Effect": "Allow",
        "Action": "iam:CreatePolicyVersion",
        "Resource": "arn:aws:iam::047709130171:policy/*"
      }
    ]
  })
  tags = {}
}

resource "aws_iam_policy" "S3-DynamoDB-for-Terraform-Backend" {
  description = "This policy allows actions by Terraform for storing state in S3 and locking for DynamoDB"
  name        = "S3-DynamoDB-for-Terraform-Backend"
  path        = "/"
  policy      = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "s3:CreateBucket",
          "s3:ListBucket",
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ],
        "Resource": [
          "arn:aws:s3:::tekanaid-terraform-state-workshop",
          "arn:aws:s3:::tekanaid-terraform-state-workshop/*"
        ]
      },
      {
        "Effect": "Allow",
        "Action": [
          "dynamodb:PutItem",
          "dynamodb:GetItem",
          "dynamodb:DeleteItem",
          "dynamodb:UpdateItem",
          "dynamodb:DescribeTable"
        ],
        "Resource": "arn:aws:dynamodb:us-east-1:047709130171:table/terraform-state"
      }
    ]
  })
  tags = {}
}


resource "aws_iam_group_policy_attachment" "s3_dynamodb_for_terraform_backend" {
  group      = "Akeyless-Workshops"
  policy_arn = "arn:aws:iam::047709130171:policy/S3-DynamoDB-for-Terraform-Backend"
}

resource "aws_iam_group" "akeyless-workshops" {
  name = "Akeyless-Workshops"
  path = "/"
}

resource "aws_iam_group_policy_attachment" "akeyless_access_for_dynamic_secrets" {
  group      = "Akeyless-Workshops"
  policy_arn = "arn:aws:iam::047709130171:policy/Akeyless_Access_for_Dynamic_Secrets"
}

resource "aws_iam_group_policy_attachment" "eks_for_workshops" {
  group      = "Akeyless-Workshops"
  policy_arn = "arn:aws:iam::047709130171:policy/EKS_for_Workshops"
}

resource "aws_iam_group_policy_attachment" "ec2_full_access" {
  group      = "Akeyless-Workshops"
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

resource "aws_iam_user" "akeyless" {
  force_destroy        = null
  name                 = "akeyless"
  path                 = "/"
  permissions_boundary = null
  tags                 = {}
  tags_all             = {}
}

resource "aws_iam_user_policy_attachment" "akeyless" {
  policy_arn = "arn:aws:iam::047709130171:policy/Akeyless_Access_for_Dynamic_Secrets"
  user       = "akeyless"
}