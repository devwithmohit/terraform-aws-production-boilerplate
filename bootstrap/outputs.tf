output "s3_bucket_name" {
  description = "Name of the S3 bucket created for Terraform state storage."
  value       = aws_s3_bucket.state.id
}

output "s3_bucket_arn" {
  description = "ARN of the S3 bucket created for Terraform state storage."
  value       = aws_s3_bucket.state.arn
}

output "dynamodb_table_name" {
  description = "Name of the DynamoDB table created for state locking."
  value       = aws_dynamodb_table.locks.id
}

output "dynamodb_table_arn" {
  description = "ARN of the DynamoDB table created for state locking."
  value       = aws_dynamodb_table.locks.arn
}

output "backend_config_example" {
  description = "Ready-to-use backend configuration block for environment root modules."
  value       = <<-EOT
    terraform {
      backend "s3" {
        bucket         = "${aws_s3_bucket.state.id}"
        key            = "<environment>/terraform.tfstate"
        region         = "${var.aws_region}"
        dynamodb_table = "${aws_dynamodb_table.locks.id}"
        encrypt        = true
      }
    }
  EOT
}
