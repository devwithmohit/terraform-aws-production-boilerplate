variable "bucket_name" {
  description = "Exact name of the S3 bucket. If null, bucket_prefix will be used."
  type        = string
  default     = null

  validation {
    condition     = var.bucket_name == null || can(regex("^[a-z0-9][a-z0-9.-]{1,61}[a-z0-9]$", var.bucket_name))
    error_message = "bucket_name must be between 3 and 63 characters long, begin and end with an alphanumeric character, and contain only lowercase letters, numbers, dots, and hyphens."
  }
}

variable "bucket_prefix" {
  description = "Prefix for the bucket name. Required if bucket_name is null."
  type        = string
  default     = null

  validation {
    condition     = var.bucket_prefix == null || (length(var.bucket_prefix) <= 37 && can(regex("^[a-z0-9][a-z0-9-]*$", var.bucket_prefix)))
    error_message = "bucket_prefix must be 37 characters or fewer and contain only lowercase letters, numbers, and hyphens."
  }
}

variable "append_random_suffix" {
  description = "Whether to append a random 8-character hex string to ensure global uniqueness."
  type        = bool
  default     = false
}

variable "environment" {
  description = "Deployment environment name (e.g., dev, staging, prod)."
  type        = string

  validation {
    condition     = contains(["dev", "stage", "staging", "prod", "production", "testing", "example"], var.environment)
    error_message = "environment must be one of: dev, stage, staging, prod, production, testing, example."
  }
}

variable "force_destroy" {
  description = "Whether all objects should be deleted from the bucket when the bucket is destroyed."
  type        = bool
  default     = false
}

variable "block_public_access" {
  description = "Whether to block all public access to the S3 bucket."
  type        = bool
  default     = true
}

variable "enable_versioning" {
  description = "Whether to enable versioning for the S3 bucket."
  type        = bool
  default     = true
}

variable "kms_key_arn" {
  description = "ARN of KMS customer-managed key for SSE-KMS. If null, AES256 (SSE-S3) is used."
  type        = string
  default     = null

  validation {
    condition     = var.kms_key_arn == null || can(regex("^arn:aws:kms:[a-z0-9-]+:[0-9]{12}:key/[a-z0-9-]+$", var.kms_key_arn))
    error_message = "kms_key_arn must be a valid AWS KMS key ARN."
  }
}

variable "enable_lifecycle_rules" {
  description = "Whether to configure lifecycle rules for cleanup and cost optimization."
  type        = bool
  default     = true
}

variable "noncurrent_version_expiration_days" {
  description = "Number of days after which noncurrent versions expire."
  type        = number
  default     = 90

  validation {
    condition     = var.noncurrent_version_expiration_days >= 1
    error_message = "noncurrent_version_expiration_days must be at least 1 day."
  }
}

variable "enforce_tls" {
  description = "Whether to attach a bucket policy that enforces SSL/TLS requests only."
  type        = bool
  default     = true
}

variable "enable_website" {
  description = "Whether to configure the bucket for static website hosting."
  type        = bool
  default     = false
}

variable "website_index_document" {
  description = "Suffix for index document in website hosting configuration."
  type        = string
  default     = "index.html"
}

variable "website_error_document" {
  description = "Key for error document in website hosting configuration."
  type        = string
  default     = "error.html"
}

variable "tags" {
  description = "Additional tags to apply to all resources."
  type        = map(string)
  default     = {}
}
