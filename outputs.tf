output "instance_ip_addr_public" {
  value = aws_instance.terraform_server.public_ip
}

output "private_key" {
  value     = tls_private_key.example.private_key_pem
  sensitive = true
}


