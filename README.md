You can use this module to provision a ec2 instance.

The ec2 instance will have ports 80 and 22 open. Nginx will be serving content on port 80.

```hcl
module "terraform-aws-nginx-instance" {
    source=".//source"
    instance_type="t2.micro"
    ssh_ip="141.72.237.98/32" 
    ami_id="ami.id"
    instance_name = "Nginx-terraform-instance"
}
```