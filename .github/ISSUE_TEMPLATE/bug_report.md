---
name: Bug Report
about: Create a report to help us improve the Terraform configurations
title: "[BUG]: "
labels: ["bug", "triage"]
assignees: ""
---

### Describe the Bug
A clear and concise description of what the bug is.

### Module / Component Affected
- [ ] `modules/vpc`
- [ ] `modules/ec2`
- [ ] `modules/s3-bucket`
- [ ] `modules/cloudfront-s3`
- [ ] `environments/dev`
- [ ] `environments/prod`
- [ ] `bootstrap`
- [ ] CI/CD (`.github/workflows`)
- [ ] Other (please specify)

### Environment Details
- **Terraform Version:** (e.g., `1.7.5`)
- **AWS Provider Version:** (e.g., `5.40.0`)
- **AWS Region:** (e.g., `ap-south-1`, `us-east-1`)
- **Operating System:** (e.g., macOS Sonoma, Ubuntu 22.04, Windows 11)

### Steps to Reproduce
1. Configure `terraform.tfvars` with:
   ```hcl
   # Paste minimal variable configuration
   ```
2. Run `terraform init`
3. Run `terraform plan` or `terraform apply`
4. Observe error output

### Expected Behavior
A clear and concise description of what you expected to happen.

### Actual Output / Error Log
```text
# Paste error message or stack trace here
```

### Additional Context
Add any other context, screenshots, or architectural diagrams about the problem here.
