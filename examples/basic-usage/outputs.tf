output "public_distribution_id_primary" {
  value   = module.cloudfront_primary.public_distribution_id
}

output "private_distribution_id_primary" {
  value   = module.cloudfront_primary.private_distribution_id
}

output "route53_domain_primary" {
  value   = module.cloudfront_primary.route53_domain
}