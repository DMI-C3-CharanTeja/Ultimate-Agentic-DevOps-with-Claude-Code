variable "region" {
  description = "AWS region for resources"
  type        = string
  default     = "ap-south-1"
}

variable "project_name" {
  description = "Project name for resource naming and tags"
  type        = string
  default     = "portfolio-site"
}

variable "environment" {
  description = "Environment name for resource tags"
  type        = string
  default     = "production"
}

variable "domain_name" {
  description = "Custom domain name for CloudFront distribution (optional)"
  type        = string
  default     = ""
}
