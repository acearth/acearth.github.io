terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
  profile = "default"
  region  = "ap-northeast-1"
}

resource "aws_security_group" "ssh-sg" {
  name = "the-sg-for-ssh"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_security_group" "web-sg" {
  name = "the-sg-for-web"
  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "app_server" {
  ami           = "ami-0df99b3a8349462c6"
  instance_type = "t2.micro"
  key_name = "2021-ec2"
  vpc_security_group_ids = [aws_security_group.web-sg.id, aws_security_group.ssh-sg.id]
  tags = {
    Name = "t2-micro-20211001"
  }
}
resource "aws_key_pair" "deployer" {
  key_name   = "2021-ec2"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDII4O4bvPJOk2qjUaYvSLTbhmn4gDMw2HvLpOJa3sIrU85RUy/bTzl6hRU7MhxVNeu33Mny9nMCTUWZwvtc9xkZw4Ta7OojXpkJeqQ4sgPvZ34lWbGbkkCKyoAYNbi9wdbhk5RDUEwc+mBqh3l+am/Xrxdqb3ztIKOgsIY2cVl5ewrNTIZ/sLpO9udBZf41TVv+MQ9qq76IAIshx3wmaTJOPFc4fY1C3zhTOx3ccyn/ezfGItMZSdFs4kR/8Cnvo/omncLfYRKlE2pOXFBzXf0KeHwDLEez6rlujSOTr8AXxvRK/mh+9QDzCh3+DntpgjN/fgp/RRmi5sqyG3ecZtdSidRENDavZcex714LqaulkCGMCPkd6MjAujuTVPNg6R9RIoghXNAo6Y7gSifnPdMtDYG/w3HLXxy92z51CF9u/9e8wcklQvSpMZ9YJ7FSE99K2h4NMtueLTN5WrLSxZRzWnD+gzkpb1QO6pPmC2QgjJruwoNUy1xnBZ+Pd21YC0= ace@arcmac"
}
