resource "aws_key_pair" "Bastion_key" {
  key_name   = "Bastion_key"
  public_key = file("~/.ssh/bastion_host.pub")
}

resource "aws_key_pair" "Test_instance_key" {
  key_name   = "Test_instance"
  public_key = file("~/.ssh/Test_instance.pub")
}

resource "aws_key_pair" "ec2_instance_private_key" {
  key_name   = "ec2_instance_private"
  public_key = file("~/.ssh/ec2_instance_private.pub")
}

## create key by using
## ssh-keygen -t rsa -b 4096 -f ~/.ssh/bastion_host
