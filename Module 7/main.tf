// ALX Module 7 lab (Creating a VPC Networking Environment for the Café)

resource "aws_vpc" "Lab_VPC" {
    cidr_block = "10.0.0.0/16"

    tags = {
      Name = "Lab VPC"
    }
  
}

resource "aws_subnet" "Public_Subnet" {
    vpc_id = aws_vpc.Lab_VPC.id
    cidr_block = "10.0.0.0/24"
    availability_zone = "us-east-1a"

    tags = {
      Name = "Public_Subnet"
    }
}


resource "aws_subnet" "Private_Subnet" {
    vpc_id = aws_vpc.Lab_VPC.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "us-east-1a"

    tags = {
      Name = "Private_Subnet"
    }
}

resource "aws_network_acl_association" "Private_subnet_assoc" {
    subnet_id = aws_subnet.Private_Subnet.id
    network_acl_id = aws_network_acl.Lab_NACL.id
  
}


resource "aws_instance" "Bastion_Host" {
    ami = var.aws_ami
    instance_type = "t2.micro"
    subnet_id = aws_subnet.Public_Subnet.id
    vpc_security_group_ids = [aws_security_group.Bastion_Host_SG.id]
    associate_public_ip_address = true
    private_ip = "10.0.0.22"
    key_name = aws_key_pair.Bastion_key.key_name


    user_data = <<-EOF
    #!/bin/bash
    yum update -y
    EOF
}


resource "aws_instance" "Test_instance" {
    ami = var.aws_ami
    instance_type = "t2.micro"
    subnet_id = aws_subnet.Public_Subnet.id
    associate_public_ip_address = true
    vpc_security_group_ids = [data.aws_security_group.default.id]
    key_name = aws_key_pair.Test_instance_key.key_name

    user_data = <<-EOF
    #!/usr/bin/env bash
    yum update -y
    EOF
}

resource "aws_instance" "ec2_instance_private" {
    ami = var.aws_ami
    instance_type = "t2.micro"
    subnet_id = aws_subnet.Private_Subnet.id
    associate_public_ip_address = false
    private_ip = "10.0.1.12"
    vpc_security_group_ids = [data.aws_security_group.default.id]
    key_name = aws_key_pair.ec2_instance_private_key.key_name
  
}


resource "aws_route_table_association" "Private_assoc" {
    subnet_id = aws_subnet.Private_Subnet.id
    route_table_id = aws_route_table.private_rt.id
  
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.Public_Subnet.id
  route_table_id = aws_route_table.public_rt.id
}
