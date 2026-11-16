# Contributing to terraform-aws-setup

Thank you for your interest in contributing to `terraform-aws-setup`! We welcome contributions from the community to help make this repository the best production-ready, modular AWS Terraform boilerplate.

---

## Code of Conduct

All contributors are expected to uphold our [Code of Conduct](CODE_OF_CONDUCT.md). Please report unacceptable behavior to the project maintainers.

---

## Getting Started

### Prerequisites

- [Terraform CLI](https://developer.hashicorp.com/terraform/downloads) `>= 1.5.0`
- [pre-commit](https://pre-commit.com/#installation) `>= 3.0`
- [tflint](https://github.com/terraform-linters/tflint) `>= 0.48.0`
- [checkov](https://github.com/bridgecrewio/checkov) (for security policy scanning)
- [Go](https://go.dev/doc/install) `>= 1.21` (required if running automated Terratest suites)

### Local Environment Setup

1. **Fork and Clone the Repository:**
   ```bash
   git clone https://github.com/<your-username>/terraform-aws-setup.git
   cd terraform-aws-setup
   ```

2. **Install Pre-Commit Hooks:**
   ```bash
   pre-commit install
   ```
   This ensures formatting, validation, and security scans run automatically before every commit.

---

## Development Standards & Style Guide

### 1. Terraform HCL Conventions
- **Canonical Formatting:** Always run `terraform fmt -recursive` before committing.
- **Naming Conventions:**
  - Resource and module names must use lowercase snake_case (e.g., `aws_security_group.this`, `module.cloudfront_s3`).
  - Prefix variables consistently (`name_prefix`, `environment`, `vpc_cidr`).
  - Use `this` as the standard resource identifier when only one primary resource of that type exists in a module.
- **No Hardcoded Values:** Never hardcode AMIs, account IDs, VPC IDs, or AWS regions. Use dynamic data sources or input variables.
- **Strict Typing:** All variables in `variables.tf` must have explicit `type`, `description`, and appropriate `default` values where applicable.
- **Documented Outputs:** Every output in `outputs.tf` must have a meaningful `description`.

### 2. Security Standards
- **Zero-Trust Access:** Do not open port 22 (SSH) to `0.0.0.0/0`. Prefer AWS Systems Manager (SSM) Session Manager.
- **IMDSv2 Enforced:** All EC2 instance declarations must enforce IMDSv2 (`http_tokens = "required"`).
- **S3 Security:** All S3 buckets must enforce server-side encryption (AES-256 or KMS), public access blocking, and TLS-only bucket policies.
- **No Secrets:** Never commit `.tfstate`, `.tfvars`, AWS secret keys, or passwords.

---

## Running Quality Checks Manually

Before submitting your Pull Request, run the full verification pipeline locally:

```bash
# 1. Check Terraform formatting
terraform fmt -check -diff -recursive

# 2. Run pre-commit checks on all files
pre-commit run --all-files

# 3. Initialize and validate each module
cd modules/vpc && terraform init -backend=false && terraform validate
cd ../ec2 && terraform init -backend=false && terraform validate
cd ../s3-bucket && terraform init -backend=false && terraform validate
cd ../cloudfront-s3 && terraform init -backend=false && terraform validate

# 4. Run automated tests (requires AWS sandbox credentials)
cd ../../tests
go test -v -timeout 30m
```

---

## Pull Request Process

1. **Create a Feature Branch:**
   ```bash
   git checkout -b feature/my-new-feature
   ```
2. **Commit Your Changes:**
   Write clear, concise commit messages following [Conventional Commits](https://www.conventionalcommits.org/):
   - `feat: add KMS customer-managed key support to S3 module`
   - `fix: correct route table association count in VPC module`
   - `docs: update deployment steps in README`
3. **Open a Pull Request:**
   - Fill in the PR template completely.
   - Link any related GitHub issues.
   - Verify that all GitHub Actions CI checks (Format, Validate, Security Scan) pass.

---

## Review and Merge

- At least one maintainer review is required before merging.
- PRs must have passing CI checks and no unresolved review discussions.
- Commits will be squashed and merged to maintain a clean Git history.
