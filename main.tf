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

module "key_pair" {
  source = "terraform-aws-modules/key-pair/aws"

  key_name   = "navoda_me_keypair"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAgMJhIV64QvB/xqW3LiFx733LP5aND5JJt3a7To5Iu9EmXp9DwXeTMAmRzta8TjG+V+JviJlBNCp66dBrAAPs2BowssKbTTLMrqtjN4Y2fy28+NGHaogzd3A8Jia9O4gtV9NZfws7l24scZDpxS/hK5wgPs5oHBj/q2stfaoMtdzwh8y8FbdRrQHW6Us4zBRz0tPRk9ybvkyfnkZcVir6zJfypnf/+6W6xm4wFfXmXxKVjgV3TyGIC+WE5tJgxVRqUZoUcWX3pF66zJ8ATdrbQeZLMdEDguCjCXld73giTp7A/ry79Q+gbXBllGjik5pIbv2/tWatF9qw4xU/CX8UKQ== imported-openssh-key"
}

resource "random_pet" "sg" {}

resource "aws_instance" "web" {
  ami                    = "ami-830c94e3"
  instance_type          = "t2.micro"
  key_name = "navoda_me_keypair"
  vpc_security_group_ids = [aws_security_group.web-sg.id]

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World" > index.html
              nohup busybox httpd -f -p 8080 &
              EOF
}

resource "aws_security_group" "web-sg" {
  name = "${random_pet.sg.id}-sg"
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "web-address" {
  value = "${aws_instance.web.public_dns}:8080"
}

output "public-dns" {
  value = aws_instance.web.public_dns
}
