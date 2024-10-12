variable "aws_region" {
}
variable "cidr_block" {
}
variable "availability_zone" {
}
variable "public_subnet_count" {
}
variable "private_subnet_count" {
}

provider "aws" {
  region = var.aws_region
}

terraform {
  backend "s3" {
    bucket = "terraform-state-pel-jenkins"
    key    = "pel/development/terraform.tfstate"
    region = "us-east-2"
  }
}

resource "aws_vpc" "pel_vpc" {
  cidr_block           = var.cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "pel_vpc"
  }
}

module "pel_modules" {
  source               = "./modules"
  vpc_id               = aws_vpc.pel_vpc.id
  availability_zone    = var.availability_zone
  public_subnet_count  = var.public_subnet_count
  private_subnet_count = var.private_subnet_count
  cidr_block           = var.cidr_block
}