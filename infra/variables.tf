variable "app_name" {
  type = string
  description = "Application name that will be used as prefix for deployed resources (only lowercase alphanumeric characters and hyphens allowed)"
  default = "public-and-private-s3"
}

locals {
  name_prefix = var.app_name
  tags = {
    Terraform = "true",
    Application = var.app_name,
  }
}

variable "aws_region" {
  type = string
  description = "Region name where infrastructure will be created"
  default = "eu-central-1"
}
