# terraform-aws-setup

Simple Terraform example to create and manage AWS infrastructure including EC2 instances and S3 backends.

## Overview

This project demonstrates Infrastructure as Code (IaC) best practices using Terraform with AWS. It includes:

- EC2 instance provisioning with dynamic AMI selection
- S3 backend configuration for Terraform state management
- Modular directory structure for scalability

## Project Structure

```
terraform-aws-setup/
├── terraform-aws/          # EC2 instance creation
│   ├── main.tf
│   ├── variables.tf
│   └── output.tf
├── terraform-s3/           # S3 bucket for backend state
│   ├── main.tf
│   └── output.tf
├── terraform-s3-project/   # S3 static website hosting
│   ├── main.tf
│   ├── output.tf
│   └── index.html
├── terraform-backend/      # Backend configuration
│   └── main.tf
└── README.md
```

## Prerequisites

- **Terraform** >= 1.0
- **AWS Account** with appropriate IAM permissions
- **AWS CLI** configured with credentials (or environment variables set)
- **Git** (for version control)

## Quick Start

### 1. Initialize Terraform

```bash
cd terraform-s3
terraform init
```

### 2. Plan Infrastructure

```bash
terraform plan
```

### 3. Apply Configuration

```bash
terraform apply
```

### 4. Destroy Resources (when done)

```bash
terraform destroy
```

## Configuration

### Environment Variables (Windows PowerShell)

```powershell
$env:AWS_ACCESS_KEY_ID="your-access-key"
$env:AWS_SECRET_ACCESS_KEY="your-secret-key"
$env:AWS_DEFAULT_REGION="ap-south-1"
```

### Environment Variables (Bash)

```bash
export AWS_ACCESS_KEY_ID="your-access-key"
export AWS_SECRET_ACCESS_KEY="your-secret-key"
export AWS_DEFAULT_REGION="ap-south-1"
```

## Variables

Edit `variables.tf` to customize:

- AWS region
- Instance type
- Environment tags
- S3 bucket names

## Outputs

Run `terraform output` to view:

- EC2 instance IDs and public IPs
- S3 bucket names and endpoints
- Backend configuration details

## Best Practices Implemented

✅ Remote state management with S3 backend
✅ Dynamic AMI selection (latest Amazon Linux 2)
✅ Modular Terraform configurations
✅ Environment-specific variables
✅ Comprehensive output documentation
✅ `.gitignore` for sensitive files

## Common Commands

```bash
# Format and validate
terraform fmt -recursive
terraform validate

# Plan and apply with variables
terraform plan -var-file="terraform.tfvars"
terraform apply -auto-approve

# Show current state
terraform show

# Refresh state
terraform refresh
```

## Troubleshooting

### State Lock Issues

```bash
terraform force-unlock <LOCK_ID>
```

### Provider Not Found

```bash
terraform init -upgrade
```

### Permission Denied

Ensure AWS credentials have necessary permissions:

- EC2 full access
- S3 full access
- IAM permissions for instance roles

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Run `terraform fmt` and `terraform validate`
5. Submit a pull request

## License

MIT License - feel free to use this for learning and development.

## Resources

- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [Terraform Best Practices](https://www.terraform.io/docs/cloud/guides/recommended-practices.html)
- [AWS Terraform Examples](https://github.com/hashicorp/terraform-provider-aws/tree/main/examples)

## Support

For issues or questions, please open a GitHub issue in the repository.
