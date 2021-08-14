terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.26.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.0.1"
    }
  }
  required_version = "~> 0.14"

  backend "remote" {
    organization = "Omerh80Terraform"

    workspaces {
      name = "gh-actions-demo"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}


resource "aws_s3_bucket" "b" {
  bucket = "omernyc-tf-test-bucket"
  acl    = "private"
  force_destroy = true

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_object" "object" {
  bucket = "omernyc-tf-test-bucket"
  key    = "file1"
  source = "omer123_test.png"

  # The filemd5() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the md5() function and the file() function:
  # etag = "${md5(file("path/to/file"))}"
  #etag = filemd5("path/to/file")
}

#multiple buckets
variable "bucket_names" {
    type = set(string)
    default = ["omerbucket1-test","omerbucket2-test","omerbucket3-test"]
}

resource "aws_s3_bucket" "bucket2" {
    for_each = var.bucket_names
    bucket = each.value
    acl = "private"

}

