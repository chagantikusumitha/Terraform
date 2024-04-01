# Networking (VPC Setup)
# main.tf
variable "aws_access_key" {
default = ""
}
variable "aws_secret_key" {
default = ""
}
variable "aws_region" {
default = "us-east-1"
}

provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = var.aws_region
}


resource "aws_vpc" "custom_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.custom_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.custom_vpc.id
  cidr_block = "10.0.2.0/24"
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.custom_vpc.id
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.custom_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "public_subnet_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}

