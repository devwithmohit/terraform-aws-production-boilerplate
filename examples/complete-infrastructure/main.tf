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
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = var.project_name
      Environment = "example"
      ManagedBy   = "Terraform"
      Example     = "complete-infrastructure"
    }
  }
}

# Dynamic Availability Zone Discovery
data "aws_availability_zones" "available" {
  state = "available"
}

# 1. VPC Module: Multi-AZ Networking
module "vpc" {
  source = "../../modules/vpc"

  name_prefix          = "${var.project_name}-example"
  environment          = "example"
  vpc_cidr             = "10.0.0.0/16"
  availability_zones   = slice(data.aws_availability_zones.available.names, 0, 2)
  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.10.0/24", "10.0.20.0/24"]
  enable_nat_gateway   = true
  single_nat_gateway   = true

  tags = var.tags
}

# 2. EC2 Module: Compute Instance with IMDSv2 and SSM
module "ec2" {
  source = "../../modules/ec2"

  name_prefix                 = "${var.project_name}-example"
  environment                 = "example"
  vpc_id                      = module.vpc.vpc_id
  subnet_id                   = module.vpc.public_subnet_ids[0]
  instance_type               = "t3.micro"
  associate_public_ip_address = true
  create_security_group       = true
  enable_ssh                  = false
  enable_http                 = true
  allowed_http_cidrs          = ["0.0.0.0/0"]
  create_iam_instance_profile = true
  root_volume_size            = 20
  root_volume_type            = "gp3"

  user_data = <<-EOF
              #!/bin/bash
              echo "Complete Infrastructure Example Online" > /var/log/startup.log
              EOF

  tags = var.tags
}

# 3. Secure S3 Bucket Module: Internal Data Storage
module "app_storage" {
  source = "../../modules/s3-bucket"

  bucket_prefix        = "${var.project_name}-app-data"
  append_random_suffix = true
  environment          = "example"
  enable_versioning    = true
  block_public_access  = true
  enforce_tls          = true
  force_destroy        = true

  tags = var.tags
}

# 4. CloudFront + S3 Static Hosting Module: Public Web Delivery via OAC
module "web_cdn" {
  source = "../../modules/cloudfront-s3"

  name_prefix          = "${var.project_name}-web"
  environment          = "example"
  append_random_suffix = true
  force_destroy        = true
  enable_versioning    = true
  default_root_object  = "index.html"
  error_document       = "index.html"
  spa_routing          = true
  price_class          = "PriceClass_100"

  tags = var.tags
}
