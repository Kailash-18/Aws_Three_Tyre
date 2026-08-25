provider "aws" {
  region = var.region

  default_tags {
    tags = {
      Project     = var.project_name
      Owner       = "Kailash Ambadipudi"
      Author      = "Kailash Ambadipudi"
      Environment = var.environment
      RegionRole  = "secondary"
      ManagedBy   = "Terraform"
    }
  }
}

provider "aws" {
  alias  = "primary"
  region = var.primary_region
}
