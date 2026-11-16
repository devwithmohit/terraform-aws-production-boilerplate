# Complete Infrastructure Integration Example

This example demonstrates how to integrate all core modules in this repository (`vpc`, `ec2`, `s3-bucket`, and `cloudfront-s3`) into a single, cohesive deployment.

## Architecture

1. **VPC Networking:** A custom VPC spanning two Availability Zones with both public and private subnets, an Internet Gateway, and a cost-optimized single NAT Gateway.
2. **EC2 Compute:** An Amazon Linux 2023 EC2 instance configured with IMDSv2, an encrypted `gp3` root EBS volume, an IAM instance profile with AWS Systems Manager (SSM) access, and a dedicated security group.
3. **Application Storage S3:** A hardened private bucket with AES-256 server-side encryption, versioning, public access blocking, and TLS enforcement.
4. **CloudFront CDN + S3 Origin:** A static content S3 bucket protected with Origin Access Control (OAC), served globally over HTTPS via CloudFront with automated HTTP-to-HTTPS redirection and SPA 404 routing.

## Usage

```bash
# 1. Initialize Terraform
terraform init

# 2. Plan the deployment
terraform plan

# 3. Apply changes
terraform apply

# 4. Clean up all resources when finished
terraform destroy
```
