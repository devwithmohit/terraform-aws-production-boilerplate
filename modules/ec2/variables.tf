variable "name_prefix" {
  description = "Prefix applied to all resource names created by this module."
  type        = string

  validation {
    condition     = length(var.name_prefix) > 0 && length(var.name_prefix) <= 32
    error_message = "name_prefix must be between 1 and 32 characters."
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

variable "vpc_id" {
  description = "The VPC ID where the security group and instance belong."
  type        = string

  validation {
    condition     = can(regex("^vpc-[a-z0-9]+$", var.vpc_id))
    error_message = "vpc_id must start with 'vpc-' followed by hexadecimal characters."
  }
}

variable "subnet_id" {
  description = "The subnet ID to launch the EC2 instance in."
  type        = string

  validation {
    condition     = can(regex("^subnet-[a-z0-9]+$", var.subnet_id))
    error_message = "subnet_id must start with 'subnet-' followed by hexadecimal characters."
  }
}

variable "instance_type" {
  description = "EC2 instance type."
  type        = string
  default     = "t3.micro"

  validation {
    condition     = can(regex("^(t3|t3a|t4g|m6i|m6a|c6i|c6a|r6i)\\.(nano|micro|small|medium|large|xlarge|2xlarge)$", var.instance_type))
    error_message = "instance_type must belong to a modern general-purpose or compute tier (e.g., t3.micro, t3.medium, m6i.large)."
  }
}

variable "ami_id" {
  description = "Optional specific AMI ID. If null, the latest Amazon Linux AMI matching ami_name_pattern will be resolved dynamically."
  type        = string
  default     = null

  validation {
    condition     = var.ami_id == null || can(regex("^ami-[a-z0-9]+$", var.ami_id))
    error_message = "If provided, ami_id must begin with 'ami-' followed by hexadecimal characters."
  }
}

variable "ami_name_pattern" {
  description = "AMI name search pattern for dynamic lookup."
  type        = string
  default     = "al2023-ami-2023.*-x86_64"
}

variable "ami_architecture" {
  description = "Architecture for AMI lookup."
  type        = string
  default     = "x86_64"

  validation {
    condition     = contains(["x86_64", "arm64"], var.ami_architecture)
    error_message = "ami_architecture must be either 'x86_64' or 'arm64'."
  }
}

variable "key_name" {
  description = "Optional SSH key pair name."
  type        = string
  default     = null
}

variable "associate_public_ip_address" {
  description = "Whether to assign a public IP to the instance."
  type        = bool
  default     = false
}

variable "root_volume_size" {
  description = "Size of the root EBS volume in GiB."
  type        = number
  default     = 20

  validation {
    condition     = var.root_volume_size >= 8 && var.root_volume_size <= 16384
    error_message = "root_volume_size must be between 8 and 16384 GiB."
  }
}

variable "root_volume_type" {
  description = "EBS root volume type."
  type        = string
  default     = "gp3"

  validation {
    condition     = contains(["gp3", "gp2", "io1", "io2"], var.root_volume_type)
    error_message = "root_volume_type must be one of: gp3, gp2, io1, io2."
  }
}

variable "user_data" {
  description = "User data script to execute on instance boot."
  type        = string
  default     = null
}

variable "create_security_group" {
  description = "Whether to create a dedicated security group for this instance."
  type        = bool
  default     = true
}

variable "additional_security_group_ids" {
  description = "List of existing security group IDs to attach to the instance."
  type        = list(string)
  default     = []
}

variable "enable_ssh" {
  description = "Whether to allow inbound SSH (port 22)."
  type        = bool
  default     = false
}

variable "allowed_ssh_cidrs" {
  description = "List of CIDR blocks permitted for SSH ingress."
  type        = list(string)
  default     = []

  validation {
    condition     = alltrue([for c in var.allowed_ssh_cidrs : can(cidrnetmask(c))])
    error_message = "All allowed_ssh_cidrs entries must be valid CIDR blocks."
  }
}

variable "enable_http" {
  description = "Whether to allow inbound HTTP (port 80)."
  type        = bool
  default     = false
}

variable "enable_https" {
  description = "Whether to allow inbound HTTPS (port 443)."
  type        = bool
  default     = false
}

variable "allowed_http_cidrs" {
  description = "List of CIDR blocks permitted for HTTP/HTTPS ingress."
  type        = list(string)
  default     = ["0.0.0.0/0"]

  validation {
    condition     = alltrue([for c in var.allowed_http_cidrs : can(cidrnetmask(c))])
    error_message = "All allowed_http_cidrs entries must be valid CIDR blocks."
  }
}

variable "create_iam_instance_profile" {
  description = "Whether to create and attach an IAM instance profile with AWS Systems Manager (SSM) permissions."
  type        = bool
  default     = true
}

variable "iam_instance_profile_name" {
  description = "Existing IAM instance profile name if create_iam_instance_profile is false."
  type        = string
  default     = null
}

variable "tags" {
  description = "Additional tags to apply to all resources."
  type        = map(string)
  default     = {}
}
