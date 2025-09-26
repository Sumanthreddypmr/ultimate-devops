variable "cluster_name" {}

variable "cluster_iam_role_arn" {}

variable "node_iam_role_arn" {}

variable "private_subnets" { 
  type = list(string) 
}

variable "key_name" {
  type    = string
  default = ""  # Optional EC2 SSH key
}
