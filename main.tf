data "aws_vpc" "default" {
  default = true
} 

resource "tls_private_key" "example" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_instance" "terraform_server" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = aws_key_pair.generated_key.key_name
  user_data     = <<EOT
  #!/bin/bash
sudo amazon-linux-extras install nginx1 -y
sudo systemctl start nginx
sudo systemctl enable nginx
EOT
  security_groups = ["${module.vote_service_sg.security_group_name}"]
  tags = {
    Name = var.instance_name
  }
}

resource "aws_key_pair" "generated_key" {
  key_name   = "terraform-key"
  public_key = tls_private_key.example.public_key_openssh
}

module "vote_service_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "terraform_sg"
  description = "Security group for user-service with custom ports open within VPC, and PostgreSQL publicly open"
  vpc_id      = data.aws_vpc.default.id

  ingress_cidr_blocks      = [data.aws_vpc.default.cidr_block]
  ingress_rules            = ["https-443-tcp"]
  egress_rules             = ["all-all"]
  ingress_with_cidr_blocks = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "User-service ports"
      cidr_blocks = var.ssh_ip
    },
    {
      rule        = "http-80-tcp"
      cidr_blocks = "0.0.0.0/0"
    },
  ]
}


