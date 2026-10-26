#VPC
resource "aws_vpc" "hextone_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags                 = { Name = "hextone_vpc" }
}

#Internet Gateway
resource "aws_internet_gateway" "hextone_igw" {
  vpc_id = aws_vpc.hextone_vpc.id
  tags   = { Name = "hextone_igw" }
}

#Public_Subnets
resource "aws_subnet" "hextone_public_1" {
  vpc_id                  = aws_vpc.hextone_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-southeast-1a"
  map_public_ip_on_launch = true
  tags                    = { Name = "hextone_public_1" }
}

resource "aws_subnet" "hextone_public_2" {
  vpc_id                  = aws_vpc.hextone_vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "ap-southeast-1b"
  map_public_ip_on_launch = true
  tags                    = { Name = "hextone_public_2" }
}

#Private_Subnets
resource "aws_subnet" "hextone_private_1" {
  vpc_id            = aws_vpc.hextone_vpc.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "ap-southeast-1a"
  tags              = { Name = "hextone_private_1" }
}

resource "aws_subnet" "hextone_private_2" {
  vpc_id            = aws_vpc.hextone_vpc.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "ap-southeast-1b"
  tags              = { Name = "hextone_private_2" }
}

#Database_Subnets
resource "aws_subnet" "hextone_database_1" {
  vpc_id            = aws_vpc.hextone_vpc.id
  cidr_block        = "10.0.5.0/24"
  availability_zone = "ap-southeast-1a"
  tags              = { Name = "hextone_database_1" }
}

resource "aws_subnet" "hextone_database_2" {
  vpc_id            = aws_vpc.hextone_vpc.id
  cidr_block        = "10.0.6.0/24"
  availability_zone = "ap-southeast-1b"
  tags              = { Name = "hextone_database_2" }
}

#Elastic_IP
resource "aws_eip" "hextone_nat_eip" {
  domain = "vpc"
  tags   = { Name = "hextone_nat_eip" }
}

#NAT_Gateway
resource "aws_nat_gateway" "hextone_nat_gateway" {
  allocation_id = aws_eip.hextone_nat_eip.id
  subnet_id     = aws_subnet.hextone_public_1.id
  tags          = { Name = "hextone_nat_gateway" }

  depends_on    = [aws_internet_gateway.hextone_igw]
}

#ROUTE_TABLE_PUBLIC
resource "aws_route_table" "hextone_public_route" {
  vpc_id = aws_vpc.hextone_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.hextone_igw.id
  }
  tags = { Name = "hextone_public_route" }
}

resource "aws_route_table_association" "hextone_pub_1" {
  subnet_id      = aws_subnet.hextone_public_1.id
  route_table_id = aws_route_table.hextone_public_route.id
}

resource "aws_route_table_association" "hextone_pub_2" {
  subnet_id      = aws_subnet.hextone_public_2.id
  route_table_id = aws_route_table.hextone_public_route.id
}

#ROUTE_TABLE_PRIVATE
resource "aws_route_table" "hextone_private_route" {
  vpc_id = aws_vpc.hextone_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.hextone_nat_gateway.id
  }
  tags = { Name = "hextone_private_route" }
}

resource "aws_route_table_association" "hextone_pri_1" {
  subnet_id      = aws_subnet.hextone_private_1.id
  route_table_id = aws_route_table.hextone_private_route.id
}

resource "aws_route_table_association" "hextone_pri_2" {
  subnet_id      = aws_subnet.hextone_private_2.id
  route_table_id = aws_route_table.hextone_private_route.id
}

#ROUTE_TABLE_DATABASE
resource "aws_route_table" "hextone_db_route" {
  vpc_id = aws_vpc.hextone_vpc.id
  tags   = { Name = "hextone_db_route" }
}

resource "aws_route_table_association" "hextone_db_1" {
  subnet_id      = aws_subnet.hextone_database_1.id
  route_table_id = aws_route_table.hextone_db_route.id
}

resource "aws_route_table_association" "hextone_db_2" {
  subnet_id      = aws_subnet.hextone_database_2.id
  route_table_id = aws_route_table.hextone_db_route.id
}