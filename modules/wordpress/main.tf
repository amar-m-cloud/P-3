variable "vpc_id" {}
variable "subnet_ids" {}
variable "security_group" {}

resource "aws_instance" "wordpress" {
  ami             = "ami-0c55b159cbfafe1f0" # Replace with your preferred AMI
  instance_type   = "t2.micro"
  subnet_id       = var.subnet_ids[0]
  vpc_security_group_ids = [var.security_group]

  tags = {
    Name = "wordpress-instance"
  }
}
