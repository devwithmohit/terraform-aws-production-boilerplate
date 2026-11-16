variable "aws_region" {
  description = "The AWS region to provision example resources into."
  type        = string
  default     = "ap-south-1"
}

variable "project_name" {
  description = "Project name identifier for prefixing resources."
  type        = string
  default     = "complete-demo"
}

variable "tags" {
  description = "Extra resource tags applied to all resources."
  type        = map(string)
  default = {
    Owner     = "Architecture-Team"
    Terraform = "true"
    Scenario  = "Full-Stack-Example"
  }
}
