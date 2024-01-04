
resource "aws_db_instance" "cr-ssrf-db" {
  allocated_storage = 5
  storage_type  = "gp2"
  engine  = "mysql"
  engine_version = "5.7"
  instance_class = "db.t2.micro"
  identifier  = "cr-ssrf-db"
  username = "foo"
  password = "foobarbaz"
  parameter_group_name = "default.mysql5.7"
  db_subnet_group_name = aws_db_subnet_group.cr-ssrf-db-subnet-group.name
  skip_final_snapshot  = true
}

resource "aws_subnet" "cr-public-subnet-2" {
  vpc_id     = aws_vpc.cr-vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1b"
  
  tags = {
    Name = "cr-public-subnet-2"
  }
}

resource "aws_db_subnet_group" "cr-ssrf-db-subnet-group" {
  name       = "cr-ssrf-db-subnet-group"
  subnet_ids = [aws_subnet.cr-public-subnet.id, aws_subnet.cr-public-subnet-2.id]
}
