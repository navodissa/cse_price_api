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

# module "key_pair" {
#   source = "terraform-aws-modules/key-pair/aws"

#   key_name   = "tf-testing"
#   public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCCIyiDhTUGTj+nsMtnFtyj1mvFAMt05vbTCbVGaXAxEIpzTzYbwz2K2rG7/eOb1wSTUXxogjchrL79dCBFG+xz5lBAGkCAMw3h0F2/HEAmWUhW8DlXJMYs8UaoojZ2LWjVZw5Uwif0jbwt/S0HYdfyPC+m7uYMM+ICExG/awV5gbOEg7TFjsxIgQYaZ1IwPP0whP01VWnT5sX+UWG4BMD5MzULwaBlzvL94WXhkB4hAuUaqZXs9UtmdFfOzNQnWO31HayO5HhD79dF317YCR5TR0CckrssB3n6TIZ1awGYDZO6bIM6vlHX/UqXh3Fi3BFrj50el7Qy6xmW19WFl1+F tf-testing"
# }

resource "random_pet" "sg" {}

resource "aws_instance" "web" {
  ami                    = "ami-830c94e3"
  instance_type          = "t2.micro"
  key_name = "tf-testing"
  vpc_security_group_ids = [aws_security_group.web-sg.id]

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World" > index.html
              nohup busybox httpd -f -p 8080 &
              EOF
}

resource "aws_security_group" "web-sg" {
  name = "${random_pet.sg.id}-sg"
  ingress = [{
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  },
  {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ]
}

output "web-address" {
  value = "${aws_instance.web.public_dns}:8080"
}

output "public-dns" {
  value = aws_instance.web.public_dns
}
