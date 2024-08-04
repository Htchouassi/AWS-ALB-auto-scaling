# 1. create vpc

resource "aws_vpc" "custom_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "my-vpc"
  }
}

# 2. create subnets
#public subnet 1
resource "aws_subnet" "public_subnet1" {
  availability_zone       = "us-east-1a"
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  vpc_id                  = aws_vpc.custom_vpc.id
  tags = {
    Name = "my-public-subnet1"
  }

}
# public subnet 2
resource "aws_subnet" "public_subnet2" {
  availability_zone       = "us-east-1b"
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = true
  vpc_id                  = aws_vpc.custom_vpc.id
  tags = {
    Name = "my-public-subnet2"
  }
}
#private subnet 1
resource "aws_subnet" "private_subnet1" {
  availability_zone = "us-east-1a"
  cidr_block        = "10.0.3.0/24"
  vpc_id            = aws_vpc.custom_vpc.id
  tags = {
    Name = "my-private-subnet1"
  }
}
# private subnet 2
resource "aws_subnet" "private_submet2" {
  availability_zone = "us-east-1b"
  cidr_block        = "10.0.4.0/24"
  vpc_id            = aws_vpc.custom_vpc.id
  tags = {
    Name = "my-private-subnet-1b"
  }
}

# 3. Internet gateway

resource "aws_internet_gateway" "intergtw_vpc" {
  vpc_id = aws_vpc.custom_vpc.id
}


# 4. route Table for public subnet 

resource "aws_route_table" "route_table_public_subnet" {
  vpc_id = aws_vpc.custom_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.intergtw_vpc.id
  }
}

# 5. Route table association with public subnet

resource "aws_route_table_association" "route_table_association1" {
  subnet_id      = aws_subnet.public_subnet1.id
  route_table_id = aws_route_table.route_table_public_subnet.id
}
resource "aws_route_table_association" "route_table_association2" {
  subnet_id      = aws_subnet.public_subnet2.id
  route_table_id = aws_route_table.route_table_public_subnet.id
}


# 6. Elastic IP
resource "aws_eip" "elastic_IP" {
  domain     = "vpc"
  depends_on = [aws_internet_gateway.intergtw_vpc]

}

# 7. Nat Gateway 
resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.elastic_IP.id
  subnet_id     = aws_subnet.public_subnet1.id
  depends_on    = [aws_internet_gateway.intergtw_vpc]
  tags = {
    Name = "My-custom-nat-gateway"
  }
}

# 8. private route table for private subnet
resource "aws_route_table" "route_table_private_subnet" {
  vpc_id = aws_vpc.custom_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gateway.id
  }
  depends_on = [aws_nat_gateway.nat_gateway]
}

# 9 route table association with private subnet 
resource "aws_route_table_association" "route_table_association3" {
  subnet_id      = aws_subnet.private_subnet1.id
  route_table_id = aws_route_table.route_table_private_subnet.id
}
resource "aws_route_table_association" "route_table_association4" {
  subnet_id      = aws_subnet.private_submet2.id
  route_table_id = aws_route_table.route_table_private_subnet.id
}