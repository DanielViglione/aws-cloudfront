module "cloudfront_public" {
  source                    = "./cloudfront_public"
  count                     = var.add_domain ? 1 : 0
  region                    = var.region
  domain_name               = var.domain_name
  certificate_arn           = var.certificate_arn
  website_root_bucket       = var.website_root_bucket
  website_logs_bucket       = var.website_logs_bucket
  lambda_edge_qualified_arn = var.function_qualified_arn
  # tags                      = local.tags
}

# note cloudfront is a cdn so it is private insomuch as you configure it to be so
module "cloudfront_private" {
  source                    = "./cloudfront_private"
  count                     = var.add_domain ? 0 : 1
  region                    = var.region
  website_root_bucket       = var.website_root_bucket
  website_logs_bucket       = var.website_logs_bucket
  # tags                      = local.tags
}

module "route53" {
  source                    = "./route53"
  count                     = var.add_domain ? 1 : 0
  region                    = var.region
  domain_name               = var.domain_name
  cloudfront_distribution   = module.cloudfront_public[0].domain_name
  cloudfront_hosted_zone_id = module.cloudfront_public[0].hosted_zone_id
  hosted_zone_name          = var.hosted_zone_name
}