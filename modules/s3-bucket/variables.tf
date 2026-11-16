variable "bucket_name" {
  description = "Exact name of the S3 bucket. If null, bucket_prefix will be used."
  type        = string
  default     = null
}

variable "bucket_prefix" {
  description = "Prefix for the bucket name. Required if bucket_name is null."
  type        = string
  default     = null
}

variable "append_random_suffix" {
  description = "Whether to append a random 8-character hex string to ensure global uniqueness."
  type        = bool
  default     = false
}

variable "environment" {
  description = "Deployment environment name (e.g., dev, staging, prod)."
  type        = string
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
