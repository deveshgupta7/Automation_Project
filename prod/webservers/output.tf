output "Webserver1_public_ip" {
  value = aws_instance.webserver1.public_ip
}

output "Webserver2_public_ip" {
  value = aws_instance.webserver2.public_ip
}

output "Webserver3_public_ip" {
  value = aws_instance.webserver3.public_ip
}

output "Webserver4_public_ip" {
  value = aws_instance.webserver4.public_ip
}

output "Webserver5_private_ip" {
  value = aws_instance.webserver5.private_ip
}

output "VM6_private_ip" {
  value = aws_instance.vm6.private_ip
}

