resource "aws_vpc" "my_vpc" {
  cidr_block       = var.vpc_cidr
  tags = {
    Name = "${terraform.workspace}-vpc"
  }
}

resource "aws_subnet" "public1_subnets" {
  vpc_id     = aws_vpc.my_vpc.id
  count = length(var.pub1_subnet_cidr)
  cidr_block = var.pub1_subnet_cidr[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "${terraform.workspace}-pubsub1-${count.index}"
  }
}

resource "aws_subnet" "public2_subnets" {
  vpc_id     = aws_vpc.my_vpc.id
  count = length(var.pub2_subnet_cidr)
  cidr_block = var.pub2_subnet_cidr[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "${terraform.workspace}-pubsub2-${count.index}"
  }
}

resource "aws_subnet" "private1_subnets" {
  vpc_id     = aws_vpc.my_vpc.id
  count = length(var.private1_subnet_cidr)
  cidr_block = var.private1_subnet_cidr[count.index]

  tags = {
    Name = "${terraform.workspace}-privatesub1-${count.index}"
  }
}

resource "aws_subnet" "private2_subnets" {
  vpc_id     = aws_vpc.my_vpc.id
  count = length(var.private2_subnet_cidr)
  cidr_block = var.private2_subnet_cidr[count.index]

  tags = {
    Name = "${terraform.workspace}-privatesub2-${count.index}"
  }
}

resource "aws_internet_gateway" "my_gw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "${terraform.workspace}-IGW"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_gw.id
  }

  tags = {
    Name = "${terraform.workspace}-public_rt"
  }
}

resource "aws_route_table_association" "pub1rtasso" {
  count = length(aws_subnet.public1_subnets)
  subnet_id      = aws_subnet.public1_subnets[count.index].id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "pub2rtasso" {
  count = length(aws_subnet.public2_subnets)
  subnet_id      = aws_subnet.public2_subnets[count.index].id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_eip" "my_eip" {
    count = 2

}

resource "aws_nat_gateway" "my_nat_gw" {
  count = 2  
  allocation_id = aws_eip.my_eip[count.index].id
  subnet_id     = aws_subnet.public1_subnets[count.index].id

  tags = {
    Name = "${terraform.workspace}-natGW-${count.index}"
  }
}

resource "aws_route_table" "privateRT" {
  vpc_id = aws_vpc.my_vpc.id
  count = 2

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.my_nat_gw[count.index].id
  }

  tags = {
    Name = "${terraform.workspace}-privateRT-${count.index}"
  }
}

resource "aws_route_table_association" "private1rtasso" {
  count = 2
  subnet_id      = aws_subnet.private1_subnets[count.index].id
  route_table_id = aws_route_table.privateRT[count.index].id
}  

resource "aws_route_table_association" "private2rtasso" {
  count = 2
  subnet_id      = aws_subnet.private2_subnets[count.index].id
  route_table_id = aws_route_table.privateRT[count.index].id
}  



