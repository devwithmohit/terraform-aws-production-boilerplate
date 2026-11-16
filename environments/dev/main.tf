terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5"
    }
  }

  # Uncomment and configure with the outputs from the bootstrap module
  # backend "s3" {
  #   bucket         = "YOUR_BOOTSTRAP_STATE_BUCKET_NAME"
  #   key            = "dev/terraform.tfstate"
  #   region         = "ap-south-1"
  #   dynamodb_table = "YOUR_BOOTSTRAP_LOCK_TABLE_NAME"
  #   encrypt        = true
  # }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = merge(
      var.tags,
      {
        Environment = var.environment
        Project     = var.project_name
        ManagedBy   = "Terraform"
      }
    )
  }
}

# Dynamic Availability Zone Discovery
data "aws_availability_zones" "available" {
  state = "available"
}

# Reusable VPC Module Call
module "vpc" {
  source = "../../modules/vpc"

  name_prefix          = "${var.project_name}-${var.environment}"
  environment          = var.environment
  vpc_cidr             = var.vpc_cidr
  availability_zones   = slice(data.aws_availability_zones.available.names, 0, 2)
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  enable_nat_gateway   = var.enable_nat_gateway
  single_nat_gateway   = true # Cost optimization for Dev environment

  tags = var.tags
}

# Reusable EC2 Instance Module Call
module "ec2" {
  source = "../../modules/ec2"

  name_prefix                 = "${var.project_name}-${var.environment}"
  environment                 = var.environment
  vpc_id                      = module.vpc.vpc_id
  subnet_id                   = module.vpc.public_subnet_ids[0]
  instance_type               = var.instance_type
  associate_public_ip_address = var.associate_public_ip
  create_security_group       = true
  enable_ssh                  = var.enable_ssh
  allowed_ssh_cidrs           = var.allowed_ssh_cidrs
  enable_http                 = true
  allowed_http_cidrs          = ["0.0.0.0/0"]
  create_iam_instance_profile = true # Enables AWS SSM Session Manager access without open SSH ports
  root_volume_size            = 20
  root_volume_type            = "gp3"

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello from ${var.project_name} dev environment!" > /tmp/hello.txt
              EOF

  tags = var.tags
}

# Reusable S3 Storage Module Call
module "s3_bucket" {
  source = "../../modules/s3-bucket"

  bucket_prefix        = "${var.project_name}-${var.environment}"
  append_random_suffix = true
  environment          = var.environment
  enable_versioning    = true
  block_public_access  = true
  enforce_tls          = true
  force_destroy        = true # Set to true in dev for clean tear-downs

  tags = var.tags
}
