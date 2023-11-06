resource "aws_vpc" "demo" {
  cidr_block = "10.0.0.0/16"

  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "demo"
  }
}

resource "aws_subnet" "public1" {
  cidr_block = "10.0.1.0/24"
  vpc_id     = aws_vpc.demo.id

  map_public_ip_on_launch = true
  availability_zone       = "ap-southeast-1a"

  tags = {
    Name = "public-1"
  }
}

resource "aws_subnet" "public2" {
  cidr_block = "10.0.2.0/24"
  vpc_id     = aws_vpc.demo.id

  map_public_ip_on_launch = true
  availability_zone       = "ap-southeast-1b"

  tags = {
    Name = "public-2"
  }
}

resource "aws_subnet" "lb1" {
  cidr_block = "10.0.3.0/24"
  vpc_id     = aws_vpc.demo.id

  map_public_ip_on_launch = true
  availability_zone       = "ap-southeast-1a"

  tags = {
    Name = "lb-1"
  }
}

resource "aws_subnet" "lb2" {
  cidr_block = "10.0.4.0/24"
  vpc_id     = aws_vpc.demo.id

  map_public_ip_on_launch = true
  availability_zone       = "ap-southeast-1b"

  tags = {
    Name = "lb-2"
  }
}

resource "aws_internet_gateway" "demo_gw" {
  vpc_id = aws_vpc.demo.id
}

resource "aws_route" "name" {
  route_table_id = aws_route_table.demo_rt.id

  destination_cidr_block = "0.0.0.0/0"

  gateway_id = aws_internet_gateway.demo_gw.id
}

resource "aws_route_table" "demo_rt" {
  vpc_id = aws_vpc.demo.id

  tags = {
    Name = "demo-rt"
  }
}

resource "aws_route_table_association" "pb_as_1" {
  route_table_id = aws_route_table.demo_rt.id
  subnet_id      = aws_subnet.public1.id
}

resource "aws_route_table_association" "pb_as_2" {
  route_table_id = aws_route_table.demo_rt.id
  subnet_id      = aws_subnet.public2.id
}

resource "aws_route_table_association" "lb_as_1" {
  route_table_id = aws_route_table.demo_rt.id
  subnet_id      = aws_subnet.lb1.id
}

resource "aws_route_table_association" "lb_as_2" {
  route_table_id = aws_route_table.demo_rt.id
  subnet_id      = aws_subnet.lb2.id
}

resource "aws_security_group" "demo_sg" {
  name        = "demo-sg"
  description = "Allow http https and ssh"
  vpc_id      = aws_vpc.demo.id

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description      = "Allow outbond"
    from_port        = 0
    to_port          = 0
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "demo-sg"
  }
}