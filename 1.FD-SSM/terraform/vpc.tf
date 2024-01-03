resource "aws_vpc" "cr-vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "cr-public-subnet" {
  vpc_id     = aws_vpc.cr-vpc.id
  cidr_block = "10.0.1.0/24"

}

resource "aws_internet_gateway" "cr-internet-gateway" {
  vpc_id = aws_vpc.cr-vpc.id
}

resource "aws_route_table" "cr-public-route-table" {
  vpc_id = aws_vpc.cr-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.cr-internet-gateway.id
  }

}

resource "aws_route_table_association" "cr-public-route-table-association" {
  subnet_id      = aws_subnet.cr-public-subnet.id
  route_table_id = aws_route_table.cr-public-route-table.id
}
