variable "vpc_id" {}
variable "cidr_block" {}

resource "aws_subnet" "subnet_a" {
  vpc_id                  = var.vpc_id
  cidr_block              = "${var.cidr_block}.0/24"
  availability_zone       = "us-east-1a"
}

resource "aws_subnet" "subnet_b" {
  vpc_id                  = var.vpc_id
  cidr_block              = "${var.cidr_block}.1/24"
  availability_zone       = "us-east-1b"
}

output "subnet_ids" {
  value = [aws_subnet.subnet_a.id, aws_subnet.subnet_b.id]
}
