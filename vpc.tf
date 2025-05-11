# create vpc
resource "aws_vpc" "vp1" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
  tags = {
    Name = "ELB-Vpc"
    Team = "wdp"
    env  = "dev"
  }
}


# Internet Gateway
resource "aws_internet_gateway" "gtw1" {
  vpc_id = aws_vpc.vp1.id
}


#Public subnet1
resource "aws_subnet" "public1" {
  availability_zone       = "us-east-1a"
  cidr_block              = "10.0.1.0/24"
  vpc_id                  = aws_vpc.vp1.id
  map_public_ip_on_launch = true
  tags = {
    Name = "utc-public-subnet-1a"
  }
}


#public subnet 2
resource "aws_subnet" "public2" {
  availability_zone       = "us-east-1b"
  cidr_block              = "10.0.2.0/24"
  vpc_id                  = aws_vpc.vp1.id
  map_public_ip_on_launch = true
  tags = {
    Name = "public-subnet-1b"
  }
}


#private subnet 1
resource "aws_subnet" "private1" {
  availability_zone = "us-east-1a"
  cidr_block        = "10.0.3.0/24"
  vpc_id            = aws_vpc.vp1.id
  tags = {
    Name = "private-subnet-1a"
  }
}


#private subnet 2
resource "aws_subnet" "private2" {
  availability_zone = "us-east-1b"
  cidr_block        = "10.0.4.0/24"
  vpc_id            = aws_vpc.vp1.id
  tags = {
    Name = "private-subnet-1b"
  }
}


#Nat gateway
resource "aws_eip" "el1" {

}

resource "aws_nat_gateway" "nat1" {
  allocation_id = aws_eip.el1.id
  subnet_id     = aws_subnet.public1.id
}

#Public route
resource "aws_route_table" "rtpub" {
  vpc_id = aws_vpc.vp1.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gtw1.id
  }
}

#Private route

resource "aws_route_table" "rtpri" {
  vpc_id = aws_vpc.vp1.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat1.id
  }
}


#Route and subnet association public

resource "aws_route_table_association" "rta1" {
  subnet_id      = aws_subnet.public1.id
  route_table_id = aws_route_table.rtpub.id

}

resource "aws_route_table_association" "rta2" {
  subnet_id      = aws_subnet.public2.id
  route_table_id = aws_route_table.rtpub.id

}

# Route and subnet association private
resource "aws_route_table_association" "rta3" {
  subnet_id      = aws_subnet.private1.id
  route_table_id = aws_route_table.rtpri.id

}

resource "aws_route_table_association" "rta4" {
  subnet_id      = aws_subnet.private2.id
  route_table_id = aws_route_table.rtpri.id

}