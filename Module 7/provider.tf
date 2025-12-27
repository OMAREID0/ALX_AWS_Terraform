terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  required_version = ">= 1.2"
}
provider "aws" {
  region = var.aws_region
  
}
variable "aws_region" {
  description = "The AWS region to deploy resources in."
  type        = string
  default     = "us-east-1"
}

variable "aws_ami" {
  description = "default ami for ec2 instance"
  type = string
  default = "ami-0fa3fe0fa7920f68e"
  
}

variable "my_ip" {
  description = "my_ip"
  type = string
  default = "0.0.0.0/32"   ## aked m4 h7ot my ip xd
  
}


data "aws_security_group" "default" {
  filter {
    name   = "group-name"
    values = ["default"]
  }

  vpc_id = aws_vpc.Lab_VPC.id
}
