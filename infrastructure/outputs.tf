output "public_distribution_id" {
  value   = length(module.cloudfront_public[0].distribution_id) > 0 ? module.cloudfront_public[0].distribution_id : ""
}

output "private_distribution_id" {
  value   = ""
  # value   = length(module.cloudfront_private.distribution_id) > 0 ? module.cloudfront_private.distribution_id : ""
}

output "route53_domain" {
  value   = length(module.route53[0].route53_domain) > 0 ? module.route53[0].route53_domain : ""
}