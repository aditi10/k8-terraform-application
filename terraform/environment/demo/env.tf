provider "aws" {
  profile    = "tajawal"
  region     = "eu-west-1"
}
/*
resource "aws_s3_bucket" "terraform-state-storage-s3" {
    bucket = "terrak81"
 
    versioning {
      enabled = false
    }
 
    lifecycle {
      prevent_destroy = true
    }
 
    tags {
      Name = "S3 Remote Terraform State Store"
    }      
}
*/
terraform {
  backend "s3" {
    bucket  = "terrak8"
    key     = "terraform.tfstate"
    region  = "eu-west-1"
    shared_credentials_file = "$HOME/.aws/credentials"
    profile = "tajawal"
#    encrypt = true
  }
}
