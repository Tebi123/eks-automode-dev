# Admin User
resource "aws_iam_user" "admin_user" {
  name = "Omotebi-admin"

  tags = {
    Name       = "Omotebi"
    Department = "DevOps"
    Role       = "Admin"
  }
}

# Developer User (Read-Only)
resource "aws_iam_user" "dev_user" {
  name = "Abimbola-dev"

  tags = {
    Name       = "Abimbola"
    Department = "Development"
    Role       = "Developer"
  }
}

# Policy to allow admin user to assume admin role
resource "aws_iam_user_policy" "admin_assume_role" {
  name = "AssumeEKSAdminRole"
  user = aws_iam_user.admin_user.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = "sts:AssumeRole"
      Resource = aws_iam_role.eks_admin.arn
    }]
  })
}

# Policy to allow dev user to assume readonly role
resource "aws_iam_user_policy" "dev_assume_role" {
  name = "AssumeEKSReadOnlyRole"
  user = aws_iam_user.dev_user.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = "sts:AssumeRole"
      Resource = aws_iam_role.eks_readonly.arn
    }]
  })
}
# # EKS Access Entry for Abimbola-dev user directly
# resource "aws_eks_access_entry" "abimbola_user" {
#   cluster_name  = aws_eks_cluster.dev.name
#   principal_arn = aws_iam_user.dev_user.arn  # Direct user access
#   type          = "STANDARD"
# }

# resource "aws_eks_access_policy_association" "abimbola_user" {
#   cluster_name  = aws_eks_cluster.dev.name
#   principal_arn = aws_eks_access_entry.abimbola_user.principal_arn

#   policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSViewPolicy"

#   access_scope {
#     type = "cluster"
#   }
# }
