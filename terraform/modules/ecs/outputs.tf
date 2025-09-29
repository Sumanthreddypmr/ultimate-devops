# ECS Cluster Outputs
output "ecs_cluster_id" {
  value = aws_ecs_cluster.this.id
}

output "ecs_cluster_name" {
  value = aws_ecs_cluster.this.name
}

# ECS Service Outputs
output "appointment_service_name" {
  value = aws_ecs_service.appointment.name
}

output "patient_service_name" {
  value = aws_ecs_service.patient.name
}

# Load Balancer Outputs
output "alb_dns_name" {
  value = aws_lb.ecs_alb.dns_name
}
