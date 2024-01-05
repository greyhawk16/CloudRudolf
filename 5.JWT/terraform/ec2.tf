#set web-ec2-role
resource "aws_iam_role" "jwt-web-ec2-role" {
	name = "jwt-web-ec2-role"
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

#policies for  role
resource "aws_iam_policy" "jwt-web-ec2-role-policy" {
	name = "jwt-web-ec2-role-policy"
	description = "policy of ec2"
	policy = <<POLICY
{
    	"Version": "2012-10-17",
    	"Statement": [
        	{
            	"Effect": "Allow",
            	"Action": [
                	"ssm:DescribeAssociation",
                	"ssm:GetDeployablePatchSnapshotForInstance",
                	"ssm:GetDocument",
                	"ssm:DescribeDocument",
                	"ssm:GetManifest",
                	"ssm:GetParameters",
                	"ssm:ListAssociations",
                	"ssm:ListInstanceAssociations",
                	"ssm:PutInventory",
                	"ssm:PutComplianceItems",
                	"ssm:PutConfigurePackageResult",
                	"ssm:UpdateAssociationStatus",
                	"ssm:UpdateInstanceAssociationStatus",
                	"ssm:UpdateInstanceInformation"
            	],
            	"Resource": "*"
        	},
        	{
        	        "Effect": "Allow",
         	        "Action": [
                	"ssmmessages:CreateControlChannel",
                	"ssmmessages:CreateDataChannel",
                	"ssmmessages:OpenControlChannel",
                	"ssmmessages:OpenDataChannel"
            	],
            	"Resource": "*"
        	},
        	{
         	        "Effect": "Allow",
            		"Action": [
                	"ec2messages:AcknowledgeMessage",
                	"ec2messages:DeleteMessage",
                	"ec2messages:FailMessage",
                	"ec2messages:GetEndpoint",
                	"ec2messages:GetMessages",
                	"ec2messages:SendReply"
            		],
            	"Resource": "*"
        	},
        	{
            		"Effect": "Allow",
            		"Action": [
                	"cloudwatch:PutMetricData"
            		],
            	"Resource": "*"
        	},
        	{
            	"Effect": "Allow",
            	"Action": [
                	"ec2:DescribeInstanceStatus"
            	],
            	"Resource": "*"
        	},
        	{
            		"Effect": "Allow",
            		"Action": [
                	"ds:CreateComputer",
                	"ds:DescribeDirectories"
            		],
            	"Resource": "*"
        	},
        	{
            	"Effect": "Allow",
            	"Action": [
                	"logs:CreateLogGroup",
                	"logs:CreateLogStream",
                	"logs:DescribeLogGroups",
                	"logs:DescribeLogStreams",
                	"logs:PutLogEvents"
            		],
            	"Resource": "*"
        	},
        	{
            	"Effect": "Allow",
            	"Action": [
                	"s3:GetBucketLocation",
                	"s3:PutObject",
               	 	"s3:GetObject",
                	"s3:GetEncryptionConfiguration",
                	"s3:AbortMultipartUpload",
                	"s3:ListMultipartUploadParts",
                	"s3:ListBucket",
                	"s3:ListBucketMultipartUploads"
            		],
            	"Resource": "*"
        	}
    	]
}
POLICY
}

resource "aws_iam_policy" "jwt-web-lambda-policy" {
	name = "jwt-web-lambda-policy"
	description = "lambda policy"
	policy = <<POLICY
{
    	"Version": "2012-10-17",
    	"Statement": [
        	{
            	"Sid": "accessLambda",
            	"Effect": "Allow",
            	"Action": [
                	"lambda:ListFunctions",
                	"lambda:GetFunction",
                	"lambda:UpdateFunctionCode",
                	"lambda:InvokeFunction",
                	"lambda:GetPolicy",
                	"lambda:UpdateFunctionConfiguration"
            	],
            	"Resource": [
                	"*"
            	]
        	}
    	]
}
POLICY
}

resource "aws_iam_policy" "jwt-web-listPolicies-policy" {
	name = "jwt-web-listPolicies-policy"
	description = "list policies"
	policy = <<POLICY
{
	"Version": "2012-10-17",
	"Statement": [
		{
			"Sid": "Statement1",
			"Effect": "Allow",
			"Action": [
				"iam:ListAttachedRolePolicies",
				"iam:GetPolicyVersion",
                		"iam:ListPolicyVersions"
			],
			"Resource": [
				"*"
			]
		}
	]
}
POLICY
}


#attach polices to web-ec2 role
resource "aws_iam_policy_attachment" "jwt-web-policies-attachment1"{
	name = "jwt-web-policies-attachment"
	roles = [
		"${aws_iam_role.jwt-web-ec2-role.name}"
	]
	policy_arn = "${aws_iam_policy.jwt-web-ec2-role-policy.arn}"
}

resource "aws_iam_policy_attachment" "jwt-web-policies-attachment2"{
        name = "jwt-web-policies-attachment2"
        roles = [
                "${aws_iam_role.jwt-web-ec2-role.name}"
        ]
        policy_arn = "${aws_iam_policy.jwt-web-lambda-policy.arn}"
}

resource "aws_iam_policy_attachment" "jwt-web-policies-attachment3"{
        name = "jwt-web-policies-attachment3"
        roles = [
                "${aws_iam_role.jwt-web-ec2-role.name}"
        ]
        policy_arn = "${aws_iam_policy.jwt-web-listPolicies-policy.arn}"
}


#profile web-ec2 instance
resource "aws_iam_instance_profile" "jwt-web-instance-profile" {
	name = "jwt-web-instance-profile"
	role = "${aws_iam_role.jwt-web-ec2-role.name}"
}


#web-ec2 security groups
resource "aws_security_group" "jwt-web-ec2-security-group" {
	name = "jwt-web-ec2-security-group"
	description = "security group for web"
	vpc_id = "${aws_vpc.sh-vpc.id}"

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
}

#web-ec2 ssh key
resource "tls_private_key" "jwt-web-ec2-key-pair" {
  algorithm     = "RSA"
  rsa_bits      = 4096
}

resource "aws_key_pair" "jwt-web-ec2-key-pair" {
  key_name   = "jwt-web-ec2-key"
  public_key = tls_private_key.jwt-web-ec2-key-pair.public_key_openssh
}

output "private_key" {
  description = "Private key for EC2 instance"
  value       = tls_private_key.jwt-web-ec2-key-pair.private_key_pem
  sensitive   = true
}


#web-ec2 instance
resource "aws_instance" "jwt-web-ec2" {
	ami = "ami-0c7217cdde317cfec"
	instance_type = "t2.medium"
	iam_instance_profile = aws_iam_instance_profile.jwt-web-instance-profile.name
	subnet_id = aws_subnet.sh-public-subnet.id
	associate_public_ip_address = true
	vpc_security_group_ids = [
		aws_security_group.jwt-web-ec2-security-group.id
	]
	root_block_device {
    	volume_type = "gp2"
    	volume_size = 8
    	delete_on_termination = true
  	}
  	key_name = aws_key_pair.jwt-web-ec2-key-pair.key_name
	
	provisioner "remote-exec" {
		inline = ["mkdir -p /home/ubuntu/code/jwt_spring"]
		connection {
			type = "ssh"
			user = "ubuntu"
			host = self.public_ip
			private_key = tls_private_key.jwt-web-ec2-key-pair.private_key_pem
		}
	}

	provisioner "file" {
		source = "../code/jwt_spring"
		destination = "/home/ubuntu/code"
		connection {
                        type = "ssh"
                        user = "ubuntu"
                        host = self.public_ip
                        private_key = tls_private_key.jwt-web-ec2-key-pair.private_key_pem
                }
	}

	user_data = <<-UD
		#!/bin/bash
		#setting service
		sudo apt update
		sudo apt install awscli -y
		sudo apt install openjdk-17-jdk -y
		sudo apt install mariadb-server -y
		
		#setting mariadb
		sudo systemctl start mariadb
		sudo systemctl enable mariadb
		mysql -e "CREATE DATABASE login;"
		mysql -e "USE login; 
		CREATE USER 'whitehat'@'localhost' IDENTIFIED BY 'whitehat';
		GRANT ALL PRIVILEGES ON login.*TO'whitehat'@'localhost';
		FLUSH PRIVILEGES;"
		sudo systemctl restart mariadb
		
		#build springboot
		cd /home/ubuntu/code/jwt_spring
		sudo -u ubuntu chmod +x gradlew
		sudo -u ubuntu ./gradlew build
		nohup java -jar build/libs/jwt-0.0.1-SNAPSHOT.jar &
	UD

	tags = {
    		Name     = "jwt-web-ec2"
  	}
}
