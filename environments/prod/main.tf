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

  # Production Remote State with AES-256 S3 Encryption and DynamoDB State Locking
  backend "s3" {
    bucket         = "terraform-aws-setup-tf-state-prod"
    key            = "prod/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraform-aws-setup-tf-locks"
    encrypt        = true
  }
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
        Compliance  = "PCI-DSS-Ready"
        DataTier    = "Confidential"
      }
    )
  }
}

# Dynamic Availability Zone Discovery (Filters active, healthy AZs)
data "aws_availability_zones" "available" {
  state = "available"
}

# 1. High-Availability Multi-AZ VPC Module Call
module "vpc" {
  source = "../../modules/vpc"

  name_prefix          = "${var.project_name}-${var.environment}"
  environment          = var.environment
  vpc_cidr             = var.vpc_cidr
  availability_zones   = slice(data.aws_availability_zones.available.names, 0, 3)
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  enable_nat_gateway   = var.enable_nat_gateway
  single_nat_gateway   = false # Dedicated NAT Gateway per AZ for production fault-tolerance

  tags = var.tags
}

# 2. Hardened Production EC2 Instance (Private Subnet Placement & IMDSv2 Enforced)
module "ec2" {
  source = "../../modules/ec2"

  name_prefix                 = "${var.project_name}-${var.environment}"
  environment                 = var.environment
  vpc_id                      = module.vpc.vpc_id
  subnet_id                   = module.vpc.private_subnet_ids[0]
  instance_type               = var.instance_type
  associate_public_ip_address = false # Strict Zero-Trust: No public IP in production
  create_security_group       = true
  enable_ssh                  = false # Port 22 closed; access strictly managed via AWS SSM
  allowed_ssh_cidrs           = []
  enable_http                 = false
  enable_https                = true
  allowed_http_cidrs          = var.allowed_ingress_cidrs
  create_iam_instance_profile = true
  root_volume_size            = var.root_volume_size
  root_volume_type            = "gp3"

  user_data = <<-EOF
              #!/bin/bash
              echo "Production workload initialized at $(date)" > /var/log/bootstrap.log
              EOF

  tags = var.tags
}

# 3. Secure CloudFront + S3 Static Hosting with Origin Access Control (OAC)
module "cloudfront_s3" {
  source = "../../modules/cloudfront-s3"

  name_prefix          = "${var.project_name}-${var.environment}"
  environment          = var.environment
  append_random_suffix = true
  force_destroy        = false # Production safety: prevents accidental data destruction
  enable_versioning    = true
  default_root_object  = "index.html"
  error_document       = "index.html"
  spa_routing          = true
  price_class          = var.cloudfront_price_class

  tags = var.tags
}
