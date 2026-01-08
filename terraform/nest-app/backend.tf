# S3 backend with DynamoDB state locking
terraform {
  backend "s3" {
    bucket         = "apanzbrooke-terraform-remote-state"
    key            = "nest/ec2/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-lock"
    profile        = "cloud-projects"
  }
}


