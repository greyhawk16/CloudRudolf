# CloudRudolf 🦌


### Whitehat school 1st project 
### Reference : cloudgoat (https://github.com/RhinoSecurityLabs/cloudgoat)


WHS 1st Team 먼지 cloud wargame project 

## 👉Web Development Environment(ALL)

each scenario has a different environment...
- <img src="https://img.shields.io/badge/Framework-%23121011?style=for-the-badge"><img src="https://img.shields.io/badge/springboot-6DB33F?style=for-the-badge&logo=springboot&logoColor=white">![Flask](https://img.shields.io/badge/flask-%23000.svg?style=for-the-badge&logo=flask&logoColor=white)
- <img src="https://img.shields.io/badge/Build-%23121011?style=for-the-badge"><img src="https://img.shields.io/badge/Gradle-02303A?style=for-the-badge&logo=Gradle&logoColor=white">
- <img src="https://img.shields.io/badge/Server-%23121011?style=for-the-badge">![Apache Tomcat](https://img.shields.io/badge/apache%20tomcat-%23F8DC75.svg?style=for-the-badge&logo=apache-tomcat&logoColor=black)![Nginx](https://img.shields.io/badge/nginx-%23009639.svg?style=for-the-badge&logo=nginx&logoColor=white)
- <img src="https://img.shields.io/badge/Language-%23121011?style=for-the-badge"><img src="https://img.shields.io/badge/java-%23ED8B00?style=for-the-badge&logo=openjdk&logoColor=white">![PHP](https://img.shields.io/badge/php-%23777BB4.svg?style=for-the-badge&logo=php&logoColor=white)![Python](https://img.shields.io/badge/python-3670A0?style=for-the-badge&logo=python&logoColor=ffdd54)
- <img src="https://img.shields.io/badge/Project Encoding-%23121011?style=for-the-badge"><img src="https://img.shields.io/badge/UTF 8-EA2328?style=for-the-badge">


## 👉Requirements to Start

1. Terraform
   
   -> You can build your infra with simple commands.
   
   -> https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli
   
2. AWS CLI
   
   -> you can control multiple AWS services from the command line and automate them through scripts.
   
   -> https://docs.aws.amazon.com/ko_kr/cli/latest/userguide/getting-started-install.html


## 👉Scenarios (Ordered of Difficulty)
### CMD-Inj
`$ cd 3.CMD-Inj`

**Size:** Small

**Difficulty:** Easy

**Summary:** You start as an outsider. Exploit web application vulnerable to command injection. Enumerate through S3 buckets to find and retrieve flag.txt.

[Visit Scenario Page](https://github.com/xorverbin/CloudRudolf/tree/main/3.CMD-Inj)

---

### SSTI
`$ cd 4.SSTI`

**Size:** Small

**Difficulty:** Easy

**Summary:** You start as an outsider. Exploit web application vulnerable to SSTI using reverse shell. Enumerate and assume iam role to access secretsmanager. Use srcretsmanager to retrieve flag.

[Visit Scenario Page](https://github.com/xorverbin/CloudRudolf/tree/main/4.SSTI)

---

### JWT
`$ cd 5.JWT`

**Size:** Medium

**Difficulty:** Moderate

**Summary:** Modulating JWT of user, you can access the admin page and find a textfield where command injection is possible. Obtaining the reverse shell, check the roles and polices assigned to the server. Use the assigned policy to find a function that seems important, and get the value of the secret used in the function.

[Visit Scenario Page](https://github.com/xorverbin/CloudRudolf/tree/main/5.JWT)

---

### FD-SSM
`$ cd 1.FD-SSM`

**Size:** Medium

**Difficulty:** Moderate

**Summary:** As an outsider, your objective is to retrieve the /.aws/credentials file using the FileDownload vulnerability on the web. By utilizing the run command, you can gain access to a web EC2 shell. Create an AMI image of the FLAG EC2 instance and execute the command.

[Visit Scenario Page](https://github.com/xorverbin/CloudRudolf/tree/main/1.FD-SSM)

---

### SSRF-APIGW
`$ cd 2.SSRF-APIGW`

**Size:** Medium

**Difficulty:** Moderate

**Summary:** Exploiting SSRF and open redirect vulnerabilities, you can retrieve metadata. Modify a Lambda function to halt CloudTrail and send requests through API Gateway. Utilize the same method to delete an RDS instance

[Visit Scenario Page](https://github.com/xorverbin/CloudRudolf/tree/main/2.SSRF-APIGW)




## ✋Notice

- Before you start, you need to create and register your aws account.
```
$ aws configure 
AWS Access Key ID [None]: <Key id>
AWS Secret Access Key [None]: <Secret Access Key>
Default region name [None]: 
Default output format [None]:
```


- When you're done with the scenario, you'll have to destroy the terraform of that scenario. If you don't destroy it, the cost of your aws account will continue to be incurred.
```
$ terraform destroy //Remove all resources managed by terraform
```
