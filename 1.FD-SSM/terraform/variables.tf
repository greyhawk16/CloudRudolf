
variable "profile" {

}

variable "region" {
  default = "us-east-1"
}

variable "crid" {

}

variable "stack-name" {
  default = "CloudRudolf"
}

variable "scenario-name" {
  default = "FD-SSM"
}

variable "ssh-public-key-for-ec2" {
  default = "./cloudrudolf.pub"
}

variable "ssh-private-key-for-ec2" {
  default = "./cloudrudolf"
}