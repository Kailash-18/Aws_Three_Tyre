output "frontend_alb_dns_name" {
  description = "Primary frontend ALB DNS name"
  value       = aws_lb.frontend.dns_name
}

output "backend_alb_dns_name" {
  description = "Primary backend ALB DNS name"
  value       = aws_lb.backend.dns_name
}

output "primary_rds_endpoint" {
  description = "Primary RDS endpoint"
  value       = aws_db_instance.primary.address
}

output "primary_rds_arn" {
  description = "Primary RDS ARN used by the secondary read replica"
  value       = aws_db_instance.primary.arn
}

output "bastion_public_ip" {
  description = "Primary bastion public IP"
  value       = aws_instance.bastion.public_ip
}

output "cloudfront_domain_name" {
  description = "CloudFront distribution domain name"
  value       = aws_cloudfront_distribution.frontend.domain_name
}
