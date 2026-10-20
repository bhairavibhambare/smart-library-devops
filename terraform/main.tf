terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "ap-southeast-2"
}

resource "aws_vpc" "library_vpc" {
  cidr_block           = "10.20.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name    = "smart-library-vpc"
    Project = "smart-library-devops"
  }
}

resource "aws_subnet" "library_subnet" {
  vpc_id                  = aws_vpc.library_vpc.id
  cidr_block              = "10.20.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name    = "smart-library-public-subnet"
    Project = "smart-library-devops"
  }
}

resource "aws_internet_gateway" "library_igw" {
  vpc_id = aws_vpc.library_vpc.id

  tags = {
    Name = "smart-library-igw"
  }
}

resource "aws_route_table" "library_route_table" {
  vpc_id = aws_vpc.library_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.library_igw.id
  }

  tags = {
    Name = "smart-library-public-rt"
  }
}

resource "aws_route_table_association" "library_route_assoc" {
  subnet_id      = aws_subnet.library_subnet.id
  route_table_id = aws_route_table.library_route_table.id
}

resource "aws_security_group" "library_sg" {
  name        = "smart-library-sg"
  description = "Allow SSH and web traffic for the Smart Library project"
  vpc_id      = aws_vpc.library_vpc.id

  ingress {
    description = "SSH - restrict to your own public IP before applying"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Smart Library web application"
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

  tags = {
    Name    = "smart-library-sg"
    Project = "smart-library-devops"
  }
}

resource "aws_s3_bucket" "library_backup" {
  bucket_prefix = "smart-library-backup-"

  tags = {
    Name    = "smart-library-backup"
    Project = "smart-library-devops"
  }
}

# Find the latest official Ubuntu Server 24.04 LTS AMI in this region
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# EC2 host for the Smart Library project
resource "aws_instance" "library_host" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.library_subnet.id
  vpc_security_group_ids      = [aws_security_group.library_sg.id]
  key_name                    = "miniproject-key"
  associate_public_ip_address = true

  root_block_device {
    volume_size = 15
    volume_type = "gp3"
  }

  tags = {
    Name    = "smart-library-app-host"
    Project = "smart-library-devops"
  }
}

output "library_host_public_ip" {
  description = "Public IP address of the Smart Library EC2 host"
  value       = aws_instance.library_host.public_ip
}

output "library_backup_bucket_name" {
  description = "Name of the Smart Library backup bucket"
  value       = aws_s3_bucket.library_backup.bucket
}
