#terraform block is used to define the required providers and their versions. In this case, we are using the AWS provider with version 5.92.0.
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.92.0"
    }
  }
}

#provider block is used to configure the AWS provider with the region ap-south-1. This is the region where the resources will be created.
provider "aws" {
  # Configuration options
  region = var.aws_region
}
#resource block is used to define the resources that will be created. In this case, we are creating an EC2 instance with the AMI ID ami-05c179eced2eb9b5b and instance type t3.nano.
#We are also adding a tag to the instance with the key Name and value MyterraformInstance.
resource "aws_instance" "my_instance" {
  ami           = "ami-05c179eced2eb9b5b"
  instance_type = "t3.nano"
  tags = {
    Name = "MyterraformInstance"

  }
}


