variable "vpc_id" {}

resource "aws_internet_gateway" "main" {
  vpc_id = var.vpc_id
}

output "igw_id" {
  value = aws_internet_gateway.main.id
}
