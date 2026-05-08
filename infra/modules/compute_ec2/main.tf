data "aws_vpc" "default" {
  default = true
}

data "aws_iam_policy_document" "ec2_assume" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "s3_read" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["arn:aws:s3:::${var.app_s3_bucket}/server.rb"]
  }
}

resource "aws_iam_role" "this" {
  name               = "${var.name}-${var.environment}-role"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume.json
}

resource "aws_iam_role_policy" "s3_read" {
  name   = "${var.name}-${var.environment}-s3-read"
  role   = aws_iam_role.this.id
  policy = data.aws_iam_policy_document.s3_read.json
}

resource "aws_iam_instance_profile" "this" {
  name = "${var.name}-${var.environment}-profile"
  role = aws_iam_role.this.name
}

resource "aws_security_group" "this" {
  name        = "${var.name}-${var.environment}-sg"
  description = "Allow inbound TCP 8080"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidr_blocks
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.name}-${var.environment}-sg"
    Environment = var.environment
  }
}

resource "aws_instance" "this" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  iam_instance_profile   = aws_iam_instance_profile.this.name
  vpc_security_group_ids = [aws_security_group.this.id]

  user_data = <<-EOF
    #!/bin/bash
    dnf install -y ruby
    aws s3 cp "s3://${var.app_s3_bucket}/server.rb" /opt/server.rb
    COMPUTE_TYPE=ec2 nohup ruby /opt/server.rb &
  EOF

  tags = {
    Name        = "${var.name}-${var.environment}"
    Environment = var.environment
  }
}
