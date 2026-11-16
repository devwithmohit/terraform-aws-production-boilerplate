# Security Policy

The `terraform-aws-setup` engineering and maintainer team takes the security of our cloud infrastructure templates, reusable modules, and supply chain seriously. We welcome responsible security research and vulnerability reports.

---

## Supported Versions

Only the latest major and minor release versions receive security updates and patches:

| Version | Supported          |
| ------- | ------------------ |
| 1.x.x   | :white_check_mark: |
| < 1.0.0 | :x:                |

---

## Reporting a Vulnerability

**Please do not report security vulnerabilities through public GitHub issues, discussions, or pull requests.**

If you discover or suspect a security vulnerability or misconfiguration in this repository:

1. **Submit via GitHub Security Advisory (Preferred):**
   - Navigate to the **Security** tab of this repository.
   - Click **Advisories** and select **New draft advisory**.
   - Provide a detailed summary and proof of concept.

2. **Alternative Contact via Email:**
   - Send an encrypted email to `security@terraform-aws-setup.org`.
   - If reporting sensitive reproduction material, please request our PGP public key before transmitting attachments.

### What to Include in Your Report
To help us triage and resolve the issue quickly, please include:
- A clear description of the vulnerability (e.g., overly permissive IAM role, unencrypted EBS volume, S3 public exposure).
- Affected module(s) and specific line numbers.
- Step-by-step reproduction instructions or a minimal `.tf` reproduction snippet.
- The potential impact and attack vector (e.g., SSRF, privilege escalation, data exfiltration).
- Any proposed mitigations or patch pull request diffs.

---

## Vulnerability Handling SLA & Lifecycle

| Phase | Target Timeline | Actions |
|---|---|---|
| **Acknowledgement** | Within 24 hours | Initial confirmation that your report was received. |
| **Triage & Assessment**| Within 48 hours | Reproduce issue, determine severity rating (CVSS v3.1), and scope. |
| **Fix Development** | 3 - 7 days | Develop, test, and validate a non-breaking security remediation. |
| **Release & Disclosure**| 7 - 14 days | Merge patch, publish release notes, and coordinate public CVE disclosure. |

---

## Security Architectural Baseline

All modules in this repository adhere to the following mandatory security controls:

1. **Zero Public Ingress by Default:** Compute instances are placed in private subnets with port 22 closed. Access is managed strictly through **AWS Systems Manager (SSM) Session Manager**.
2. **Metadata Security:** All EC2 instances enforce **IMDSv2** (`http_tokens = required`) to mitigate SSRF credential theft.
3. **Storage & Transport Encryption:**
   - All S3 buckets enforce server-side encryption (`AES256` or `KMS`) and reject non-HTTPS transport (`aws:SecureTransport = false`).
   - EBS root and data volumes are provisioned with encryption enabled by default (`encrypted = true`, `gp3`).
4. **CloudFront Origin Access Control (OAC):** Static assets are delivered via CloudFront using SigV4 signing; direct S3 public access is blocked.
5. **Least Privilege IAM:** Roles and policies grant strictly bounded permissions without wildcards on destructive actions.

---

## Responsible Disclosure & Attribution

We believe in acknowledging security researchers for their contributions. Once a fix has been published, reporters will be publicly credited in our release notes and GitHub Security Advisory (unless anonymity is requested).
