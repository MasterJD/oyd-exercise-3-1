environment = "dev"
name        = "ruby-http"
ami_id      = "ami-0d43f0bb92e485897"
instance_type = "t3.micro"

# Replace with your public IP in CIDR form (e.g. 203.0.113.5/32).
allowed_cidr_blocks = ["181.209.195.28/32"]

# Replace with the S3 bucket name that contains app/server.rb.
app_s3_bucket = "ruby-http-app-17001625-17001969"
