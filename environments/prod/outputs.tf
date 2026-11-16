output "vpc_id" {
  description = "VPC ID of the production environment."
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "Public subnet IDs in production across 3 AZs."
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "Private subnet IDs in production across 3 AZs."
  value       = module.vpc.private_subnet_ids
}

output "nat_gateway_ids" {
  description = "NAT Gateway IDs in production (one per AZ)."
  value       = module.vpc.nat_gateway_ids
}

output "ec2_instance_id" {
  description = "EC2 instance ID in production."
  value       = module.ec2.instance_id
}

output "ec2_private_ip" {
  description = "Private IP address of the EC2 instance in production."
  value       = module.ec2.private_ip
}

output "ec2_security_group_id" {
  description = "Security group ID attached to the production EC2 instance."
  value       = module.ec2.security_group_id
}

output "ec2_iam_role_arn" {
  description = "IAM Role ARN for SSM Session Manager on the production instance."
  value       = module.ec2.iam_role_arn
}

output "s3_static_bucket_id" {
  description = "Private S3 bucket name storing the static website content."
  value       = module.cloudfront_s3.s3_bucket_id
}

output "s3_static_bucket_arn" {
  description = "Private S3 bucket ARN."
  value       = module.cloudfront_s3.s3_bucket_arn
}

output "cloudfront_distribution_id" {
  description = "CloudFront Distribution ID."
  value       = module.cloudfront_s3.cloudfront_distribution_id
}

output "cloudfront_domain_name" {
  description = "Secure HTTPS domain name of the CloudFront CDN distribution."
  value       = module.cloudfront_s3.cloudfront_domain_name
}
