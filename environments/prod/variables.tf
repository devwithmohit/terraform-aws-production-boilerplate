variable "aws_region" {
  description = "AWS region for production deployment."
  type        = string
  default     = "ap-south-1"
}

variable "project_name" {
  description = "Project name prefix."
  type        = string
  default     = "demo-app"
}

variable "environment" {
  description = "Environment identifier."
  type        = string
  default     = "prod"
}

variable "vpc_cidr" {
  description = "CIDR block for production VPC."
  type        = string
  default     = "10.20.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets (spread across 3 AZs)."
  type        = list(string)
  default     = ["10.20.1.0/24", "10.20.2.0/24", "10.20.3.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets (spread across 3 AZs)."
  type        = list(string)
  default     = ["10.20.10.0/24", "10.20.20.0/24", "10.20.30.0/24"]
}

variable "enable_nat_gateway" {
  description = "Whether to provision NAT Gateways in production."
  type        = bool
  default     = true
}

variable "instance_type" {
  description = "EC2 instance type for production workloads."
  type        = string
  default     = "t3.medium"
}

variable "root_volume_size" {
  description = "Root EBS volume size in GiB for production instance."
  type        = number
  default     = 50
}

variable "allowed_ingress_cidrs" {
  description = "CIDR blocks allowed HTTPS access to the private instance."
  type        = list(string)
  default     = ["10.20.0.0/16"]
}

variable "cloudfront_price_class" {
  description = "Price class for production CloudFront distribution."
  type        = string
  default     = "PriceClass_100"
}

variable "tags" {
  description = "Resource tags applied to production resources."
  type        = map(string)
  default = {
    Owner       = "DevOps-Core"
    Terraform   = "true"
    Criticality = "Tier-1"
    CostCenter  = "infrastructure-production"
  }
}
