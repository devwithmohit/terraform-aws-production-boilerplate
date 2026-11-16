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
  #   key            = "prod/terraform.tfstate"
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

# Dynamic Availability Zone Discovery (Filters out unsupported AZs automatically)
data "aws_availability_zones" "available" {
  state = "available"
}

# High-Availability Multi-AZ VPC Module Call
module "vpc" {
  source = "../../modules/vpc"

  name_prefix          = "${var.project_name}-${var.environment}"
  environment          = var.environment
  vpc_cidr             = var.vpc_cidr
  availability_zones   = slice(data.aws_availability_zones.available.names, 0, 3)
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  enable_nat_gateway   = var.enable_nat_gateway
  single_nat_gateway   = false # Multi-AZ Redundant NAT Gateways for Production HA

  tags = var.tags
}

# Hardened Production EC2 Instance (Placed in Private Subnet)
module "ec2" {
  source = "../../modules/ec2"

  name_prefix                 = "${var.project_name}-${var.environment}"
  environment                 = var.environment
  vpc_id                      = module.vpc.vpc_id
  subnet_id                   = module.vpc.private_subnet_ids[0]
  instance_type               = var.instance_type
  associate_public_ip_address = false # Strict Zero-Trust: No public IP in production
  create_security_group       = true
  enable_ssh                  = false # Port 22 closed; access strictly managed via SSM
  allowed_ssh_cidrs           = []
  enable_http                 = false
  enable_https                = true
  allowed_http_cidrs          = var.allowed_ingress_cidrs
  create_iam_instance_profile = true
  root_volume_size            = var.root_volume_size
  root_volume_type            = "gp3"

  user_data = <<-EOF
              #!/bin/bash
              echo "Production workload initialized." > /var/log/provisioning.log
              EOF

  tags = var.tags
}

# Production Storage with Versioning, Strict Access Block, and Prevent Deletion
module "s3_bucket" {
  source = "../../modules/s3-bucket"

  bucket_prefix        = "${var.project_name}-${var.environment}"
  append_random_suffix = true
  environment          = var.environment
  enable_versioning    = true
  block_public_access  = true
  enforce_tls          = true
  force_destroy        = false # Production safety: prevent accidental deletion of state or assets

  tags = var.tags
}
