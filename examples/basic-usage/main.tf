terraform {
  required_providers {
    aws = {
      version = "= 3.74.1"
      source = "hashicorp/aws"
    }
  }
}

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

############ AWS Bootstrap ############
# creates vpc, subnets, nacls, etc from account_settings module
module "bootstrap" {
  source = "git::git@github.com:Infinite-Limit-Data-Science-LLC/aws-bootstrap.git?ref=v1.1"
}

############ Static Web Hosting ############

# the cloudfront catalog uses the s3 catalog which enforces SSE-KMS encryption
# CloudWatch OAI cannot perform KMS decryption with its custom identity. 
# It only can decrypt SSE-S3. In effect, we create a Lambda@Edge function to
# handle the KMS decryption on each request
# lambda edge must be in us-east-1
module "lambda_edge" {
  source                    = "../../infrastructure/lambda_edge"
  name_prefix               = var.name
  name_suffix               = var.name_suffix
  add_domain                = var.add_domain
  domain                    = var.certificate_name
  // permissions_boundary_arn  = module.account_settings.permissions_boundary_arn

  // environment               = module.account_settings.environment
  // product                   = module.account_settings.product
  // owner_name                = module.account_settings.owner_name
  // owner_contact             = module.account_settings.owner_contact
  // runbook_url               = module.account_settings.runbook_url
  // data_classification       = module.account_settings.data_classification
  // cost_center               = module.account_settings.cost_center
  // terraform_path            = var.name

  providers = {
    aws = "aws"
  }
}

module "cloudfront_primary" {
  source                    = "../../infrastructure"
  region                    = "us-east-1"
  website_root_bucket       = var.website_root_bucket_primary
  website_logs_bucket       = var.website_logs_bucket_primary
  add_domain                = var.add_domain
  domain_name               = var.domain_name
  certificate_arn           = module.lambda_edge.certificate_arn
  hosted_zone_name          = var.route53_hosted_zone_name
  lambda_edge_role_arn      = module.lambda_edge.lambda_edge_execution_role_arn
  function_qualified_arn    = module.lambda_edge.function_qualified_arn

  // environment               = module.account_settings.environment
  // product                   = module.account_settings.product
  // owner_name                = module.account_settings.owner_name
  // owner_contact             = module.account_settings.owner_contact
  // runbook_url               = module.account_settings.runbook_url
  // data_classification       = module.account_settings.data_classification
  // cost_center               = module.account_settings.cost_center
  // terraform_path            = var.name

  providers = {
     aws = "aws"
  }
}

module "cloudfront_secondary" {
  source                    = "../../infrastructure"
  region                    = "us-west-2"
  website_root_bucket       = var.website_root_bucket_secondary
  website_logs_bucket       = var.website_logs_bucket_secondary
  add_domain                = var.add_domain
  domain_name               = var.domain_name
  certificate_arn           = module.lambda_edge.certificate_arn
  hosted_zone_name          = var.route53_hosted_zone_name
  lambda_edge_role_arn      = module.lambda_edge.lambda_edge_execution_role_arn
  function_qualified_arn    = module.lambda_edge.function_qualified_arn
  
  // environment               = module.account_settings.environment
  // product                   = module.account_settings.product
  // owner_name                = module.account_settings.owner_name
  // owner_contact             = module.account_settings.owner_contact
  // runbook_url               = module.account_settings.runbook_url
  // data_classification       = module.account_settings.data_classification
  // cost_center               = module.account_settings.cost_center
  // terraform_path            = var.name

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