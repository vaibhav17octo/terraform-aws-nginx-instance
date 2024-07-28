variable "instance_type" {
  type = string
}

variable "ssh_ip" {
    type = string
    description = "provide an IP from which you would like to SSH with CIDR block eg 141.72.237.98/32"
}

variable "ami_id" {
    type = string
}

variable "instance_name" {
    type = string
}