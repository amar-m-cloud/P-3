variable "vpc_id" {}
variable "subnet_ids" {}
variable "igw_id" {}

resource "aws_route_table" "public" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.igw_id
  }

  tags = {
    Name = "public"
  }
}

resource "aws_route_table_association" "subnet_association_a" {
  subnet_id      = var.subnet_ids[0]
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "subnet_association_b" {
  subnet_id      = var.subnet_ids[1]
  route_table_id = aws_route_table.public.id
}
