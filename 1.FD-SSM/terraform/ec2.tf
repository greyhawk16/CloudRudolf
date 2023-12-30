

## web-ec2 ##

#web-ec2 role 

resource "aws_iam_role" "cr-fd-web-ec2-role"{
    name = "cr-fd-web-ec2-role-${var.crid}"
    assume_role_policy = <<ARP
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
ARP
  tags = {
      Name = "cr-fd-web-ec2-role-${var.crid}"
      Stack = "${var.stack-name}"
      Scenario = "${var.scenario-name}"
  }
}

#web-ec2 policy for web-ec2 role

resource "aws_iam_policy" "cr-fd-web-ec2-role-policy" {
  name = "cr-fd-web-ec2-role-policy-${var.crid}"
  description = "cr-fd-web-ec2-role-policy-${var.crid}"
  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "Statement1",
            "Effect": "Allow",
            "Action": [
                "ec2:*",
                "ssm:*"
            ],
            "Resource": "*"
        }
    ]
}
POLICY
}

#attach web-ec2 policy to web-ec2 role

resource "aws_iam_policy_attachment" "cr-fd-web-ec2-role-policy-attachment" {
  name = "cr-fd-web-ec2-role-policy-attachment-${var.crid}"
  roles = [
      "${aws_iam_role.cr-fd-web-ec2-role.name}"
  ]
  policy_arn = "${aws_iam_policy.cr-fd-web-ec2-role-policy.arn}"
}


#profile web-ec2 instance

resource "aws_iam_instance_profile" "cr-fd-web-ec2-instance-profile" {
  name = "cr-fd-web-ec2-instance-profile-${var.crid}"
  role = "${aws_iam_role.cr-fd-web-ec2-role.name}"
}

#web-ec2 security groups

resource "aws_security_group" "cr-fd-web-ec2-security-group" {
  name        = "cr-fd-web-ec2-${var.crid}"
  description = "Cloud ${var.crid} Security Group for file download web EC2 Instance over SSH, http"
  vpc_id      = "${aws_vpc.cr-vpc.id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name     = "cr-fd-web-ec2-${var.crid}"
    Stack    = var.stack-name
    Scenario = var.scenario-name
  }
}
#web-ec2 ssh key 
resource "tls_private_key" "cr-fd-web-ec2-key-pair" {
  algorithm     = "RSA"
  rsa_bits      = 4096
}

resource "aws_key_pair" "cr-fd-web-ec2-key-pair" {
  key_name   = "cr-fd-web-ec2-key"
  public_key = tls_private_key.cr-fd-web-ec2-key-pair.public_key_openssh
}

output "private_key" {
  description = "Private key for EC2 instance"
  value       = tls_private_key.cr-fd-web-ec2-key-pair.private_key_pem
  sensitive   = true
}

#web-ec2 instance
resource "aws_instance" "cr-fd-web-ec2" {
  ami = "ami-0c7217cdde317cfec"
  instance_type = "t2.medium"
  iam_instance_profile = aws_iam_instance_profile.cr-fd-web-ec2-instance-profile.name
  subnet_id = aws_subnet.cr-public-subnet.id
  associate_public_ip_address = true
  vpc_security_group_ids = [
    aws_security_group.cr-fd-web-ec2-security-group.id
  ]
  root_block_device {
    volume_type = "gp2"
    volume_size = 8
    delete_on_termination = true
  }
  key_name = aws_key_pair.cr-fd-web-ec2-key-pair.key_name

  provisioner "remote-exec" {
    inline = ["mkdir -p /home/ubuntu/code/fd_spring ; mkdir -p /home/ubuntu/web_file"]
    connection {
      type        = "ssh"
      user        = "ubuntu"
      host        = self.public_ip
      private_key = tls_private_key.cr-fd-web-ec2-key-pair.private_key_pem
    }
  }

  provisioner "file" {
    source = "../code/fd_spring"
    destination = "/home/ubuntu/code"
    connection {
      type        = "ssh"
      user        = "ubuntu"
      host        = self.public_ip
      private_key = tls_private_key.cr-fd-web-ec2-key-pair.private_key_pem
    }
  }

  provisioner "file" {
    source = "../code/dochi.jpg"
    destination = "/home/ubuntu/web_file/dochi.jpg"
    connection {
      type        = "ssh"
      user        = "ubuntu"
      host        = self.public_ip
      private_key = tls_private_key.cr-fd-web-ec2-key-pair.private_key_pem
    }
  }

  user_data = <<-UD
    #!/bin/bash
    sudo apt update
    sudo apt install awscli -y
    echo -e "${aws_iam_access_key.cr-fd-ac-sonic.id}\n${aws_iam_access_key.cr-fd-ac-sonic.secret}\nus-east-1\njson" | aws configure --profile sonic
    sudo apt install openjdk-21-jdk -y
    cd /home/ubuntu/code/fd_spring
    sudo chmod 755 gradlew
    sudo ./gradlew bootRun
  UD

  tags = {
    Name     = "cr-fd-web-ec2-${var.crid}"
    Stack    = var.stack-name
    Scenario = var.scenario-name
  }
}



## flag-ec2 ##

#flag-ec2 security groups

resource "aws_security_group" "cr-fd-flag-ec2-security-group" {
  name        = "cr-fd-flag-ec2-${var.crid}"
  description = "Cloud ${var.crid} Security Group for file download flag EC2 Instance"
  vpc_id      = "${aws_vpc.cr-vpc.id}"

  tags = {
    Name     = "cr-fd-flag-ec2-sg${var.crid}"
    Stack    = var.stack-name
    Scenario = var.scenario-name
  }
}

#flag-ec2 instance 
resource "aws_instance" "cr-fd-flag-ec2" {
    ami = "ami-0c7217cdde317cfec"
    instance_type = "t2.micro"
    subnet_id = "${aws_subnet.cr-public-subnet.id}"
    associate_public_ip_address = true
    vpc_security_group_ids = [
        "${aws_security_group.cr-fd-flag-ec2-security-group.id}"
    ]
    root_block_device {
        volume_type = "gp2"
        volume_size = 8
        delete_on_termination = true
    }

  user_data = <<-UD
    #!/bin/bash
    echo "flag = {Ddabong dochiya gomawo}" > flag.txt
    UD

    volume_tags = {
        Name = "CloudRudolf ${var.crid} fd flag EC2 Instance Root Device"
        Stack = "${var.stack-name}"
        Scenario = "${var.scenario-name}"
    }
    tags = {
        Name = "cr-fd-flag-ec2-${var.crid}"
        Stack = "${var.stack-name}"
        Scenario = "${var.scenario-name}"
    }
}
