provider "aws" {
    profile = "${var.profile}"
    region = "${var.region}"
}

terraform {
  required_version = "1.6.6"

  required_providers {
    aws = ">= 5.31.0"
  }
}
