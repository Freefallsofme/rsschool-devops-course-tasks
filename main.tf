terraform {
  required_version = ">= 1.0"

  backend "s3" {
    bucket         = "frfllsbucket"
    key            = "terraform.tfstate"
    region         = "eu-north-1"
    encrypt        = true
    dynamodb_table = "terraform-lock-table"
  }
}

provider "aws" {
  region = "eu-north-1"
}

resource "aws_s3_bucket" "state" {
  bucket = "frfllsbucket"
  acl    = "private"

  versioning {
    enabled = true
  }
}

resource "aws_dynamodb_table" "locks" {
  name         = "terraform-lock-table"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
