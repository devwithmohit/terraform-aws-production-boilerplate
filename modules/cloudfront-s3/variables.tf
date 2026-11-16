variable "name_prefix" {
  description = "Prefix applied to all resources created by this module."
  type        = string
}

variable "environment" {
  description = "Deployment environment name (e.g., dev, staging, prod)."
  type        = string
}

variable "bucket_name" {
  description = "Explicit name for the S3 origin bucket. If null, a name will be derived from name_prefix."
  type        = string
  default     = null
}

variable "append_random_suffix" {
  description = "Whether to append a random 8-character hex string to ensure global S3 uniqueness."
  type        = bool
  default     = true
}

variable "force_destroy" {
  description = "Whether to allow bucket destruction even if it contains objects."
  type        = bool
  default     = false
}

variable "enable_versioning" {
  description = "Whether to enable S3 bucket versioning."
  type        = bool
  default     = true
}

variable "default_root_object" {
  description = "The default root object served by CloudFront."
  type        = string
  default     = "index.html"
}

variable "error_document" {
  description = "The custom error document path."
  type        = string
  default     = "404.html"
}

variable "spa_routing" {
  description = "Whether to redirect 403 and 404 errors to index.html with a 200 status code for Single Page Applications (React/Vue/Angular)."
  type        = bool
  default     = true
}

variable "price_class" {
  description = "CloudFront distribution price class (e.g., PriceClass_100, PriceClass_200, PriceClass_All)."
  type        = string
  default     = "PriceClass_100"
}

variable "custom_domain_names" {
  description = "List of custom domain names (CNAMEs) for the CloudFront distribution."
  type        = list(string)
  default     = []
}

variable "acm_certificate_arn" {
  description = "ARN of the AWS ACM SSL certificate in us-east-1 (required when using custom_domain_names)."
  type        = string
  default     = null
}

variable "geo_restriction_type" {
  description = "Method for geo-restriction: none, whitelist, or blacklist."
  type        = string
  default     = "none"
}

variable "geo_restriction_locations" {
  description = "List of ISO 3166-1-alpha-2 country codes for geo-restriction."
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Additional tags to apply to all resources."
  type        = map(string)
  default     = {}
}
