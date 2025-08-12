variable "aws_region" {
  description = "AWS region for backend resources"
  type        = string
  default     = "eu-west-2"
}
variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "eks-automode"
}
variable "aws_account_id" {
  description = "AWS Account ID"
  type        = string
}
variable "environment" {
  description = "Environment name"
  type        = string
  default     = "global"
}
