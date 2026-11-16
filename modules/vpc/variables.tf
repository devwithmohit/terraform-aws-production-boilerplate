variable "name_prefix" {
  description = "Prefix applied to all resource names created by this module."
  type        = string

  validation {
    condition     = length(var.name_prefix) > 0 && length(var.name_prefix) <= 32
    error_message = "name_prefix must be between 1 and 32 characters in length."
  }
}

variable "environment" {
  description = "Deployment environment name (e.g., dev, staging, prod)."
  type        = string

  validation {
    condition     = contains(["dev", "stage", "staging", "prod", "production", "testing", "example"], var.environment)
    error_message = "environment must be one of: dev, stage, staging, prod, production, testing, example."
  }
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"

  validation {
    condition     = can(cidrnetmask(var.vpc_cidr))
    error_message = "vpc_cidr must be a valid IPv4 CIDR block (e.g., 10.0.0.0/16)."
  }
}

variable "availability_zones" {
  description = "List of availability zones in the region to distribute subnets across."
  type        = list(string)

  validation {
    condition     = length(var.availability_zones) >= 2
    error_message = "At least 2 availability zones must be specified for high availability."
  }
}

variable "public_subnet_cidrs" {
  description = "List of CIDR blocks for public subnets."
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]

  validation {
    condition     = length(var.public_subnet_cidrs) >= 1 && alltrue([for c in var.public_subnet_cidrs : can(cidrnetmask(c))])
    error_message = "All public_subnet_cidrs entries must be valid IPv4 CIDR blocks."
  }
}

variable "private_subnet_cidrs" {
  description = "List of CIDR blocks for private subnets."
  type        = list(string)
  default     = ["10.0.10.0/24", "10.0.20.0/24"]

  validation {
    condition     = length(var.private_subnet_cidrs) >= 1 && alltrue([for c in var.private_subnet_cidrs : can(cidrnetmask(c))])
    error_message = "All private_subnet_cidrs entries must be valid IPv4 CIDR blocks."
  }
}

variable "enable_nat_gateway" {
  description = "Whether to provision NAT Gateways for private subnet outbound internet access."
  type        = bool
  default     = true
}

variable "single_nat_gateway" {
  description = "If true, provision a single shared NAT Gateway across all private subnets to reduce costs (recommended for dev/stage). If false, provision one per AZ for HA (recommended for prod)."
  type        = bool
  default     = true
}

variable "tags" {
  description = "Additional tags to apply to all resources."
  type        = map(string)
  default     = {}
}
