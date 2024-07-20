provider "aws" {
  profile = "default"
  region  = "us-east-2"

}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.63"
    }
  }
}

terraform {
  backend "s3" {
    # Bucket name and other configurations will be provided via backend-config.hcl
  }
}
