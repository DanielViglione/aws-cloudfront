// locals {
//   tags = merge({
//     "scrapetorium:environment"          = var.environment,
//     "scrapetorium:product"              = var.product,
//     "scrapetorium:owner-name"           = var.owner_name,
//     "scrapetorium:owner-contact"        = var.owner_contact,
//     "scrapetorium:runbook-url"          = var.runbook_url,
//     "scrapetorium:data-classification"  = var.data_classification,
//     "scrapetorium:cost-center"          = var.cost_center,
//     "scrapetorium:terraform-path"       = var.terraform_path,
//     "scrapetorium:terraform"            = true,
//   }, var.tags)
// }

# the cloudfront catalog uses the s3 catalog which enforces SSE-KMS encryption
# CloudWatch OAI cannot perform KMS decryption with its custom identity. 
# It only can decrypt SSE-S3. In effect, we create a Lambda@Edge function to
# handle the KMS decryption on each request
# lambda edge must be in us-east-1
module "lambda_edge" {
  source                        = "./lambda_edge"
  name_prefix                   = var.name_prefix
  name_suffix                   = var.name_suffix
  add_domain                    = var.add_domain
  certificate_name              = var.certificate_name
}

module "cloudfront_public" {
  source                        = "./cloudfront_public"
  count                         = var.add_domain ? 1 : 0
  domain_name                   = var.domain_name
  certificate_name              = var.certificate_name
  website_root_bucket_primary   = var.website_root_bucket_primary
  website_logs_bucket_primary   = var.website_logs_bucket_primary
  website_root_bucket_secondary = var.website_root_bucket_secondary
  website_logs_bucket_secondary = var.website_logs_bucket_secondary
  lambda_edge_qualified_arn     = module.lambda_edge.function_qualified_arn
  # tags                        = local.tags
}

# note cloudfront is a cdn so it is private insomuch as you configure it to be so
module "cloudfront_private" {
  source                    = "./cloudfront_private"
  count                     = var.add_domain ? 0 : 1
  # tags                      = local.tags
}

module "route53" {
  source                    = "./route53"
  count                     = var.add_domain ? 1 : 0
  domain_name               = var.domain_name
  cloudfront_distribution   = module.cloudfront_public[0].domain_name
  cloudfront_hosted_zone_id = module.cloudfront_public[0].hosted_zone_id
  hosted_zone_name          = var.hosted_zone_name
}