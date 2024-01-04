

## web-ec2 ##

#web-ec2 role 

resource "aws_iam_role" "cr-ssrf-web-ec2-role"{
    name = "cr-ssrf-web-ec2-role"
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
}

#web-ec2 policy for web-ec2 role

resource "aws_iam_policy" "cr-ssrf-web-ec2-role-policy" {
  name = "cr-ssrf-web-ec2-role-policy"
  description = "cr-ssrf-web-ec2-role-policy"
  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "lambda:UpdateFunctionCode",
            "Resource": "*"
        },
        {
            "Sid": "Statement1",
            "Effect": "Allow",
            "Action": [
                "apigateway:*"
            ],
            "Resource": "*"
        }
    ]
}
POLICY
}
resource "aws_iam_policy" "cr-ssrf-web-ec2-role-list-policy" {
  name = "cr-ssrf-web-ec2-role-list-policy"
  description = "cr-ssrf-web-ec2-role-list-policy"
  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "iam:GetPolicyVersion",
            "Resource": "*"
        },
        
        {
            "Effect": "Allow",
            "Action": "iam:ListPolicyVersions",
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "iam:ListAttachedRolePolicies",
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "lambda:GetFunction",
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "rds:DescribeDBInstances",
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "cloudtrail:DescribeTrails",
            "Resource": "*"
        }
    ]
}
POLICY
}


#attach web-ec2 policy to web-ec2 role

resource "aws_iam_policy_attachment" "cr-ssrf-web-ec2-role-policy-attachment1" {
  name = "cr-ssrf-web-ec2-role-policy-attachment"
  roles = [
      "${aws_iam_role.cr-ssrf-web-ec2-role.name}"
  ]
  policy_arn = "${aws_iam_policy.cr-ssrf-web-ec2-role-policy.arn}"
}


resource "aws_iam_policy_attachment" "cr-ssrf-web-ec2-role-policy-attachment2" {
  name = "cr-ssrf-web-ec2-role-policy-attachment"
  roles = [
      "${aws_iam_role.cr-ssrf-web-ec2-role.name}"
  ]
  policy_arn = "${aws_iam_policy.cr-ssrf-web-ec2-role-list-policy.arn}"
}


#profile web-ec2 instance

resource "aws_iam_instance_profile" "cr-ssrf-web-ec2-instance-profile" {
  name = "cr-ssrf-web-ec2-instance-profile"
  role = "cr-ssrf-web-ec2-role"
}

#web-ec2 security groups

resource "aws_security_group" "cr-ssrf-web-ec2-security-group" {
  name        = "cr-ssrf-web-ec2"
  vpc_id      = "${aws_vpc.cr-vpc.id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
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
    Name     = "cr-ssrf-web-ec2"
  }
}
#web-ec2 ssh key 
resource "tls_private_key" "cr-ssrf-web-ec2-key" {
  algorithm     = "RSA"
  rsa_bits      = 4096
}

resource "aws_key_pair" "cr-ssrf-web-ec2-key-pair" {
  key_name   = "cr-ssrf-web-ec2-key"
  public_key = tls_private_key.cr-ssrf-web-ec2-key.public_key_openssh
}

output "private_key" {
  description = "Private key for EC2 instance"
  value       = tls_private_key.cr-ssrf-web-ec2-key.private_key_pem
  sensitive   = true
}

#web-ec2 instance
resource "aws_instance" "cr-ssrf-web-ec2" {
  ami = "ami-0c7217cdde317cfec"
  instance_type = "t2.micro"
  iam_instance_profile = aws_iam_instance_profile.cr-ssrf-web-ec2-instance-profile.name
  subnet_id = aws_subnet.cr-public-subnet.id
  associate_public_ip_address = true
  vpc_security_group_ids = [
    aws_security_group.cr-ssrf-web-ec2-security-group.id
  ]
  root_block_device {
    volume_type = "gp2"
    volume_size = 8
    delete_on_termination = true
  }
  key_name = aws_key_pair.cr-ssrf-web-ec2-key-pair.key_name



provisioner "remote-exec"{
  script= "script.sh"
    connection {
      type        = "ssh"
      user        = "ubuntu"
      host        = self.public_ip
      private_key = tls_private_key.cr-ssrf-web-ec2-key.private_key_pem
    }
}

  provisioner "file" {
    source = "../code/"
    destination = "/var/www/html/"
    connection {
      type        = "ssh"
      user        = "ubuntu"
      host        = self.public_ip
      private_key = tls_private_key.cr-ssrf-web-ec2-key.private_key_pem
    }

  }

  tags = {
    Name     = "cr-ssrf-web-ec2"
 
  }
}


