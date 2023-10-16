variable "vpc_id" {}
variable "security_group" {}
variable "subnet_ids" {}

resource "aws_lb" "main" {
  name               = "wordpress-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.security_group]
  enable_deletion_protection = false

  enable_http2        = true
  idle_timeout        = 400
  enable_cross_zone_load_balancing = true

  subnets = var.subnet_ids

  enable_deletion_protection = false

  enable_deletion_protection = false

  enable_deletion_protection = false

  enable_deletion_protection = false

  enable_deletion_protection = false

  enable_deletion_protection = false
}

output "load_balancer_name" {
  value = aws_lb.main.name
}

output "load_balancer_dns_name" {
  value = aws_lb.main.dns_name
}
