resource "aws_vpc" "cr-vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "cr-vpc-${var.crid}"
    Stack = "${var.stack-name}"
    Scenario = "${var.scenario-name}"
  }
}

resource "aws_subnet" "cr-public-subnet" {
  vpc_id     = aws_vpc.cr-vpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "cr-public-subnet-${var.crid}"
    Stack = "${var.stack-name}"
    Scenario = "${var.scenario-name}"
  }
}

resource "aws_internet_gateway" "cr-internet-gateway" {
  vpc_id = aws_vpc.cr-vpc.id

  tags = {
    Name = "cr-internet-gateway-${var.crid}"
    Stack = "${var.stack-name}"
    Scenario = "${var.scenario-name}"
  }
}

resource "aws_route_table" "cr-public-route-table" {
  vpc_id = aws_vpc.cr-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.cr-internet-gateway.id
  }

  tags = {
    Name = "cr-public-route-table-${var.crid}"
    Stack = "${var.stack-name}"
    Scenario = "${var.scenario-name}"
  }
}

resource "aws_route_table_association" "cr-public-route-table-association" {
  subnet_id      = aws_subnet.cr-public-subnet.id
  route_table_id = aws_route_table.cr-public-route-table.id
}
