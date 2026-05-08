variable "environment" {
  description = "Deployment environment name, e.g. dev."
  type        = string
}

variable "name" {
  description = "Base name used for resource naming."
  type        = string
}

variable "ami_id" {
  description = "AMI ID to use for the EC2 instance."
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type matching the AMI architecture."
  type        = string
  default     = "t3.micro"
}

variable "allowed_cidr_blocks" {
  description = "CIDR blocks allowed to access the HTTP server on port 8080."
  type        = list(string)
}

variable "app_s3_bucket" {
  description = "S3 bucket containing server.rb."
  type        = string
}
