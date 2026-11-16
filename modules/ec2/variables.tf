variable "name_prefix" {
  description = "Prefix applied to all resource names created by this module."
  type        = string
}

variable "environment" {
  description = "Deployment environment name (e.g., dev, staging, prod)."
  type        = string
}

variable "vpc_id" {
  description = "The VPC ID where the security group and instance belong."
  type        = string
}

variable "subnet_id" {
  description = "The subnet ID to launch the EC2 instance in."
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type."
  type        = string
  default     = "t3.micro"
}

variable "ami_id" {
  description = "Optional specific AMI ID. If null, the latest Amazon Linux AMI matching ami_name_pattern will be resolved dynamically."
  type        = string
  default     = null
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
}

variable "root_volume_type" {
  description = "EBS root volume type."
  type        = string
  default     = "gp3"
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
