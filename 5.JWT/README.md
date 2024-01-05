# Scenario: JWT
**Size:** Medium

**Difficulty:** Moderate

**Command:** 
- creation: `$ cd ./terraform; terraform init; terraform apply`
- destruction: `$ cd ./terraform; terraform destroy`

## Scenario Resources

- EC2 x 1
- Secret x 1
- Lambda x 2
- IAM Role X 1

## Start of Scenario

- Public IP Address of an EC2 server which runs a web application
- http://printedIP:8080/jwt-login

## Scenario Goal(s)

Get the value of a secret(flag) used in the lambda function.

## Summary

Modulating JWT of user, you can access the admin page and find a textfield where command injection is possible. Obtaining the reverse shell, check the roles and polices assigned to the server. Use the assigned policy to find a function that seems important, and get the value of the secret used in the function.

## Exploitation Route(s)

![image](https://github.com/chantro/CloudRudolf/assets/108852196/40646001-06ae-4302-8ba9-2707fc74a6c6)

