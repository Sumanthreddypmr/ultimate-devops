# ------------------------
# VPC
# ------------------------
resource "aws_vpc" "this" {
  cidr_block           = var.cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = { Name = "eks-vpc" }
}

# ------------------------
# Internet Gateway
# ------------------------
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
  tags   = { Name = "eks-igw" }
}

# ------------------------
# Public Subnets
# ------------------------
resource "aws_subnet" "public_1" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnet_cidrs[0]
  availability_zone       = var.azs[0]
  map_public_ip_on_launch = true
  tags                    = { Name = "public-subnet-1" }
}

resource "aws_subnet" "public_2" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnet_cidrs[1]
  availability_zone       = var.azs[1]
  map_public_ip_on_launch = true
  tags                    = { Name = "public-subnet-2" }
}

# ------------------------
# Private Subnets
# ------------------------
resource "aws_subnet" "private_1" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.private_subnet_cidrs[0]
  availability_zone = var.azs[0]
  tags              = { Name = "private-subnet-1" }
}

resource "aws_subnet" "private_2" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.private_subnet_cidrs[1]
  availability_zone = var.azs[1]
  tags              = { Name = "private-subnet-2" }
}

# ------------------------
# Public Route Table
# ------------------------
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id
  tags   = { Name = "public-rt" }
}

resource "aws_route_table_association" "public_1" {
  subnet_id      = aws_subnet.public_1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_2" {
  subnet_id      = aws_subnet.public_2.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route" "internet_access" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
}

# ------------------------
# NAT Gateway
# ------------------------
resource "aws_eip" "nat" {
  depends_on = [aws_internet_gateway.this]
  tags       = { Name = "nat-eip" }
}

resource "aws_nat_gateway" "this" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public_1.id
  tags          = { Name = "eks-nat-gateway" }
}

# ------------------------
# Private Route Table
# ------------------------
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id
  tags   = { Name = "private-rt" }
}

resource "aws_route" "private_nat" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.this.id
}

resource "aws_route_table_association" "private_1" {
  subnet_id      = aws_subnet.private_1.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_2" {
  subnet_id      = aws_subnet.private_2.id
  route_table_id = aws_route_table.private.id
}

# ------------------------
# Security Group for ECS
# ------------------------
resource "aws_security_group" "app_sg" {
  name        = "ecs-app-sg"
  description = "Allow HTTP traffic for ECS services"
  vpc_id      = aws_vpc.this.id

  ingress {
    from_port   = 80
    to_port     = 80
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
