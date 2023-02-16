variable "app_name" {
  type = string
  description = "Application name that will be used as prefix for deployed resources (only lowercase alphanumeric characters and hyphens allowed)"
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
}

variable "aws_access_key" {
  type = string
  description = "Access key to use for creating infrastructure"
}

variable "aws_secret_key" {
  type = string
  description = "Secret key to use for creating infrastructure"
}
