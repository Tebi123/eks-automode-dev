# Data source to get available AZs
data "aws_availability_zones" "available" {
  state = "available"
}
# VPC configuration
resource "aws_vpc" "dev" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "dev-vpc"
  }
}
# Public subnet
resource "aws_subnet" "dev_public" {
  count                   = 2
  vpc_id                  = aws_vpc.dev.id
  cidr_block              = "10.0.${count.index + 1}.0/24"
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "dev-public-${count.index + 1}"


  }
}

# Private subnet
resource "aws_subnet" "dev_private" {
  count             = 2
  vpc_id            = aws_vpc.dev.id
  cidr_block        = "10.0.${count.index + 10}.0/24"
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "dev-private-${count.index + 1}"

  }
}

# Internet Gateway
resource "aws_internet_gateway" "dev" {
  vpc_id = aws_vpc.dev.id

  tags = {
    Name = "dev-igw"
  }
}

# Nat Gateway
resource "aws_nat_gateway" "dev" {
  allocation_id = aws_eip.dev.id
  subnet_id     = aws_subnet.dev_public[0].id # Place in first public subnet

  tags = {
    Name = "dev-nat-gateway"
  }
  depends_on = [aws_internet_gateway.dev]
}

# EIP for Nat Gateway
resource "aws_eip" "dev" {
  domain = "vpc"

  tags = {
    Name = "dev-eip"
  }
  depends_on = [aws_internet_gateway.dev]
}

# Route Table for Public Subnet
resource "aws_route_table" "dev_public" {
  vpc_id = aws_vpc.dev.id

  tags = {
    Name = "dev-public-rt"
  }
}

# Route to Internet for Public Subnets
resource "aws_route" "dev_public_internet" {
  route_table_id         = aws_route_table.dev_public.id
  destination_cidr_block = "0.0.0.0/0" # ALL traffic to internet
  gateway_id             = aws_internet_gateway.dev.id
}

# Route Table for Private Subnet
resource "aws_route_table" "dev_private" {
  vpc_id = aws_vpc.dev.id

  tags = {
    Name = "dev-private-rt"
  }
}

# Route to NAT for Private Subnets
resource "aws_route" "dev_private_nat" {
  route_table_id         = aws_route_table.dev_private.id
  destination_cidr_block = "0.0.0.0/0" # ALL traffic to NAT
  nat_gateway_id         = aws_nat_gateway.dev.id
}

# Associate Public Subnets with Public Route Table
resource "aws_route_table_association" "dev_public" {
  count          = length(aws_subnet.dev_public)
  subnet_id      = aws_subnet.dev_public[count.index].id
  route_table_id = aws_route_table.dev_public.id
}

# Associate Private Subnets with Private Route Table
resource "aws_route_table_association" "dev_private" {
  count          = length(aws_subnet.dev_private)
  subnet_id      = aws_subnet.dev_private[count.index].id
  route_table_id = aws_route_table.dev_private.id
}
