variable "domain" {}
variable "lb_dns" {}

resource "aws_route53_zone" "main" {
  name = var.domain
}

resource "aws_route53_record" "lb_record" {
  zone_id = aws_route53_zone.main.zone_id
  name    = var.domain
  type    = "CNAME"
  ttl     = "300"
  records = [var.lb_dns]
}

output "name_servers" {
  value = aws_route53_zone.main.name_servers
}
