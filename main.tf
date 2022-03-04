provider "aws" {
  region = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}
variable "region" {}
variable "access_key" {}
variable "secret_key" {}
variable "vpc_cidr" {}
variable "subnet_cidr" {}
variable "route_table_cidr" {}
variable "ingress_cidr" {}
variable "egress_cidr" {}
variable "ami" {}
variable "instance_type" {}
variable "availability_zone" {}
variable "key_name" {}
resource "aws_vpc" "my_vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "my_vpc"
  }
}
resource "aws_subnet" "my_subnet" {
  cidr_block = var.subnet_cidr
  vpc_id = aws_vpc.my_vpc.id
  availability_zone = var.availability_zone
  tags = {
    Name = "my_subnet"
  }
}
resource "aws_internet_gateway" "my_gateway" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "my_gateway"
  }
}
resource "aws_route_table" "my_route_table" {
  vpc_id = aws_vpc.my_vpc.id
  route {
    cidr_block = var.route_table_cidr
    gateway_id = aws_internet_gateway.my_gateway.id
  }
  tags = {
    Name = "my_route_table"
  }
}
resource "aws_security_group" "my_securit" {
  name = "my_security"
  vpc_id = aws_vpc.my_vpc.id
  ingress {
    from_port = 0
    protocol = "-1"
    to_port = 0
    cidr_blocks = var.ingress_cidr
  }
  egress {
    from_port = 0
    protocol = "-1"
    to_port = 0
    cidr_blocks = var.egress_cidr
  }
}
resource "aws_route_table_association" "my_association" {
  route_table_id = aws_route_table.my_route_table.id
  subnet_id = aws_subnet.my_subnet.id
}
resource "aws_instance" "my_instnace" {
  ami = var.ami
  instance_type = var.instance_type
  availability_zone = var.availability_zone
  subnet_id = aws_subnet.my_subnet.id
  vpc_security_group_ids = [aws_security_group.my_securit.id]
  associate_public_ip_address = true
  key_name = var.key_name
  tags = {
    Name = "my_instance"
  }
}