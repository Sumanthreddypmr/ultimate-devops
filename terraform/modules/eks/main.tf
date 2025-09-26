resource "aws_eks_cluster" "this" {
  name     = var.cluster_name
  version  = "1.30"
  role_arn = var.cluster_iam_role_arn

  vpc_config {
    subnet_ids = var.private_subnets
    endpoint_private_access = true
    endpoint_public_access  = true
  }

  tags = {
    Name = var.cluster_name
  }

  depends_on = [
    var.cluster_iam_role_arn
  ]
}

# Managed Node Group
resource "aws_eks_node_group" "this" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = "${var.cluster_name}-nodes"
  node_role_arn   = var.node_iam_role_arn
  subnet_ids      = var.private_subnets

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 2
  }

  instance_types = ["t3.medium"]

  

  tags = {
    Name = "${var.cluster_name}-nodes"
  }

  depends_on = [
    aws_eks_cluster.this
  ]
}
