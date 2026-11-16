variable "aws_region" {
  description = "AWS region for deployment."
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
  default     = "dev"
}

variable "vpc_cidr" {
  description = "CIDR block for dev VPC."
  type        = string
  default     = "10.10.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets."
  type        = list(string)
  default     = ["10.10.1.0/24", "10.10.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets."
  type        = list(string)
  default     = ["10.10.10.0/24", "10.10.20.0/24"]
}

variable "enable_nat_gateway" {
  description = "Whether to provision NAT Gateway in dev."
  type        = bool
  default     = true
}

variable "instance_type" {
  description = "EC2 instance type for dev."
  type        = string
  default     = "t3.micro"
}

variable "associate_public_ip" {
  description = "Whether to associate a public IP with dev EC2 instance."
  type        = bool
  default     = true
}

variable "enable_ssh" {
  description = "Whether to open SSH port 22 in dev security group."
  type        = bool
  default     = false
}

variable "allowed_ssh_cidrs" {
  description = "CIDR blocks allowed SSH access in dev."
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Resource tags."
  type        = map(string)
  default = {
    Owner     = "DevOps-Team"
    Terraform = "true"
  }
}
