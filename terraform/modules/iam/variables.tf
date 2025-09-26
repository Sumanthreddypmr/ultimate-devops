# No mandatory variables in IAM module currently.
# Optional: you can define names for IAM roles
variable "cluster_role_name" {
  type    = string
  default = "eks-cluster-role"
}

variable "node_role_name" {
  type    = string
  default = "eks-node-role"
}
