output "vpc_id" {
  description = "The ID of the created VPC."
  value       = module.vpc.vpc_id
}

output "public_subnets" {
  description = "Public subnet IDs."
  value       = module.vpc.public_subnet_ids
}

output "private_subnets" {
  description = "Private subnet IDs."
  value       = module.vpc.private_subnet_ids
}

output "ec2_instance_id" {
  description = "The EC2 instance identifier."
  value       = module.ec2.instance_id
}

output "ec2_public_ip" {
  description = "Public IP address of the compute instance."
  value       = module.ec2.public_ip
}

output "app_storage_bucket_id" {
  description = "Internal S3 bucket name."
  value       = module.app_storage.bucket_id
}

output "cloudfront_domain_name" {
  description = "HTTPS endpoint domain of the CloudFront CDN distribution."
  value       = module.web_cdn.cloudfront_domain_name
}

output "cloudfront_distribution_id" {
  description = "CloudFront distribution identifier."
  value       = module.web_cdn.cloudfront_distribution_id
}

output "static_content_bucket_id" {
  description = "S3 origin bucket name for CloudFront."
  value       = module.web_cdn.s3_bucket_id
}
