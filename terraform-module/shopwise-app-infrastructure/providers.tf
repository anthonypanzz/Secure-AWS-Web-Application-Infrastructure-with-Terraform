# AWS provider
provider "aws" {
  region  = "us-east-1"
  profile = "cloud-projects"

  default_tags {
    tags = {
      "Automation"  = "terraform"
      "Project"     = "shopwise"
      "Environment" = "dev"
    }
  }
}