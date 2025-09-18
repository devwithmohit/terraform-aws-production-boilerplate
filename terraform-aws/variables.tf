# Variables are used to define input values that can be passed to the Terraform configuration. In this case, we are defining a variable aws_region with a default value of ap-south-1.
variable "aws_region" {
  description = "The AWS region to launch the instance."
  type        = string
  default     = "ap-south-1"

}
