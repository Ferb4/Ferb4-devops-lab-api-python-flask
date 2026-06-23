terraform {
  required_version = ">= 1.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

data "aws_ami" "debian" {
  most_recent = true
  owners      = ["136693071363"]

  filter {
    name   = "name"
    values = ["debian-12-amd64-*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_security_group" "lab_sg" {
  name        = "devops-lab-sg"
  description = "DevOps Lab Security Group"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "local_ed25519" {
  key_name   = "lab-ed25519"
  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF1SQC4vL1oLk7zeysfQqon1ExVUTVvxO/TH+sS6FcUW ferb@Debian"
}

resource "aws_instance" "lab" {
  ami           = data.aws_ami.debian.id
  instance_type = "t3.micro"

  associate_public_ip_address = true
  key_name                    = aws_key_pair.local_ed25519.key_name

  vpc_security_group_ids = [
    aws_security_group.lab_sg.id
  ]

  user_data = <<-EOF
#!/bin/bash
apt-get update -y
apt-get install -y docker.io
systemctl enable docker
systemctl start docker
EOF

  tags = {
    Name = "devops-lab"
  }
}
resource "aws_ecr_repository" "api" {
  name = "devops-lab-api"

  image_scanning_configuration {
    scan_on_push = true
  }
}
