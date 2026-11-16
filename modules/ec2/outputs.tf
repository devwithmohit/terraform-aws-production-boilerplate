output "instance_id" {
  description = "The ID of the EC2 instance."
  value       = aws_instance.this.id
}

output "instance_arn" {
  description = "The ARN of the EC2 instance."
  value       = aws_instance.this.arn
}

output "public_ip" {
  description = "The public IP address assigned to the instance, if applicable."
  value       = aws_instance.this.public_ip
}

output "private_ip" {
  description = "The private IP address of the instance."
  value       = aws_instance.this.private_ip
}

output "security_group_id" {
  description = "The ID of the security group created for this instance."
  value       = var.create_security_group ? aws_security_group.this[0].id : null
}

output "iam_role_arn" {
  description = "The ARN of the IAM role created for SSM access."
  value       = var.create_iam_instance_profile ? aws_iam_role.this[0].arn : null
}

output "ami_id" {
  description = "The AMI ID used to launch the instance."
  value       = aws_instance.this.ami
}
