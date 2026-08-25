provider "aws" {
  region = var.region

  default_tags {
    tags = {
      Project     = var.project_name
      Owner       = "Kailash Ambadipudi"
      Author      = "Kailash Ambadipudi"
      Environment = var.environment
      RegionRole  = "primary"
      ManagedBy   = "Terraform"
    }
  }
}
