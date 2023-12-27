resource "null_resource" "run_script" {
  provisioner "local-exec" {
    command = <<-CM
    #!/bin/bash
    ssh-keygen -b 4096 -t rsa -f ./cloudrudolf -q -N ""

    CM
  }
}


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
resource "aws_key_pair" "cr-fd-web-ec2-key-pair" {
  key_name = "cr-fd-web-ec2-key-pair-${var.crid}"
  public_key = "${file(var.ssh-public-key-for-ec2)}"

}


#web-ec2 instance

resource "aws_instance" "cr-fd-web-ec2" {
    ami = "ami-0c7217cdde317cfec"
    instance_type = "t2.medium"
    iam_instance_profile = "${aws_iam_instance_profile.cr-fd-web-ec2-instance-profile.name}"
    subnet_id = "${aws_subnet.cr-public-subnet.id}"
    associate_public_ip_address = true
    vpc_security_group_ids = [
        "${aws_security_group.cr-fd-web-ec2-security-group.id}"
    ]
    root_block_device {
        volume_type = "gp2"
        volume_size = 8
        delete_on_termination = true
    }
    key_name = "${aws_key_pair.cr-fd-web-ec2-key-pair.key_name}"
    provisioner "file" {
      source = "../code/fd_spring"
      destination = "/home/ubuntu/code/fd_spring"
      connection {
        type = "ssh"
        user = "ubuntu"
        host = self.public_ip
        private_key = "${file(var.ssh-private-key-for-ec2)}"
      }
    }
    provisioner "file" {
      source = "../code/dochi.img"
      destination = "/home/ubuntu/web_file/dochi.img"
      connection {
        type = "ssh"
        user = "ubuntu"
        host = self.public_ip
        private_key = "${file(var.ssh-private-key-for-ec2)}"
      }
    }
    user_data = <<-UD
        #!/bin/bash
        sudo apt update
        sudo apt install awscli
        echo -e "${aws_iam_access_key.cr-fd-ac-sonic.id}\n${aws_iam_access_key.cr-fd-ac-sonic.secret}\nus-east-1\njson" | aws configure --profile sonic
        sudo apt install openjdk-21-jdk
        cd /home/ubuntu/code/fd_spring
        sudo gradle clean build
        cd code/fd_spring/build/libs/
        sudo java -jar fd_spring-0.0.1-SNAPSHOT.jar
        UD
    volume_tags = {
        Name = "CloudRudolf ${var.crid} fd web EC2 Instance Root Device"
        Stack = "${var.stack-name}"
        Scenario = "${var.scenario-name}"
    }

    tags = {
        Name = "cr-fd-web-ec2-${var.crid}"
        Stack = "${var.stack-name}"
        Scenario = "${var.scenario-name}"
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
