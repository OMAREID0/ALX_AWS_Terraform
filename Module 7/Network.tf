###########################
######### NACL#############
###########################

resource "aws_network_acl" "Lab_NACL" {
    vpc_id = aws_vpc.Lab_VPC.id
    tags = {
      Name = "Custome_NACL"
    }
}

resource "aws_network_acl_rule" "inbound" {
    network_acl_id = aws_network_acl.Lab_NACL.id

    rule_number = 100
    egress = false
    protocol = "-1"
    rule_action = "allow"
    cidr_block = "0.0.0.0/0"
    from_port = 0
    to_port = 0
}

resource "aws_network_acl_rule" "outbound" {
    network_acl_id = aws_network_acl.Lab_NACL.id

    rule_number = 200
    egress = true
    protocol = "-1"
    rule_action = "allow"
    cidr_block = "0.0.0.0/0"
    from_port = 0
    to_port = 0
}


resource "aws_network_acl_rule" "ICMP_block_inbound" {
    network_acl_id = aws_network_acl.Lab_NACL.id

    rule_number = 50
    egress = false
    protocol = "1"   ##ICMP
    rule_action = "deny"
    cidr_block = "10.0.0.0/24"
    from_port = -1
    to_port = -1
}

resource "aws_network_acl_rule" "ICMP_block_outbound" {
    network_acl_id = aws_network_acl.Lab_NACL.id

    rule_number = 60
    egress = true
    protocol = "1"   ##ICMP
    rule_action = "deny"
    cidr_block = "10.0.0.0/24"
    from_port = -1
    to_port = -1
}



######################################
######### Security Groups ############
######################################



resource "aws_security_group" "Bastion_Host_SG" {
    name = "Bastion_Host_SG"
    description = "SG allow ssh and inbound traffic from 0.0.0.0/0"
    vpc_id = aws_vpc.Lab_VPC.id

    #inbound rules
    ingress {
        description = "ssh from my ip"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = [var.my_ip]
    }

    egress {
        description = "allow outbound traffic"
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
    }

    tags = {
        Name = "Bastion_Host_SG"
    }
  
}



##################################
######### NAT Gateway ############
##################################


resource "aws_eip" "nat_eip" {
  domain = "vpc"
}


resource "aws_nat_gateway" "Lab_nat" {
    allocation_id = aws_eip.nat_eip.id
    subnet_id = aws_subnet.Public_Subnet.id

    tags = {
      Name = "Lab-NAT-GW"
    }
  
}


resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.Lab_VPC.id

  tags = {
    Name = "Private-RT"
  }
}

resource "aws_route" "private_nat_route" {
  route_table_id         = aws_route_table.private_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.Lab_nat.id
}

##################################
####### internet Gateway #########
##################################

resource "aws_internet_gateway" "lab_igw" {
  vpc_id = aws_vpc.Lab_VPC.id

  tags = {
    Name = "Lab-IGW"
  }
}


resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.Lab_VPC.id

  tags = {
    Name = "Public-RT"
  }
}

resource "aws_route" "public_internet" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.lab_igw.id
}

