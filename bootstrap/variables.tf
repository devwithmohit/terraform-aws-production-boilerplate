variable "aws_region" {
  description = "AWS region where backend state resources will be provisioned."
  type        = string
  default     = "ap-south-1"
}

variable "project_name" {
  description = "Project name prefix used to label state resources."
  type        = string
  default     = "terraform-aws-setup"
}
