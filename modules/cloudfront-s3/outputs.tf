output "s3_bucket_id" {
  description = "The name of the S3 storage bucket."
  value       = aws_s3_bucket.this.id
}

output "s3_bucket_arn" {
  description = "The ARN of the S3 storage bucket."
  value       = aws_s3_bucket.this.arn
}

output "s3_bucket_regional_domain_name" {
  description = "The regional domain name of the S3 bucket."
  value       = aws_s3_bucket.this.bucket_regional_domain_name
}

output "cloudfront_distribution_id" {
  description = "The identifier for the CloudFront distribution."
  value       = aws_cloudfront_distribution.this.id
}

output "cloudfront_distribution_arn" {
  description = "The ARN of the CloudFront distribution."
  value       = aws_cloudfront_distribution.this.arn
}

output "cloudfront_domain_name" {
  description = "The domain name corresponding to the distribution (e.g., d111111abcdef8.cloudfront.net)."
  value       = aws_cloudfront_distribution.this.domain_name
}

output "cloudfront_hosted_zone_id" {
  description = "The CloudFront Route 53 zone ID that can be used to route an Alias resource record set."
  value       = aws_cloudfront_distribution.this.hosted_zone_id
}

output "oac_id" {
  description = "The ID of the CloudFront Origin Access Control."
  value       = aws_cloudfront_origin_access_control.this.id
}
