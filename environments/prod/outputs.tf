output "vpc_id" {
  description = "VPC ID of the prod environment."
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "Public subnet IDs in prod environment across 3 AZs."
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "Private subnet IDs in prod environment across 3 AZs."
  value       = module.vpc.private_subnet_ids
}

output "nat_gateway_ids" {
  description = "NAT Gateway IDs in prod environment (one per AZ)."
  value       = module.vpc.nat_gateway_ids
}

output "ec2_instance_id" {
  description = "EC2 instance ID in prod environment."
  value       = module.ec2.instance_id
}

output "ec2_private_ip" {
  description = "Private IP address of the EC2 instance in prod."
  value       = module.ec2.private_ip
}

output "ec2_security_group_id" {
  description = "Security group ID attached to the prod EC2 instance."
  value       = module.ec2.security_group_id
}

output "s3_bucket_id" {
  description = "Production application S3 bucket name."
  value       = module.s3_bucket.bucket_id
}

output "s3_bucket_arn" {
  description = "Production application S3 bucket ARN."
  value       = module.s3_bucket.bucket_arn
}
