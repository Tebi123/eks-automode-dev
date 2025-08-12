variable "allowed_cidrs" {
  description = "CIDR blocks allowed to access EKS API server"
  type        = list(string)
  default     = []
}

variable "environment" {
  description = "Environment name (dev/staging/prod)"
  type        = string
  default     = "dev"
}
