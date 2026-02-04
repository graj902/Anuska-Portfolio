provider "aws" {
  region = var.region
}

# 1. Networking (Task 2)
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags = { Name = "${var.project_name}-vpc" }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
}

resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "rta" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.rt.id
}

# 2. Security Group (Task 2)
resource "aws_security_group" "web_sg" {
  name   = "portfolio-sg"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
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

# 3. S3 Bucket (Task 4)
resource "aws_s3_bucket" "portfolio_bucket" {
  bucket = "anuska-portfolio-assets-mumbai-2026"
}

resource "aws_s3_bucket_versioning" "v" {
  bucket = aws_s3_bucket.portfolio_bucket.id
  versioning_configuration { status = "Enabled" }
}

# 4. EC2 Instance (Task 2)
resource "aws_instance" "web_server" {
  ami           = "ami-0522dabe3a7407c92" # Amazon Linux 2023 in Mumbai
  instance_type = var.instance_type
  subnet_id     = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              dnf update -y
              dnf install python3 git -y
              git clone https://github.com/graj902/Anuska-Portfolio.git
              cd Anuska-Portfolio
              pip3 install -r requirements.txt
              python3 app.py &
              EOF

  tags = { Name = "${var.project_name}-server" }
}
