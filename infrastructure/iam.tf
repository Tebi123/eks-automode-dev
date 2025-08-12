# Data source for AWS account ID
data "aws_caller_identity" "current" {}

# Admin Role
resource "aws_iam_role" "eks_admin" {
  name = "${aws_eks_cluster.dev.name}-admin-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
      }
      Condition = {
        StringEquals = {
          "aws:PrincipalTag/Department" : "DevOps"
        }
      }
    }]
  })

  tags = {
    Name        = "${aws_eks_cluster.dev.name}-admin-role"
    Environment = "dev"
    Purpose     = "EKS Admin Access"
  }
}

# Read-Only Role
resource "aws_iam_role" "eks_readonly" {
  name = "${aws_eks_cluster.dev.name}-readonly-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
      }
      Condition = {
        StringEquals = {
          "aws:PrincipalTag/Department" : ["Development", "QA"]
        }
      }
    }]
  })

  tags = {
    Name        = "${aws_eks_cluster.dev.name}-readonly-role"
    Environment = "dev"
    Purpose     = "EKS Read-Only Access"
  }
}

# Read-Only Policy
resource "aws_iam_policy" "eks_readonly" {
  name        = "${aws_eks_cluster.dev.name}-readonly-policy"
  description = "Read-only access to EKS cluster"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "eks:DescribeCluster",
          "eks:ListClusters",
          "eks:DescribeNodegroup",
          "eks:ListNodegroups",
          "eks:AccessKubernetesApi"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "ec2:DescribeInstances",
          "ec2:DescribeSecurityGroups",
          "ec2:DescribeSubnets",
          "ec2:DescribeVpcs"
        ]
        Resource = "*"
      }
    ]
  })
}

# Attach policies to roles
resource "aws_iam_role_policy_attachment" "eks_admin_full" {
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
  role       = aws_iam_role.eks_admin.name
}

resource "aws_iam_role_policy_attachment" "eks_readonly" {
  policy_arn = aws_iam_policy.eks_readonly.arn
  role       = aws_iam_role.eks_readonly.name
}

# EKS Access Entries
resource "aws_eks_access_entry" "admin" {
  cluster_name  = aws_eks_cluster.dev.name
  principal_arn = aws_iam_role.eks_admin.arn
  type          = "STANDARD"
}

resource "aws_eks_access_entry" "readonly" {
  cluster_name  = aws_eks_cluster.dev.name
  principal_arn = aws_iam_role.eks_readonly.arn
  type          = "STANDARD"
}

# EKS Access Policy Associations
resource "aws_eks_access_policy_association" "admin" {
  cluster_name  = aws_eks_cluster.dev.name
  principal_arn = aws_eks_access_entry.admin.principal_arn

  policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"

  access_scope {
    type = "cluster"
  }
}

resource "aws_eks_access_policy_association" "readonly" {
  cluster_name  = aws_eks_cluster.dev.name
  principal_arn = aws_eks_access_entry.readonly.principal_arn

  policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSViewPolicy"

  access_scope {
    type = "cluster"
  }
}
