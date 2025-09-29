variable "cluster_name" {
  type        = string
  description = "ECS Cluster name"
}

variable "env" {
  type        = string
  description = "Environment name (dev/prod)"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID where ECS will be deployed"
}

variable "public_subnets" {
  type        = list(string)
  description = "List of public subnets for ALB"
}

variable "private_subnets" {
  type        = list(string)
  description = "List of private subnets for ECS services"
}

variable "app_sg_id" {
  type        = string
  description = "Security Group ID for ECS services"
}

variable "ecs_task_execution_role" {
  type        = string
  description = "IAM Role ARN for ECS task execution"
}

variable "appointment_image" {
  type        = string
  description = "Docker image for appointment service"
}

variable "patient_image" {
  type        = string
  description = "Docker image for patient service"
}
