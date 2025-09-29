# Optional: define names for IAM roles
variable "cluster_role_name" {
  type    = string
  default = "eks-cluster-role"
}

variable "node_role_name" {
  type    = string
  default = "eks-node-role"
}

variable "env" {
  type        = string
  description = "Environment name (dev/prod)"
  default     = "dev"
}
