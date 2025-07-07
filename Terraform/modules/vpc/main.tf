resource "aws_vpc" "main" {
  cidr_block       = var.cidr_block
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    Name = "${var.environment}-vpc"
  }
}

resource "aws_subnet" "private_subnet" {
  count = length(var.private_subnet_cidr)

  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidr[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name = "${var.environment}-private-subnet-${count.index + 1}"
  }
  
}

resource "aws_subnet" "public_subnet" {
    vpc_id            = aws_vpc.main.id
    cidr_block        = var.public_subnet_cidr[count.index]
    availability_zone = var.availability_zones[count.index]

    map_public_ip_on_launch = true
    
    tags = {
        Name = "${var.environment}-public-subnet-${count.index + 1}"
    }
  
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.environment}-internet-gateway"
  }
}

resource "aws_eip" "nat_eip" {
    count = length(var.availability_zones)
    domain = "vpc"
    
    tags = {
        Name = "${var.environment}-nat-eip-${count.index + 1}"
    }

 
  
}

resource "aws_nat_gateway" "main" {
  count = length(var.availability_zones)

  allocation_id = aws_eip.nat_eip[count.index].id
  subnet_id     = aws_subnet.public_subnet[count.index].id

  tags = {
    Name = "${var.environment}-nat-gateway-${count.index + 1}"
  }
  
}

resource "aws_route_table" "public" {
    vpc_id = aws_vpc.main.id
     route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.main.id
    }

    tags = {
        Name = "${var.environment}-public-route-table"
    }
  
}

resource "aws_route_table" "private" {
    vpc_id = aws_vpc.main.id
    count = length(var.private_subnet_cidr)

    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.main[count.index].id
    }

    tags = {
        Name = "${var.environment}-private-route-table-${count.index + 1}"
    }   
  
}

resource "aws_route_table_association" "private" {
    count = length(var.private_subnet_cidr)
    subnet_id = aws_subnet.private_subnet[count.index].id
    route_table_id = aws_route_table.private[count.index].id
  
}

resource "aws_route_table_association" "public" {
    count = length(var.public_subnet_cidr)
    subnet_id = aws_subnet.public_subnet[count.index].id
    route_table_id = aws_route_table.public.id
  
}