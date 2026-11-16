data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = [var.ami_name_pattern]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = [var.ami_architecture]
  }
}

# IAM Role for EC2 SSM Session Manager Access
resource "aws_iam_role" "this" {
  count = var.create_iam_instance_profile ? 1 : 0
  name  = "${var.name_prefix}-ec2-ssm-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = merge(
    var.tags,
    {
      Name        = "${var.name_prefix}-ec2-ssm-role"
      Environment = var.environment
      ManagedBy   = "Terraform"
    }
  )
}

resource "aws_iam_role_policy_attachment" "ssm" {
  count      = var.create_iam_instance_profile ? 1 : 0
  role       = aws_iam_role.this[0].name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "this" {
  count = var.create_iam_instance_profile ? 1 : 0
  name  = "${var.name_prefix}-ec2-instance-profile"
  role  = aws_iam_role.this[0].name

  tags = merge(
    var.tags,
    {
      Name        = "${var.name_prefix}-ec2-instance-profile"
      Environment = var.environment
      ManagedBy   = "Terraform"
    }
  )
}

# Dedicated Security Group
resource "aws_security_group" "this" {
  count       = var.create_security_group ? 1 : 0
  name_prefix = "${var.name_prefix}-ec2-sg-"
  description = "Security group for ${var.name_prefix} EC2 instance"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.enable_ssh ? [1] : []
    content {
      description = "SSH access"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = var.allowed_ssh_cidrs
    }
  }

  dynamic "ingress" {
    for_each = var.enable_http ? [1] : []
    content {
      description = "HTTP access"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = var.allowed_http_cidrs
    }
  }

  dynamic "ingress" {
    for_each = var.enable_https ? [1] : []
    content {
      description = "HTTPS access"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = var.allowed_http_cidrs
    }
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(
    var.tags,
    {
      Name        = "${var.name_prefix}-ec2-sg"
      Environment = var.environment
      ManagedBy   = "Terraform"
    }
  )
}

# EC2 Instance
resource "aws_instance" "this" {
  ami           = coalesce(var.ami_id, data.aws_ami.amazon_linux.id)
  instance_type = var.instance_type
  subnet_id     = var.subnet_id

  vpc_security_group_ids = compact(
    concat(
      var.create_security_group ? [aws_security_group.this[0].id] : [],
      var.additional_security_group_ids
    )
  )

  key_name                    = var.key_name
  associate_public_ip_address = var.associate_public_ip_address
  iam_instance_profile        = var.create_iam_instance_profile ? aws_iam_instance_profile.this[0].name : var.iam_instance_profile_name
  user_data                   = var.user_data

  root_block_device {
    volume_size           = var.root_volume_size
    volume_type           = var.root_volume_type
    encrypted             = true
    delete_on_termination = true

    tags = merge(
      var.tags,
      {
        Name        = "${var.name_prefix}-root-vol"
        Environment = var.environment
        ManagedBy   = "Terraform"
      }
    )
  }

  # Enforce IMDSv2 for security compliance
  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
  }

  tags = merge(
    var.tags,
    {
      Name        = "${var.name_prefix}-instance"
      Environment = var.environment
      ManagedBy   = "Terraform"
    }
  )

  lifecycle {
    ignore_changes = [ami]
  }
}
