# backend.tf for networking directory
terraform {
  backend "s3" {
    bucket         = "eks-automode-tfstate-backend-dev"
    key            = "networking/terraform.tfstate"
    region         = "eu-west-2"
    encrypt        = true
    dynamodb_table = "eks-automode-tfstate-backend-lock-dev"
  }
}
