# TFLint Configuration for Terraform Security and Best Practices

config {
  # Enable all rules by default
  disabled_by_default = false

  # Ignore .terraform directories
  ignore_module = {
    "terraform-aws-modules/vpc/aws"            = true
    "terraform-aws-modules/eks/aws"            = true
    "terraform-aws-modules/security-group/aws" = true
  }
}

# AWS Provider Rules
plugin "aws" {
  enabled = true
  version = "0.24.1"
  source  = "github.com/terraform-linters/tflint-ruleset-aws"
}

# Security Rules
rule "aws_instance_invalid_type" {
  enabled = true
}

rule "aws_instance_previous_type" {
  enabled = true
}

rule "aws_route_specified_multiple_targets" {
  enabled = true
}

rule "aws_route_invalid_route_table" {
  enabled = true
}

rule "aws_security_group_rule_invalid_protocol" {
  enabled = true
}

# EKS Specific Rules
rule "aws_eks_cluster_invalid_version" {
  enabled = true
}

rule "aws_eks_node_group_invalid_ami_type" {
  enabled = true
}

rule "aws_eks_node_group_invalid_instance_types" {
  enabled = true
}

# VPC Rules
rule "aws_vpc_invalid_cidr_block" {
  enabled = true
}

rule "aws_subnet_invalid_cidr_block" {
  enabled = true
}

# S3 Security Rules
rule "aws_s3_bucket_invalid_policy" {
  enabled = true
}

rule "aws_s3_bucket_invalid_acl" {
  enabled = true
}
