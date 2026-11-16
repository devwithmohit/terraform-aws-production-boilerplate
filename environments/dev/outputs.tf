output "vpc_id" {
  description = "VPC ID of the dev environment."
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "Public subnet IDs in dev environment."
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "Private subnet IDs in dev environment."
  value       = module.vpc.private_subnet_ids
}

output "nat_gateway_ids" {
  description = "NAT Gateway IDs in dev environment."
  value       = module.vpc.nat_gateway_ids
}

output "ec2_instance_id" {
  description = "EC2 instance ID in dev environment."
  value       = module.ec2.instance_id
}

output "ec2_public_ip" {
  description = "Public IP address of the EC2 instance in dev."
  value       = module.ec2.public_ip
}

output "ec2_private_ip" {
  description = "Private IP address of the EC2 instance in dev."
  value       = module.ec2.private_ip
}

output "ec2_security_group_id" {
  description = "Security group ID attached to the dev EC2 instance."
  value       = module.ec2.security_group_id
}

output "s3_bucket_id" {
  description = "Dev application S3 bucket name."
  value       = module.s3_bucket.bucket_id
}

output "s3_bucket_arn" {
  description = "Dev application S3 bucket ARN."
  value       = module.s3_bucket.bucket_arn
}
