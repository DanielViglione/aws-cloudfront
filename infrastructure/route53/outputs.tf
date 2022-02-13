output "route53_domain" {
  value     = aws_route53_record.record.name
}