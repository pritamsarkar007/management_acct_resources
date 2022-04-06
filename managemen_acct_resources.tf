terraform {
  backend "s3" {
    bucket = "mngmt-tf-states"
    key    = "tfstate/terraform.tfstate"
    region = "us-east-1"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}
provider "aws" {
  region = "us-east-1"
}


module "s3" {
  source        = "./s3"
  bucket_name   = "mngmt-tf-states"
  account_id    = "484942116355"
  allowed_roles = ["mngmnt_deployment_tf"]
  actions = [
    "DeleteObject",
    "GetObject",
    "ListBucket",
    "PutObject"
  ]


}
