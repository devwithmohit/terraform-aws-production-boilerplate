terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.92.0"
    }
     random = {
      source = "hashicorp/random"
      version = "3.7.1"
    }
  }
}

provider "aws" {
  # Configuration options
  region = "ap-south-1"
}

resource "random_id" "rand_id" {
  byte_length = 8
}
resource "aws_s3_bucket" "bucket_1" {
  bucket = "bucket-devops-${random_id.rand_id.hex}"
}

resource "aws_s3_object" "data_1" {
  bucket = aws_s3_bucket.bucket_1.bucket
  source = "./chapter3.jpeg"
  key    = "images.jpeg"
}




