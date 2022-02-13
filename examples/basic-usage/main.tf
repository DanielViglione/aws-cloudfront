provider "aws" {
  # alias    = "primary_region"
  region     = "us-east-1"
}

provider "aws" {
  alias  = "secondary_region"
  region = "us-west-2"
}

resource "random_pet" "name_suffix" {
  length = 2
}

############ Static Web Hosting ############
data "aws_acm_certificate" "cert_must_be_us_east1" {
  count     = var.add_domain ? 1 : 0
  domain    = var.certificate_name
  statuses  = ["ISSUED"]
}

# the cloudfront catalog uses the s3 catalog which enforces SSE-KMS encryption
# CloudWatch OAI cannot perform KMS decryption with its custom identity. 
# It only can decrypt SSE-S3. In effect, we create a Lambda@Edge function to
# handle the KMS decryption on each request
# lambda edge must be in us-east-1
module "lambda_edge" {
  source                    = "../../infrastructure/lambda_edge"
  name_prefix               = var.name
  name_suffix               = var.name_suffix
  filename                  = "${abspath("../../")}/lambda_edge.zip"
  source_code_hash          = filebase64sha256("${abspath("../../")}/lambda_edge.zip")
  # permissions_boundary_arn  = module.account_settings.permissions_boundary_arn

  providers = {
    aws = "aws"
  }
}

module "cloudfront_primary" {
  source                    = "../../infrastructure"
  name_prefix               = var.name
  name_suffix               = var.name_suffix
  region                    = "us-east-1"
  website_root_bucket       = var.website_root_bucket_primary
  website_logs_bucket       = var.website_logs_bucket_primary
  add_domain                = var.add_domain
  domain_name               = var.domain_name
  certificate_arn           = data.aws_acm_certificate.cert_must_be_us_east1[0].arn
  hosted_zone_name          = var.route53_hosted_zone_name
  lambda_edge_role_arn      = module.lambda_edge.lambda_edge_execution_role_arn
  function_qualified_arn    = module.lambda_edge.function_qualified_arn

  providers = {
     aws = "aws"
  }
}

module "cloudfront_secondary" {
  source                    = "../../infrastructure"
  name_prefix               = var.name
  name_suffix               = var.name_suffix
  region                    = "us-west-2"
  website_root_bucket       = var.website_root_bucket_secondary
  website_logs_bucket       = var.website_logs_bucket_secondary
  add_domain                = var.add_domain
  domain_name               = var.domain_name
  certificate_arn           = data.aws_acm_certificate.cert_must_be_us_east1[0].arn
  hosted_zone_name          = var.route53_hosted_zone_name
  lambda_edge_role_arn      = module.lambda_edge.lambda_edge_execution_role_arn
  function_qualified_arn    = module.lambda_edge.function_qualified_arn

  providers = {
     aws = "aws.secondary_region"
  }
}

resource "null_resource" "publish_primary_image" {
  triggers = {
    always_run = timestamp()
  }

  provisioner "local-exec" {
    interpreter       = ["bash", "-c"]
    command           = "${abspath("../../")}/initialize.sh ${var.website_root_bucket_primary}"
  }
}

resource "null_resource" "publish_secondary_image" {
  triggers = {
    always_run = timestamp()
  }

  provisioner "local-exec" {
    interpreter       = ["bash", "-c"]
    command           = "${abspath("../../")}/initialize.sh ${var.website_root_bucket_secondary}"
  }
}