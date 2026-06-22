resource "aws_s3_bucket" "tf-state" {
  bucket = "rjnoord-ecs-tf-state"
}

resource "aws_vpc" "Main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "ecs-fargate-vpc"
  }
}

resource "aws_subnet" "public_subnet_A" {
  vpc_id            = aws_vpc.Main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "Public-subnet-A"
  }

}

resource "aws_subnet" "public_subnet_B" {
  vpc_id            = aws_vpc.Main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "public-subnet-b"
  }

}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.Main.id

  tags = {
    Name = "Internet-gateway-fargate"
  }
}

resource "aws_route_table" "Public" {
  vpc_id = aws_vpc.Main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public-route-table"
  }
}

resource "aws_route_table_association" "public_a" {
  subnet_id      = aws_subnet.public_subnet_A.id
  route_table_id = aws_route_table.Public.id
}

resource "aws_route_table_association" "public_b" {
  subnet_id      = aws_subnet.public_subnet_B.id
  route_table_id = aws_route_table.Public.id
}

