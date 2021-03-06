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
  required_version = ">= 0.14"

  backend "remote" {
    organization = "navoda"

    workspaces {
      name = "gh-action-demo"
    }
  }
}


provider "aws" {
  region = "us-west-2"
}

resource "random_pet" "sg" {}

resource "aws_instance" "web" {
  ami                    = "ami-03d5c68bab01f3496"
  instance_type          = "t2.micro"
  key_name = "tf-testing"
  vpc_security_group_ids = [aws_security_group.web-sg.id]

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World!" > index.html
              nohup busybox httpd -f -p 8080 &
              EOF
}

resource "aws_security_group" "web-sg" {
  name = "${random_pet.sg.id}-sg"
  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress  {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress   {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }  
}

output "web-address" {
  value = "${aws_instance.web.public_dns}:8080"
}

output "public-dns" {
  value = aws_instance.web.public_dns
}
