# backend.tf for infrastructure directory
terraform {
  backend "s3" {
    bucket         = "eks-automode-tfstate-backend-dev"
    key            = "infrastructure/terraform.tfstate"
    region         = "eu-west-2"
    encrypt        = true
    dynamodb_table = "eks-automode-tfstate-backend-lock-dev"
  }
}
