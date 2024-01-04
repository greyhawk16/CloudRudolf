

output "CloudRudolf_start_ip_address_port_80" {
  value = aws_instance.cr-ssrf-web-ec2.public_ip
}


