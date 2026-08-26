resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.project_name}-secondary-vpc"
  }
}

resource "aws_subnet" "public" {
  count = 2

  vpc_id                  = aws_vpc.main.id
  cidr_block              = "172.21.${count.index + 1}.0/24"
  availability_zone       = var.azs[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-secondary-public-${count.index + 1}"
    Tier = "public"
  }
}

resource "aws_subnet" "frontend" {
  count = 2

  vpc_id            = aws_vpc.main.id
  cidr_block        = "172.21.${count.index + 3}.0/24"
  availability_zone = var.azs[count.index]

  tags = {
    Name = "${var.project_name}-secondary-frontend-${count.index + 1}"
    Tier = "frontend"
  }
}

resource "aws_subnet" "backend" {
  count = 2

  vpc_id            = aws_vpc.main.id
  cidr_block        = "172.21.${count.index + 5}.0/24"
  availability_zone = var.azs[count.index]

  tags = {
    Name = "${var.project_name}-secondary-backend-${count.index + 1}"
    Tier = "backend"
  }
}

resource "aws_subnet" "database" {
  count = 2

  vpc_id            = aws_vpc.main.id
  cidr_block        = "172.21.${count.index + 7}.0/24"
  availability_zone = var.azs[count.index]

  tags = {
    Name = "${var.project_name}-secondary-database-${count.index + 1}"
    Tier = "database"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project_name}-secondary-igw"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "${var.project_name}-secondary-public-rt"
  }
}

resource "aws_route_table_association" "public" {
  count = 2

  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.public[count.index].id
}

resource "aws_eip" "nat" {
  domain = "vpc"

  tags = {
    Name = "${var.project_name}-secondary-nat-eip"
  }
}

resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id

  tags = {
    Name = "${var.project_name}-secondary-nat"
  }

  depends_on = [aws_internet_gateway.main]
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main.id
  }

  tags = {
    Name = "${var.project_name}-secondary-private-rt"
  }
}

resource "aws_route_table_association" "frontend" {
  count = 2

  route_table_id = aws_route_table.private.id
  subnet_id      = aws_subnet.frontend[count.index].id
}

resource "aws_route_table_association" "backend" {
  count = 2

  route_table_id = aws_route_table.private.id
  subnet_id      = aws_subnet.backend[count.index].id
}

resource "aws_route_table_association" "database" {
  count = 2

  route_table_id = aws_route_table.private.id
  subnet_id      = aws_subnet.database[count.index].id
}
