data "aws_route53_zone" "selected" {
  name         = var.hosted_zone_name
  private_zone = false
}

resource "aws_route53_record" "record" {
  zone_id                   = data.aws_route53_zone.selected.id
  name                      = "${var.region}-${var.domain_name}"
  type                      = "A"
  
  alias {
    name                    = var.cloudfront_distribution
    zone_id                 = var.cloudfront_hosted_zone_id
    evaluate_target_health  = false
  }
}