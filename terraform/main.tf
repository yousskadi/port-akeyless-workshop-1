provider "aws" {
  region = var.region
}

resource "random_string" "suffix" {
  length  = 8
  special = false
}

data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "tekanaid-terraform-state-workshop"
    key    = "main-vpc/terraform.tfstate"
    region = "us-east-1"
  }
}

provider "port" {
}

# Filter out local zones, which are not currently supported 
# with managed node groups
data "aws_availability_zones" "available" {
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}

locals {
  cluster_name = var.cluster_name == "" ? "education-eks-${random_string.suffix.result}" : var.cluster_name
  # Creating the AWS-AUTH ConfigMap
  # The role below is the role that the GitHub Actions workflow will assume and was created in the workshop_admin_setup/Terraform_IAM_Config/main.tf file. 
  # This allows any just in time credentianals created by akeyless to be used to access the EKS cluster.
  aws_auth_configmap_yaml = <<-EOT
  data:
    mapRoles: |
      - rolearn: arn:aws:iam::047709130171:role/github-actions-eks-role
        username: github-actions
        groups:
          - system:masters
      - rolearn: ${module.eks.eks_managed_node_groups["one"].iam_role_arn}
        username: system:node:{{EC2PrivateDNSName}}
        groups:
          - system:bootstrappers
          - system:nodes
  EOT
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.15.3"

  cluster_name    = local.cluster_name
  cluster_version = var.cluster_version

  vpc_id                         = data.terraform_remote_state.vpc.outputs.vpc_id
  subnet_ids                     = data.terraform_remote_state.vpc.outputs.private_subnets
  cluster_endpoint_public_access = true

  # Disable creation of custom KMS key
  create_kms_key = false

  # Use AWS managed key for cluster encryption
  cluster_encryption_config = {
    resources        = ["secrets"]
    provider_key_arn = "arn:aws:kms:${var.region}:${data.aws_caller_identity.current.account_id}:alias/aws/eks"
  }

  eks_managed_node_group_defaults = {
    ami_type = "AL2_x86_64"
  }

  eks_managed_node_groups = {
    one = {
      name = "node-group-1"

      instance_types = ["t3.small"]

      min_size     = 1
      max_size     = 3
      desired_size = 2
    }

    # two = {
    #   name = "node-group-2"

    #   instance_types = ["t3.small"]

    #   min_size     = 1
    #   max_size     = 2
    #   desired_size = 1
    # }
  }

  # Only manage existing aws-auth ConfigMap, don't try to create it
  #   create_aws_auth_configmap = false
  #   manage_aws_auth_configmap = true

  #   aws_auth_users = [
  #     {
  #       userarn  = data.aws_caller_identity.current.arn
  #       username = data.aws_caller_identity.current.user_id
  #       groups   = ["system:masters"]
  #     },
  #     {
  #       userarn  = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/tmp.sam.gabrail@tekanaid.com.FiLhQ"
  #       username = "tmp.sam.gabrail@tekanaid.com.FiLhQ"
  #       groups   = ["system:masters"]
  #     },
  #     {
  #       userarn  = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/sam"
  #       username = "sam"
  #       groups   = ["system:masters"]
  #     }
  #   ]

}

# Add this data source to get the current AWS account ID
data "aws_caller_identity" "current" {}

# https://aws.amazon.com/blogs/containers/amazon-ebs-csi-driver-is-now-generally-available-in-amazon-eks-add-ons/ 
data "aws_iam_policy" "ebs_csi_policy" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
}

# module "irsa-ebs-csi" {
#   source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
#   version = "4.7.0"

#   create_role                   = true
#   role_name                     = "AmazonEKSTFEBSCSIRole-${module.eks.cluster_name}"
#   provider_url                  = module.eks.oidc_provider
#   role_policy_arns              = [data.aws_iam_policy.ebs_csi_policy.arn]
#   oidc_fully_qualified_subjects = ["system:serviceaccount:kube-system:ebs-csi-controller-sa"]
# }

# resource "aws_eks_addon" "ebs-csi" {
#   cluster_name             = module.eks.cluster_name
#   addon_name               = "aws-ebs-csi-driver"
#   addon_version            = "v1.38.1-eksbuild.1"
#   service_account_role_arn = module.irsa-ebs-csi.iam_role_arn
#   tags = {
#     "eks_addon" = "ebs-csi"
#     "terraform" = "true"
#   }
# }

# Port resources
resource "port_entity" "eks_cluster" {
  identifier = module.eks.cluster_arn
  title      = module.eks.cluster_name
  blueprint  = "eks"
  # run_id     = var.port_run_id
  properties = {
    string_props = {
      "version"  = module.eks.cluster_version,
      "name"     = module.eks.cluster_name,
      "endpoint" = module.eks.cluster_endpoint,
      "roleArn"  = module.eks.cluster_iam_role_arn
    }
  }
  relations = {
    single_relations = {
      "region" = var.region
    }
  }

  depends_on = [module.eks.cluster_name]
}

provider "kubectl" {
  apply_retry_count      = 5
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
  load_config_file       = false
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args        = ["eks", "get-token", "--cluster-name", module.eks.cluster_name, "--region", var.region]
  }
}

resource "kubectl_manifest" "aws_auth" {
  yaml_body = <<YAML
apiVersion: v1
kind: ConfigMap
metadata:
  labels:
    app.kubernetes.io/managed-by: Terraform
  name: aws-auth
  namespace: kube-system
${local.aws_auth_configmap_yaml}
YAML

  depends_on = [module.eks]

  lifecycle {
    ignore_changes = all
  }
}
