resource "aws_vpc" "sh-vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "sh-public-subnet" {
  vpc_id     = aws_vpc.sh-vpc.id
  cidr_block = "10.0.1.0/24"

}

resource "aws_internet_gateway" "sh-internet-gateway" {
  vpc_id = aws_vpc.sh-vpc.id
}

resource "aws_route_table" "sh-public-route-table" {
  vpc_id = aws_vpc.sh-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.sh-internet-gateway.id
  }

}

resource "aws_route_table_association" "sh-public-route-table-association" {
  subnet_id      = aws_subnet.sh-public-subnet.id
  route_table_id = aws_route_table.sh-public-route-table.id
}
