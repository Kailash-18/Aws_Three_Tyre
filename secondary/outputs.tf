output "frontend_alb_dns_name" {
  description = "Secondary frontend ALB DNS name"
  value       = aws_lb.frontend.dns_name
}

output "backend_alb_dns_name" {
  description = "Secondary backend ALB DNS name"
  value       = aws_lb.backend.dns_name
}

output "read_replica_endpoint" {
  description = "Secondary RDS read replica endpoint"
  value       = aws_db_instance.replica.address
}
